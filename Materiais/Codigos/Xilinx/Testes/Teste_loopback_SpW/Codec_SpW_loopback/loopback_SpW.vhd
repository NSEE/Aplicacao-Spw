----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:59:58 11/09/2015 
-- Design Name: 
-- Module Name:    loopback_SpW - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity loopback_SpW is
    Port ( CLOCK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
			-- GPIOs Placa Filha
				GPIOs_i : in std_logic_vector(2 downto 0);
				GPIOs_o : out std_logic_vector(5 downto 3);
			-- Saida LEDS
				LED   : out std_logic_vector(1 to 3);
				LEDs_PF : out std_logic_vector(7 downto 0);
			-- Sinais LVDS
				-- saídas
				LVDS_DOUT_p : out std_logic;
				LVDS_DOUT_n : out std_logic;
				LVDS_SOUT_p : out std_logic;
				LVDS_SOUT_n : out std_logic;
				-- entradas
				LVDS_DIN_p : in std_logic;
				LVDS_DIN_n : in std_logic;
				LVDS_SIN_p : in std_logic;
				LVDS_SIN_n : in std_logic);
				
end loopback_SpW;

architecture Behavioral of loopback_SpW is

	-- Component Declaration for the Unit Under Test (UUT)
    COMPONENT CodecSpWXNSEE2
	GENERIC(
		FREQ_CLK : INTEGER := 100   -- clock frequency in MHz
	);
    PORT(
         Clk            : IN  std_logic;
         MReset         : IN  std_logic;
         LinkStart      : IN  std_logic;
         LinkDisable    : IN  std_logic;
         AutoStart      : IN  std_logic;
         TX_Write       : IN  std_logic;
         TX_Data        : IN  std_logic_vector(8 downto 0);
         Tick_IN        : IN  std_logic;
         Time_IN        : IN  std_logic_vector(7 downto 0);
         DIn            : IN  std_logic;
         SIn            : IN  std_logic;
         Buffer_Ready   : IN  std_logic;
         DOut           : OUT  std_logic;
         SOut           : OUT  std_logic;
         TX_Ready       : OUT  std_logic;
         Buffer_Write   : OUT  std_logic;
         RX_Data        : OUT  std_logic_vector(8 downto 0);
         Tick_OUT       : OUT  std_logic;
         Time_OUT       : OUT  std_logic_vector(7 downto 0);
         EstadoInterno  : OUT  std_logic_vector(9 downto 0) -- 0 --> '1'= "Disconnect Error"  | 5 --> '1'= "ErrorWait"
                                                            -- 1 --> '1'= "Parity Error"      | 6 --> '1'= "Ready" 
                                                            -- 2 --> '1'= "Escape Error"      | 7 --> '1'= "Started"
                                                            -- 3 --> '1'= "Credit Error"      | 8 --> '1'= "Connecting"
                                                            -- 4 --> '1'= "ErrorReset"        | 9 -> '1'= "Run"

        );
    END COMPONENT;
	 -------------------------------------------------------------------------------------------------------------

	 -- Component LVDS Outputs
	 COMPONENT OBUFDS PORT(
         O  : out std_ulogic;
         OB : out std_ulogic;
         I  : in  std_ulogic
			);
	 END COMPONENT;
	----------------------------
	
	-- Component LVDS Inputs
	COMPONENT IBUFDS PORT(
         I  : in  std_ulogic;
         IB : in  std_ulogic;
         O  : out std_ulogic
         );
	END COMPONENT;
	----------------------------
	
	-- Component Double clock frequency (DCM)
	COMPONENT clock_pll
	PORT(
		CLKIN_IN : IN std_logic;
		RST_IN : IN std_logic;  	
		CLKIN_IBUFG_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic;
		CLK2X_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;
	----------------------------

	-- Inputs CodecSpWXNSEE2:
	signal Clk           : std_logic :='0';
	signal MReset        : std_logic :='1';

	------------------------------------------------------------------
	
	--Codec SpW 1:
	signal LinkStart1     : std_logic :='0';
	signal LinkDisable1   : std_logic :='1';
	signal AutoStart1     : std_logic :='0';
	signal TX_Write1      : std_logic :='0';
	signal TX_Data1       : std_logic_vector(8 downto 0) := (others => '0');
	signal Tick_IN1      : std_logic :='0';
	signal Time_IN1       : std_logic_vector(7 downto 0) := (others => '0');
	signal DIn1           : std_logic :='0';
	signal SIn1           : std_logic :='0';
	signal Buffer_Ready1  : std_logic :='1';
	-------------------------------------------------------------------
	
	-- Outputs CodecSpWXNSEE2:
	signal DOut1          : std_logic;
	signal SOut1          : std_logic;
	signal TX_Ready1     : std_logic;
	signal Buffer_Write1  : std_logic;
	signal RX_Data1       : std_logic_vector(8 downto 0);
	signal Tick_OUT1      : std_logic;
	signal Time_OUT1      : std_logic_vector(7 downto 0);
	signal EstadoInterno1 : std_logic_vector(9 downto 0);
	------------------------------------------------------------------

	signal somador       : integer := 0;
	signal contador      : integer := 0;
	
	-- Estados:
	type state_type is (estado_desativado, estado_inicia, estado_espera, estado_escreve); 
	signal estado_codec : state_type;
	
	type state_type1 is (estado_desativado1, estado_leitura1, estado_escreve1);
	signal estado_codec1 : state_type1;
	
	--
	signal RESET_doubleclk : std_logic;
	
	-- Signal GPIOs:
	signal s_GPIOs_i : std_logic_vector(2 downto 0) := (OTHERS => '0');
	signal s_GPIOs_o : std_logic_vector(5 downto 3) := (OTHERS => '0');
	--------------------------------------------------------------------------------------
begin

--Clk <= CLOCK;
--RESET_doubleclk <= not(RESET);

	Inst_clock_pll: clock_pll PORT MAP(
		CLKIN_IN => CLOCK,
		RST_IN => not(RESET),
		CLKIN_IBUFG_OUT => OPEN,
		CLK0_OUT => OPEN,
		CLK2X_OUT => Clk,
		LOCKED_OUT => RESET_doubleclk 
	);

	 
 

   c_SpW_1: CodecSpWXNSEE2 
	GENERIC MAP(
		  FREQ_CLK => 100 
		  )
	PORT MAP (
        Clk           => Clk, 
        MReset        => not(RESET_doubleclk), -- Reset da placa é invertido
        LinkStart     => LinkStart1,
        LinkDisable   => LinkDisable1,
        AutoStart     => AutoStart1,
        TX_Write      => TX_Write1,
        TX_Data       => TX_Data1,
        Tick_IN       => Tick_IN1,
        Time_IN       => Time_IN1,
        DIn           => DIn1,            --LVDS
        SIn           => SIn1,            --LVDS
        Buffer_Ready  => Buffer_Ready1,
        DOut          => DOut1,           --LVDS
        SOut          => SOut1,           --LVDS
        TX_Ready      => TX_Ready1,
        Buffer_Write  => Buffer_Write1,
        RX_Data       => RX_Data1,
        Tick_OUT      => Tick_OUT1,
        Time_OUT      => Time_OUT1,
        EstadoInterno => EstadoInterno1
        );


	
MReset      <= '0';	
LinkStart1    <= '1';
LinkDisable1  <= '0';
AutoStart1    <= '1';

s_GPIOs_i <= GPIOs_i;
GPIOs_o <= s_GPIOs_o;

-- Exibir dados do RX_Data1 nos leds da placa Filha
LEDs_PF(7) <= RX_Data1(7);
LEDs_PF(6) <= RX_Data1(6);
LEDs_PF(5) <= RX_Data1(5);
LEDs_PF(4) <= RX_Data1(4);
LEDs_PF(3) <= RX_Data1(3);
LEDs_PF(2) <= RX_Data1(2);
LEDs_PF(1) <= RX_Data1(1);
LEDs_PF(0) <= RX_Data1(0);

-- Buffer_Write1 no GPIO_o
s_GPIOs_o(3) <= Buffer_Write1;



-- PROCESSO CODEC SpW-=-=-=-==--=-=-=-=-=-=-=--=-=-=--=-==-=-=-=-=-=-=-=--=-=-=-=-
	PROCESS (Clk)
	begin
		if	(rising_edge(Clk)) then
		
			if (EstadoInterno1(9) = '0') then
				estado_codec1 <= estado_desativado1;
			else
				Tick_in1 <= Tick_out1;
				Time_in1 <= Time_out1;
				case estado_codec1 is 
					when estado_desativado1 =>
						if Buffer_Write1 = '1' then --Pode ler?
							estado_codec1 <= estado_leitura1; -- Vai para o estado de leitura.
						else
							estado_codec1 <= estado_desativado1;-- Espera permissao para leitura...
						end if;
					when estado_leitura1 =>
						if (Buffer_Write1 = '0') and (TX_Ready1 = '1') then --Terminou a leitura e pode escrever?
							TX_data1 <= RX_data1;
							estado_codec1 <= estado_escreve1; -- Vai para o estado de escrita.
						else
							estado_codec1 <=  estado_leitura1;
						end if;	
					when estado_escreve1 =>
						if (TX_Ready1 = '1') then
							estado_codec1 <= estado_escreve1; -- Continua em estado de escrita até terminar (TX_Ready1 = '0').
						else
							estado_codec1 <= estado_desativado1;
						end if;
				end case;
				
			end if;
		
		end if;
	end PROCESS;
	
	PROCESS (estado_codec1)
	begin
        case estado_codec1 is
		
            when estado_desativado1 => 
                TX_Write1 <= '0';
				Buffer_Ready1 <= '1'; -- Pede pra realizar leitura.
            when estado_leitura1 =>
                TX_Write1 <= '0';
				Buffer_Ready1 <= '0'; -- Realiza a leitura.	 
            when estado_escreve1 =>
                TX_Write1 <= '1'; -- Realiza a escrita
 				Buffer_Ready1 <= '1';
		end case;		  
	end PROCESS;
	

	PROCESS(RESET_doubleclk)
	begin
		if (not(RESET_doubleclk)='1') then
			LED(1) <= '1'; -- Status para saber se o programa está rodando na fpga.
			LED(2) <= '0'; -- Status para saber se o programa está rodando na fpga.
		else
			LED(1) <= '0'; -- Status para saber se o programa está rodando na fpga.
			LED(2) <= '1'; -- Status para saber se o programa está rodando na fpga.
		end if;	
	end PROCESS;

LED(3) <= EstadoInterno1(9); -- Exibir status do estado "running".

-----------------------------------------------------------------------------
 --Lvds J1
-----------------------------------------------------------------------------
  OBUFDS_INSTANCE_LVDSd : OBUFDS port map
    (
      O  => LVDS_DOUT_p,
      OB => LVDS_DOUT_n,
      I  => DOut1
      );
	  
  OBUFDS_INSTANCE_LVDSs : OBUFDS port map
    (
      O  => LVDS_SOUT_p,
      OB => LVDS_SOUT_n,
      I  => Sout1
      );
	  
  IBUFDS_inst_d : IBUFDS port map
    (
      O  => Din1,
      I  => LVDS_DIN_p,
      IB => LVDS_DIN_n
      );
	  
  IBUFDS_inst_s : IBUFDS port map
    (
      O  => Sin1,
      I  => LVDS_SIN_p,
      IB => LVDS_SIN_n
      );	



end Behavioral;



