--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:47:55 08/13/2015
-- Design Name:   
-- Module Name:   C:/Users/Dennis/Desktop/Aplicacao-Spw/Materiais/Codigos/Xilinx/AplicacaoSpW/TB_apSpW/TB_apSpW.vhd
-- Project Name:  TB_apSpW
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Reg_Geral
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_apSpW IS
    Generic (
	      N : positive := 16;
			CPOL : std_logic := '0';
			CPHA : std_logic := '0';
			PREFETCH : positive := 2;
			SPI_2X_CLK_DIV : positive := 5);
END TB_apSpW;
 
ARCHITECTURE behavior OF TB_apSpW IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Reg_Geral
    PORT(
         clk : IN  std_logic;
         aclr : IN  std_logic;
         reg_addr : IN  std_logic_vector(6 downto 0);
         reg_dado_in : IN  std_logic_vector(7 downto 0);
         reg_dado_out : OUT  std_logic_vector(7 downto 0);
         reg_rw : IN  std_logic;
         reg_en : IN  std_logic;
         DA_CH0_en : OUT  std_logic;
         DA_CH0_next : IN  std_logic;
         DA_CH0_dado : OUT  std_logic_vector(15 downto 0);
         DA_CH1_en : OUT  std_logic;
         DA_CH1_next : IN  std_logic;
         DA_CH1_dado : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    
	 COMPONENT spi_master
    GENERIC(   
        N : positive := 16;                                             -- 32bit serial word length is default
        CPOL : std_logic := '0';                                        -- SPI mode selection (mode 0 default)
        CPHA : std_logic := '0';                                        -- CPOL = clock polarity, CPHA = clock phase.
        PREFETCH : positive := 2;                                       -- prefetch lookahead cycles
        SPI_2X_CLK_DIV : positive := 5);                                -- for a 100MHz sclk_i, yields a 10MHz SCK
    PORT(  
        sclk_i : in std_logic := 'X';                                   -- high-speed serial interface system clock
        pclk_i : in std_logic := 'X';                                   -- high-speed parallel interface system clock
        rst_i : in std_logic := 'X';                                    -- reset core
        ---- serial interface ----
        spi_ssel_o : out std_logic;                                     -- spi bus slave select line
        spi_sck_o : out std_logic;                                      -- spi bus sck
        spi_mosi_o : out std_logic;                                     -- spi bus mosi output
        spi_miso_i : in std_logic := 'X';                               -- spi bus spi_miso_i input
        ---- parallel interface ----
        di_req_o : out std_logic;                                       -- preload lookahead data request line
        di_i : in  std_logic_vector (N-1 downto 0) := (others => 'X');  -- parallel data in (clocked on rising spi_clk after last bit)
        wren_i : in std_logic := 'X';                                   -- user data write enable, starts transmission when interface is idle
        wr_ack_o : out std_logic;                                       -- write acknowledge
        do_valid_o : out std_logic;                                     -- do_o data valid signal, valid during one spi_clk rising edge.
        do_o : out  std_logic_vector (N-1 downto 0)                    -- parallel output (clocked on rising spi_clk after last bit)
    );
	 END COMPONENT;
	
--	 COMPONENT SPI_controller
--    PORT(
--         ACT_bit : IN  std_logic;
--         data_req : IN  std_logic;
--         CLK : IN  std_logic;
--         RST_IN : IN  std_logic;
--         DA_CH0_ack_o : OUT  std_logic;
--         wren_m_c : OUT  std_logic
--        );
--    END COMPONENT;
	 
	 COMPONENT DAC_controller
	 GENERIC(   
        N : positive := 16);  
    PORT(
           CLK : in  STD_LOGIC;
           RST_IN : in  STD_LOGIC;
			  DA_CHA_data : in STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
			  DA_CHB_data : in STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
           ACTb_CHA : in  STD_LOGIC;
           ACTb_CHB : in  STD_LOGIC;
           data_req : in  STD_LOGIC;
           DA_CHA_ack_o : out  STD_LOGIC;
           wren_m_c : out  STD_LOGIC;
           DA_CHB_ack_o : out  STD_LOGIC;
			  data_to_spi : out STD_LOGIC_VECTOR(N-1 downto 0)
        );
    END COMPONENT;
        	
	-- Registrador sinais ------------------------------------------------------
		--Inputs
		signal clk : std_logic := '0';
		signal aclr : std_logic := '0';
		signal reg_addr : std_logic_vector(6 downto 0) := (others => '0');
		signal reg_dado_in : std_logic_vector(7 downto 0) := (others => '0');
		signal reg_rw : std_logic := '0';
		signal reg_en : std_logic := '0';
		signal DA_CH0_next : std_logic := '0';
		signal DA_CH1_next : std_logic := '0';

		--Outputs
		signal reg_dado_out : std_logic_vector(7 downto 0);
		signal DA_CH0_en : std_logic;
		signal DA_CH0_dado : std_logic_vector(N-1 downto 0);
		signal DA_CH1_en : std_logic;
		signal DA_CH1_dado : std_logic_vector(N-1 downto 0);
   ----------------------------------------------------------------------------
	
	-- Spi_master sinais -------------------------------------------------------
		--Inputs
		signal sclk_i : std_logic := '0';
		signal pclk_i : std_logic := '0';
		signal rst_i : std_logic := '0';
		signal spi_miso_i : std_logic := '0';
		signal di_i : std_logic_vector(N-1 downto 0) := (others => '0');
		signal wren_i : std_logic := '0';

		--Outputs
		signal spi_ssel_o : std_logic;
		signal spi_sck_o : std_logic;
		signal spi_mosi_o : std_logic;
		signal di_req_o : std_logic;
		signal wr_ack_o : std_logic;
		signal do_valid_o : std_logic;
		signal do_o : std_logic_vector(N-1 downto 0);

   ----------------------------------------------------------------------------
	
	-- spi_controller ----------------------------------------------------------
	   --Inputs
		signal ACT_bit : std_logic := '0';
		signal data_req : std_logic := '0';
--		signal CLK : std_logic := '0';
		signal RST_IN : std_logic := '0';

		--Outputs
		signal DA_CH0_ack_o : std_logic;
		signal wren_m_c : std_logic;
   ----------------------------------------------------------------------------
	
	-- DAC_controller ----------------------------------------------------------
	   --Outputs
		signal data_to_spi : std_logic_vector(N-1 downto 0);
	----------------------------------------------------------------------------	
	
   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut_reg: Reg_Geral PORT MAP (
          clk => clk,
          aclr => aclr,
          reg_addr => reg_addr,
          reg_dado_in => reg_dado_in,
          reg_dado_out => reg_dado_out,
          reg_rw => reg_rw,
          reg_en => reg_en,
          DA_CH0_en => DA_CH0_en,
          DA_CH0_next => DA_CH0_next,
          DA_CH0_dado => DA_CH0_dado,
          DA_CH1_en => DA_CH1_en,
          DA_CH1_next => DA_CH1_next,
          DA_CH1_dado => DA_CH1_dado
        );
	
	-- Instantiate the Unit Under Test 2 (UUT2)
   uut_spi_m: spi_master PORT MAP (
          sclk_i => clk,
          pclk_i => clk,
          rst_i => rst_i,
          spi_ssel_o => spi_ssel_o,
          spi_sck_o => spi_sck_o,
          spi_mosi_o => spi_mosi_o,
          spi_miso_i => spi_miso_i,
          di_req_o => di_req_o,
          di_i => data_to_spi,
          wren_i => wren_i,
          wr_ack_o => wr_ack_o,
          do_valid_o => do_valid_o,
          do_o => do_o
        );
	
	-- Instantiate the Unit Under Test 3(UUT3)
--   uut_spi_ctrl: SPI_controller PORT MAP (
--          ACT_bit => DA_CH0_en,
--          data_req => di_req_o,
--          CLK => clk,
--          RST_IN => RST_IN,
--          DA_CH0_ack_o => DA_CH0_next,
--          wren_m_c => wren_i
--        );
	-- Instantiate the Unit Under Test 4 (UUT4)
	uut_dac_ctrl: DAC_Controller PORT MAP (
	        CLK => clk,
           RST_IN => RST_IN,
			  DA_CHA_data => DA_CH0_dado,
			  DA_CHB_data => DA_CH1_dado,
           ACTb_CHA => DA_CH0_en,
           ACTb_CHB => DA_CH1_en,
           data_req => di_req_o,
           DA_CHA_ack_o => DA_CH0_next,
           wren_m_c => wren_i,
           DA_CHB_ack_o => DA_CH1_next,
			  data_to_spi => data_to_spi
			);  
	
   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		
		---------------------------------------------------
		-- Inserindo valores no registrador
		---------------------------------------------------
			reg_addr <= "0011110"; -- endereco 30 (endereco de config do D/A canal 0)
			reg_dado_in <= "00000011"; -- dado a ser escrito no registrador
			reg_rw <= '0'; -- '0': comando de escrita
			wait for 10 ns;
			reg_en <= '1'; -- ativa entrada/saida do registrador
			wait for 20 ns;
			reg_en <= '0'; -- desativa entrada/saida do registrador
			
			wait for 200 ns;
			
			reg_addr <= "0100000"; -- endereco 32 - CH0 LSB
			reg_dado_in <= "10101010"; -- dado a ser escrito no registrador
			reg_rw <= '0'; -- '0': comando de escrita
			wait for 10 ns;
			reg_en <= '1'; -- ativa entrada/saida do registrador
			wait for 20 ns;
			reg_en <= '0'; -- desativa entrada/saida do registrador
			
			wait for 200 ns;
			
			reg_addr <= "0011111"; -- endereco 31 - CH0 MSB
			reg_dado_in <= "00001111"; -- dado a ser escrito no registrador
			reg_rw <= '0'; -- '0': comando de escrita
			wait for 10 ns;
			reg_en <= '1'; -- ativa entrada/saida do registrador
			wait for 20 ns;
			reg_en <= '0'; -- desativa entrada/saida do registrador
			
			wait for 4000 ns;
			
			reg_addr <= "0011111"; -- endereco 31 - CH0 MSB
			reg_dado_in <= "10001111"; -- dado a ser escrito no registrador
			reg_rw <= '0'; -- '0': comando de escrita
			wait for 10 ns;
			reg_en <= '1'; -- ativa entrada/saida do registrador
			wait for 20 ns;
			reg_en <= '0'; -- desativa entrada/saida do registrador
			
			wait for 4000 ns;
			
			reg_addr <= "0100001"; -- endereco 33 (endereco de config do D/A canal 1)
			reg_dado_in <= "00001011"; -- dado a ser escrito no registrador
			reg_rw <= '0'; -- '0': comando de escrita
			wait for 10 ns;
			reg_en <= '1'; -- ativa entrada/saida do registrador
			wait for 20 ns;
			reg_en <= '0'; -- desativa entrada/saida do registrador
			
			wait for 200 ns;
			
			reg_addr <= "0100011"; -- endereco 35 - CH1 LSB
			reg_dado_in <= "10101010"; -- dado a ser escrito no registrador
			reg_rw <= '0'; -- '0': comando de escrita
			wait for 10 ns;
			reg_en <= '1'; -- ativa entrada/saida do registrador
			wait for 20 ns;
			reg_en <= '0'; -- desativa entrada/saida do registrador
			
			wait for 200 ns;
			
			reg_addr <= "0100010"; -- endereco 34 - CH1 MSB
			reg_dado_in <= "10001111"; -- dado a ser escrito no registrador
			reg_rw <= '0'; -- '0': comando de escrita
			wait for 10 ns;
			reg_en <= '1'; -- ativa entrada/saida do registrador
			wait for 20 ns;
			reg_en <= '0'; -- desativa entrada/saida do registrador
			
			
			wait for 4000 ns;
			
			reg_addr <= "0011111"; -- endereco 31 - CH0 MSB
			reg_dado_in <= "10001010"; -- dado a ser escrito no registrador
			reg_rw <= '0'; -- '0': comando de escrita
			wait for 10 ns;
			reg_en <= '1'; -- ativa entrada/saida do registrador
			wait for 20 ns;
			reg_en <= '0'; -- desativa entrada/saida do registrador
			
			
			wait for 4000 ns;
			
			reg_addr <= "0011111"; -- endereco 31 - CH0 MSB
			reg_dado_in <= "10000000"; -- dado a ser escrito no registrador
			reg_rw <= '0'; -- '0': comando de escrita
			wait for 10 ns;
			reg_en <= '1'; -- ativa entrada/saida do registrador
			wait for 20 ns;
			reg_en <= '0'; -- desativa entrada/saida do registrador
			
			
			wait for 300 ns;
			
--			reg_addr <= "0100000"; -- endereco 30
--			reg_dado_in <= "00001111"; -- dado a ser escrito no registrador
--			reg_rw <= '0'; -- '0': comando de escrita
--			wait for 10 ns;
--			reg_en <= '1'; -- ativa entrada/saida do registrador
--			wait for 20 ns;
--			reg_en <= '0'; -- desativa entrada/saida do registrador
--			
--			wait for 200 ns;
--			
--			reg_addr <= "0001111"; -- endereco 31
--			reg_rw <= '1'; -- '1': comando de leitura
--			wait for 10 ns;
--			reg_en <= '1'; -- ativa entrada/saida do registrador
--			wait for 20 ns;
--			reg_en <= '0'; -- desativa entrada/saida do registrador
--			
--			wait for 500 ns;
		------------------------------------------------------------------------------

		
			
			
      wait;
   end process;

END;
