----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:41:56 07/27/2015 
-- Design Name: 
-- Module Name:    SPI_controller - Behavioral 
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

entity SPI_controller is
    Port ( ACT : in STD_LOGIC_VECTOR (7 downto 0);
	        data_req : in STD_LOGIC;
           CLK : in STD_LOGIC;
			  RST_IN : in STD_LOGIC;
			  ACT_edit : out STD_LOGIC_VECTOR (7 downto 0);
           wren_m_c : out STD_LOGIC
			  );
end SPI_controller;

architecture Behavioral of SPI_controller is
	signal ACT_bit : STD_LOGIC := '0';
	
	-- Build a type for the state machine
	type state_type is (s_waiting_data, s_send_data, s_sending_data);
	
	signal state_ctrl : state_type;
	
begin

    process (CLK, RST_IN) is
        begin
		      if (RST_IN = '1') then
				    state_ctrl <= s_waiting_data;
				elsif (rising_edge (CLK)) then
				    case state_ctrl is
					     when s_waiting_data =>
						      ACT_bit <= ACT(4);								
						      if (ACT_bit = '1') then
								    state_ctrl <= s_send_data;
								else
								    state_ctrl <= s_waiting_data;
								end if;
								
						  when s_send_data =>
                        state_ctrl <= s_sending_data;						  
							
					     when s_sending_data =>
						      if (data_req = '1') then
								    state_ctrl <= s_waiting_data;
								else
								    state_ctrl <= s_sending_data;
								end if;	 
								
                end case;
					 
				end if;        
    end process;
	
    process (state_ctrl) is
	 begin
	     case state_ctrl is
		      when s_waiting_data =>
				    wren_m_c <= '0';
				when s_send_data =>
                wren_m_c <= '1';
            when s_sending_data =>
                wren_m_c <= '0';
        end case;
	 end process;					 


end Behavioral;

