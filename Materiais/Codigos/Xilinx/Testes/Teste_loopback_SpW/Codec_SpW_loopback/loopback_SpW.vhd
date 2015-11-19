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
use work.spwpkg.all;

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

	-- Component Declaration for the Unit Under Test 2 (UUT2)
    COMPONENT spwstream
	generic (
        sysfreq:        real;
        txclkfreq:      real := 0.0;
        rximpl:         spw_implementation_type := impl_generic;
        rxchunk:        integer range 1 to 4 := 1;
        tximpl:         spw_implementation_type := impl_generic;
        rxfifosize_bits: integer range 6 to 14 := 11;
        txfifosize_bits: integer range 2 to 14 := 11
    );

    port (
        clk:        in  std_logic;
        rxclk:      in  std_logic;
        txclk:      in  std_logic;
        rst:        in  std_logic;
        autostart:  in  std_logic;
        linkstart:  in  std_logic;
        linkdis:    in  std_logic;
        txdivcnt:   in  std_logic_vector(7 downto 0);
        tick_in:    in  std_logic;
        ctrl_in:    in  std_logic_vector(1 downto 0);
        time_in:    in  std_logic_vector(5 downto 0);
        txwrite:    in  std_logic;
        txflag:     in  std_logic;
        txdata:     in  std_logic_vector(7 downto 0);
        txrdy:      out std_logic;
        txhalff:    out std_logic;
        tick_out:   out std_logic;
        ctrl_out:   out std_logic_vector(1 downto 0);
        time_out:   out std_logic_vector(5 downto 0);
        rxvalid:    out std_logic;
        rxhalff:    out std_logic;
        rxflag:     out std_logic;
        rxdata:     out std_logic_vector(7 downto 0);
        rxread:     in  std_logic;
        started:    out std_logic;
        connecting: out std_logic;
        running:    out std_logic;
        errdisc:    out std_logic;
        errpar:     out std_logic;
        erresc:     out std_logic;
        errcred:    out std_logic;
        spw_di:     in  std_logic;
        spw_si:     in  std_logic;
        spw_do:     out std_logic;
        spw_so:     out std_logic
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
	
--	-- Component Double clock frequency (DCM)
--	COMPONENT clock_pll
--	PORT(
--		CLKIN_IN : IN std_logic;
--		RST_IN : IN std_logic;  	
--		CLKIN_IBUFG_OUT : OUT std_logic;
--		CLK0_OUT : OUT std_logic;
--		CLK2X_OUT : OUT std_logic;
--		LOCKED_OUT : OUT std_logic
--		);
--	END COMPONENT;
	----------------------------
	
	COMPONENT clock_pll2
	PORT(
		CLKIN1_IN : IN std_logic;
		RST_IN : IN std_logic;          
		CLK0_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;

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
	
	type state_type1 is (estado_desativado1, estado_leitura1, estado_espera1, estado_escreve1);
	signal estado_codec1 : state_type1;
	
	--
	signal RESET_doubleclk : std_logic;
	
	-- Signal GPIOs:
	signal s_GPIOs_i : std_logic_vector(2 downto 0) := (OTHERS => '0');
	signal s_GPIOs_o : std_logic_vector(5 downto 3) := (OTHERS => '0');
	--------------------------------------------------------------------------------------
	
	
	-- Signal SpW light
	signal sig_autostart : std_logic;
	signal sig_linkstart : std_logic;
	signal sig_linkdis   : std_logic;
	
	signal sig_rst      : std_logic;
	signal sig_tick_in  : std_logic;
    signal sig_ctrl_in  : std_logic_vector(1 downto 0);
	signal sig_time_in  : std_logic_vector(5 downto 0) := (others => '0');
	signal sig_txwrite  : std_logic;
	signal sig_txflag   : std_logic;
	signal sig_txdata   : std_logic_vector(7 downto 0) := (others => '0');
	signal sig_txrdy    : std_logic;
	signal sig_txhalff  : std_logic;
	signal sig_tick_out : std_logic;
	signal sig_ctrl_out	: std_logic_vector(1 downto 0);
	signal sig_time_out	: std_logic_vector(5 downto 0);
	signal sig_rxvalid  : std_logic;
	signal sig_rxhalff  : std_logic;
	signal sig_rxflag   : std_logic;
	signal sig_rxdata   : std_logic_vector(7 downto 0);
	signal sig_rxread   : std_logic;
	signal sig_started  : std_logic;
	signal sig_connecting : std_logic;
	signal sig_running  : std_logic;
	signal sig_errdisc  : std_logic;
	signal sig_errpar   : std_logic;
	signal sig_erresc   : std_logic;
	signal sig_errcred  : std_logic;
	signal sig_spw_di   : std_logic;
	signal sig_spw_si   : std_logic;
	signal sig_spw_do   : std_logic;
	signal sig_spw_so   : std_logic;

	-- Signal SpW light 1 (gera numeros e escreve)
	signal sig_autostart1 : std_logic;
	signal sig_linkstart1 : std_logic;
	signal sig_linkdis1   : std_logic;
	
	signal sig_rst1      : std_logic;
	signal sig_tick_in1  : std_logic;
    signal sig_ctrl_in1  : std_logic_vector(1 downto 0);
	signal sig_time_in1  : std_logic_vector(5 downto 0) := (others => '0');
	signal sig_txwrite1  : std_logic;
	signal sig_txflag1   : std_logic;
	signal sig_txdata1   : std_logic_vector(7 downto 0) := (others => '0');
	signal sig_txrdy1    : std_logic;
	signal sig_txhalff1  : std_logic;
	signal sig_tick_out1 : std_logic;
	signal sig_ctrl_out1	: std_logic_vector(1 downto 0);
	signal sig_time_out1	: std_logic_vector(5 downto 0);
	signal sig_rxvalid1  : std_logic;
	signal sig_rxhalff1  : std_logic;
	signal sig_rxflag1   : std_logic;
	signal sig_rxdata1   : std_logic_vector(7 downto 0);
	signal sig_rxread1   : std_logic;
	signal sig_started1  : std_logic;
	signal sig_connecting1 : std_logic;
	signal sig_running1  : std_logic;
	signal sig_errdisc1  : std_logic;
	signal sig_errpar1   : std_logic;
	signal sig_erresc1   : std_logic;
	signal sig_errcred1  : std_logic;
	signal sig_spw_di1   : std_logic;
	signal sig_spw_si1   : std_logic;
	signal sig_spw_do1   : std_logic;
	signal sig_spw_so1   : std_logic;
	
	signal codec_state : std_logic_vector(6 downto 0);
	
	signal LED2 : std_logic := '0';
	
begin

--Clk <= CLOCK;
--RESET_doubleclk <= not(RESET);

--	Inst_clock_pll: clock_pll PORT MAP(
--		CLKIN_IN => CLOCK,
--		RST_IN => not(RESET),
--		CLKIN_IBUFG_OUT => OPEN,
--		CLK0_OUT => OPEN,
--		CLK2X_OUT => Clk,
--		LOCKED_OUT => RESET_doubleclk 
--	);
	

	Inst_clock_pll2: clock_pll2 PORT MAP(
		CLKIN1_IN => CLOCK,
		RST_IN => not(RESET),
		CLK0_OUT => Clk,
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


	c_SpW_light: spwstream
	generic map(
        sysfreq		=> 100.0e6,
        txclkfreq	=> 100.0e6,
        rximpl		=> impl_generic,
        rxchunk		=> 1,
        tximpl		=> impl_generic,
        rxfifosize_bits => 11,
        txfifosize_bits => 11
    )
    port map(
        clk 	=> Clk,
        rxclk	=> Clk,
        txclk	=> Clk,
        rst		=> not(RESET_doubleclk),
        autostart 	=> sig_autostart,
        linkstart	=> sig_linkstart,
        linkdis		=> sig_linkdis,
        txdivcnt	=> "00000001",
        tick_in		=> sig_tick_in,
        ctrl_in		=> sig_ctrl_in,
        time_in		=> sig_time_in,
        txwrite		=> sig_txwrite,
        txflag		=> sig_txflag,
        txdata		=> sig_txdata,
        txrdy		=> sig_txrdy,
        txhalff		=> sig_txhalff,
        tick_out	=> sig_tick_out,
        ctrl_out	=> sig_ctrl_out,
        time_out	=> sig_time_out,
        rxvalid		=> sig_rxvalid,
        rxhalff		=> sig_rxhalff,
        rxflag		=> sig_rxflag,
        rxdata		=> sig_rxdata,
        rxread		=> sig_rxread,
        started		=> sig_started,
        connecting	=> sig_connecting,
        running		=> sig_running,
        errdisc		=> sig_errdisc,
        errpar		=> sig_errpar,
        erresc		=> sig_erresc,
        errcred		=> sig_errcred,
        spw_di		=> sig_spw_di,
        spw_si		=> sig_spw_si,
        spw_do		=> sig_spw_do,
        spw_so		=> sig_spw_so
    );
	
	
	c_SpW_light1: spwstream
	generic map(
        sysfreq		=> 100.0e6,
        txclkfreq	=> 100.0e6,
        rximpl		=> impl_generic,
        rxchunk		=> 1,
        tximpl		=> impl_generic,
        rxfifosize_bits => 11,
        txfifosize_bits => 11
    )
    port map(
        clk 	=> Clk,
        rxclk	=> Clk,
        txclk	=> Clk,
        rst		=> not(RESET_doubleclk),
        autostart 	=> sig_autostart1,
        linkstart	=> sig_linkstart1,
        linkdis		=> sig_linkdis1,
        txdivcnt	=> "00000001",
        tick_in		=> sig_tick_in1,
        ctrl_in		=> sig_ctrl_in1,
        time_in		=> sig_time_in1,
        txwrite		=> sig_txwrite1,
        txflag		=> sig_txflag1,
        txdata		=> sig_txdata1,
        txrdy		=> sig_txrdy1,
        txhalff		=> sig_txhalff1,
        tick_out	=> sig_tick_out1,
        ctrl_out	=> sig_ctrl_out1,
        time_out	=> sig_time_out1,
        rxvalid		=> sig_rxvalid1,
        rxhalff		=> sig_rxhalff1,
        rxflag		=> sig_rxflag1,
        rxdata		=> sig_rxdata1,
        rxread		=> sig_rxread1,
        started		=> sig_started1,
        connecting	=> sig_connecting1,
        running		=> sig_running1,
        errdisc		=> sig_errdisc1,
        errpar		=> sig_errpar1,
        erresc		=> sig_erresc1,
        errcred		=> sig_errcred1,
        spw_di		=> sig_spw_di1,
        spw_si		=> sig_spw_si1,
        spw_do		=> sig_spw_do1,
        spw_so		=> sig_spw_so1
    );
	
	
-- =========================================
-- * * * * * Inicializando conexao * * * * *
-- =========================================

--MReset      <= '0';	
--LinkStart1    <= '1';
--LinkDisable1  <= '0';
--AutoStart1    <= '1';

	sig_autostart <= '1';
	sig_linkstart <= '1';
	sig_linkdis <= '0';
	
	sig_autostart1 <= '1';
	sig_linkstart1 <= '1';
	sig_linkdis1 <= '0';
	
-- =========================================

-- =========================================
-- * * Transformar status codec em vetor * *
-- =========================================
	codec_state <=  sig_started & 
					sig_connecting & 
					sig_running & 
					sig_errdisc & 
					sig_errpar & 
					sig_erresc & 
					sig_errcred;
-- =========================================


s_GPIOs_i <= GPIOs_i;
GPIOs_o <= s_GPIOs_o;


-- ==========================================
-- * * * *  Exibir rxdata nos leds  * * * * *
-- ==========================================

---- Exibir dados do RX_Data1 nos leds da placa Filha
--LEDs_PF(7) <= RX_Data1(7);
--LEDs_PF(6) <= RX_Data1(6);
--LEDs_PF(5) <= RX_Data1(5);
--LEDs_PF(4) <= RX_Data1(4);
--LEDs_PF(3) <= RX_Data1(3);
--LEDs_PF(2) <= RX_Data1(2);
--LEDs_PF(1) <= RX_Data1(1);


LEDs_PF(7) <= LED2;
LEDs_PF(6) <= sig_rxdata(6);
LEDs_PF(5) <= sig_rxdata(5);
LEDs_PF(4) <= sig_rxdata(4);
LEDs_PF(3) <= sig_rxdata(3);
LEDs_PF(2) <= sig_rxdata(2);
LEDs_PF(1) <= sig_rxdata(1);
LEDs_PF(0) <= sig_rxdata(0);

-- =========================================


-- ==========================================
-- * * * *  loopback SpaceWire light  * * * * *
-- ==========================================
--    sig_spw_di <= sig_spw_do;
--    sig_spw_si <= sig_spw_so;
	
--	sig_spw_di <= sig_spw_do1;
--	sig_spw_si <= sig_spw_so1;
--	
--	sig_spw_di1 <= sig_spw_do;
--	sig_spw_si1 <= sig_spw_so;
	
	
-- =========================================	


-- Buffer_Write1 no GPIO_o
s_GPIOs_o(3) <= Buffer_Write1;




---- ===============================================================================================
---- = = = = = = = = = = = = = = = = = = = PROCESSO CODEC SpW 1  = = = = = = = = = = = = = = = = = = 
---- ===============================================================================================
--	PROCESS (Clk)
--	begin
--		
--		if	(rising_edge(Clk)) then
--		
--			if (sig_running1 = '0') then
--			estado_codec <= estado_desativado;
--			
--			else 
--				case estado_codec is
--					
--				when estado_desativado =>
--					if (sig_running1 = '1') then -- verifica se conexão está em "running"
--						estado_codec <= estado_inicia; -- vai para estado_inicia
--					else
--						contador <= 0;
--						somador  <= 0;
--						estado_codec <= estado_desativado; -- continua no estado desativado
--					end if;	
--						
--				when estado_inicia =>
--					if (contador < 5) then
--						contador <= contador + 1;
--						estado_codec <= estado_inicia; -- continua estado_inicia
--					else	
--						if (contador = 5) then
--							somador <= somador + 1;
--							contador <= 0;
--							estado_codec <= estado_espera; -- vai para estado_espera
--						end if;	
--					end if;	
--						
--				when estado_espera =>
--					if (sig_txrdy1 = '1') then --verifica se pode escrever dados na entrada
--						estado_codec <= estado_escreve; -- vai para estado_escreve
--					else
--						estado_codec <= estado_espera; -- continua estado_espera
--					end if;	
--						
--				when estado_escreve =>
----					if (sig_txrdy1 = '1') then
----						estado_codec <= estado_escreve;
----					else
--						estado_codec <= estado_inicia;
--						contador <= 1;
----					end if;	
--						
--				end case;
--			end if;
--		end if;
--	end PROCESS;
--	
--	-- EESTADOS CODEC SpW0
--	PROCESS (estado_codec)
--	begin
--        case estado_codec is
--		
--            when estado_desativado => 
--                sig_txwrite1 <= '0';
--				  
--            when estado_inicia =>
--                sig_txwrite1 <= '0';
--					 
--            when estado_espera =>
--				sig_txwrite1 <= '0';
--				sig_txflag1  <= '0';
--				sig_txdata1  <= std_logic_vector(to_unsigned(somador, sig_txdata1'length));
--				
--            when estado_escreve =>
--				if (somador > 2) then
--					sig_txwrite1 <= '1';
--				end if;  
--		end case;		  
--	end PROCESS;
--
---- ===============================================================================================
---- = = = = = = = = = = = = = = = = FIM PROCESSO CODEC SpW 1  = = = = = = = = = = = = = = = = = = = 
---- ===============================================================================================


	PROCESS(Clk, codec_state(4))
	variable contador2 : integer :=0;
	begin
		if rising_edge(Clk) then
			contador2 := contador2 +1;
			
			if (100000000> contador2) then
				LED2 <= '0';
			end if;
			if (contador2 >= 100000000) and (200000000>contador2) then
				if (codec_state(4) = '0') then
					LED2 <= '1';
				end if;
			end if;
			if (contador2 = 200000000) then
				contador2:= 0;
			end if;
		end if;
	end PROCESS;
	LED(2) <= LED2;


-- ===============================================================================================
-- = = = = = = = = = = = = = =   PROCESSO LOOPBACK CODEC SpW   = = = = = = = = = = = = = = = = = = 
-- ===============================================================================================
	PROCESS (Clk)
	begin
		if	(rising_edge(Clk)) then
		
			if (codec_state(4) = '0') then -- Se codec SpW NÃO está em estado de running...
				estado_codec1 <= estado_desativado1;
			else -- Se está em estado de running...
--				Tick_in1 <= Tick_out1;
--				Time_in1 <= Time_out1;
				sig_tick_in <= sig_tick_out;
				sig_time_in <= sig_time_out;
				case estado_codec1 is 
					when estado_desativado1 =>
--						if Buffer_Write1 = '1' then --Pode ler?
						if sig_rxvalid = '1' then -- Tem dado para ler?
							estado_codec1 <= estado_leitura1; -- Vai para o estado de leitura.
						else -- Se não tem dado para ler, então espera...
							estado_codec1 <= estado_desativado1;-- Espera permissao para leitura...
						end if;
					when estado_leitura1 =>
--						if (Buffer_Write1 = '0') and (TX_Ready1 = '1') then --Terminou a leitura e pode escrever?
							estado_codec1 <= estado_espera1;
					when estado_espera1 =>
						if sig_txrdy = '1' then
							estado_codec1 <= estado_escreve1;
						end if;
					when estado_escreve1 =>
--						if (TX_Ready1 = '1') then
--						if sig_txrdy = '1' then
--							estado_codec1 <= estado_escreve1; -- Continua em estado de escrita até terminar (TX_Ready1 = '0').
--						else
							estado_codec1 <= estado_desativado1;
--						end if;
				end case;
				
			end if;
		
		end if;
	end PROCESS;
	
	PROCESS (estado_codec1)
	begin
        case estado_codec1 is
		
            when estado_desativado1 => 
--              TX_Write1 <= '0';
--				Buffer_Ready1 <= '1'; -- Pede pra realizar leitura.

				sig_txwrite <= '0'; -- Nao escreve
				sig_rxread <= '0'; -- Espera para poder ler
            when estado_leitura1 =>
--              TX_Write1 <= '0';
--				Buffer_Ready1 <= '0'; -- Realiza a leitura.	 
				sig_rxread <= '1'; -- Realiza leitura
				sig_txwrite <= '0'; -- Nao escreve
				sig_txdata <= sig_rxdata;
				sig_txflag <= sig_rxflag;
			
			when estado_espera1 =>
				sig_rxread <= '0';
				sig_txwrite <= '0';
			
            when estado_escreve1 =>
--              TX_Write1 <= '1'; -- Realiza a escrita
-- 				Buffer_Ready1 <= '1';
				sig_rxread <= '0'; -- Para de fazer a leitura
				sig_txwrite <= '1'; -- Realiza a escrita
				
		end case;		  
	end PROCESS;
	
-- ===============================================================================================
-- = = = = = = = = = = = = = =   FIM PROCESSO LOOPBACK CODEC SpW   = = = = = = = = = = = = = = = =
-- ===============================================================================================	
	
	PROCESS(RESET_doubleclk)
	begin
		if (not(RESET_doubleclk)='1') then
			LED(1) <= '1'; -- Status para saber se o programa está rodando na fpga.
			--LED(2) <= '0'; -- Status para saber se o programa está rodando na fpga.
		else
			LED(1) <= '0'; -- Status para saber se o programa está rodando na fpga.
			--LED(2) <= '1'; -- Status para saber se o programa está rodando na fpga.
		end if;	
	end PROCESS;

LED(3) <= sig_running; -- Exibir status do estado "running".

-----------------------------------------------------------------------------
 --Lvds J1
-----------------------------------------------------------------------------
  OBUFDS_INSTANCE_LVDSd : OBUFDS port map
    (
      O  => LVDS_DOUT_p,
      OB => LVDS_DOUT_n,
      I  => sig_spw_do
      );
	  
  OBUFDS_INSTANCE_LVDSs : OBUFDS port map
    (
      O  => LVDS_SOUT_p,
      OB => LVDS_SOUT_n,
      I  => sig_spw_so
      );
	  
  IBUFDS_inst_d : IBUFDS port map
    (
      O  => sig_spw_di,
      I  => LVDS_DIN_p,
      IB => LVDS_DIN_n
      );
	  
  IBUFDS_inst_s : IBUFDS port map
    (
      O  => sig_spw_si,
      I  => LVDS_SIN_p,
      IB => LVDS_SIN_n
      );	



end Behavioral;



