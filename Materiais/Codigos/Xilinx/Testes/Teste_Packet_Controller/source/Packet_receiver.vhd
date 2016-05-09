----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:01:16 01/14/2016 
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

entity Packet_receiver is
    Port ( 
		   -- Entradas
			   CLOCK : in  STD_LOGIC;
			   RESET : in  STD_LOGIC;
			   
			   -- Entradas referentes ao SpW
			   rx_valid_i 	: in STD_LOGIC;
			   RX_Data 		: in STD_LOGIC_VECTOR(7 downto 0);
			   RX_flag_i 	: in STD_LOGIC;
		   
		   -- Saidas
			   RX_read_o : out STD_LOGIC; -- Comando de leitura de dados para o SpW.
			   Data_ack_o: out STD_LOGIC; -- Indica que um 'Start Packet' foi recebido.
			   Data_pkt_flag : out STD_LOGIC; -- Indica que um novo pacote recebido foi recebido por completo.
			   Data_pkt : out  STD_LOGIC_VECTOR (31 downto 0)); -- Pacote recebido completo.
			   
end Packet_receiver;

architecture Behavioral of Packet_receiver is

	-- Estados:
		type state_type is (estado_wait,
							estado_data_req1,
							estado_verify_data1,
							estado_start_rcvd,
							estado_data_req2,
							estado_read_write_rcvd,
							estado_data_req3,
							estado_regadress_rcvd,
							estado_data_req4,
							estado_data_rcvd,
							estado_data_req5,
							estado_EOP_rcvd,
							estado_EOP_not_rcvd); 
		signal estado_pckt : state_type;
	
	signal Data_Sample : std_logic_vector(7 downto 0);
	signal Data1 : std_logic_vector(7 downto 0);
	signal Data2 : std_logic_vector(7 downto 0);
	signal Data3 : std_logic_vector(7 downto 0);
	signal Data4 : std_logic_vector(7 downto 0);

begin

	PROCESS(CLOCK)
	begin
		if rising_edge(CLOCK) then
			if (RESET = '1') then
				estado_pckt <= estado_wait;
			else
			
				case estado_pckt is
					when estado_wait =>
						-- RX_read_o <= '0';
						if (rx_valid_i = '1') then 				-- Se tem dado a ser lido...
							estado_pckt <= estado_data_req1; 	-- Vai para estado de leitura.
						else
							estado_pckt <= estado_wait; 		-- Continua no estado_wait.
						end if;
					
					when estado_data_req1 =>
						-- RX_read_o <= '1'; -- Pede pra fazer a leitura
						estado_pckt <= estado_verify_data1;
						
					when estado_verify_data1 =>
						-- RX_read_o <= '0';
						if (Data_Sample = x"FA") then
							estado_pckt <= estado_start_rcvd;
						else
							estado_pckt <= estado_wait;
						end if;
						
					when estado_start_rcvd =>
						-- Data_ack_o <= '1'; -- Envia ACK como resposta mostrando que o start packet foi recebido.
						-- RX_read_o <= '0'; -- Nao pede pra realizar leitura.
						-- Data1 <= RX_Data; -- Armazena RX_Data em Data1.
						if (rx_valid_i = '1') then
							estado_pckt <= estado_data_req2; -- Ha dado a ser lido. Ir para o proximo estado.
						else
							estado_pckt <= estado_start_rcvd; -- Nao ha dado a ser lido. Continuar no estado e esperar dado.
						end if;
					
					when estado_data_req2 =>
						-- RX_read_o <= '1'; -- Pede pra fazer leitura;
						estado_pckt <= estado_read_write_rcvd;
						
					when estado_read_write_rcvd =>
						-- RX_read_o <= '0'; -- Nao pede pra realizar leitura.
						-- Data2 <= RX_Data; -- Armazena RX_Data em Data2.
						if (rx_valid_i = '1') then
							estado_pckt <= estado_data_req3; -- Ha dado a ser lido. Ir para o proximo estado.
						else
							estado_pckt <= estado_read_write_rcvd; -- Nao ha dado a ser lido. Continuar no estado e esperar dado.
						end if;
					
					when estado_data_req3 =>
						-- RX_read_o = '1'; -- Pede pra fazer leitura;
						estado_pckt <= estado_regadress_rcvd;
					
					when estado_regadress_rcvd =>
						-- RX_read_o <= '0'; -- Nao pede pra realizar leitura.
						-- Data3 <= RX_Data; -- Armazena RX_Data em Data3.
						if (rx_valid_i = '1') then
							estado_pckt <= estado_data_req4; -- Ha dado a ser lido. Ir para o proximo estado.
						else
							estado_pckt <= estado_regadress_rcvd; -- Nao ha dado a ser lido. Continuar no estado e esperar dado.
						end if;
						
					when estado_data_req4 =>
						-- RX_read_o <= '1'; -- Pede pra realizar leitura.
						estado_pckt <= estado_data_rcvd;
					
					when estado_data_rcvd =>
						-- RX_read_o <= '0'; -- Nao pede pra realizar leitura.
						-- Data4 <= RX_Data; -- Armazena RX_Data em Data4.
						if (rx_valid_i = '1') then
							estado_pckt <= estado_data_req5; -- Ha dado a ser lido. Ir para o proximo estado.
						else
							estado_pckt <= estado_data_rcvd; -- Nao ha dado a ser lido. Continuar no estado e esperar dado.
						end if;
						
					when estado_data_req5 =>
						-- RX_read_o <= '1'; -- Pede pra realizar leitura.
						if (RX_flag_i = '1') then -- Data control flag = '1' ? High if the received character is EOP or EEP.
							if (RX_Data = "00000000") then -- RX_Data = "XXXXXXX0"? => EOP Normal end of packet
								estado_pckt <= estado_EOP_rcvd; -- EOP recebido.
							else
								estado_pckt <= estado_EOP_not_rcvd; -- EOP Nao recebido.
							end if;							
						end if;
						
					when estado_EOP_rcvd =>
						-- Data_pkt <= Data1 & Data2 & Data3 & Data4; 
						-- RX_read_o <= '0';
						estado_pckt <= estado_wait;
						
					when estado_EOP_not_rcvd =>
						-- RX_read_o <= '0';
						estado_pckt <= estado_wait;
				end case;		
			end if;
		end if;	
			
	end PROCESS;
	
	PROCESS(estado_pckt)
	begin
		case estado_pckt is
			
			when estado_wait =>
				RX_read_o <= '0'; -- Nao solicita recebimento de dados.
				Data_ack_o <= '0'; -- Nao envia ACK.
				Data_pkt_flag <= '0'; -- Nao atualiza Data_pkt.
				Data_pkt <="00000000000000000000000000000001";
				
			when estado_data_req1 =>
				RX_read_o <= '1'; -- Solicita recebimento de dados.
				Data_ack_o <= '0'; -- Nao envia ACK.
				Data_pkt_flag <= '0'; -- Nao atualiza Data_pkt.
				Data_sample <= RX_Data;
				Data_pkt <="00000000000000000000000000000010";
				
			when estado_verify_data1 =>
				RX_read_o <= '0'; -- Nao solicita recebimento de dados.
				Data_ack_o <= '0'; -- Nao envia ACK
				Data_pkt_flag <= '0'; -- Nao atualiza Data_pkt.
				Data_pkt <="00000000000000000000000000000100";
				Data1 <= RX_Data; -- Armazena RX_Data em Data1.
			
			when estado_start_rcvd =>
				RX_read_o <= '0'; -- Nao solicita recebimento de dados.
				Data_ack_o <= '1'; -- Envia ACK como resposta mostrando que o start packet foi recebido.
				
				Data_pkt_flag <= '0'; -- Nao atualiza Data_pkt.
				Data_pkt <="00000000000000000000000000001000";
			
			when estado_data_req2 =>
				RX_read_o <= '1'; -- Solicita recebimento de dados.
				Data_ack_o <= '0'; -- Nao envia ACK.
				Data_pkt_flag <= '0'; -- Nao atualiza Data_pkt.
				Data_pkt <="00000000000000000000000000010000";
				Data2 <= RX_Data; -- Armazena RX_Data em Data2.
			
			when estado_read_write_rcvd =>
				RX_read_o <= '0'; -- Nao solicita recebimento de dados.
				
				Data_ack_o <= '0'; -- Nao envia ACK.
				Data_pkt_flag <= '0'; -- Nao atualiza Data_pkt.
				Data_pkt <="00000000000000000000000000100000";
				
			when estado_data_req3 =>
				RX_read_o <= '1'; -- Solicita recebimento de dados.
				Data_ack_o <= '0'; -- Nao envia ACK.
				Data_pkt_flag <= '0'; -- Nao atualiza Data_pkt.
				Data_pkt <="00000000000000000000000001000000";
				Data3 <= RX_Data; -- Armazena RX_Data em Data3.
			
			when estado_regadress_rcvd =>
				RX_read_o <= '0'; -- Nao solicita recebimento de dados.
				
				Data_ack_o <= '0'; -- Nao envia ACK.
				Data_pkt_flag <= '0'; -- Nao atualiza Data_pkt.
				Data_pkt <="00000000000000000000000010000000";
			
			when estado_data_req4 =>
				RX_read_o <= '1'; -- Solicita recebimento de dados.
				Data_ack_o <= '0'; -- Nao envia ACK.
				Data_pkt_flag <= '0'; -- Nao atualiza Data_pkt.
				Data_pkt <="00000000000000000000000100000000";
				Data4 <= RX_Data; -- Armazena RX_Data em Data4.
				
			when estado_data_rcvd =>
				RX_read_o <= '0'; -- Nao solicita recebimento de dados.
				
				Data_ack_o <= '0'; -- Nao envia ACK.
				Data_pkt_flag <= '0'; -- Nao atualiza Data_pkt.
				
			when estado_data_req5 =>
				RX_read_o <= '1'; -- Solicita recebimento de dados.
				Data_ack_o <= '0'; -- Nao envia ACK.
				Data_pkt_flag <= '0'; -- Nao atualiza Data_pkt.
				
			when estado_EOP_rcvd =>
				RX_read_o <= '0'; -- Nao solicita recebimento de dados.
				Data_pkt <= Data1 & Data2 & Data3 & Data4; -- Reunião de todos os dados recebidos.
				Data_pkt_flag <= '1'; -- Atualização de Data_pkt.
				Data_ack_o <= '0'; -- Nao envia ACK.
			
			when estado_EOP_not_rcvd =>
				RX_read_o <= '0'; -- Nao solicita recebimento de dados.
				-- Fazer alguma coisa aqui pra indicar que EOP nao foi recebido.
				Data_pkt_flag <= '0'; -- Nao atualiza Data_pkt.
				Data_pkt <="01010101010101010101010100000000";
			
		end case;
		
	end PROCESS;
	
end Behavioral;

