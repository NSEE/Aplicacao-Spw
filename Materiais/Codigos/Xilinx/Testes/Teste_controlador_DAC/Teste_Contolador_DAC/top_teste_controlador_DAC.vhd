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

entity top_teste_controlador_DAC is
    Generic (
	      N : positive := 16;
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
			     SCK : out STD_LOGIC;  -- Serial Clock DAC
			     SDI : out STD_LOGIC;  -- MOSI DAC
			     CS  : out STD_LOGIC); -- Chip Select DAC
end top_teste_controlador_DAC;

architecture Behavioral of top_teste_controlador_DAC is

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
	
	-- DAC_controller ----------------------------------------------------------
	   --imputs
		signal RST_IN : std_logic := '0';
		
		--Outputs
		signal data_to_spi : std_logic_vector(N-1 downto 0);
	----------------------------------------------------------------------------
	
	 signal clkdv : std_logic := '0';
    signal answer : integer range 0 to 4000 := 0;
	 signal answer_vector : std_logic_vector(11 downto 0);
	 signal nova_entrada : std_logic := '0';
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
	 CS  <= spi_ssel_o;
	 SCK <= spi_sck_o;
	 
	 LED(7 downto 1) <= "1111000";
	 LED(0) <= reset;
	 
    process(clk, reset,nova_entrada) -- gera valores para answer
	 variable angle : natural range 0 to 90 := 0;
	 variable counter : natural range 0 to 101000 := 0;
	 variable espera : natural range 0 to 100 := 0;
	 begin
	     if reset = '1' then
		      counter := 0;
				angle := 0;
	     elsif rising_edge(clk) then
		      if nova_entrada = '0' then
		          counter := counter + 1;
				end if;	 
				if counter = 100000 then
				    if (angle < 90) then
					     angle := angle + 10;
					 else
					     angle := 0;	
                end if;						        
				end if;	 
				if counter = 100100 then -- Espera para indicar que tem nova entrada de dados.
				    nova_entrada<= '1';
					 counter := 0;
				end if;
				
				if nova_entrada = '1' then
				     espera := espera +1;
				 
					  -- CONFIGURAÇAO DO D/A CANAL 0
					  if ((espera > 0) and (30>= espera)) then
						  reg_addr <= std_logic_vector(to_unsigned(30,7)); -- endereço 30 (D/A CONFIG CANAL 0)
						  reg_dado_in <= "00000011"; --#A/B = 0 | BUF = 0 | #GA = 1 | #SHUT = 1
						  reg_rw <= '0'; -- Comando de escrita
						  if (espera = 10) then
								reg_en <= '1';
						  end if;
						  if (espera = 20) then
								reg_en <= '0';
						  end if;
					  end if;	  
					  -- FIM CONFIGURAÇAO DO D/A CANAL 0
					  
					  -- ESCREVER DADOS REGISTRADOR:
					  -- LSB DATA ENDERECO 32:
					  if ((espera > 40) and (60>= espera)) then
					      reg_addr <= std_logic_vector(to_unsigned(32,7)); -- endereço 32: LSB DATA
					      reg_dado_in <= answer_vector(7 downto 0);-- LSB DATA
					      reg_rw <= '0'; -- Comando de escrita
					      if (espera = 50) then
					          reg_en <= '1';
					      end if;
					      if (espera = 60) then
					          reg_en <= '0';
					      end if;
					  end if;
					  -- MSB DATA ENDERECO 31:
					  if ((espera > 70) and (90>= espera)) then
					      reg_addr <= std_logic_vector(to_unsigned(31,7)); -- endereço 31: MSB DATA
					      reg_dado_in <= "1000" & answer_vector(11 downto 8);-- MSB DATA
					      reg_rw <= '0'; -- Comando de escrita
					      if (espera = 80) then
					          reg_en <= '1';
					      end if;
					      if (espera = 90) then
					          reg_en <= '0';
								 espera := 0;
								 nova_entrada <= '0';
					      end if;
					  end if;   
				end if;
				
		  end if;	 
		  answer <= 44*angle;
		  --answer <= 44*40;
		  answer_vector <= std_logic_vector(to_unsigned(answer,12));
	 end process;
	
end Behavioral;

