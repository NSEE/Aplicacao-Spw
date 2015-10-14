----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:01:52 08/27/2015 
-- Design Name: 
-- Module Name:    ADC_Controller - Behavioral 
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

entity ADC_Controller is
	Generic (
			N : positive := 19);  -- 19bit serial word length
    Port ( 	CLK : in  STD_LOGIC;
			RST_IN : in  STD_LOGIC;
			AD_CH0_data : in STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
			AD_CH1_data : in STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
			ACTb_CH0 : in  STD_LOGIC;
			ACTb_CH1 : in  STD_LOGIC;
			data_req : in  STD_LOGIC;
			AD_CH0_ack_o : out  STD_LOGIC;
			wren_m_c : out  STD_LOGIC;
			AD_CH1_ack_o : out  STD_LOGIC;
			data_to_spi : out STD_LOGIC_VECTOR(N-1 downto 0));
end ADC_Controller;

architecture Behavioral of ADC_Controller is

	-- Build a type for the state machine
	type state_type is (s_waiting_CH0,
						s_waiting_CH1,
						s_set_data_to_CH0,
						s_set_data_to_CH1,
						s_send_data_to_Ch0,
						s_send_data_to_CH1,
						s_sending_receiving_CH0,
						s_sending_receiving_CH1,
						s_verify_CH0,
						s_verify_CH1);
	
	signal state_ctrl_ADC : state_type;

begin

    process (CLK, RST_IN) is
        begin
		      if (RST_IN = '1') then
				    state_ctrl_ADC <= s_waiting_CH0;
				elsif (rising_edge (CLK)) then
				    case state_ctrl_ADC is
						when s_waiting_CH0 =>
							if (ACTb_CH0 = '1') then --verifica se há dado a ser enviado/recebido no canal 0.
								--ACTb_CH0 = '1' : Tem dado a ser tratado. Ir para próximo estado.
								state_ctrl_ADC <= s_set_data_to_CH0;
							else --Se ACTb_CH0 = '0'...
								--ACTb_CH0 = '0' : Não tem dado a ser enviado/recebido no canal 0.
								--Verificar se tem dado a ser enviado/recebido no canal 1.
								state_ctrl_ADC <= s_waiting_CH1;
							end if;
						when s_set_data_to_CH0 =>
							--Transição rápida.
							state_ctrl_ADC <= s_send_data_to_CH0;
						when s_send_data_to_CH0 =>
							--Transição rápida. (wren_m_c = '0' --> wren_m_c = '1').
							state_ctrl_ADC <= s_sending_receiving_CH0;
						when s_sending_receiving_CH0 =>
							if (data_req = '1') then
								--Dado enviado/recebido canal 0. Verificar agora se tem dado a ser enviado/recebido para o canal 1.
								state_ctrl_ADC <= s_verify_CH1;
							else --Se data_req = '0'...
								--Enviando/recebendo dado canal 0. Aguardar término. Continuar no estado de envio e recebimento.
								state_ctrl_ADC <= s_sending_receiving_CH0;
							end if;	
						when s_verify_CH1 =>
							--Transição rápida. (DA_CHA_ack_o = '0' --> DA_CHA_ack_o = '1').
							state_ctrl_ADC <= s_waiting_CH1;								
						when s_waiting_CH1 =>
							if (ACTb_CH1 = '1') then --verifica se há dado a ser enviado/recebido no canal 1.
								--ACTb_CH1 = '1' : Tem dado a ser tratado. Ir para próximo estado.
								state_ctrl_ADC <= s_set_data_to_CH1;
							else --Se ACTb_CH1 = '0'...
								--ACTb_CH1 = '0' : Não tem dado a ser enviado/recebido canal 1.
								--Verificar se tem dado a ser enviado/recebido no canal 0.
								state_ctrl_ADC <= s_waiting_CH0;
							end if;
						when s_set_data_to_CH1 =>
							--Transição rapida.
							state_ctrl_ADC <= s_send_data_to_CH1;
						when s_send_data_to_CH1 =>
							--Transição rápida. (wren_m_c = '0' --> wren_m_c = '1').
							state_ctrl_ADC <= s_sending_receiving_CH1;
						when s_sending_receiving_CH1 =>
							if (data_req = '1') then
								--Dado enviado/recebido canal 1. Verificar agora se tem dado a ser enviado/recebido para o canal 0.
								state_ctrl_ADC <= s_verify_CH0;
							else --Se data_req = '0'...
								--Enviando/recebendo dado canal 1. Aguardar término. Continuar no estado de envio e recebimento.
								state_ctrl_ADC <= s_sending_receiving_CH0;
							end if;
						when s_verify_CH0 =>
							--Estado de transição. (DA_CHB_ack_o = '0' --> DA_CHB_ack_o = '1').
							state_ctrl_ADC <= s_waiting_CH0;
					end case;				 
				end if;        
    end process;


    process (state_ctrl_ADC) is
	 begin
	     case state_ctrl_ADC is
			when s_waiting_CH0 =>
				wren_m_c     <= '0';
				AD_CH0_ack_o <= '0';
				AD_CH1_ack_o <= '0';
				Data_to_spi  <= (others => '0');
			when s_waiting_CH1 =>
				wren_m_c     <= '0';
				AD_CH0_ack_o <= '0';
				AD_CH1_ack_o <= '0';
				Data_to_spi  <= (others => '0');
			when s_set_data_to_CH0   =>
				wren_m_c     <= '0';
				AD_CH0_ack_o <= '0';
				AD_CH1_ack_o <= '0';
				Data_to_spi  <= AD_CH0_data;
			when s_set_data_to_CH1     =>
				wren_m_c     <= '0';
				AD_CH0_ack_o <= '0';
				AD_CH1_ack_o <= '0';
				Data_to_spi  <= AD_CH1_data;	 
			when s_send_data_to_CH0    =>
				wren_m_c     <= '1';
				AD_CH0_ack_o <= '0';
				AD_CH1_ack_o <= '0';
				Data_to_spi  <= AD_CH0_data;	 
			when s_send_data_to_CH1    =>
				wren_m_c     <= '1';
				AD_CH0_ack_o <= '0';
				AD_CH1_ack_o <= '0';
				Data_to_spi  <= AD_CH1_data;					 
            when s_sending_receiving_CH0 =>
				wren_m_c     <= '0';
				AD_CH0_ack_o <= '0';
				AD_CH1_ack_o <= '0';
				Data_to_spi  <= AD_CH0_data;	 
            when s_sending_receiving_CH1 =>
				wren_m_c     <= '0';
				AD_CH0_ack_o <= '0';
				AD_CH1_ack_o <= '0';
				Data_to_spi  <= AD_CH1_data;	 
			when s_verify_CH0     =>
				wren_m_c     <= '0';
				AD_CH0_ack_o <= '0';
				AD_CH1_ack_o <= '1';	
				Data_to_spi  <= (others => '0');	 
			when s_verify_CH1     =>
				wren_m_c     <= '0';
				AD_CH0_ack_o <= '1';
				AD_CH1_ack_o <= '0';	
				Data_to_spi  <= (others => '0');
        end case;
	 end process;		
end Behavioral;
