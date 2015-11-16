----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:26:34 09/03/2015 
-- Design Name: 
-- Module Name:    top_teste_controlador_DAC - Behavioral 
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

entity top_teste_controlador_ADC is
    Generic (
			N : positive := 19; -- 19bit serial word length
			CPOL : std_logic := '0';
			CPHA : std_logic := '0';
			PREFETCH : positive := 2;
			SPI_2X_CLK_DIV : positive := 5);
			
    Port ( --INPUTS
			CLOCK : in  STD_LOGIC;
			RESET : in  STD_LOGIC;
		   --OUTPUTS
           --LEDS
				LED : out  STD_LOGIC_VECTOR (7 downto 0);
		   --DAC
				SCK : out STD_LOGIC;  -- Serial Clock ADC
				SDI : out STD_LOGIC;  -- MOSI ADC
				SDO : in STD_LOGIC;  -- MISO ADC
				CS  : out STD_LOGIC); -- Chip Select ADC
end top_teste_controlador_ADC;

architecture Behavioral of top_teste_controlador_ADC is

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

    COMPONENT spi_master
    GENERIC(   
        N : positive := 19;                                             -- 32bit serial word length is default
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
        do_o : out  std_logic_vector (N-1 downto 0)                     -- parallel output (clocked on rising spi_clk after last bit)
	    );
	END COMPONENT;	
	 
    COMPONENT ADC_controller
    GENERIC(   
        N : positive := 19);  
    PORT(
		CLK : in  STD_LOGIC;
		RST_IN : in  STD_LOGIC;
		AD_CH0_data : in STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
		AD_CH1_data : in STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
		ACTb_CH0 : in STD_LOGIC;
		ACTb_CH1 : in STD_LOGIC;
		data_req : in STD_LOGIC;
		AD_CH0_ack_o : out STD_LOGIC;
		wren_m_c : out STD_LOGIC;
		AD_CH1_ack_o : out STD_LOGIC;
		data_to_spi : out STD_LOGIC_VECTOR(N-1 downto 0)
		);
    END COMPONENT;
	 
--	COMPONENT divide_clock
--	PORT(
--		CLKIN_IN : IN std_logic;
--		RST_IN : IN std_logic;          
--		CLKDV_OUT : OUT std_logic;
--		CLKDV_OUT1 : OUT std_logic;
--		CLKIN_IBUFG_OUT : OUT std_logic;
--		CLK0_OUT : OUT std_logic;
--		LOCKED_OUT : OUT std_logic
--		);
--	END COMPONENT;
	 
	 
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
		signal AD_CH0_next : std_logic := '0';
		signal AD_CH1_next : std_logic := '0';

		--Outputs
		signal reg_dado_out : std_logic_vector(7 downto 0);
		signal DA_CH0_en : std_logic;
		signal DA_CH0_dado : std_logic_vector(15 downto 0);
		signal DA_CH1_en : std_logic;
		signal DA_CH1_dado : std_logic_vector(15 downto 0);
		signal AD_CH0_en : std_logic;
		signal AD_CH0_dado : std_logic_vector(18 downto 0);
		signal AD_CH1_en : std_logic;
		signal AD_CH1_dado : std_logic_vector(18 downto 0);
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
	
	-- DAC_controller ----------------------------------------------------------
	   --imputs
		signal RST_IN : std_logic := '0';
		
		--Outputs
		signal data_to_spi : std_logic_vector(N-1 downto 0);
	----------------------------------------------------------------------------
	
	 signal clkdv : std_logic := '0';
	 signal nova_entrada : std_logic := '0';
	 
	 type memory_type is array (0 to 90) of std_logic_vector(6 downto 0);
	 signal Seno : memory_type := 
	 ("0000000","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX",-- 0 a 9
	  "0010001","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX",--10 a 19
	  "0100010","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX",--20 a 29
	  "0110010","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX",--30 a 39
	  "1000000","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX",--40 a 49
	  "1001100","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX",--50 a 59
	  "1010110","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX",--60 a 69
	  "1011101","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX",--70 a 79
	  "1100010","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX","XXXXXXX",--80 a 89
	  "1100100"--90
	 );
	 
	 signal Dontcare_s : std_logic_vector(13 downto 0) := "00000000000000";
	 signal tensao : integer range 0 to 4096;
	 --signal tensao_c : integer := 0;
begin

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
          DA_CH1_dado =>DA_CH1_dado,
		  AD_CH0_en => AD_CH0_en,
		  AD_CH0_next => AD_CH0_next,
		  AD_CH0_dado => AD_CH0_dado,
	      AD_CH1_en => AD_CH1_en,
		  AD_CH1_next => AD_CH1_next,
		  AD_CH1_dado => AD_CH1_dado
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
		  
	-- Instantiate the Unit Under Test 4 (UUT4)
	uut_adc_ctrl: ADC_Controller PORT MAP (
		CLK => clk,
        RST_IN => RST_IN,
		AD_CH0_data => AD_CH0_dado,
		AD_CH1_data => AD_CH1_dado,
        ACTb_CH0 => AD_CH0_en,
        ACTb_CH1 => AD_CH1_en,
        data_req => di_req_o,
        AD_CH0_ack_o => AD_CH0_next,
        wren_m_c => wren_i,
        AD_CH1_ack_o => AD_CH1_next,
		data_to_spi => data_to_spi
		);  
	
--	Inst_divide_clock: divide_clock PORT MAP(
--		CLKIN_IN => clock,
--		RST_IN => reset,
--		CLKDV_OUT => open,
--		CLKDV_OUT1 => clk,
--		CLKIN_IBUFG_OUT => open,
--		CLK0_OUT => open,
--		LOCKED_OUT => open
--	);
	
	--clk<=clkdv;
    clk <= clock;
	SDI <= spi_mosi_o;
	 spi_miso_i <= SDO;
	CS  <= spi_ssel_o;
	SCK <= spi_sck_o;
	
	
	 
	process(clk, reset,nova_entrada) -- gera valores para answer
	variable angle : natural range 0 to 90 := 0;
	variable counter : natural range 0 to 101000 := 0;
	variable espera : natural range 0 to 100 := 0;
	begin
		if reset = '1' then
			counter := 0;
			angle := 0;
			LED(7 downto 0) <= "01010101";
		elsif rising_edge(clk) then
			--LED(7 downto 0) <= do_o(11 downto 4);
			
			if nova_entrada = '0' then
				counter := counter + 1;
			end if;
			if counter = 100000 then
				nova_entrada <= '1';
				counter := 0;
			end if;	
			
			if nova_entrada = '1' then
				espera := espera + 1;
				
				-- ESCREVE CONFIGURAÇÃO DO A/D CANAL 0
				if ((espera > 0) and (30 >= espera)) then
					reg_addr <= std_logic_vector(to_unsigned(20,7)); -- endereço 20 (A/D CONFIG CANAL 0)
					reg_dado_in <= "10001000"; -- Single/#Diff = 1 | D2 = X | D1 = 0 | D0 = 0
					reg_rw <= '0'; -- Comando de escrita
					if (espera = 10) then
						reg_en <= '1';
					end if;
					if (espera = 20) then
						reg_en <= '0';
					end if;
				end if;
				-- FIM CONFIGURAÇÃO DO A/D CANAL 0	
				if (espera = 300) then
					espera := 0;
				end if;
				
			end if;
			
			--	******************************************
			--******** "EXIBIR TENSAO NOS LEDS" ************  A CADA 0,375Volts acende um led
			--  ******************************************
			tensao <= to_integer(unsigned(do_o));
			
			if (tensao > 0) and (512 > tensao) then -- Se é maior que 0V e menor que 0,375V
				LED(7 downto 0) <= "00000001";
			end if;
			
			if (tensao >= 512) and (1024 > tensao) then -- Se é maior que 0,375V e menor que 0,75V
				LED(7 downto 0) <= "00000011";
			end if;

			if (tensao >= 1024) and (1536 > tensao) then -- Se é maior que 0,75V e menor que 1,125V
				LED(7 downto 0) <= "00000111";
			end if;
			
			if (tensao >= 1536) and (2048 > tensao) then -- Se é maior que 1,125V e menor que 1,5V
				LED(7 downto 0) <= "00001111";
			end if;
			
			if (tensao >= 2048) and (2560 > tensao) then -- Se é maior que 1,5V e menor que 1,875V
				LED(7 downto 0) <= "00011111";
			end if;
			
			if (tensao >= 2560) and (3072 > tensao) then -- Se é maior que 1,875V e menor que 2,25V
				LED(7 downto 0) <= "00111111";
			end if;
			
			if (tensao >= 3072) and (3584 > tensao) then -- Se é maior que 2,25V e menor que 2,625V
				LED(7 downto 0) <= "01111111";
			end if;
			
			if (tensao >= 3584) and (4096 > tensao) then -- Se é maior que 2,625V e menor que 3,0V
				LED(7 downto 0) <= "11111111";
			end if;
			
		end if;
	end process;
	
	
end Behavioral;

