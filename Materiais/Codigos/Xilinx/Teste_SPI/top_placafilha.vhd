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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_placafilha is
    Port ( Clock : in  STD_LOGIC;
           Reset : in  STD_LOGIC);
end top_placafilha;

architecture Behavioral of top_placafilha is



begin

    --=============================================================================================
    -- Component instantiation for the SPI_controller port
    --=============================================================================================
    Inst_spi_controller: entity work.spi_controller(rtl)
	     port map(
		     ACT_bit      => DA_CH0_en,
	        data_req     => m_di_req_o,
           CLK          => Clock,
			  RST_IN       => Reset,
			  DA_CH0_ack_o => DA_CH0_ack,
           wren_m_c     => m_wren_i
		  );

    --=============================================================================================
    -- Component instantiation for the registrador port
    --=============================================================================================
    Inst_registrador: entity work.registrador(rtl)
	     port map(
		      clock => Clock,
            aclr  => '0',
	         reg_addr => ADDR_REG,
	         reg_dado_in => DATA_TO_REG,
	         reg_dado_out => DATA_FROM_REG,
            reg_rw => REG_W_or_R, -- 0 : read, 1 : write
	         reg_en => ENABLE_REG, -- enable read/write
	
	         DA_CH0_en 	: out STD_LOGIC;
	         DA_CH0_ack  : in  STD_LOGIC;
  	         DA_CH0_dado : out STD_LOGIC_VECTOR(11 DOWNTO 0);
	
	         DA_CH1_en 	: out STD_LOGIC;
	         DA_CH1_ack  : in  STD_LOGIC;
  	         DA_CH1_dado : out STD_LOGIC_VECTOR(11 DOWNTO 0);
		  );
		 
    --=============================================================================================
    -- Component instantiation for the SPI master port
    --=============================================================================================
    Inst_spi_master: entity work.spi_master(rtl)
        generic map (N => N, CPOL => CPOL, CPHA => CPHA, PREFETCH => PREFETCH, SPI_2X_CLK_DIV => SPI_2X_CLK_DIV)
        port map( 
            sclk_i => m_clk_i,                      -- system clock is used for serial and parallel ports
            pclk_i => m_clk_i,
            rst_i => m_rst_i,
            spi_ssel_o => m_spi_ssel_o,
            spi_sck_o => m_spi_sck_o,
            spi_mosi_o => m_spi_mosi_o,
            spi_miso_i => m_spi_miso_i,
            di_req_o => m_di_req_o,
            di_i => m_di_i,
            wren_i => m_wren_i,
            do_valid_o => m_do_valid_o,
            do_o => m_do_o,
            ----- debug -----
            do_transfer_o => m_do_transfer_o,
            wren_o => m_wren_o,
            wr_ack_o => m_wren_ack_o,
            rx_bit_reg_o => m_rx_bit_reg_o,
            state_dbg_o => m_state_dbg_o,
            core_clk_o => m_core_clk_o,
            core_n_clk_o => m_core_n_clk_o,
            sh_reg_dbg_o => m_sh_reg_dbg_o
        );

end Behavioral;

