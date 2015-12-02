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

	-- Component clock_pll -- Increase frequency - 50MHz to 200Mhz
	COMPONENT clock_pll2
	PORT(
		CLKIN1_IN : IN std_logic;
		RST_IN : IN std_logic;          
		CLK0_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;
	----------------------------


	-- outputs clock_pll:
	signal Clk           : std_logic :='0';
	signal RESET_doubleclk : std_logic;
	
	
	-- Estados:
	type state_type is (estado_desativado, estado_inicia, estado_espera, estado_escreve); 
	signal estado_codec : state_type;
	
	type state_type1 is (estado_desativado1, estado_leitura1, estado_espera1, estado_escreve1);
	signal estado_codec1 : state_type1;
	
	
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

	-- Signal estado codec (6-sig_started, 5-sig_connecting, 4-sig_running, 3-sig_errdisc 
	-- 											2-sig_errpar, 1-sig_erresc, 0-sig_errcred)
	signal codec_state : std_logic_vector(6 downto 0);
	

	
begin

	Inst_clock_pll2: clock_pll2 PORT MAP(
		CLKIN1_IN => CLOCK,
		RST_IN => not(RESET),
		CLK0_OUT => Clk,
		LOCKED_OUT => RESET_doubleclk
	);
 

	c_SpW_light: spwstream
	generic map(
        sysfreq		=> 200.0e6,
        txclkfreq	=> 200.0e6,
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
	
		
	
-- =========================================
-- * * * * * Inicializando conexao * * * * *
-- =========================================

	sig_autostart <= '1';
	sig_linkstart <= '1';
	sig_linkdis <= '0';
		
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

LEDs_PF(7) <= sig_rxdata(7);
LEDs_PF(6) <= sig_rxdata(6);
LEDs_PF(5) <= sig_rxdata(5);
LEDs_PF(4) <= sig_rxdata(4);
LEDs_PF(3) <= sig_rxdata(3);
LEDs_PF(2) <= sig_rxdata(2);
LEDs_PF(1) <= sig_rxdata(1);
LEDs_PF(0) <= sig_rxdata(0);

-- =========================================


LED(3) <= codec_state(4); -- Exibir status do codec "running".


-- ===============================================================================================
-- * * * * * * * * * * * * * *   PROCESSO LOOPBACK CODEC SpW   * * * * * * * * * * * * * * * * * *
-- ===============================================================================================
	PROCESS (Clk)
	begin
		if	(rising_edge(Clk)) then
		
			if (codec_state(4) = '0') then -- Se codec SpW NÃO está em estado de running...
				estado_codec1 <= estado_desativado1;
			else -- Se está em estado de running...
				sig_tick_in <= sig_tick_out;
				sig_time_in <= sig_time_out;
				case estado_codec1 is 
					when estado_desativado1 =>
						if sig_rxvalid = '1' then -- Tem dado para ler?
							estado_codec1 <= estado_leitura1; -- Vai para o estado de leitura.
						else -- Se não tem dado para ler, então espera...
							estado_codec1 <= estado_desativado1;-- Espera permissao para leitura...
						end if;
					when estado_leitura1 =>
							estado_codec1 <= estado_espera1;
					when estado_espera1 =>
						if sig_txrdy = '1' then
							estado_codec1 <= estado_escreve1;
						end if;
					when estado_escreve1 =>
							estado_codec1 <= estado_desativado1;

				end case;
				
			end if;
		
		end if;
	end PROCESS;
	
	PROCESS (estado_codec1)
	begin
	
        case estado_codec1 is
		
            when estado_desativado1 =>
				sig_txwrite <= '0'; -- Nao escreve
				sig_rxread <= '0'; -- Espera para poder ler
				
            when estado_leitura1 =>
				sig_rxread <= '1'; -- Realiza leitura
				sig_txwrite <= '0'; -- Nao escreve
				sig_txdata <= sig_rxdata;
				sig_txflag <= sig_rxflag;
			
			when estado_espera1 =>
				sig_rxread <= '0';
				sig_txwrite <= '0';
			
            when estado_escreve1 =>
				sig_rxread <= '0'; -- Para de fazer a leitura
				sig_txwrite <= '1'; -- Realiza a escrita
				
		end case;	
		
	end PROCESS;
	
-- ================================================  FIM PROCESSO LOOPBACK CODEC SpW 


-- =================================================================================
-- * * * * * * * * *   PROCESSO MOSTRAR ACIONAMENTO DO RESET   * * * * * * * * * * *
-- =================================================================================
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
-- ==================================================================================


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