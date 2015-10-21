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
			  -- sa�das
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
	
	type state_type_reading is (estado_leitura_desativado, estado_leitura_espera, estado_leitura_le);
	signal estado_codec_leitura : state_type_reading;
	
	--
	signal RESET_doubleclk : std_logic;
	--------------------------------------------------------------------------------------
begin

Clk <= CLOCK;
RESET_doubleclk <= not(RESET);

--	Inst_clock_pll: clock_pll PORT MAP(
--		CLKIN_IN => CLOCK,
--		RST_IN => not(RESET),
--		CLKIN_IBUFG_OUT => OPEN,
--		CLK0_OUT => OPEN,
--		CLK2X_OUT => Clk,
--		LOCKED_OUT => RESET_doubleclk 
--	);

	 
----------------------------------------------- 
 
   c_SpW: CodecSpWXNSEE2 
	GENERIC MAP(
		  FREQ_CLK => 100 
		  )
	PORT MAP (
        Clk           => Clk, 
        MReset        => not(RESET_doubleclk), -- Reset da placa � invertido
        LinkStart     => LinkStart,
        LinkDisable   => LinkDisable,
        AutoStart     => AutoStart,
        TX_Write      => TX_Write,
        TX_Data       => TX_Data,
        Tick_IN       => Tick_IN,
        Time_IN       => Time_IN,
        DIn           => DIn,            --LVDS
        SIn           => SIn,            --LVDS
        Buffer_Ready  => Buffer_Ready,
        DOut          => DOut,           --LVDS
        SOut          => SOut,           --LVDS
        TX_Ready      => TX_Ready,
        Buffer_Write  => Buffer_Write,
        RX_Data       => RX_Data,
        Tick_OUT      => Tick_OUT,
        Time_OUT      => Time_OUT,
        EstadoInterno => EstadoInterno
        );


	PROCESS (Clk) -- Processo para iniciar a conex�o (CRIADO PARA USO NA SIMULA��O)
        variable delay_inicial : integer := 0;
	begin
        if (rising_edge(Clk)) then
		
            if (110 >= delay_inicial) then
                delay_inicial := delay_inicial + 1;
            end if;	
			 
            if (delay_inicial = 100) then
                -- Comandos para inicializa�ao do CodecSpWXNSEE2
                LinkStart    <= '1';
                LinkDisable  <= '0';
                AutoStart    <= '1';
                MReset       <= '0';
            end if;
			
        end if;	
	end PROCESS;
	
	
	-- PROCESSO DE ESCRITA -=-=-=-=-=-=--==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	PROCESS (Clk)
	begin
		
		if	(rising_edge(Clk)) then
		
			if (EstadoInterno(9) = '0') then
			estado_codec <= estado_desativado;
			
			else 
				case estado_codec is
					
				when estado_desativado =>
					if (EstadoInterno(9) = '1') then -- verifica se conex�o est� em "running"
						estado_codec <= estado_inicia; -- vai para estado_inicia
					else
						contador <= 0;
						somador  <= 0;
						estado_codec <= estado_desativado; -- continua no estado desativado
					end if;	
						
				when estado_inicia =>
					if (contador < 5) then
						contador <= contador + 1;
						estado_codec <= estado_inicia; -- continua estado_inicia
					else	
						if (contador = 5) then
							somador <= somador + 1;
							contador <= 0;
							estado_codec <= estado_espera; -- vai para estado_espera
						end if;	
					end if;	
						
				when estado_espera =>
					if (TX_Ready = '1') then --verifica se pode escrever dados na entrada
						estado_codec <= estado_escreve; -- vai para estado_escreve
					else
						estado_codec <= estado_espera; -- continua estado_espera
					end if;	
						
				when estado_escreve =>
					if (TX_Ready = '1') then
						estado_codec <= estado_escreve;
					else
						estado_codec <= estado_inicia;
						contador <= 1;
					end if;	
						
				end case;
			end if;
		end if;
	end PROCESS;
	
		
	PROCESS (estado_codec, somador)
	begin
        case estado_codec is
		
            when estado_desativado => 
                TX_Write <= '0';
				  
            when estado_inicia =>
                TX_Write <= '0';
					 
            when estado_espera =>
                TX_Write <= '0';
                TX_Data  <= std_logic_vector(to_unsigned(somador, TX_Data'length));
				
            when estado_escreve =>
                TX_Write <= '1';
				  
		end case;		  
	end PROCESS;


-- PROCESSO DE LEITURA -=-=-=-==--=-=-=-=-=-=-=--=-=-=--=-==-=-=-=-=-=-=-=--=-=-=-=-
	PROCESS (Clk)
	begin
		if	(rising_edge(Clk)) then
		
			if (EstadoInterno(9) = '0') then
				estado_codec_leitura <= estado_leitura_desativado;
			
			else 
				case estado_codec_leitura is
					
				when estado_leitura_desativado =>
					if (EstadoInterno(9) = '1') then -- verifica se conex�o est� em "running"
						estado_codec_leitura <= estado_leitura_espera; -- vai para estado_inicia
					else
						estado_codec_leitura <= estado_leitura_desativado; -- continua no estado desativado
					end if;	
				when estado_leitura_espera =>
					if Buffer_Write = '1' then -- verifica se pode ler
						estado_codec_leitura <= estado_leitura_le; --Se sim... ent�o realiza o processo de leitura
					else -- Se nao...
						estado_codec_leitura <= estado_leitura_espera; --Se n�o... continua no estado de espera
					end if;
				when estado_leitura_le =>
					if Buffer_Write = '0' then -- Verifica se j� foi feita a leitura
						estado_codec_leitura <= estado_leitura_escreve; -- Se Sim... Entao vai pro estado de espera
					else -- Se n�o...
						estado_codec_leitura <= estado_leitura_le; --Se nao... Continua no estado de leitura
					end if;
					
					-- At� aqui leu. Agora escrever de volta.
				when estado_leitura_escreve =>
					estado_codec_leitura <= estado_leitura_espera;
				
				end case;	
			end if;
		
		end if;
	end PROCESS;
	
	PROCESS (estado_codec_leitura)
	begin
		case estado_codec_leitura is
			when estado_leitura_desativado =>
				Buffer_Ready <= '1';	

			when estado_leitura_espera =>
				Buffer_Ready <= '1'; -- Pede pra realizar leitura;
				--Fica aguardando se pode ler na saida de dados (at� obter buffer_write=1)
			when estado_leitura_le =>
				Buffer_Ready <= '0'; -- Pode Ler
			when estado_leitura_escreve =>
				TX_data <= RX_data;
				TX_Write <= '1';
		end case;
	end PROCESS;
   
   
Din <= Dout;
Sin <= Sout;

	PROCESS(RESET_doubleclk)
	begin
		if (not(RESET_doubleclk)='1') then
			LED(1) <= '1'; -- Status para saber se o programa est� rodando na fpga.
			LED(2) <= '1'; -- Status para saber se o programa est� rodando na fpga.
		else
			LED(1) <= '0'; -- Status para saber se o programa est� rodando na fpga.
			LED(2) <= '0'; -- Status para saber se o programa est� rodando na fpga.
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

