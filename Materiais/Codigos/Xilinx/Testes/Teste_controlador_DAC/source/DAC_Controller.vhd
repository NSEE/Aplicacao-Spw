----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:01:52 08/27/2015 
-- Design Name: 
-- Module Name:    DAC_Controller - Behavioral 
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

entity DAC_Controller is
	 Generic (
	        N : positive := 16);  -- 16bit serial word length is default
    Port ( CLK : in  STD_LOGIC;
           RST_IN : in  STD_LOGIC;
			  DA_CHA_data : in STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
			  DA_CHB_data : in STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
           ACTb_CHA : in  STD_LOGIC;
           ACTb_CHB : in  STD_LOGIC;
           data_req : in  STD_LOGIC;
           DA_CHA_ack_o : out  STD_LOGIC;
           wren_m_c : out  STD_LOGIC;
           DA_CHB_ack_o : out  STD_LOGIC;
			  data_to_spi : out STD_LOGIC_VECTOR(N-1 downto 0));
end DAC_Controller;

architecture Behavioral of DAC_Controller is

	-- Build a type for the state machine
	type state_type is (s_waiting_data_to_A,
	                    s_waiting_data_to_B,
	                    s_set_data_to_A,
							  s_set_data_to_B,
	                    s_send_data_to_A,
							  s_send_data_to_B,
	                    s_sending_data_to_A,
							  s_sending_data_to_B,
							  s_next_verify_A,
							  s_next_verify_B);
	
	signal state_ctrl : state_type;

begin

    process (CLK, RST_IN) is
        begin
		      if (RST_IN = '1') then
				    state_ctrl <= s_waiting_data_to_A;
				elsif (rising_edge (CLK)) then
				    case state_ctrl is
					     when s_waiting_data_to_A =>
						      if (ACTb_CHA = '1') then --verifica se há dado a ser enviado para o canal A.
								    --ACTb_CHA = '1' : Tem dado a ser tratado. Ir para próximo estado.
								    state_ctrl <= s_set_data_to_A;
								else -- ACTb_CHA = '0'...
								    --ACTb_CHA = '0' : Não tem dado a ser enviado para o canal A.
								    --Verificar se tem dado a ser enviado para o canal B.
								    state_ctrl <= s_waiting_data_to_B;
								end if;
						  when s_set_data_to_A =>
						      state_ctrl <= s_send_data_to_A;
						  when s_send_data_to_A =>
						      --Estado de transição. (wren_m_c = '0' --> wren_m_c = '1').
						      state_ctrl <= s_sending_data_to_A;
						  when s_sending_data_to_A =>
						      if (data_req = '1') then
								    --Dado enviado para o canal A. Verificar agora se tem dado a ser enviado para B.
									 state_ctrl <= s_next_verify_B;
								else -- data_req = '0'...
								    --Enviando dado para o canal A. Aguardar término. Continuar no estado de envio.
								    state_ctrl <= s_sending_data_to_A;
								end if;	
						  when s_next_verify_B =>
						      --Estado de transição. (DA_CHA_ack_o = '0' --> DA_CHA_ack_o = '1').
						      state_ctrl <= s_waiting_data_to_B;								
						  when s_waiting_data_to_B =>
							   if (ACTb_CHB = '1') then --verifica se há dado a ser enviado para o canal B.
								    --ACTb_CHB = '1' : Tem dado a ser tratado. Ir para próximo estado.
								    state_ctrl <= s_set_data_to_B;
								else -- ACTb_CHB = '0'...
								    --ACTb_CHB = '0' : Não tem dado a ser enviado para o canal B.
								    --Verificar se tem dado a ser enviado para o canal A.
								    state_ctrl <= s_waiting_data_to_A;
								end if;
						  when s_set_data_to_B =>
						      state_ctrl <= s_send_data_to_B;
						  when s_send_data_to_B =>
						      --Estado de transição. (wren_m_c = '0' --> wren_m_c = '1').
								state_ctrl <= s_sending_data_to_B;
						  when s_sending_data_to_B =>
						      if (data_req = '1') then
								    --Dado enviado para o canal B. Verificar agora se tem dado a ser enviado para A.
								    state_ctrl <= s_next_verify_A;
								else -- data_req = '0'...
								    --Enviando dado para o canal B. Aguardar término. Continuar no estado de envio.
								    state_ctrl <= s_sending_data_to_B;
								end if;
						  when s_next_verify_A =>
						      --Estado de transição. (DA_CHB_ack_o = '0' --> DA_CHB_ack_o = '1').
								state_ctrl <= s_waiting_data_to_A;
                end case;				 
				end if;        
    end process;


    process (state_ctrl) is
	 begin
	     case state_ctrl is
		      when s_waiting_data_to_A =>
				    wren_m_c     <= '0';
					 DA_CHA_ack_o <= '0';
					 DA_CHB_ack_o <= '0';
					 Data_to_spi  <= (others => '0');
		      when s_waiting_data_to_B =>
				    wren_m_c     <= '0';
					 DA_CHA_ack_o <= '0';
					 DA_CHB_ack_o <= '0';
					 Data_to_spi  <= (others => '0');
				when s_set_data_to_A     =>
				    wren_m_c     <= '0';
					 DA_CHA_ack_o <= '0';
					 DA_CHB_ack_o <= '0';
					 Data_to_spi  <= DA_CHA_data;
				when s_set_data_to_B     =>
				    wren_m_c     <= '0';
					 DA_CHA_ack_o <= '0';
					 DA_CHB_ack_o <= '0';
					 Data_to_spi  <= DA_CHB_data;	 
				when s_send_data_to_A    =>
                wren_m_c     <= '1';
					 DA_CHA_ack_o <= '0';
					 DA_CHB_ack_o <= '0';
					 Data_to_spi  <= DA_CHA_data;	 
				when s_send_data_to_B    =>
                wren_m_c     <= '1';
					 DA_CHA_ack_o <= '0';
					 DA_CHB_ack_o <= '0';
					 Data_to_spi  <= DA_CHB_data;					 
            when s_sending_data_to_A =>
                wren_m_c     <= '0';
					 DA_CHA_ack_o <= '0';
					 DA_CHB_ack_o <= '0';
					 Data_to_spi  <= DA_CHA_data;	 
            when s_sending_data_to_B =>
                wren_m_c     <= '0';
					 DA_CHA_ack_o <= '0';
					 DA_CHB_ack_o <= '0';
					 Data_to_spi  <= DA_CHB_data;	 
				when s_next_verify_A     =>
                wren_m_c     <= '0';
                DA_CHA_ack_o <= '0';
					 DA_CHB_ack_o <= '1';	
					 Data_to_spi  <= (others => '0');	 
				when s_next_verify_B     =>
                wren_m_c     <= '0';
                DA_CHA_ack_o <= '1';
					 DA_CHB_ack_o <= '0';	
					 Data_to_spi  <= (others => '0');
        end case;
	 end process;		
end Behavioral;

