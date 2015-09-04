----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:48:12 08/11/2015 
-- Design Name: 
-- Module Name:    top_placafilha - Behavioral 
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
use work.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_placafilha is
	 GENERIC (
			N : positive := 16; 					-- 16bit serial word length
			CPOL : std_logic := '0'; 			-- SPI mode selection (mode 0 default)
			CPHA : std_logic := '1';   		-- CPOL = clock polarity, CPHA = clock phase.
			PREFETCH : positive := 2;   		-- prefetch lookahead cycles
			SPI_2X_CLK_DIV : positive := 5 	-- for a 100MHz sclk_i, yields a 10MHz SCK
	 );
    Port ( Clock : in  STD_LOGIC;
           Reset : in  STD_LOGIC;


			
			 ADDR_REG : in std_logic_vector(6 downto 0) := "0000000";
			 DATA_TO_REG : in std_logic_vector(7 downto 0) := "11111111";
			 DATA_FROM_REG: out std_logic_vector(7 downto 0);
			 REG_W_or_R : in std_logic := '0';
			 ENABLE_REG : in std_logic :='0';
			
			 DA_CH0_dado_signal : out std_logic_vector (15 downto 0);
			 DA_CH1_dado_signal : out std_logic_vector (15 downto 0);

			 -- spi bus wires
			 spi_sck : out std_logic;
			 spi_ssel : out std_logic;
			 spi_miso : in std_logic := 'X';
			 spi_mosi : out std_logic;
			 -- master parallel interface
			 di_m : in std_logic_vector (N-1 downto 0) := (others => '0');
			 do_m : out std_logic_vector (N-1 downto 0) := (others => 'U');
			 do_valid_m : out std_logic;
			 di_req_m : out std_logic;
			 wren_m : in std_logic := '0';
			 wren_o_m : out std_logic := 'U'			  
			  
			  );
end top_placafilha;

architecture Behavioral of top_placafilha is

	signal DA_CH0_en_signal : std_logic :='0';
	signal DA_CH1_en_signal : std_logic :='0';
	signal m_di_req_o : std_logic;
	signal DA_CH0_ack : std_logic;
	signal DA_CH1_ack : std_logic;
	signal m_wren_i : std_logic;
--	
--	signal ADDR_REG : std_logic_vector(6 downto 0);
--	signal DATA_TO_REG : std_logic_vector(7 downto 0);
--	signal DATA_FROM_REG: std_logic_vector(7 downto 0);
--	signal REG_W_or_R : std_logic;
--	signal ENABLE_REG : std_logic;
--	
--	signal DA_CH0_dado_signal : std_logic_vector (15 downto 0);
--	signal DA_CH1_dado_signal : std_logic_vector (15 downto 0);
--
--    -- spi bus wires
--    signal spi_sck : std_logic;
--    signal spi_ssel : std_logic;
--    signal spi_miso : std_logic;
--    signal spi_mosi : std_logic;
--	 -- master parallel interface
--    signal di_m : std_logic_vector (N-1 downto 0) := (others => '0');
--    signal do_m : std_logic_vector (N-1 downto 0) := (others => 'U');
--    signal do_valid_m : std_logic;
--    signal di_req_m : std_logic;
--    signal wren_m : std_logic := '0';
--    signal wren_o_m : std_logic := 'U';
    
begin

    --=============================================================================================
    -- Component instantiation for the SPI_controller port
    --=============================================================================================
    Inst_spi_controller: entity work.spi_controller(rtl)
	     port map(
		     ACT_bit      => DA_CH0_en_signal,
	        data_req     => m_di_req_o,
           CLK          => Clock,
			  RST_IN       => Reset,
			  DA_CH0_ack_o => DA_CH0_ack,
           wren_m_c     => m_wren_i
		  );

    --=============================================================================================
    -- Component instantiation for the registrador port
    --=============================================================================================
    Inst_registrador: entity work.Reg_Geral(rtl)
	     port map(
		      clk => Clock,
            aclr  => '0',
	         reg_addr => ADDR_REG,
	         reg_dado_in => DATA_TO_REG,
	         reg_dado_out => DATA_FROM_REG,
            reg_rw => REG_W_or_R, -- 0 : read, 1 : write
	         reg_en => ENABLE_REG, -- enable read/write
	
	         DA_CH0_en => DA_CH0_en_signal,
	         DA_CH0_next  => DA_CH0_ack,
  	         DA_CH0_dado => DA_CH0_dado_signal,
	
	         DA_CH1_en => DA_CH1_en_signal,
	         DA_CH1_next  => DA_CH1_ack,
  	         DA_CH1_dado => DA_CH1_dado_signal
		  );
		 
    --=============================================================================================
    -- Component instantiation for the SPI master port
    --=============================================================================================
    Inst_spi_master: entity work.spi_master(rtl)
        generic map (N => N, CPOL => CPOL, CPHA => CPHA, PREFETCH => PREFETCH, SPI_2X_CLK_DIV => SPI_2X_CLK_DIV)
        port map( 
            sclk_i => Clock,                      -- system clock is used for serial and parallel ports
            pclk_i => Clock,
            rst_i => Reset,
            spi_ssel_o => spi_ssel,
            spi_sck_o => spi_sck,
            spi_mosi_o => spi_mosi,
            spi_miso_i => spi_miso,
            di_req_o => di_req_m,
            di_i => di_m,
            wren_i => wren_m,
            do_valid_o => do_valid_m,
            do_o => do_m
--            ----- debug -----
--            do_transfer_o => m_do_transfer_o,
--            wren_o => m_wren_o,
--            wr_ack_o => m_wren_ack_o,
--            rx_bit_reg_o => m_rx_bit_reg_o,
--            state_dbg_o => m_state_dbg_o,
--            core_clk_o => m_core_clk_o,
--            core_n_clk_o => m_core_n_clk_o,
--            sh_reg_dbg_o => m_sh_reg_dbg_o
        );

end Behavioral;

