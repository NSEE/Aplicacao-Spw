----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:22:24 03/09/2015 
-- Design Name: 
-- Module Name:    vhd_Teste_Codec - Behavioral 
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

entity vhd_Teste_Codec is
    Port ( -- Entradas Gerais
           CLOCK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
			  
			  -- Saida LEDS
			  LED   : out std_logic_vector(1 to 3);
			  
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
				LVDS_SIN_n : in std_logic
			 );
end vhd_Teste_Codec;

architecture Behavioral of vhd_Teste_Codec is

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
	signal LinkStart     : std_logic :='0';
	signal LinkDisable   : std_logic :='1';
	signal AutoStart     : std_logic :='0';
	signal TX_Write      : std_logic :='0';
	signal TX_Data       : std_logic_vector(8 downto 0) := (others => '0');
	signal Tick_IN       : std_logic :='0';
	signal Time_IN       : std_logic_vector(7 downto 0) := (others => '0');
	signal DIn           : std_logic :='0';
	signal SIn           : std_logic :='0';
	signal Buffer_Ready  : std_logic :='0';
	-------------------------------------------------------------------
	
	-- Outputs CodecSpWXNSEE2:
	signal DOut          : std_logic;
	signal SOut          : std_logic;
	signal TX_Ready      : std_logic;
	signal Buffer_Write  : std_logic;
	signal RX_Data       : std_logic_vector(8 downto 0);
	signal Tick_OUT      : std_logic;
	signal Time_OUT      : std_logic_vector(7 downto 0);
	signal EstadoInterno : std_logic_vector(9 downto 0);
	------------------------------------------------------------------

	signal somador       : integer := 0;
	signal contador      : integer := 0;
	
	-- Estados:
	type state_type is (estado_desativado, estado_inicia, estado_espera, estado_escreve); 
	signal estado_codec : state_type;
	
	--
	signal RESET_doubleclk : std_logic;
	--------------------------------------------------------------------------------------
begin

--Clk <= CLOCK;

	Inst_clock_pll: clock_pll PORT MAP(
		CLKIN_IN => CLOCK,
		RST_IN =>not(RESET),
		CLKIN_IBUFG_OUT => OPEN,
		CLK0_OUT => OPEN,
		CLK2X_OUT => Clk,
		LOCKED_OUT => RESET_doubleclk 
	);

	 
----------------------------------------------- 
 
   c_SpW: CodecSpWXNSEE2 
	GENERIC MAP(
		  FREQ_CLK => 100 
		  )
	PORT MAP (
        Clk           => Clk, 
        MReset        => not(RESET_doubleclk), -- Reset da placa é invertido
        LinkStart     => '1',
        LinkDisable   => '0',
        AutoStart     => '1',
        TX_Write      => '0',
        TX_Data       => TX_Data,
        Tick_IN       => Tick_IN,
        Time_IN       => Time_IN,
        DIn           => DIn,            --LVDS
        SIn           => SIn,            --LVDS
        Buffer_Ready  => Buffer_Ready,
        DOut          => DOut,           --LVDS
        SOut          => SOut,           --LVDS
        TX_Ready      => OPEN,
        Buffer_Write  => Buffer_Write,
        RX_Data       => RX_Data,
        Tick_OUT      => Tick_OUT,
        Time_OUT      => Time_OUT,
        EstadoInterno => EstadoInterno
        );

	PROCESS(RESET_doubleclk)
	begin
		if (not(RESET_doubleclk)='1') then
			LED(1) <= '1'; -- Status para saber se o programa está rodando na fpga.
			LED(2) <= '0'; -- Status para saber se o programa está rodando na fpga.
		else
			LED(1) <= '0'; -- Status para saber se o programa está rodando na fpga.
			LED(2) <= '0'; -- Status para saber se o programa está rodando na fpga.
		end if;	
	end PROCESS;

LED(3) <= EstadoInterno(9); -- Exibir status do estado "running".

-------------------------------------------------------------------------------
-- Lvds J1
-------------------------------------------------------------------------------
  OBUFDS_INSTANCE_LVDSd : OBUFDS port map
    (
      O  => LVDS_DOUT_p,
      OB => LVDS_DOUT_n,
      I  => DOut
      );
	  
  OBUFDS_INSTANCE_LVDSs : OBUFDS port map
    (
      O  => LVDS_SOUT_p,
      OB => LVDS_SOUT_n,
      I  => Sout
      );
	  
  IBUFDS_inst_d : IBUFDS port map
    (
      O  => Din,
      I  => LVDS_DIN_p,
      IB => LVDS_DIN_n
      );
	  
  IBUFDS_inst_s : IBUFDS port map
    (
      O  => Sin,
      I  => LVDS_SIN_p,
      IB => LVDS_SIN_n
      );	

end Behavioral;

