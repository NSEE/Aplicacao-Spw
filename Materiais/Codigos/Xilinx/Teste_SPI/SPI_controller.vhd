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
			  DA_CH0_ack_o : out STD_LOGIC := '0';
           wren_m_c : out STD_LOGIC
			  );
end SPI_controller;

architecture Behavioral of SPI_controller is
	signal ACT_bit : STD_LOGIC := '0';
	
	-- Build a type for the state machine
	type state_type is (s_waiting_data, s_send_data, s_sending_data, s_next_data);
	
	signal state_ctrl : state_type;
	
begin

    process (CLK, RST_IN) is
        begin
		      if (RST_IN = '1') then
				    state_ctrl <= s_waiting_data;
				elsif (rising_edge (CLK)) then
				    case state_ctrl is
					     when s_waiting_data =>
						      ACT_bit <= ACT(7);
						      if (ACT_bit = '1') then --verifica se há dado a ser tratado.
								    --ACT_bit = '1' : Tem dado a ser tratado. Passar para o próximo estado.
								    state_ctrl <= s_send_data;
								else
								    --ACT_bit = '0' : Não tem dado a ser tratado. Continuar no mesmo estado.
								    state_ctrl <= s_waiting_data;
								end if;
								
						  when s_send_data => --Estado de transição rápida.
                        state_ctrl <= s_sending_data; --Ir para próximo estado.
							
					     when s_sending_data =>
						      if (data_req = '1') then -- Verificar fim do processo de envio do dado ao D/A.
								    --data_req = '1' : Transmissão do dado ao D/A foi concluída.
								    state_ctrl <= s_next_data; --Ir para próximo estado.
								else
								    --data_req = '0' : Aguardar término da transmissão do dado ao D/A.
								    state_ctrl <= s_sending_data; --Continuar no mesmo estado.
								end if;
								
                    when s_next_data => --Estado de transição rápida.
                        state_ctrl <= s_waiting_data; --Ir para próximo estado (recomeçar ciclo).
								
                end case;
					 
				end if;        
    end process;
	
    process (state_ctrl) is
	 begin
	     case state_ctrl is
		      when s_waiting_data =>
				    wren_m_c     <= '0';
					 DA_CH0_ack_o <= '0';
				when s_send_data =>
                wren_m_c     <= '1';
					 DA_CH0_ack_o <= '0';
            when s_sending_data =>
                wren_m_c     <= '0';
					 DA_CH0_ack_o <= '0';
				when s_next_data =>
                wren_m_c     <= '0';
                DA_CH0_ack_o <= '1';					 
        end case;
	 end process;					 


end Behavioral;

