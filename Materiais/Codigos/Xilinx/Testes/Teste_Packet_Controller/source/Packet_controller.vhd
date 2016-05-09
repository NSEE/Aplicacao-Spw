----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:34:39 02/10/2016 
-- Design Name: 
-- Module Name:    Packet_controller - Behavioral 
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

entity Packet_controller is
    Port ( CLOCK : in  STD_LOGIC;
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
end Packet_controller;

architecture Behavioral of Packet_controller is

	-- Estados:
		type state_type is (stt_wait_packet,
							stt_save_packet,
							stt_verify_write_read,
							stt_send_answer,
							stt_set_data_to_write,
							stt_write_to_reg,
							stt_write_completed,
							stt_set_data_to_read,
							stt_read_from_reg,
							stt_data_from_reg,
							stt_read_completed); 
		signal stt_pkt_ctrl : state_type;
		
		signal Read_Write_s : std_logic_vector (7 downto 0);
		signal Reg_addr_s : std_logic_vector (7 downto 0);
		signal Data_s : std_logic_vector (7 downto 0);
		signal Reg_data_i_s : std_logic_vector (7 downto 0);

begin
	
	PROCESS (CLOCK)
	begin
		if rising_edge(CLOCK) then
			if RESET = '1' then
				stt_pkt_ctrl <= stt_wait_packet;
			else
				case stt_pkt_ctrl is
					when stt_wait_packet =>
						-- Answer_flag_o <= '0';
						-- Reg_en_o <= '0';
						if Data_pkt_flag_i = '1' then -- Se tem pacote novo recebido
							stt_pkt_ctrl <= stt_save_packet;
						else
							stt_pkt_ctrl <= stt_wait_packet;
						end if;	
					
					when stt_save_packet =>
						-- Read_Write_s <= Data_pkt(23 downto 16);
						-- Reg_addr_s <= Data_pkt(15 downto 8);
						-- Data_s <= Data_pkt(7 downto 0);
						-- Answer_flag_o <= '0';
						stt_pkt_ctrl <= stt_verify_write_read;
						
					when stt_verify_write_read =>
						-- Answer_flag_o <= '0';
						if (Read_Write_s = x"01") then -- Se é comando de escrita
							stt_pkt_ctrl <= stt_set_data_to_write;
						elsif (Read_Write_s = x"10") then -- Se é comando de leitura
							stt_pkt_ctrl <= stt_set_data_to_read;
						end if;	
					
					when stt_send_answer =>
						-- Answer_flag_o <= '1';
						stt_pkt_ctrl <= stt_wait_packet;
					
					-----------------------------
					--         ESCRITA         --
					-----------------------------
					
					when stt_set_data_to_write =>
						-- Reg_addr_o <= Reg_addr_s;
						-- Reg_dado_o <= Data_s;
						-- Reg_rw_o <= '0';
						-- Answer_flag_o <= '0';
						-- Reg_en_o <= '0';
						stt_pkt_ctrl <= stt_write_to_reg;
						
					when stt_write_to_reg =>
						-- Reg_en_o <= '1';
						-- Answer_flag_o <= '0';
						stt_pkt_ctrl <= stt_write_completed;
						
					when stt_write_completed =>
						-- Answer_pkt_o <= x"BC" & x"01" & Reg_addr_s & x"00" & EOP;
						-- Answer_flag_o <= '0';
						stt_pkt_ctrl <= stt_send_answer;
											
						
					-----------------------------
					--         LEITURA         --
					-----------------------------	
					
					when stt_set_data_to_read =>
						-- Reg_addr_o <= Reg_addr_s;
						-- Reg_rw_o <= '1';
						-- Reg_en_o <= '0';
						stt_pkt_ctrl <= stt_read_from_reg;
						
					when stt_read_from_reg =>
						-- Reg_en_o <= '1';
						stt_pkt_ctrl <= stt_data_from_reg;
						
					when stt_data_from_reg =>
						-- Reg_data_i <= Reg_dado_out;
						-- Reg_en_o <= '0';
						stt_pkt_ctrl <= stt_read_completed;
						
					when stt_read_completed =>
						-- Answer_pkt_o <= x"BC" & x"10" & Reg_addr_s & Reg_data_i & EOP;
						-- Answer_flag_o <= '0';
						stt_pkt_ctrl <= stt_send_answer;
						
				end case;
			end if;	
		end if;			
	end PROCESS;	

	PROCESS(stt_pkt_ctrl)
	begin
		case stt_pkt_ctrl is
			
			when stt_wait_packet =>
				Answer_flag_o <= '0';
				Reg_en_o <= '0';
				
			when stt_save_packet =>
				Read_Write_s <= Data_pkt(23 downto 16);
				Reg_addr_s <= Data_pkt(15 downto 8);
				Data_s <= Data_pkt(7 downto 0);
				Answer_flag_o <= '0';
				Reg_en_o <= '0';
				
			when stt_verify_write_read =>
				Answer_flag_o <= '0';
				Reg_en_o <= '0';
			
			when stt_send_answer =>
				Answer_flag_o <= '1';
				Reg_en_o <= '0';
			
			when stt_set_data_to_write =>
				Reg_addr_o <= Reg_addr_s;
				Reg_dado_o <= Data_s;
				Reg_rw_o <= '0';
				Answer_flag_o <= '0';
				Reg_en_o <= '0';
				
			
			when stt_write_to_reg =>
				Reg_en_o <= '1';
				Answer_flag_o <= '0';
				
			when stt_write_completed =>
				Answer_pkt_o <= x"BC" & x"01" & Reg_addr_s & x"00" & x"00";   -- Ultimo dado é EOP.
				Answer_flag_o <= '0';
			
			when stt_set_data_to_read =>
				Reg_addr_o <= Reg_addr_s;
				Reg_rw_o <= '1';
				Reg_en_o <= '0';
			
			when stt_read_from_reg =>
				Reg_en_o <= '1';
				Answer_flag_o <= '0';
				
			when stt_data_from_reg =>
				Reg_data_i_s <= Reg_dado_out;
				Answer_flag_o <= '0';
				Reg_en_o <= '0';
				
			when stt_read_completed =>
				Answer_pkt_o <= x"BC" & x"10" & Reg_addr_s & Reg_data_i_s & x"00";  -- Ultimo dado é EOP.
				Answer_flag_o <= '0';
				Reg_en_o <= '0';
								
			
		end case;
		
	end PROCESS;

end Behavioral;

