--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:23:51 08/13/2015
-- Design Name:   
-- Module Name:   C:/Users/Dennis/Desktop/Aplicacao-Spw/Materiais/Codigos/Xilinx/AplicacaoSpW/TB_apSpW/tb_spi_controller.vhd
-- Project Name:  TB_apSpW
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SPI_controller
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
 
ENTITY tb_spi_controller IS
END tb_spi_controller;
 
ARCHITECTURE behavior OF tb_spi_controller IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SPI_controller
    PORT(
         ACT_bit : IN  std_logic;
         data_req : IN  std_logic;
         CLK : IN  std_logic;
         RST_IN : IN  std_logic;
         DA_CH0_ack_o : OUT  std_logic;
         wren_m_c : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal ACT_bit : std_logic := '0';
   signal data_req : std_logic := '0';
   signal CLK : std_logic := '0';
   signal RST_IN : std_logic := '0';

 	--Outputs
   signal DA_CH0_ack_o : std_logic;
   signal wren_m_c : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SPI_controller PORT MAP (
          ACT_bit => ACT_bit,
          data_req => data_req,
          CLK => CLK,
          RST_IN => RST_IN,
          DA_CH0_ack_o => DA_CH0_ack_o,
          wren_m_c => wren_m_c
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
