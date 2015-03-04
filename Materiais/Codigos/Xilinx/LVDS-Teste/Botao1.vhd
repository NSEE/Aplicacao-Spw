----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:51:04 02/10/2015 
-- Design Name: 
-- Module Name:    Botao1 - Behavioral 
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Botao1 is
    Port ( CLOCK: in STD_LOGIC;
			  RESET: in STD_LOGIC;
			  SW2 : in  STD_LOGIC;
			  Botao1_out : out  STD_LOGIC_VECTOR (3 downto 0));
		     --LED : out	 STD_LOGIC_VECTOR (3 downto 0));
end Botao1;

architecture Behavioral of Botao1 is
	signal contador : integer range 0 to 15 := 0;
	signal SW2_LastState : STD_LOGIC :='0';
	signal SET_SW2 : STD_LOGIC :='0';
	signal debounce_SW2_on : STD_LOGIC :='0';
	signal debounce_SW2_off : STD_LOGIC :='0';
	signal debounce_SW2_count_on : integer range 0 to 5000000 :=0;
	signal debounce_SW2_count_off : integer range 0 to 5000000 :=0;
	--signal RESET: STD_LOGIC :='0';
begin
	
	process (CLOCK, RESET) is
		--variable debounce_SW2_count_on : integer range 0 to 5000000 :=0;
		--variable debounce_SW2_count_off : integer range 0 to 5000000 :=0;
	begin
		if (RESET = '1') then
			contador <= 0;			
		elsif rising_edge(CLOCK) then
		
		
		--**********************************************
		-- *********** Debounce Chave 2 ***************
		--**********************************************
		
			if (SW2 = '1') and (SW2_LastState = '0') then --rising_edge da chave (Chave em 1)
				debounce_SW2_on <= '1';
			end if;
				
			if (debounce_SW2_on = '1')	then
				debounce_SW2_count_on <= debounce_SW2_count_on + 1;
			end if;
			
			if (debounce_SW2_count_on = 5000000) then
				if (SW2 = '1') then	--Se botão continua pressionado
					SET_SW2 <= '1';	
					SW2_LastState <= '1';
					contador <= contador + 1;
				end if;	
				debounce_SW2_on <= '0';
				debounce_SW2_count_on <= 0;	
			end if;
			
			if (SW2 = '0') and (SW2_LastState = '1') then --falling_edge da chave (Chave em 0)
				debounce_SW2_off <= '1';
			end if;
			
			if (debounce_SW2_off = '1')	then
				debounce_SW2_count_off <= debounce_SW2_count_off + 1;
			end if;
			
			if (debounce_SW2_count_off = 5000000) then
				if (SW2 = '0') then --
					SET_SW2 <= '0';
					SW2_LastState <= '0';
				end if;	
				debounce_SW2_off <= '0';
				debounce_SW2_count_off <= 0;
			end if;
			
		--**********************************************************			
		--**********************************************************		
							
		end if;
	end process;

			--LED <= std_logic_vector(to_unsigned(contador, LED'length ));	
			Botao1_out <= std_logic_vector(to_unsigned(contador, Botao1_out'length ));

end Behavioral;

