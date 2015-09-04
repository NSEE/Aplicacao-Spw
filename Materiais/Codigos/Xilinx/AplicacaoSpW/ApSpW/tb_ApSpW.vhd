--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:01:48 08/12/2015
-- Design Name:   
-- Module Name:   C:/Users/Dennis/Desktop/Aplicacao-Spw/Materiais/Codigos/Xilinx/AplicacaoSpW/ApSpW/tb_ApSpW.vhd
-- Project Name:  ApSpW
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top_placafilha
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
 
ENTITY tb_ApSpW IS
END tb_ApSpW;
 
ARCHITECTURE behavior OF tb_ApSpW IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_placafilha
    PORT(
         Clock : IN  std_logic;
         Reset : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clock : std_logic := '0';
   signal Reset : std_logic := '0';

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_placafilha PORT MAP (
          Clock => Clock,
          Reset => Reset
        );

   -- Clock process definitions
   Clock_process :process
   begin
		Clock <= '0';
		wait for Clock_period/2;
		Clock <= '1';
		wait for Clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for Clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
