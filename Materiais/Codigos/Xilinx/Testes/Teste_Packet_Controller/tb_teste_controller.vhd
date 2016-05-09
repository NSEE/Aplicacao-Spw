--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:32:59 01/17/2016
-- Design Name:   
-- Module Name:   E:/Users/Dennis Teles/Documentos/SpW/Aplicacao-Spw/Materiais/Codigos/Xilinx/Testes/Teste_Packet_Controller/tb_teste_controller.vhd
-- Project Name:  Teste_Packet_Controller
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Packet_controller
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.spwpkg.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_teste_controller IS
END tb_teste_controller;
 
ARCHITECTURE behavior OF tb_teste_controller IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
	
	
    COMPONENT Packet_receiver
    PORT(
         CLOCK : IN  std_logic;
         RESET : IN  std_logic;
         rx_valid_i : IN  std_logic;
         RX_Data : IN  std_logic_vector(7 downto 0);
         RX_flag_i : IN  std_logic;
         RX_read_o : OUT  std_logic;
         Data_ack_o : OUT  std_logic;
         Data_pkt_flag : OUT  std_logic;
         Data_pkt : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    -----------------------------------------------------------
	
	-- Component Declaration for the Unit Under Test 2/3 (UUT2/3)
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
	
	-- Component Declaration for the Unit Under Test 4 (UUT4)
	COMPONENT Packet_controller
    PORT(
		CLOCK : in  STD_LOGIC;
		RESET : in  STD_LOGIC;

		-- inputs
		Data_pkt_flag_i : in  STD_LOGIC;
		Data_pkt : in  STD_LOGIC_VECTOR (31 downto 0);
		Reg_dado_out : in std_logic_vector(7 downto 0);

		-- outputs
		Reg_addr_o : out std_logic_vector(6 downto 0);
		Reg_dado_o : out std_logic_vector(7 downto 0);
		Reg_rw_o : out std_logic;	
		Reg_en_o : out std_logic;
		Answer_flag_o : out std_logic;
		Answer_pkt_o : out std_logic_vector(39 downto 0)
		);
    END COMPONENT;
		   
	-- Component Declaration for the Unit Under Test 5 (UUT5)
	COMPONENT Reg_Geral
    PORT(
		clk : IN  std_logic;
        aclr : IN  std_logic;
        reg_addr : IN  std_logic_vector(6 downto 0);
        reg_dado_in : IN  std_logic_vector(7 downto 0);
        reg_dado_out : OUT  std_logic_vector(7 downto 0);
        reg_rw : IN  std_logic;
        reg_en : IN  std_logic;
        -- D/A converter signals
		DA_CH0_en : OUT  std_logic;
        DA_CH0_next : IN  std_logic;
        DA_CH0_dado : OUT  std_logic_vector(15 downto 0);
        DA_CH1_en : OUT  std_logic;
        DA_CH1_next : IN  std_logic;
        DA_CH1_dado : OUT  std_logic_vector(15 downto 0);
		-- A/D converter signals
		AD_CH0_en : out STD_LOGIC;
		AD_CH0_next : in STD_LOGIC;
		AD_CH0_dado : out STD_LOGIC_VECTOR(18 DOWNTO 0);
		AD_CH1_en : out STD_LOGIC;
		AD_CH1_next : in STD_LOGIC;
		AD_CH1_dado : out STD_LOGIC_VECTOR(18 DOWNTO 0)
        );
    END COMPONENT;
	
	 -------------------------------------------------------------------------------------------------------------

   --Inputs
   signal CLOCK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal rx_valid_i : std_logic := '0';
   signal RX_Data : std_logic_vector(7 downto 0) := (others => '0');
   signal RX_flag_i : std_logic := '0';

 	--Outputs
   signal RX_read_o : std_logic;
   signal Data_ack_o : std_logic;
   signal Data_pkt_flag : std_logic;
   signal Data_pkt : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLOCK_period : time := 10 ns;
   
   	-- Signal SpW light
	signal sig_autostart : std_logic;
	signal sig_linkstart : std_logic;
	signal sig_linkdis   : std_logic;
	
	signal sig_tick_in  : std_logic := '0';
    signal sig_ctrl_in  : std_logic_vector(1 downto 0) := "00";
	signal sig_time_in  : std_logic_vector(5 downto 0) := (others => '0');
	signal sig_txwrite  : std_logic := '0';
	signal sig_txflag   : std_logic := '0';
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
	
	-- Signal SpW light 2
	signal sig_autostart2 : std_logic;
	signal sig_linkstart2 : std_logic;
	signal sig_linkdis2   : std_logic;

	signal sig_tick_in2  : std_logic := '0';
    signal sig_ctrl_in2  : std_logic_vector(1 downto 0);
	signal sig_time_in2  : std_logic_vector(5 downto 0) := (others => '0');
	signal sig_txwrite2  : std_logic := '0';
	signal sig_txflag2   : std_logic := '0';
	signal sig_txdata2   : std_logic_vector(7 downto 0) := (others => '0');
	signal sig_txrdy2    : std_logic;
	signal sig_txhalff2  : std_logic;
	signal sig_tick_out2 : std_logic;
	signal sig_ctrl_out2	: std_logic_vector(1 downto 0);
	signal sig_time_out2	: std_logic_vector(5 downto 0);
	signal sig_rxvalid2  : std_logic;
	signal sig_rxhalff2  : std_logic;
	signal sig_rxflag2   : std_logic;
	signal sig_rxdata2   : std_logic_vector(7 downto 0);
	signal sig_rxread2   : std_logic;
	signal sig_started2  : std_logic;
	signal sig_connecting2 : std_logic;
	signal sig_running2  : std_logic;
	signal sig_errdisc2  : std_logic;
	signal sig_errpar2   : std_logic;
	signal sig_erresc2   : std_logic;
	signal sig_errcred2  : std_logic;
	signal sig_spw_di2   : std_logic;
	signal sig_spw_si2   : std_logic;
	signal sig_spw_do2   : std_logic;
	signal sig_spw_so2   : std_logic;
	
	
	-- Signal packet_controller
	signal Reg_addr_o_s : std_logic_vector(6 downto 0);
	signal Reg_dado_o_s : std_logic_vector(7 downto 0);
	signal reg_dado_out_s : std_logic_vector(7 downto 0);
	signal Reg_rw_o_s : std_logic;	
	signal Reg_en_o_s : std_logic;
	signal Answer_flag_o_s : std_logic;
	signal Answer_pkt_o_s :	std_logic_vector(39 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Packet_receiver PORT MAP (
          CLOCK => CLOCK,
          RESET => RESET,
          rx_valid_i => sig_rxvalid2,
          RX_Data => sig_rxdata2,
          RX_flag_i => sig_rxflag2,
          RX_read_o => sig_rxread2,
          Data_ack_o => Data_ack_o,
          Data_pkt_flag => Data_pkt_flag,
          Data_pkt => Data_pkt
        );
		
	-- ===========================================================================

	-- Instantiate the Unit Under Test 2 (UUT2)
	uut2: spwstream generic map(
        sysfreq		=> 100.0e6,
        txclkfreq	=> 100.0e6,
        rximpl		=> impl_generic,
        rxchunk		=> 1,
        tximpl		=> impl_generic,
        rxfifosize_bits => 11,
        txfifosize_bits => 11
    )
    port map(
        clk 	=> CLOCK,
        rxclk	=> CLOCK,
        txclk	=> CLOCK,
        rst		=> RESET,
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
	
   -- ===========================================================================
	
		-- Instantiate the Unit Under Test 3 (UUT3)
	uut3: spwstream generic map(
        sysfreq		=> 100.0e6,
        txclkfreq	=> 100.0e6,
        rximpl		=> impl_generic,
        rxchunk		=> 1,
        tximpl		=> impl_generic,
        rxfifosize_bits => 11,
        txfifosize_bits => 11
    )
    port map(
        clk 	=> CLOCK,
        rxclk	=> CLOCK,
        txclk	=> CLOCK,
        rst		=> RESET,
        autostart 	=> sig_autostart2,
        linkstart	=> sig_linkstart2,
        linkdis		=> sig_linkdis2,
        txdivcnt	=> "00000001",
        tick_in		=> sig_tick_in2,
        ctrl_in		=> sig_ctrl_in2,
        time_in		=> sig_time_in2,
        txwrite		=> sig_txwrite2,
        txflag		=> sig_txflag2,
        txdata		=> sig_txdata2,
        txrdy		=> sig_txrdy2,
        txhalff		=> sig_txhalff2,
        tick_out	=> sig_tick_out2,
        ctrl_out	=> sig_ctrl_out2,
        time_out	=> sig_time_out2,
        rxvalid		=> sig_rxvalid2,
        rxhalff		=> sig_rxhalff2,
        rxflag		=> sig_rxflag2,
        rxdata		=> sig_rxdata2,
        rxread		=> sig_rxread2,
        started		=> sig_started2,
        connecting	=> sig_connecting2,
        running		=> sig_running2,
        errdisc		=> sig_errdisc2,
        errpar		=> sig_errpar2,
        erresc		=> sig_erresc2,
        errcred		=> sig_errcred2,
        spw_di		=> sig_spw_di2,
        spw_si		=> sig_spw_si2,
        spw_do		=> sig_spw_do2,
        spw_so		=> sig_spw_so2
    );
	
	
	-- Instantiate the Unit Under Test 4 (UUT4)
	uut4: Packet_controller PORT MAP (
		CLOCK => CLOCK,
		RESET => RESET,
		Data_pkt_flag_i => Data_pkt_flag,
		Data_pkt => Data_pkt,
		Reg_dado_out => reg_dado_out_s,
		Reg_addr_o => Reg_addr_o_s,
		Reg_dado_o => Reg_dado_o_s,
		Reg_rw_o => Reg_rw_o_s,	
		Reg_en_o => Reg_en_o_s,
		Answer_flag_o => Answer_flag_o_s,
		Answer_pkt_o => Answer_pkt_o_s		   
        );


	-- Instantiate the Unit Under Test 5 (UUT5)
	uut5: Reg_Geral PORT MAP (
          clk => CLOCK,
          aclr => '0',
          reg_addr => reg_addr_o_s,
          reg_dado_in => reg_dado_o_s,
          reg_dado_out => reg_dado_out_s,
          reg_rw => reg_rw_o_s,
          reg_en => reg_en_o_s,
          DA_CH0_en => OPEN,
          DA_CH0_next => '0',
          DA_CH0_dado => OPEN,
          DA_CH1_en => OPEN,
          DA_CH1_next => '0',
          DA_CH1_dado =>OPEN,
		  AD_CH0_en => OPEN,
		  AD_CH0_next => '0',
		  AD_CH0_dado => OPEN,
	      AD_CH1_en => OPEN,
		  AD_CH1_next => '0',
		  AD_CH1_dado => OPEN
		  );

	sig_spw_di <= sig_spw_do2;
	sig_spw_si <= sig_spw_so2;
	sig_spw_di2 <= sig_spw_do;
	sig_spw_si2 <= sig_spw_so;
	
   -- Clock process definitions
   CLOCK_process :process
   begin
		CLOCK <= '0';
		wait for CLOCK_period/2;
		CLOCK <= '1';
		wait for CLOCK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLOCK_period*10;

      -- insert stimulus here 
	sig_autostart <= '1';
	sig_linkstart <= '1';
	sig_linkdis <= '0';
	sig_autostart2 <= '1';
	sig_linkstart2 <= '1';
	sig_linkdis2 <= '0';  
	  
	RESET <= '0';
	  wait for 20 ns;
	RESET <= '1';
	  wait for 20 ns;
	RESET <= '0';
	
	sig_txwrite <= '0';
	
	wait for 30 us;
	
		sig_txdata <= x"FA";
		wait for 10 ns;
		sig_txflag <= '0';
		sig_txwrite <= '1';
		
	
		wait for 10 ns;
		sig_txwrite <= '0';
		
		wait for 100 ns;
		
		sig_txdata <= x"10"; -- Write = x"01" / read = x"10"
		wait for 10 ns;
		sig_txflag <= '0';
		sig_txwrite <= '1';		
		wait for 10 ns;
		sig_txwrite <= '0';
		
		wait for 100 ns;
		
		sig_txdata <= x"4A";
		wait for 10 ns;
		sig_txflag <= '0';
		sig_txwrite <= '1';		
		wait for 10 ns;
		sig_txwrite <= '0';
		
		wait for 500 ns;
		
		sig_txdata <= x"CD";
		wait for 10 ns;
		sig_txflag <= '0';
		sig_txwrite <= '1';		
		wait for 10 ns;
		sig_txwrite <= '0';
		
		sig_txflag <= '1';
		sig_txdata <= "00000000"; -- "00000001" = EEP // "00000000" = EOP
		wait for 10 ns;
		sig_txwrite <= '1';		
		wait for 10 ns;
		sig_txwrite <= '0';
		
      wait;
   end process;

END;
