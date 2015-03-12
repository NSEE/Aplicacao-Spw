-------------------------------------------------------------------------------
-- Codec SpW ECSS-E-50-12C
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity CodecSpWXNSEE2 is port
(
	-- external inputs of all the CODEC (ECSS-E-50-12C)
   -- general inputs
   Clk   : in std_logic;   -- clock input (frequencia a definir)
   MReset : in std_logic;   -- reset input for inicialization
	-- inputs of the state machine
	LinkStart : in std_logic;   -- Asks the initialization of the Link (2 ends of the Link)
	LinkDisable : in std_logic;   -- Asks the disabling of the Link
	AutoStart : in std_logic;   -- Asks the one end of the Link (and waits for the NULLs from the other)
	-- inputs of the transmitter
	TX_Write : in std_logic;   -- controls the write of data/control by the host
	TX_Data : in std_logic_vector(8 DOWNTO 0);   -- data bus or control bus from the host
   Tick_IN : in std_logic;
	Time_IN : in std_logic_vector(7 DOWNTO 0);
	-- inputs of the receiver
   DIn : in std_logic;   -- input D of the receiver
	SIn : in std_logic;   -- input S of the receiver
	Buffer_Ready : in std_logic;

	-- external outputs of all the CODEC (ECSS-E-50-12C)
	-- outputs of the transmitter
   DOut : out std_logic;   -- output D of the transmitter
	SOut : out std_logic;   -- output S of the transmitter
   TX_Ready : out std_logic;   -- indicates that the transmitter can be written by the host with a data or control
	-- outputs of the receiver
	Buffer_Write : out std_logic;   -- controls the write of data/control on the host
	RX_Data : out std_logic_vector(8 DOWNTO 0);   -- data bus or control bus to the host
   Tick_OUT : out std_logic;
	Time_OUT : out std_logic_vector(7 DOWNTO 0);
	EstadoInterno : out std_logic_vector(9 DOWNTO 0)   -- bit 0 --> '1' if "Disconnect Error"
	                                                   -- bit 1 --> '1' if "Parity Error"
																		-- bit 2 --> '1' if "Escape Error"
																		-- bit 3 --> '1' if "Credit Error"
																		-- bit 4 --> '1' if in state "ErrorReset"
																		-- bit 5 --> '1' if in state "ErrorWait"
																		-- bit 6 --> '1' if in state "Ready"
																		-- bit 7 --> '1' if in state "Started"
																		-- bit 8 --> '1' if in state "Connecting"
																		-- bit 9 --> '1' if in state "Run"
);
end entity CodecSpWXNSEE2;

architecture behaviour of CodecSpWXNSEE2 is
  
	signal Reset : std_logic;   -- two cascaded register filtered Reset
	signal Reset_F : std_logic;   -- one cascaded register filtered Reset
   -- state machine parts
   type st is (ErrorReset, ErrorWait, Ready, Started, Connecting, Run);   -- all possible states
   signal Estado : st;   -- states
   -- 
   signal RunParaErrorReset : std_logic;
	signal ConnectingParaErrorReset : std_logic;
   signal StartedParaErrorReset : std_logic;
   signal ReadyParaErrorReset : std_logic;
   signal ErrorWaitParaErrorReset : std_logic;
   --
	signal SendNULLs : std_logic;   -- on '1' send NULLs
	signal SendFCTs : std_logic;   -- on '1' send FCTs
	signal SendNChars : std_logic;   -- on '1' send NChars
	signal SendTimeCodes : std_logic;   -- on '1' send TimeCodes
	signal SNULL : std_logic;   -- on '1' send a NULL
	signal SFCT : std_logic;   -- on '1' send a FCT
	signal SNChar : std_logic;   -- on '1' send a NChar
	signal STimeCode : std_logic;   -- on '1' send a TimeCode
   signal EnableTimer6v4 : std_logic;   -- on '1' disparate the Timer 6v4, on '0' disables the timer 6v4
   signal EnableTimer12v8 : std_logic;   -- on '1' disparate the Timer 12v8, on '0' disables the timer 12v8
	signal EnableTX : std_logic;   -- on '1' enable TX and on '0' disable TX
	signal EnableRX : std_logic;   -- on '1' enable RX and on '0' disable RX
	signal LinkEnabled : std_logic;   -- on '1' indicates that the link can begin to work
   -- timer parts
	CONSTANT FREQ_CLK : INTEGER := 100;   -- clock frequency in MHz
	CONSTANT N_6v4 : INTEGER := 640;   -- FREQ_CLK * 6,4
	CONSTANT N_12v8 : INTEGER := 1280;   -- FREQ_CLK * 12,8
   signal Timer6v4_count : INTEGER RANGE 4095 DOWNTO 0;   -- count the ticks for timer 6v4
   signal Timer12v8_count : INTEGER RANGE 8191 DOWNTO 0;   -- count the ticks for timer 12v8
   signal After6v4us : std_logic;   -- on '1' indicates that has passed 6,4us after start of timer 6v4
   signal After12v8us : std_logic;   -- on '1' indicates that has passed 12,8us after start of timer 12v8
   -- transmitter parts
   signal SignalD : std_logic;   -- signal D of the transmitter
	signal SignalS : std_logic;   -- signal S of the transmitter
--	CONSTANT SIZETXFifoMais8 : INTEGER := 64;   -- number of possibles positions in the TX fifo + 8
	CONSTANT SIZETXFifoMais8 : INTEGER := 16;   -- number of possibles positions in the TX fifo + 8
   signal CreditCountTX : INTEGER RANGE SIZETXFifoMais8 DOWNTO 0;   -- indicates how many NChars can be transmitted
   signal TXCount : INTEGER RANGE 63 DOWNTO 0;   -- count the ticks for TX clock
--   signal TXClk : std_logic;   -- this is the TX clock for transmition (initialy it must be of 10MHz)
	CONSTANT N_TX : INTEGER := 9;   -- (FREQ_CLK * 0,1) - 1 (initial TX clock ticks)
	CONSTANT N_TX100M : INTEGER := 0;   -- (FREQ_CLK * 0,01) - 1 (100Mbps TX clock ticks)
   signal TXCountConstant : INTEGER RANGE 63 DOWNTO 0;   -- gives the step for the ticks for Tx clock
	CONSTANT N_TXBit13 : INTEGER := 13;   -- word of 14 bits of size
	CONSTANT N_TXBit12 : INTEGER := 12;   -- word of 13 bits of size
	CONSTANT N_TXBit11 : INTEGER := 11;   -- word of 12 bits of size
	CONSTANT N_TXBit10 : INTEGER := 10;   -- word of 11 bits of size
	CONSTANT N_TXBit09 : INTEGER := 9;   -- word of 10 bits of size
	CONSTANT N_TXBit08 : INTEGER := 8;   -- word of 9 bits of size
	CONSTANT N_TXBit07 : INTEGER := 7;   -- word of 8 bits of size
	CONSTANT N_TXBit06 : INTEGER := 6;   -- word of 7 bits of size
	CONSTANT N_TXBit05 : INTEGER := 5;   -- word of 6 bits of size
	CONSTANT N_TXBit04 : INTEGER := 4;   -- word of 5 bits of size
	CONSTANT N_TXBit03 : INTEGER := 3;   -- word of 4 bits of size
	CONSTANT N_TXBit02 : INTEGER := 2;   -- word of 3 bits of size
	CONSTANT N_TXBit01 : INTEGER := 1;   -- word of 2 bits of size
	CONSTANT N_TXBit00 : INTEGER := 0;   -- positiond of the bit number 0
   type TXst is (TXBit00, TXBit01, TXBit02, TXBit03, TXBit04, TXBit05, TXBit06, TXBit07, TXBit08, TXBit09, TXBit10, TXBit11, TXBit12, TXBit13, TXStopping, TXStopped);   -- all possible states of the TX serializer
   signal TXEstado : TXst;   -- indicates the current states of the TX serializer
   signal TXSizeInUse : TXst;   -- size of the word in use being sended
   signal TXSizeNext : TXst;   -- size of the next word to be sent
   signal TXWordInUse : std_logic_vector(N_TXBit13 DOWNTO N_TXBit00);   -- word in use being sended
   signal TXWordNext : std_logic_vector(N_TXBit13 DOWNTO N_TXBit00);   -- next word to be sent
	signal EnableTXDSOut : std_logic;   -- on '1' enable TXDSOut and on '0' disable TXDSOut
	-- signal TXFirstTime : std_logic;   -- on '1' indicates the first time to send after the EnableTX
	signal TXSemaphore : std_logic;   -- on '1' indicates the necessity of wait liberation to send another NULL, NChar, FCT, or TimeCode
	signal SendNULLsFirstTime : std_logic;   -- indicates the current state of the SendNULLs process

   signal ResultXor0706 : std_logic;   -- results of the partial XOR operation for parity
   signal ResultXor0504 : std_logic;   -- results of the partial XOR operation for parity
   signal ResultXor0302 : std_logic;   -- results of the partial XOR operation for parity
   signal ResultXor0100 : std_logic;   -- results of the partial XOR operation for parity
   signal ResultXor07060504 : std_logic;   -- results of the partial XOR operation for parity
   signal ResultXor03020100 : std_logic;   -- results of the partial XOR operation for parity
   signal ResultXorTotal : std_logic;   -- results of the partial XOR operation for parity
   signal ParityContTXSizeInUse : std_logic;   -- results of the parity in the case of control
   signal ParityDataTXSizeInUse : std_logic;   -- results of the parity in the case of data

   -- FIFO transmitter parts
	CONSTANT SIZETXData : INTEGER := 9;   -- word of 9 bits of size (1 bit of control and 8 bits of data)
	CONSTANT SIZETXPtr : INTEGER := 6;   -- word of 6 bits of size (possible from 0 to 63 positions)
	CONSTANT SIZETXFifo : INTEGER := SIZETXFifoMais8 - 8;   -- number of possibles positions in the TX fifo
	signal TXFifoFull : std_logic;   -- on '1' indicates that the TX FIFO is full
	signal TXFifoEmpty : std_logic;   -- on '1' indicates that the TX FIFO is empty
   type TXFifoType is array (0 to SIZETXFifo-1) of std_logic_vector(SIZETXData-1 downto 0);
   signal TXFifo : TXFifoType :=(others => (others => '0'));   -- TX FIFO memory for queue.
   --signal TXFifoReadPtr : std_logic_vector(SIZETXPtr-1 downto 0) := (others => '0');  -- TX FIFO read pointer.
   --signal TXFifoWritePtr : std_logic_vector(SIZETXPtr-1 downto 0) := (others => '0');  -- TX FIFO write pointer.
   signal TXFifoReadPtr : INTEGER RANGE SIZETXFifo-1 DOWNTO 0 := 0;  -- TX FIFO read pointer.
   signal TXFifoWritePtr : INTEGER RANGE SIZETXFifo-1 DOWNTO 0 := 0;  -- TX FIFO write pointer.
   signal TXFifoDeltaUsado : INTEGER RANGE SIZETXFifo DOWNTO 0 := 0;  -- TX FIFO delta usado (number of words written and NOT readed).
   signal TXFifoDeltaNaoUsado : INTEGER RANGE SIZETXFifo DOWNTO 0 := SIZETXFifo;  -- TX FIFO delta NÃO usado (number of empty spaces).
   type TXFifost is (TXFifoFirst, TXFifoSecond, TXFifoThird);   -- all possible TXFifo states
   signal TXFifoEstado : TXFifost;   -- state of the TXFifo
   -- TimeCode transmitter parts
   signal Tick_IN_F : std_logic;   -- auxiliar Flag to get the rising edge of the signal Tick_IN
	signal Tick_IN_Borda : std_logic;   -- signal indicating that was passed by the rising edge when equal '1' and by the falling edge when equal '0'
   signal Time_IN_Data : std_logic_vector(7 DOWNTO 0);   -- register to write internally the TimeCode
	
   -- receiver parts	
   signal RXClk : std_logic;   -- signal indicating a clock recovered from the signals DIn and SIn with an XOR operation
	signal DisconnectError : std_logic;   -- RxErr part - on '1' indicates error
	signal DisconnectErrorD : std_logic;   -- RxErr on D part - on '1' indicates error
	signal DisconnectErrorS : std_logic;   -- RxErr on S part - on '1' indicates error
	signal ParityError : std_logic;   -- RxErr part - on '1' indicates error
	signal EscapeError : std_logic;   -- RxErr part - on '1' indicates error
	signal CreditError : std_logic;   -- CreditError part - on '1' indicates error
	signal GotBit : std_logic;   -- 
	signal GotNULLFirstTime : std_logic;   -- GotNULLFirstTime part - on '1' indicates that a First NULL has arrived
	signal GotNULL : std_logic;   -- GotNULL part - on '1' indicates that a NULL has arrived
	signal GotNChar : std_logic;   -- GotNChar part - on '1' indicates that a NChar has arrived
	signal GotTimeCode : std_logic;   -- GotTimeCode part - on '1' indicates that a TimeCode has arrived
	signal GotFCT : std_logic;   -- GotFCT part - on '1' indicates that a FCT has arrived
	-- signal GotFCT_F : std_logic;   -- answer to the GotFCT part
	CONSTANT SIZERXFifoMais8 : INTEGER := 64;   -- number of possibles positions in the RX fifo + 8
   signal CreditCountRX : INTEGER RANGE SIZERXFifoMais8 DOWNTO 0;   -- indicates how many NChars can be received
   signal CreditCountRXmais8 : INTEGER RANGE SIZERXFifoMais8 DOWNTO 0;   -- indicates how many NChars can be received
   -- FIFO receiver parts	
	CONSTANT SIZERXData : INTEGER := 9;   -- word of 9 bits of size (1 bit of control and 8 bits of data)
	CONSTANT SIZERXPtr : INTEGER := 6;   -- word of 6 bits of size (possible from 0 to 63 positions)
	CONSTANT SIZERXFifo : INTEGER := SIZERXFifoMais8 - 8;   -- number of possibles positions in the RX fifo
	signal RXFifoFull : std_logic;   -- on '1' indicates that the RX FIFO is full
	signal RXFifoEmpty : std_logic;   -- on '1' indicates that the RX FIFO is empty
   type RXFifoType is array (0 to SIZERXFifo-1) of std_logic_vector(SIZERXData-1 downto 0);
   signal RXFifo : RXFifoType :=(others => (others => '0'));   -- RX FIFO memory for queue.
   --signal RXFifoReadPtr : std_logic_vector(SIZERXPtr-1 downto 0) := (others => '0');  -- RX FIFO read pointer.
   --signal RXFifoWritePtr : std_logic_vector(SIZERXPtr-1 downto 0) := (others => '0');  -- RX FIFO write pointer.
   signal RXFifoReadPtr : INTEGER RANGE SIZERXFifo-1 DOWNTO 0 := 0;  -- RX FIFO read pointer.
   signal RXFifoWritePtr : INTEGER RANGE SIZERXFifo-1 DOWNTO 0 := 0;  -- RX FIFO write pointer.
   signal RXFifoDeltaUsado : INTEGER RANGE SIZERXFifo DOWNTO 0 := 0;  -- RX FIFO delta usado (number of words written and NOT readed).
   signal RXFifoDeltaNaoUsado : INTEGER RANGE SIZERXFifo DOWNTO 0 := SIZERXFifo;  -- RX FIFO delta NÃO usado (number of empty spaces).
   type RXFifost is (RXFifoFirst, RXFifoSecond, RXFifoThird);   -- all possible RXFifo states
   signal RXFifoEstado : RXFifost;   -- state of the RXFifo
   -- parallelizer
   signal RXCountD : INTEGER RANGE 1023 DOWNTO 0;   -- count the ticks for RX clock to use in the "disconect error on D"
   signal RXCountS : INTEGER RANGE 1023 DOWNTO 0;   -- count the ticks for RX clock to use in the "disconect error on S"
--	CONSTANT N_RTX : INTEGER := 85;   -- number of tick clock's (using clk=100MHz)
	CONSTANT N_RTX : INTEGER := 85;   -- number of tick clock's (using clk=10MHz)   -- to aprox. to 850ns
   signal RXClk_F : std_logic;   -- auxiliary flag to see the changes of the signal RXClk
	CONSTANT N_RXBit13 : INTEGER := 13;   -- word of 14 bits of size
	CONSTANT N_RXBit12 : INTEGER := 12;   -- word of 13 bits of size
	CONSTANT N_RXBit11 : INTEGER := 11;   -- word of 12 bits of size
	CONSTANT N_RXBit10 : INTEGER := 10;   -- word of 11 bits of size
	CONSTANT N_RXBit09 : INTEGER := 9;   -- word of 10 bits of size
	CONSTANT N_RXBit08 : INTEGER := 8;   -- word of 9 bits of size
	CONSTANT N_RXBit07 : INTEGER := 7;   -- word of 8 bits of size
	CONSTANT N_RXBit06 : INTEGER := 6;   -- word of 7 bits of size
	CONSTANT N_RXBit05 : INTEGER := 5;   -- word of 6 bits of size
	CONSTANT N_RXBit04 : INTEGER := 4;   -- word of 5 bits of size
	CONSTANT N_RXBit03 : INTEGER := 3;   -- word of 4 bits of size
	CONSTANT N_RXBit02 : INTEGER := 2;   -- word of 3 bits of size
	CONSTANT N_RXBit01 : INTEGER := 1;   -- word of 2 bits of size
	CONSTANT N_RXBit00 : INTEGER := 0;   -- positiond of the bit number 0
   type RXst is (RXBit00, RXBit01, RXBit02, RXBit03, RXBit04, RXBit05, RXBit06, RXBit07, RXBit08, RXBit09, RXBit10, RXBit11, RXBit12, RXBit13);   -- all possible states of the RX parallelizer
   signal RXEstado : RXst;   -- indicates the current states of the RX parallelizer
   signal RXSizeInUse : RXst;   -- size of the word in use being received
   signal RXSizeNext : RXst;   -- size of the next word to be received
   signal RXWordInUse : std_logic_vector(N_RXBit13 DOWNTO N_RXBit00);   -- word in use being received
   signal RXWordNext : std_logic_vector(N_RXBit13 DOWNTO N_RXBit00);   -- next word to be received
	signal EnableRXDSIn : std_logic;   -- on '1' enable RXDSIn and on '0' disable RXDSIn
	signal RXSemaphore : std_logic;   -- on '1' indicates that a NULL, NChar, FCT, or TimeCode was read and transferred to the register RXWordNext
	signal RXSemaphore_F : std_logic;   -- auxiliary flag

   signal DIn_F : std_logic;   -- auxiliary flag to see the changes of the signal DIn
   signal SIn_F : std_logic;   -- auxiliary flag to see the changes of the signal SIn
	signal RXAcumulatedXor : std_logic;   -- acumulates the XOR operation of the last word (control or data) received
	signal RXParity : std_logic;   -- calculus of the parity of the new word (control or data) in process of receiving
	
	
begin   -- architecture behavior

   -- Possible ways from one "Estado" to other "Estado" 
   RunParaErrorReset <= LinkDisable OR CreditError OR DisconnectError OR ParityError OR EscapeError;
	ConnectingParaErrorReset <= DisconnectError OR ParityError OR EscapeError OR (GotNULL AND (GotNChar OR GotTimeCode)) OR After12v8us;
   StartedParaErrorReset <= DisconnectError OR ParityError OR EscapeError OR (GotNULL AND (GotFCT OR GotNChar OR GotTimeCode)) OR After12v8us;
   ReadyParaErrorReset <= DisconnectError OR ParityError OR EscapeError OR (GotNULL AND (GotFCT OR GotNChar OR GotTimeCode));
   ErrorWaitParaErrorReset <= DisconnectError OR ParityError OR EscapeError OR (GotNULL AND (GotFCT OR GotNChar OR GotTimeCode));
   -- Calculus of the parity for transmition
	ResultXor0706 <= TXWordInUse(N_TXBit07) XOR TXWordInUse(N_TXBit06);
   ResultXor0504 <= TXWordInUse(N_TXBit05) XOR TXWordInUse(N_TXBit04);
   ResultXor0302 <= TXWordInUse(N_TXBit03) XOR TXWordInUse(N_TXBit02);
   ResultXor0100 <= TXWordInUse(N_TXBit01) XOR TXWordInUse(N_TXBit00);
	ResultXor07060504 <= ResultXor0706 XOR ResultXor0504;
	ResultXor03020100 <= ResultXor0302 XOR ResultXor0100;
   ResultXorTotal <= ResultXor07060504 XOR ResultXor03020100;

   -- process to construct the parity
   parity_construction_process : process (TXSizeInUse, ResultXorTotal, ResultXor0100) is
	begin
		case TXSizeInUse is   -- this will calculate the new parity in function of the size of the last word send (Cases of: Control and Data)
			when TXBit13 =>
				ParityContTXSizeInUse <= NOT (ResultXorTotal XOR '1');   -- the final '1' represents TXWordNext(N_TXBit12) <= '1' (Control)
				ParityDataTXSizeInUse <= NOT (ResultXorTotal XOR '0');   -- the final '0' represents TXWordNext(N_TXBit12) <= '0' (Data)
			when TXBit09 =>
				ParityContTXSizeInUse <= NOT (ResultXorTotal XOR '1');   -- the final '1' represents TXWordNext(N_TXBit08) <= '1' (Control)
				ParityDataTXSizeInUse <= NOT (ResultXorTotal XOR '0');   -- the final '0' represents TXWordNext(N_TXBit08) <= '0' (Data)
			when TXBit07 =>
				ParityContTXSizeInUse <= NOT (ResultXor0100 XOR '1');   -- the final '1' represents TXWordNext(N_TXBit06) <= '1' (Control)
				ParityDataTXSizeInUse <= NOT (ResultXor0100 XOR '0');   -- the final '0' represents TXWordNext(N_TXBit06) <= '0' (Data)
			when TXBit03 =>
				ParityContTXSizeInUse <= NOT (ResultXor0100 XOR '1');   -- the final '1' represents TXWordNext(N_TXBit02) <= '1' (Control)
				ParityDataTXSizeInUse <= NOT (ResultXor0100 XOR '0');   -- the final '0' represents TXWordNext(N_TXBit02) <= '0' (Data)
			when OTHERS =>   -- this case is an error !!!!!!!!!!!!!!!!!!!!!!!!!!!!
				ParityContTXSizeInUse <= '0';
				ParityDataTXSizeInUse <= '0';
		end case;
   end process parity_construction_process;

   -- purpose: transit on the states
   state_machine_process : process (Clk, Reset) is   -- process to control all the ECSS-E-50-12C
   begin
      if (Reset = '1') then   -- asynchronous reset (active high)
         Estado <= ErrorReset;
         EnableTimer6v4 <= '0';   -- disable the Timer 6v4
         EnableTimer12v8 <= '0';   -- disable the Timer 12v8
         EnableTX <= '0';   -- disable TX
         EnableRX <= '0';   -- disable RX
			SendNULLs <= '0';   -- don't send anything
			SendFCTs <= '0';   -- don't send anything
			SendNChars <= '0';   -- don't send anything
			SendTimeCodes <= '0';   -- don't send anything
			
      elsif (rising_edge(Clk)) then  -- rising clock edge
         case Estado is
            when ErrorReset =>
				   if ( After6v4us = '1' ) then   -- has passed 6,4us after start of timer
                  Estado <= ErrorWait;   -- new state "ErrorWait"
   				   EnableTimer6v4 <= '0';   -- disable the Timer 6v4
                  EnableTimer12v8 <= '0';   -- disable the Timer 12v8
               else
                  Estado <= ErrorReset;
   				   EnableTimer6v4 <= '1';   -- (re)disparate the Timer 6v4
                  EnableTimer12v8 <= '0';   -- disable the Timer 12v8
					end if;
               EnableTX <= '0';   -- disable TX
               EnableRX <= '0';   -- disable RX
               SendNULLs <= '0';   -- don't send anything
	            SendFCTs <= '0';   -- don't send anything
	            SendNChars <= '0';   -- don't send anything
	            SendTimeCodes <= '0';   -- don't send anything
				when ErrorWait =>
					if ( ErrorWaitParaErrorReset = '1' ) then
                  Estado <= ErrorReset;   -- new state "ErrorReset"
   				   EnableTimer6v4 <= '0';   -- disable the Timer 6v4
                  EnableTimer12v8 <= '0';   -- disable the Timer 12v8
				   elsif (After12v8us = '1') then   -- has passed 12,8us after start of timer
                  Estado <= Ready;   -- new state "Ready"
   				   EnableTimer6v4 <= '0';   -- disable the Timer 6v4
                  EnableTimer12v8 <= '0';   -- disable the Timer 12v8
               else
                  Estado <= ErrorWait;
   				   EnableTimer6v4 <= '0';   -- disable the Timer 6v4
                  EnableTimer12v8 <= '1';   -- (re)disparate the Timer 12v8
				   end if;
               EnableTX <= '0';   -- disable TX
               EnableRX <= '1';   -- enable RX
               SendNULLs <= '0';   -- don't send anything
	            SendFCTs <= '0';   -- don't send anything
	            SendNChars <= '0';   -- don't send anything
	            SendTimeCodes <= '0';   -- don't send anything
				when Ready =>
					if ( ReadyParaErrorReset = '1' ) then
                  Estado <= ErrorReset;   -- new state "ErrorReset"
   				   EnableTimer6v4 <= '0';   -- disable the Timer 6v4
                  EnableTimer12v8 <= '0';   -- disable the Timer 12v8
				   elsif ( LinkEnabled = '1' ) then   -- the Link is enabled
                  Estado <= Started;   -- new state "Started"
   				   EnableTimer6v4 <= '0';   -- disable the Timer 6v4
                  EnableTimer12v8 <= '0';   -- disable the Timer 12v8
               else
                  Estado <= Ready;
   				   EnableTimer6v4 <= '0';   -- disable the Timer 6v4
                  EnableTimer12v8 <= '0';   -- disable the Timer 12v8
				   end if;
               EnableTX <= '0';   -- disable TX
               EnableRX <= '1';   -- enable RX
               SendNULLs <= '0';   -- don't send anything
               SendFCTs <= '0';   -- don't send anything
	            SendNChars <= '0';   -- don't send anything
	            SendTimeCodes <= '0';   -- don't send anything
				when Started =>
					if ( StartedParaErrorReset = '1' ) then
                  Estado <= ErrorReset;   -- new state "ErrorReset"
   				   EnableTimer6v4 <= '0';   -- disable the Timer 6v4
                  EnableTimer12v8 <= '0';   -- disable the Timer 12v8
				   elsif ( GotNULL = '1' ) then   -- received a NULL
                  Estado <= Connecting;   -- new state "Connecting"
   				   EnableTimer6v4 <= '0';   -- disable the Timer 6v4
                  EnableTimer12v8 <= '0';   -- disable the Timer 12v8
               else
                  Estado <= Started;
   				   EnableTimer6v4 <= '0';   -- disable the Timer 6v4
                  EnableTimer12v8 <= '1';   -- (re)disparate the Timer 12v8
				   end if;
               EnableTX <= '1';   -- enable TX
               EnableRX <= '1';   -- enable RX
	            SendNULLs <= '1';   -- send NULLs
	            SendFCTs <= '0';   -- don't send anything
	            SendNChars <= '0';   -- don't send anything
	            SendTimeCodes <= '0';   -- don't send anything
				when Connecting =>
					if ( ConnectingParaErrorReset = '1' ) then
                  Estado <= ErrorReset;   -- new state "ErrorReset"
   				   EnableTimer6v4 <= '0';   -- disable the Timer 6v4
                  EnableTimer12v8 <= '0';   -- disable the Timer 12v8
				   elsif ( GotFCT = '1' ) then   -- received a FCT
                  Estado <= Run;   -- new state "Run"
   				   EnableTimer6v4 <= '0';   -- disable the Timer 6v4
                  EnableTimer12v8 <= '0';   -- disable the Timer 12v8
               else
                  Estado <= Connecting;
   				   EnableTimer6v4 <= '0';   -- disable the Timer 6v4
                  EnableTimer12v8 <= '1';   -- (re)disparate the Timer 12v8
				   end if;
               EnableTX <= '1';   -- enable TX
               EnableRX <= '1';   -- enable RX
	            SendNULLs <= '1';   -- send NULLs
	            SendFCTs <= '1';   -- send FCTs
	            SendNChars <= '0';   -- don't send anything
	            SendTimeCodes <= '0';   -- don't send anything
				when Run =>
				   if ( RunParaErrorReset = '1' ) then
                  Estado <= ErrorReset;   -- new state "ErrorReset"
   				   EnableTimer6v4 <= '0';   -- disable the Timer 6v4
                  EnableTimer12v8 <= '0';   -- disable the Timer 12v8
               else
                  Estado <= Run;
   				   EnableTimer6v4 <= '0';   -- disable the Timer 6v4
                  EnableTimer12v8 <= '0';   -- disable the Timer 12v8
				   end if;
               EnableTX <= '1';   -- enable TX
               EnableRX <= '1';   -- enable RX
	            SendNULLs <= '1';   -- send NULLs
	            SendFCTs <= '1';   -- send FCTs
	            SendNChars <= '1';   -- send NChars
	            SendTimeCodes <= '1';   -- send TimeCodes
				when OTHERS =>
               Estado <= ErrorReset;
				   EnableTimer6v4 <= '0';   -- disable the Timer 6v4
               EnableTimer12v8 <= '0';   -- disable the Timer 12v8
               EnableTX <= '0';   -- disable TX
               EnableRX <= '0';   -- disable RX
		         SendNULLs <= '0';   -- don't send anything
		         SendFCTs <= '0';   -- don't send anything
		         SendNChars <= '0';   -- don't send anything
		         SendTimeCodes <= '0';   -- don't send anything
			end case;
      end if;
   end process state_machine_process;

   timer6v4_process : process (Clk, Reset) is   -- process to control the timer 6v4 (6,4us)
   begin
      if (Reset = '1') then   -- asynchronous reset (active high)
         Timer6v4_count <= 0;
         After6v4us <= '0';
      elsif (rising_edge(Clk)) then  -- rising clock edge
         if (EnableTimer6v4 = '0') then   -- synchronous EnableTimer6v4 (stop on '0')
            Timer6v4_count <= 0;
            After6v4us <= '0';
         else   -- EnableTimer6v4 is enabled
		      if Timer6v4_count >= N_6v4 then
               After6v4us <= '1';   -- has passed 6,4us after start of timer 6v4
		      else
               After6v4us <= '0';   -- don't has passed 6,4us after start of timer 6v4
   	         Timer6v4_count <= Timer6v4_count + 1;
		      end if;
			end if;
      end if;
   end process timer6v4_process;

   timer12v8_process : process (Clk, Reset) is   -- process to control the timer 12v8 (12,8us)
   begin
      if (Reset = '1') then   -- asynchronous reset (active high)
         Timer12v8_count <= 0;
         After12v8us <= '0';
      elsif (rising_edge(Clk)) then  -- rising clock edge
         if (EnableTimer12v8 = '0') then   -- synchronous EnableTimer12v8 (stop on '0')
            Timer12v8_count <= 0;
            After12v8us <= '0';
			else   -- EnableTimer12v8 is enabled
		      if Timer12v8_count >= N_12v8 then
               After12v8us <= '1';   -- has passed 12,8us after start of timer 12v8
		      else
               After12v8us <= '0';   -- don't has passed 12,8us after start of timer 12v8
   	         Timer12v8_count <= Timer12v8_count + 1;
		      end if;
			end if;
      end if;
   end process timer12v8_process;

   tx_rx_process : process (Clk, Reset) is   -- process to control the transmitter and the receiver
   begin
      if (Reset = '1') then   -- asynchronous reset (active high)
         SignalS <= '0';
         SignalD <= '0';
         TXEstado <= TXStopped;
	      TXSizeInUse <= TXStopped;
         TXWordInUse <= (N_TXBit13 DOWNTO N_TXBit00 => '0');
		   TXSizeNext <= TXStopped;
		   TXWordNext <= (N_TXBit13 DOWNTO N_TXBit00 => '0');
			-- TXFirstTime <= '1';   -- first time to transmit after reset or error
			TXSemaphore <= '0';   -- can write on the TXSizeNext register
         TXCount <= 0;   -- auxiliary variable to adjust the frequency of the transmition (Mbps)
         TXCountConstant <= N_TX;
         EnableTXDSOut <= '0';   -- disables the serializer part of the transmitter
         SendNULLsFirstTime <= '1';   -- says that it is a new beggining in the machine of the transmition

	      TXFifoFull <= '0';
	      TXFifoEmpty <= '1';
         TXFifoReadPtr <= 0;
         TXFifoWritePtr <= 0;
         TXFifoDeltaUsado <= 0;
         TXFifoDeltaNaoUsado <= SIZETXFifo;
         CreditCountTX <= 0;

	      RXFifoFull <= '0';
	      RXFifoEmpty <= '1';
         RXFifoReadPtr <= 0;
         RXFifoWritePtr <= 0;
         RXFifoDeltaUsado <= 0;
         RXFifoDeltaNaoUsado <= SIZERXFifo;
         CreditCountRX <= 0;
         CreditCountRXmais8 <= 8;

         TX_Ready <= '0';
         TXFifoEstado <= TXFifoFirst;
         Buffer_Write <= '0';
         RXFifoEstado <= RXFifoFirst;

         Tick_IN_Borda <= '0';   
			Tick_IN_F <= '0';
         Time_IN_Data <= (others => '0');

		   RX_Data <= (others => '0');
	
         RXSemaphore_F <= '0';
	      GotNULL <= '0';   -- NO GotNULL
	      GotFCT <= '0';   -- NO GotFCT
         GotNCHAR <= '0';   -- NO GotNCHAR
         GotTimeCode <= '0';   -- NO GotTimeCode
         -- GotFCT_F <= '0';
	      CreditError <= '0';   -- NO Credit Error

			Tick_OUT <= '1';
	      Time_OUT <= (others => '0');

	      SNULL <= '0';   -- don't send a NULL
	      SFCT <= '0';   -- don't send a FCT
	      SNChar <= '0';   -- don't send a NChar
	      STimeCode <= '0';   -- don't send a TimeCode

	      DisconnectErrorD <= '0';   -- NO Disconnect Error on D
	      DisconnectErrorS <= '0';   -- NO Disconnect Error on S
	      ParityError <= '0';   -- NO Parity Error
	      EscapeError <= '0';   -- NO Escape Error
	      GotBit <= '0';   -- NO GotBit
	      GotNULLFirstTime <= '0';   -- NO GotNULLFirstTime

			RXSemaphore <= '0';   -- can NOT read from the RXWordNext register

	      RXSizeInUse <= RXBit00;
         RXWordInUse <= (N_RXBit13 DOWNTO N_RXBit00 => '0');
		   RXSizeNext <= RXBit00;
		   RXWordNext <= (N_RXBit13 DOWNTO N_RXBit00 => '0');

			RXEstado <= RXBit00;
         DIn_F <= '1';
         SIn_F <= '1';
         RXClk_F <= '1';
         RXAcumulatedXor <= '0';   -- Zero Acumulated Xor
         RXParity <= '0';   -- NO Parity Error
			RXCountD <= 0;
			RXCountS <= 0;

	   elsif (rising_edge(Clk)) then  -- rising clock edge
         -- Constructing clock of transmitter
         if ( TXCount >= TXCountConstant ) then   -- counter exceeds the limit
--            if ( Estado = Run ) then
--			      TXCountConstant <= N_TX100M;
--			   else
--			      TXCountConstant <= N_TX;
--			   end if;
		      if (EnableTXDSOut = '1') then   -- testing enable of this transmitter's clock
			      case TXEstado is
                  when TXBit13 =>
                     if (SignalD = TXWordInUse(N_TXBit13)) then
				            SignalS <= NOT SignalS;
   			         end if;
                     SignalD <= TXWordInUse(N_TXBit13);
                     TXEstado <= TXBit12;
							-- Se estiver no estado "Run" aumenta a velocidade para 100Mbps
                     if ( Estado = Run ) then
		                  TXCountConstant <= N_TX100M;
		               end if;
					   when TXBit12 =>
                     if (SignalD = TXWordInUse(N_TXBit12)) then
				            SignalS <= NOT SignalS;
				         end if;
                     SignalD <= TXWordInUse(N_TXBit12);
                     TXEstado <= TXBit11;
                  when TXBit11 =>
                     if (SignalD = TXWordInUse(N_TXBit11)) then
				            SignalS <= NOT SignalS;
				         end if;
                     SignalD <= TXWordInUse(N_TXBit11);
                     TXEstado <= TXBit10;
                  when TXBit10 =>
                     if (SignalD = TXWordInUse(N_TXBit10)) then
				            SignalS <= NOT SignalS;
   			         end if;
                     SignalD <= TXWordInUse(N_TXBit10);
                     TXEstado <= TXBit09;
                  when TXBit09 =>
                     if (SignalD = TXWordInUse(N_TXBit09)) then
	   			         SignalS <= NOT SignalS;
				         end if;
                     SignalD <= TXWordInUse(N_TXBit09);
                     TXEstado <= TXBit08;
							-- Se estiver no estado "Run" aumenta a velocidade para 100Mbps
                     if ( Estado = Run ) then
		                  TXCountConstant <= N_TX100M;
		               end if;
                  when TXBit08 =>
                     if (SignalD = TXWordInUse(N_TXBit08)) then
	   			         SignalS <= NOT SignalS;
   			         end if;
                     SignalD <= TXWordInUse(N_TXBit08);
                     TXEstado <= TXBit07;
                  when TXBit07 =>
                     if (SignalD = TXWordInUse(N_TXBit07)) then
  					         SignalS <= NOT SignalS;
   	   		      end if;
                     SignalD <= TXWordInUse(N_TXBit07);
                     TXEstado <= TXBit06;
							-- Se estiver no estado "Run" aumenta a velocidade para 100Mbps
                     if ( Estado = Run ) then
		                  TXCountConstant <= N_TX100M;
		               end if;
                  when TXBit06 =>
                     if (SignalD = TXWordInUse(N_TXBit06)) then
   	   		         SignalS <= NOT SignalS;
				         end if;
                     SignalD <= TXWordInUse(N_TXBit06);
                     TXEstado <= TXBit05;
                  when TXBit05 =>
                     if (SignalD = TXWordInUse(N_TXBit05)) then
	   			         SignalS <= NOT SignalS;
				         end if;
                     SignalD <= TXWordInUse(N_TXBit05);
                     TXEstado <= TXBit04;
                  when TXBit04 =>
                     if (SignalD = TXWordInUse(N_TXBit04)) then
  					         SignalS <= NOT SignalS;
		   		      end if;
                     SignalD <= TXWordInUse(N_TXBit04);
                     TXEstado <= TXBit03;
                  when TXBit03 =>
                     if (SignalD = TXWordInUse(N_TXBit03)) then
		   		         SignalS <= NOT SignalS;
   			         end if;
                     SignalD <= TXWordInUse(N_TXBit03);
                     TXEstado <= TXBit02;
							-- Se estiver no estado "Run" aumenta a velocidade para 100Mbps
                     if ( Estado = Run ) then
		                  TXCountConstant <= N_TX100M;
		               end if;
                  when TXBit02 =>
                     if (SignalD = TXWordInUse(N_TXBit02)) then
   				         SignalS <= NOT SignalS;
   		   	      end if;
                     SignalD <= TXWordInUse(N_TXBit02);
                     TXEstado <= TXBit01;
                  when TXBit01 =>
                     if (SignalD = TXWordInUse(N_TXBit01)) then
   				         SignalS <= NOT SignalS;
   		   	      end if;
                     SignalD <= TXWordInUse(N_TXBit01);
                     TXEstado <= TXBit00;
                  when TXBit00 =>
                     if (SignalD = TXWordInUse(N_TXBit00)) then
			   	         SignalS <= NOT SignalS;
				         end if;
                     SignalD <= TXWordInUse(N_TXBit00);
                     if (TXSemaphore = '1') then
				            TXEstado <= TXSizeNext;
	   			         TXSizeInUse <= TXSizeNext;
                        TXWordInUse <= TXWordNext;
  			               TXSemaphore <= '0';   -- permits the next write on the registers "TXWordNext and TXSizeNext" by the transmitter_process
	                     -- Limpa os Flag's SNULL, SFCT, SNChar, STimeCode
								SNULL <= '0';
	                     SFCT <= '0';
	                     SNChar <= '0';
	                     STimeCode <= '0';
							else
				            TXEstado <= TXStopping;   -- goto the progressive stopping ................................................
	   			         TXSizeInUse <= TXStopping;
                        TXWordInUse <= (N_TXBit13 DOWNTO N_TXBit00 => '0');
							end if;
                  when TXStopping =>   -- stopping transmitting ...................................................................
                     if (SignalD = '1' and SignalS = '1') then
  			               SignalS <= '0';
   		               SignalD <= '1';
                     elsif (SignalD = '1' and SignalS = '0') then
  			               SignalS <= '0';
   		               SignalD <= '0';
                     elsif (SignalD = '0' and SignalS = '1') then
  			               SignalS <= '0';
   		               SignalD <= '0';
                     else
  			               SignalS <= '0';
   		               SignalD <= '0';
				         end if;
   			         TXEstado <= TXStopped;
	   			      TXSizeInUse <= TXStopped;
                     TXWordInUse <= (N_TXBit13 DOWNTO N_TXBit00 => '0');
                  when TXStopped =>   -- transmitter stopped .......................................................................
  			            SignalS <= '0';
   		            SignalD <= '0';
				         TXEstado <= TXStopped;
	   			      TXSizeInUse <= TXStopped;
                     TXWordInUse <= (N_TXBit13 DOWNTO N_TXBit00 => '0');
							EnableTXDSOut <= '0';
							-- Se NÃO estiver no estado "Run" diminui a velocidade para 10Mbps
                     if ( Estado /= Run ) then
		                  TXCountConstant <= N_TX;
		               end if;
						when OTHERS =>
  			            SignalS <= '0';
   		            SignalD <= '0';
				         TXEstado <= TXStopped;
	   			      TXSizeInUse <= TXStopped;
                     TXWordInUse <= (N_TXBit13 DOWNTO N_TXBit00 => '0');
     			   end case;
	         else
		         SignalS <= '0';
		         SignalD <= '0';
		         TXEstado <= TXStopped;
  			      TXSizeInUse <= TXStopped;
               TXWordInUse <= (N_TXBit13 DOWNTO N_TXBit00 => '0');
			   end if;
            TXCount <= 0;   -- reinitiates the counter
		   else
  	         TXCount <= TXCount + 1;   -- increments the counter
	      end if;
         
         if (EnableTX = '1') then
   			-- Main Core
				if (TXSemaphore = '0' and ( NOT (RXSemaphore = '1' and RXSemaphore_F = '0') )) then   -- possible to send TimeCodes, FCTs, NCHARs, NULLS
	   		   if (SendTimeCodes = '1' and Tick_IN_Borda = '1') then   -- send Time Codes prioritary AND
                                                                    -- it is after a rising edge of the signal Tick_IN
					   TXSizeNext <= TXBit13;   -- limit size of the TimeCode
						TXWordNext(N_TXBit13) <= ParityContTXSizeInUse;
				      TXWordNext(N_TXBit12) <= '1';   -- | ESC
				      TXWordNext(N_TXBit11) <= '1';   -- |
				      TXWordNext(N_TXBit10) <= '1';   -- +
				      TXWordNext(N_TXBit09) <= '1';   -- | parity
				      TXWordNext(N_TXBit08) <= '0';   -- | indicating that is DATA with time
					   TXWordNext(N_TXBit07) <= Time_IN_Data(N_TXBit00);   -- TimeCode(0)
					   TXWordNext(N_TXBit06) <= Time_IN_Data(N_TXBit01);   -- TimeCode(1)
					   TXWordNext(N_TXBit05) <= Time_IN_Data(N_TXBit02);   -- TimeCode(2)
					   TXWordNext(N_TXBit04) <= Time_IN_Data(N_TXBit03);   -- TimeCode(3)
					   TXWordNext(N_TXBit03) <= Time_IN_Data(N_TXBit04);   -- TimeCode(4)
					   TXWordNext(N_TXBit02) <= Time_IN_Data(N_TXBit05);   -- TimeCode(5)
					   TXWordNext(N_TXBit01) <= Time_IN_Data(N_TXBit06);   -- TimeCode(6)
					   TXWordNext(N_TXBit00) <= Time_IN_Data(N_TXBit07);   -- TimeCode(7)
	               TXSemaphore <= '1';
	               STimeCode <= '1';   -- send a TimeCode
			         Tick_IN_Borda <= '0';   
				   elsif ( SendFCTs = '1' and CreditCountRXmais8 <= RXFifoDeltaNaoUsado ) then   -- send FCTs prioritary AND
			                                                        -- exist space to receive plus 8 NChars, then I can send a FCT
		   		   TXSizeNext <= TXBit03;   -- limit size of the FCT
			   	   TXWordNext(N_TXBit13 DOWNTO N_TXBit04) <= (N_TXBit13 DOWNTO N_TXBit04 => '0');
						TXWordNext(N_TXBit03) <= ParityContTXSizeInUse;
				      TXWordNext(N_TXBit02) <= '1';   -- | FCT
				      TXWordNext(N_TXBit01) <= '0';   -- |
				      TXWordNext(N_TXBit00) <= '0';   -- +
						CreditCountRX <= CreditCountRX + 8;
						CreditCountRXmais8 <= CreditCountRXmais8 + 8;
			         TXSemaphore <= '1';
	               SFCT <= '1';   -- send a FCT
						-- EnableTXDSOut <= '1';   -- enables the serializer part of the transmitter
				   elsif (SendNChars = '1' and CreditCountTX >= 1 and TXFifoDeltaUsado >= 1 ) then   -- send NChars prioritary AND
			                                                                               -- if exist space in the other side of the transmition to receive (I received FCTs), I can send AND
		   		                                                                         -- there is at least one NCHAR to be sended
						if ( TXFifo(TXFifoReadPtr)(N_TXBit08) = '0' ) then   -- indicate common Data 
						   TXSizeNext <= TXBit09;   -- limit size of the NCHAR ---> (Data)
			   	      TXWordNext(N_TXBit13 DOWNTO N_TXBit10) <= (N_TXBit13 DOWNTO N_TXBit10 => '0');
						   TXWordNext(N_TXBit09) <= ParityDataTXSizeInUse;
							TXWordNext(N_TXBit08) <= '0';                                -- NCHAR(8) = '0' (Data)
						   TXWordNext(N_TXBit07) <= TXFifo(TXFifoReadPtr)(N_TXBit00);   -- NCHAR(0)
						   TXWordNext(N_TXBit06) <= TXFifo(TXFifoReadPtr)(N_TXBit01);   -- NCHAR(1)
						   TXWordNext(N_TXBit05) <= TXFifo(TXFifoReadPtr)(N_TXBit02);   -- NCHAR(2)
						   TXWordNext(N_TXBit04) <= TXFifo(TXFifoReadPtr)(N_TXBit03);   -- NCHAR(3)
						   TXWordNext(N_TXBit03) <= TXFifo(TXFifoReadPtr)(N_TXBit04);   -- NCHAR(4)
						   TXWordNext(N_TXBit02) <= TXFifo(TXFifoReadPtr)(N_TXBit05);   -- NCHAR(5)
						   TXWordNext(N_TXBit01) <= TXFifo(TXFifoReadPtr)(N_TXBit06);   -- NCHAR(6)
						   TXWordNext(N_TXBit00) <= TXFifo(TXFifoReadPtr)(N_TXBit07);   -- NCHAR(7)
						else
						   if ( TXFifo(TXFifoReadPtr)(N_TXBit00) = '0' ) then   -- indicates EOP
		   		         TXSizeNext <= TXBit03;   -- limit size of the EOP
			   	         TXWordNext(N_TXBit13 DOWNTO N_TXBit04) <= (N_TXBit13 DOWNTO N_TXBit04 => '0');
								TXWordNext(N_TXBit03) <= ParityContTXSizeInUse;
				            TXWordNext(N_TXBit02) <= '1';   -- | EOP
				            TXWordNext(N_TXBit01) <= '0';   -- |
				            TXWordNext(N_TXBit00) <= '1';   -- +
							else   -- indicates EEP
		   		         TXSizeNext <= TXBit03;   -- limit size of the EEP
			   	         TXWordNext(N_TXBit13 DOWNTO N_TXBit04) <= (N_TXBit13 DOWNTO N_TXBit04 => '0');
								TXWordNext(N_TXBit03) <= ParityContTXSizeInUse;
				            TXWordNext(N_TXBit02) <= '1';   -- | EEP
				            TXWordNext(N_TXBit01) <= '1';   -- |
				            TXWordNext(N_TXBit00) <= '0';   -- +
						   end if;
						end if;
                  if TXFifoReadPtr = SIZETXFifo-1 then
						   TXFifoReadPtr <= 0;
						else
						   TXFifoReadPtr <= TXFifoReadPtr + 1;
						end if;
                  if TXFifoDeltaUsado = SIZETXFifo then
   					   TXFifoFull <= '0';
					   end if;
                  if TXFifoDeltaUsado = 1 then
						   TXFifoEmpty <= '1';
						end if;
				      TXFifoDeltaUsado <= TXFifoDeltaUsado - 1;
				      TXFifoDeltaNaoUsado <= TXFifoDeltaNaoUsado + 1;
					   CreditCountTX <= CreditCountTX - 1;
                  TXSemaphore <= '1';
	               SNChar <= '1';   -- send a NChar
   			   elsif (SendNULLs = '1') then   -- send NULLs prioritary
    					if SendNULLsFirstTime = '1' then
							TXEstado <= TXBit07;   -- indicates the position of the actual bit to be sended
							TXSizeInUse <= TXBit07;   -- limit size of the first NULL
							TXWordInUse(N_TXBit13 DOWNTO N_TXBit08) <= (N_TXBit13 DOWNTO N_TXBit08 => '0');
							TXWordInUse(N_TXBit07) <= '0';   -- + ---> (this bit is the parity)
							TXWordInUse(N_TXBit06) <= '1';   -- |
							TXWordInUse(N_TXBit05) <= '1';   -- |
							TXWordInUse(N_TXBit04) <= '1';   -- | First NULL
							TXWordInUse(N_TXBit03) <= '0';   -- |
							TXWordInUse(N_TXBit02) <= '1';   -- |
							TXWordInUse(N_TXBit01) <= '0';   -- |
							TXWordInUse(N_TXBit00) <= '0';   -- +
							SendNULLsFirstTime <= '0';
                     --	TXSemaphore <= '0';
							EnableTXDSOut <= '1';   -- enables the serializer part of the transmitter
                  else
							TXSizeNext <= TXBit07;   -- limit size of the NULL
							TXWordNext(N_TXBit13 DOWNTO N_TXBit08) <= (N_TXBit13 DOWNTO N_TXBit08 => '0');
							TXWordNext(N_TXBit07) <= ParityContTXSizeInUse;
							TXWordNext(N_TXBit06) <= '1';   -- |
							TXWordNext(N_TXBit05) <= '1';   -- |
							TXWordNext(N_TXBit04) <= '1';   -- | NULL
							TXWordNext(N_TXBit03) <= '0';   -- |
							TXWordNext(N_TXBit02) <= '1';   -- |
							TXWordNext(N_TXBit01) <= '0';   -- |
							TXWordNext(N_TXBit00) <= '0';   -- +
							TXSemaphore <= '1';
							SNULL <= '1';   -- send a NULL
          			end if;
  				   end if;
				end if;

	         if (SendTimeCodes = '1') then
				   if (Tick_IN = '1') then
  			         if (Tick_IN_F = '0') then
						   Time_IN_Data <= Time_IN;
			            Tick_IN_Borda <= '1';
			         end if;
					end if;
					Tick_IN_F <= Tick_IN;
				else
               Tick_IN_Borda <= '0';   
               Tick_IN_F <= '0';
            end if;				
	      else
		      TXSizeNext <= TXStopped;
		      TXWordNext <= (N_TXBit13 DOWNTO N_TXBit00 => '0');
            SendNULLsFirstTime <= '1';   -- says that it is a new beggining in the machine of the transmition
	         SNULL <= '0';   -- don't send a NULL
	         SFCT <= '0';   -- don't send a FCT
	         SNChar <= '0';   -- don't send a NChar
	         STimeCode <= '0';   -- don't send a TimeCode
			end if;	

         if (EnableRX = '1') then
   			-- Main Core
	   		if (RXSemaphore = '1' and RXSemaphore_F = '0') then   -- (rising edge) was written one information in the 
			      case RXSizeNext is   -- this will find how kind of data is the next register
                  when RXBit13 =>   -- (ESCAPE) TIMECODE ("p11110tttttttt" where p is the parity bit)
                     GotTimeCode <= '1';   -- GotTimeCode='1' -> completed the receiving of a TimeCode
			            Tick_OUT <= '0';
	                  Time_OUT <= RXWordNext(N_RXBit13 downto N_RXBit06);
						when RXBit09 =>   -- signifies "data" ("p0dddddddd" where p is the parity bit)
                     if ( CreditCountRX >= 1 ) then
							   GotNCHAR <= '1';   -- GotNCHAR='1' -> completed the receiving of a NCHAR
						      CreditCountRX <= CreditCountRX - 1;
						      CreditCountRXmais8 <= CreditCountRXmais8 - 1;
                        RXFifo(RXFifoWritePtr)(SIZERXData-1) <= RXWordNext(N_RXBit01);
                        RXFifo(RXFifoWritePtr)(SIZERXData-2 downto 0) <= RXWordNext(N_RXBit09 downto N_RXBit02);
                        if RXFifoWritePtr = SIZERXFifo-1 then
	                        RXFifoWritePtr <= 0;
	                     else
	                        RXFifoWritePtr <= RXFifoWritePtr + 1;
	                     end if;
                        if RXFifoDeltaUsado = SIZERXFifo-1 then
		                     RXFifoFull <= '1';
	                     end if;
                        if RXFifoDeltaUsado = 0 then
  		                     RXFifoEmpty <= '0';
	                     end if;
                        RXFifoDeltaUsado <= RXFifoDeltaUsado + 1;
                        RXFifoDeltaNaoUsado <= RXFifoDeltaNaoUsado - 1;
							else
                        -- Data unespected ! There is a Credit Error !!!!!!!!!!!	
			               CreditError <= '1';
							end if;
                  when RXBit07 =>   -- NULL ("p1110100" where p is the parity bit)
                     GotNULL <= '1';   -- GotNULL='1' -> completed the receiving of a NULL
                  when RXBit03 =>
						   if ( RXWordNext(N_RXBit02) = '1' and RXWordNext(N_RXBit03) = '0' ) then   -- EEP ("p110" where p is the parity bit)
                        GotNCHAR <= '1';   -- GotNCHAR='1' -> completed the receiving of a NCHAR -> EEP is also considered as a NCHAR
						      CreditCountRX <= CreditCountRX - 1;
						      CreditCountRXmais8 <= CreditCountRXmais8 - 1;
	                     RXFifo(RXFifoWritePtr) <= "100000001";
                        if RXFifoWritePtr = SIZERXFifo-1 then
		                     RXFifoWritePtr <= 0;
		                  else
		                     RXFifoWritePtr <= RXFifoWritePtr + 1;
		                  end if;
                        if RXFifoDeltaUsado = SIZERXFifo-1 then
			                  RXFifoFull <= '1';
		                  end if;
                        if RXFifoDeltaUsado = 0 then
   		                  RXFifoEmpty <= '0';
		                  end if;
	                     RXFifoDeltaUsado <= RXFifoDeltaUsado + 1;
	                     RXFifoDeltaNaoUsado <= RXFifoDeltaNaoUsado - 1;
					      elsif ( RXWordNext(N_RXBit02) = '0' and RXWordNext(N_RXBit03) = '1' ) then   -- EOP ("p101" where p is the parity bit)
                        GotNCHAR <= '1';   -- GotNCHAR='1' -> completed the receiving of a NCHAR -> EOP is also considered as a NCHAR
						      CreditCountRX <= CreditCountRX - 1;
						      CreditCountRXmais8 <= CreditCountRXmais8 - 1;
		                  RXFifo(RXFifoWritePtr) <= "100000000";
                        if RXFifoWritePtr = SIZERXFifo-1 then
		                     RXFifoWritePtr <= 0;
		                  else
		                     RXFifoWritePtr <= RXFifoWritePtr + 1;
		                  end if;
                        if RXFifoDeltaUsado = SIZERXFifo-1 then
			                  RXFifoFull <= '1';
		                  end if;
                        if RXFifoDeltaUsado = 0 then
			                  RXFifoEmpty <= '0';
		                  end if;
	                     RXFifoDeltaUsado <= RXFifoDeltaUsado + 1;
	                     RXFifoDeltaNaoUsado <= RXFifoDeltaNaoUsado - 1;
					      elsif ( RXWordNext(N_RXBit02) = '0' and RXWordNext(N_RXBit03) = '0' ) then   -- FCT ("p100" where p is the parity bit)
                        GotFCT <= '1';   -- GotFCT='1' -> completed the receiving of a FCT
				            if (CreditCountTX <= 48) then   -- possible to accumulate Credit Count to send
				               CreditCountTX <= CreditCountTX + 8;
					         else   -- NO possible to accumulate Credit Count to send
			                  CreditError <= '1';
					         end if;
							else
							
							end if;
				      when OTHERS =>   -- this case is an error !!!!!!!!!!!!!!!!!!!!!!!!!!!!
                     -- do nothing
	   		   end case;
					RXSemaphore_F <= '1';
				elsif (RXSemaphore = '0' and RXSemaphore_F = '1') then   -- (falling edge)
					RXSemaphore_F <= '0';
	            GotNULL <= '0';   -- NO GotNULL
	            GotFCT <= '0';   -- NO GotFCT
               GotNCHAR <= '0';   -- NO GotNCHAR
               GotTimeCode <= '0';   -- NO GotTimeCode
	            Tick_OUT <= '1';
			   end if;
			else
				RXSemaphore_F <= '0';
    	      GotNULL <= '0';   -- NO GotNULL
	         GotFCT <= '0';   -- NO GotFCT
            GotNCHAR <= '0';   -- NO GotNCHAR
            GotTimeCode <= '0';   -- NO GotTimeCode
            Tick_OUT <= '1';
	         CreditError <= '0';
			end if;
			
         if (EnableRX = '1') then   -- synchronous EnableRX (enable on '1')
	                                 -- receiver operation is enabled
            if (GotNULLFirstTime = '1') then
					if (RXSemaphore_F = '1') then
					   RXSemaphore <= '0';
					end if;
				end if;
				
				case RXEstado is
					when RXBit13 =>
						if ( RXClk = '0' and RXClk_F = '1' ) then
							if (GotNULLFirstTime = '1') then
								RXSizeInUse <= RXBit13;
								RXEstado <= RXBit00;
								RXAcumulatedXor <= RXAcumulatedXor xor DIn;
								RXWordInUse(N_RXBit13) <= DIn;
							else
								GotBit <= '0';   -- NO GotBit
								RXEstado <= RXBit00;
							end if;
						end if;
					when RXBit12 =>
						if ( RXClk = '1' and RXClk_F = '0' ) then
							if (GotNULLFirstTime = '1') then
								RXEstado <= RXBit13;
								RXAcumulatedXor <= RXAcumulatedXor xor DIn;
								RXWordInUse(N_RXBit12) <= DIn;
							else
								GotBit <= '0';   -- NO GotBit
								RXEstado <= RXBit00;
							end if;
						end if;
					when RXBit11 =>
						if ( RXClk = '0' and RXClk_F = '1' ) then
							if (GotNULLFirstTime = '1') then
								RXEstado <= RXBit12;
								RXAcumulatedXor <= RXAcumulatedXor xor DIn;
								RXWordInUse(N_RXBit11) <= DIn;
							else
								GotBit <= '0';   -- NO GotBit
								RXEstado <= RXBit00;
							end if;
						end if;
					when RXBit10 =>
						if ( RXClk = '1' and RXClk_F = '0' ) then
							if (GotNULLFirstTime = '1') then
								RXEstado <= RXBit11;
								RXAcumulatedXor <= RXAcumulatedXor xor DIn;
								RXWordInUse(N_RXBit10) <= DIn;
							else
								GotBit <= '0';   -- NO GotBit
								RXEstado <= RXBit00;
							end if;
						end if;
					when RXBit09 =>
						if ( RXClk = '0' and RXClk_F = '1' ) then
							if (GotNULLFirstTime = '1') then
								if ( RXWordInUse(N_RXBit01) = '1' ) then   -- signifies "control"
									RXEstado <= RXBit10;
								else   -- signifies "data" ("p0dddddddd" where p is the parity bit)
									RXSizeInUse <= RXBit09;
									RXEstado <= RXBit00;
								end if;
								RXAcumulatedXor <= RXAcumulatedXor xor DIn;
								RXWordInUse(N_RXBit09) <= DIn;
							else
								GotBit <= '0';   -- NO GotBit
								RXEstado <= RXBit00;
							end if;
						end if;
					when RXBit08 =>
						if ( RXClk = '1' and RXClk_F = '0' ) then
							if (GotNULLFirstTime = '1') then
								RXEstado <= RXBit09;
								RXAcumulatedXor <= RXAcumulatedXor xor DIn;
								RXWordInUse(N_RXBit08) <= DIn;
							else
								GotBit <= '0';   -- NO GotBit
								RXEstado <= RXBit00;
							end if;
						end if;
					when RXBit07 =>
						if ( RXClk = '0' and RXClk_F = '1' ) then
							if (GotNULLFirstTime = '1') then
								if ( RXWordInUse(N_RXBit01) = '1' ) then   -- signifies "control"
									if ( RXWordInUse(N_RXBit04) = '1' and RXWordInUse(N_RXBit05) = '0' ) then   -- TIMECODE
										RXEstado <= RXBit08;
									else   -- it only can be a NULL (the only possibility)
										if ( DIn /= '0' ) then
											EscapeError <= '1';   -- Escape Error !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
										end if;
										RXSizeInUse <= RXBit07;
										RXEstado <= RXBit00;
									end if;
								else   -- signifies "data" ("p0dddddddd" where p is the parity bit)
									RXEstado <= RXBit08;
								end if;
								RXAcumulatedXor <= RXAcumulatedXor xor DIn;
								RXWordInUse(N_RXBit07) <= DIn;
							else
								if ( DIn = '0' and SIn = '0' ) then   -- eightth bit of the First NULL
	                        GotNULLFirstTime <= '1';   -- GotNULLFirstTime='1' -> completed the receiving of the first NULL
	                        GotNULL <= '1';   -- GotNULL='1' -> completed the receiving of a NULL
									RXEstado <= RXBit00;
									RXSizeInUse <= RXBit07;
									RXWordInUse(N_RXBit07) <= DIn;
									RXAcumulatedXor <= RXAcumulatedXor xor DIn;
								else
									GotBit <= '0';   -- NO GotBit
									RXEstado <= RXBit00;
								end if;
							end if;
						end if;
					when RXBit06 =>
						if ( RXClk = '1' and RXClk_F = '0' ) then
							if (GotNULLFirstTime = '1') then
								if ( RXWordInUse(N_RXBit01) = '1' ) then   -- signifies "control"
									if ( RXWordInUse(N_RXBit04) = '0' and RXWordInUse(N_RXBit05) = '1' ) then   -- NULL
										if ( DIn /= '0' ) then
											EscapeError <= '1';   -- Escape Error !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
										end if;
									end if;
								end if;
								RXAcumulatedXor <= RXAcumulatedXor xor DIn;
								RXEstado <= RXBit07;
								RXWordInUse(N_RXBit06) <= DIn;
							else
								if ( DIn = '0' and SIn = '1' ) then   -- seventh bit of the First NULL
									RXEstado <= RXBit07;
									RXWordInUse(N_RXBit06) <= DIn;
									RXAcumulatedXor <= RXAcumulatedXor xor DIn;
								else
									GotBit <= '0';   -- NO GotBit
									RXEstado <= RXBit00;
								end if;
							end if;
						end if;
					when RXBit05 =>
						if ( RXClk = '0' and RXClk_F = '1' ) then
							if (GotNULLFirstTime = '1') then
								if ( RXWordInUse(N_RXBit01) = '1' ) then   -- signifies "control"
									if ( RXWordInUse(N_RXBit04) = '1' and DIn = '1' ) then   -- it is NOT TIMECODE
										EscapeError <= '1';   -- Escape Error !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
									elsif ( RXWordInUse(N_RXBit04) = '0' and DIn = '0' ) then   -- it is NOT NULL
										EscapeError <= '1';   -- Escape Error !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
									end if;
									RXAcumulatedXor <= '0';
								else   -- signifies "data" ("p0dddddddd" where p is the parity bit)
									RXAcumulatedXor <= RXAcumulatedXor xor DIn;
								end if;
								RXEstado <= RXBit06;
								RXWordInUse(N_RXBit05) <= DIn;
							else
								if ( DIn = '1' and SIn = '1' ) then   -- sixth bit of the First NULL
									RXEstado <= RXBit06;
									RXWordInUse(N_RXBit05) <= DIn;
									RXAcumulatedXor <= '0';
								else
									GotBit <= '0';   -- NO GotBit
									RXEstado <= RXBit00;
								end if;
							end if;
						end if;
					when RXBit04 =>
						if ( RXClk = '1' and RXClk_F = '0' ) then
							if (GotNULLFirstTime = '1') then
								if ( RXWordInUse(N_RXBit01) = '1' ) then   -- signifies "control"
									RXAcumulatedXor <= '0';
								else   -- signifies "data" ("p0dddddddd" where p is the parity bit)
									RXAcumulatedXor <= RXAcumulatedXor xor DIn;
								end if;
								RXEstado <= RXBit05;
								RXWordInUse(N_RXBit04) <= DIn;
							else
								if ( DIn = '0' and SIn = '1' ) then   -- fifth bit of the First NULL
									RXEstado <= RXBit05;
									RXWordInUse(N_RXBit04) <= DIn;
								else
									GotBit <= '0';   -- NO GotBit
									RXEstado <= RXBit00;
								end if;
							end if;
						end if;
					when RXBit03 =>
						if ( RXClk = '0' and RXClk_F = '1' ) then
							if (GotNULLFirstTime = '1') then
								if ( RXParity /= RXWordInUse(N_RXBit00) ) then
									ParityError <= '1';   -- Parity Error has occurred
								end if;
								RXAcumulatedXor <= RXAcumulatedXor xor DIn;
								if ( RXWordInUse(N_RXBit01) = '1' ) then   -- signifies "control"
									if ( RXWordInUse(N_RXBit02) = '1' and DIn = '1' ) then   -- ESCAPE --> maybe TIMECODE ("p11110tttttttt" where p is the parity bit) or NULL ("p1110100" where p is the parity bit)
										RXEstado <= RXBit04;
									elsif ( RXWordInUse(N_RXBit02) = '1' and DIn = '0' ) then   -- EEP ("p110" where p is the parity bit)
										RXSizeInUse <= RXBit03;
										RXEstado <= RXBit00;
									elsif ( RXWordInUse(N_RXBit02) = '0' and DIn = '1' ) then   -- EOP ("p101" where p is the parity bit)
										RXSizeInUse <= RXBit03;
										RXEstado <= RXBit00;
									else   -- FCT ("p100" where p is the parity bit)
										RXSizeInUse <= RXBit03;
										RXEstado <= RXBit00;
									end if;
								else   -- signifies "data" ("p0dddddddd" where p is the parity bit)
									RXEstado <= RXBit04;
								end if;
								RXWordInUse(N_RXBit03) <= DIn;
							else
								if ( DIn = '1' and SIn = '1' ) then   -- fourth bit of the First NULL
									RXEstado <= RXBit04;
									RXWordInUse(N_RXBit03) <= DIn;
								else
									GotBit <= '0';   -- NO GotBit
									RXEstado <= RXBit00;
								end if;
							end if;
						end if;
					when RXBit02 =>
						if ( RXClk = '1' and RXClk_F = '0' ) then
							if (GotNULLFirstTime = '1') then
								RXParity <= NOT RXParity;
								RXAcumulatedXor <= RXAcumulatedXor xor DIn;
								RXEstado <= RXBit03;
								RXWordInUse(N_RXBit02) <= DIn;
							else
								if ( DIn = '1' and SIn = '0' ) then   -- third bit of the First NULL
									RXEstado <= RXBit03;
									RXWordInUse(N_RXBit02) <= DIn;
								else
									GotBit <= '0';   -- NO GotBit
									RXEstado <= RXBit00;
								end if;
							end if;
						end if;
					when RXBit01 =>
						if ( RXClk = '0' and RXClk_F = '1' ) then
							if (GotNULLFirstTime = '1') then
								RXParity <= RXAcumulatedXor xor DIn;
								RXAcumulatedXor <= '0';
								RXEstado <= RXBit02;
								RXWordInUse(N_RXBit01) <= DIn;
							else
								if ( DIn = '1' and SIn = '1' ) then   -- second bit of the First NULL
									RXEstado <= RXBit02;
									RXWordInUse(N_RXBit01) <= DIn;
								else
									GotBit <= '0';   -- NO GotBit
									RXEstado <= RXBit00;
								end if;
							end if;
						end if;
					when RXBit00 =>
						if ( RXClk = '1' and RXClk_F = '0' ) then
							if (GotNULLFirstTime = '1') then
								RXWordNext <= RXWordInUse;
								RXSizeNext <= RXSizeInUse;
								RXSemaphore <= '1';   -- can read from the RXWordNext register
								RXEstado <= RXBit01;
								RXWordInUse(N_RXBit00) <= DIn;
							else
								if ( DIn = '0' and DIn_F = '0' and SIn = '1' and SIn_F = '0' ) then   -- (first bit) beginning of the First NULL
									GotBit <= '1';   -- GotBit
									RXEstado <= RXBit01;
									RXWordInUse(N_RXBit00) <= DIn;
								end if;
							end if;
						end if;						
					when OTHERS =>
						GotBit <= '0';   -- NO GotBit
	               GotNULLFirstTime <= '0';   -- NO GotNULLFirstTime
						RXEstado <= RXBit00;
				end case;

				if ( GotBit = '1' ) then
					if ( DIn_F = DIn ) then
						if ( RXCountD >= N_RTX ) then
							DisconnectErrorD <= '1';   -- Disconnect Error on D
						else
							RXCountD <= RXCountD + 1;
							DisconnectErrorD <= '0';   -- NO Disconnect Error on D
						end if;				
					else
						RXCountD <= 0;
						DisconnectErrorD <= '0';   -- NO Disconnect Error on D
					end if;
					if ( SIn_F = SIn ) then
						if ( RXCountS >= N_RTX ) then
							DisconnectErrorS <= '1';   -- Disconnect Error on S
						else
							RXCountS <= RXCountS + 1;
							DisconnectErrorS <= '0';   -- NO Disconnect Error on S
						end if;				
					else
						RXCountS <= 0;
						DisconnectErrorS <= '0';   -- NO Disconnect Error on S
					end if;
				else
	   			RXCountD <= 0;
					DisconnectErrorD <= '0';   -- NO Disconnect Error on D
	   			RXCountS <= 0;
					DisconnectErrorS <= '0';   -- NO Disconnect Error on S
	         end if;
				
            DIn_F <= DIn;
            SIn_F <= SIn;
            RXClk_F <= RXClk;
		   else	
	         DisconnectErrorD <= '0';   -- NO Disconnect Error on D
	         DisconnectErrorS <= '0';   -- NO Disconnect Error on S
	         ParityError <= '0';   -- NO Parity Error
	         EscapeError <= '0';   -- NO Escape Error
	         GotBit <= '0';   -- NO GotBit
	         GotNULLFirstTime <= '0';   -- NO GotNULLFirstTime

   			RXSemaphore <= '0';   -- can NOT read from the RXWordNext register
				
	         RXSizeInUse <= RXBit00;
            RXWordInUse <= (N_RXBit13 DOWNTO N_RXBit00 => '0');
		      RXSizeNext <= RXBit00;
		      RXWordNext <= (N_RXBit13 DOWNTO N_RXBit00 => '0');

   			RXEstado <= RXBit00;
            DIn_F <= '1';
            SIn_F <= '1';
            RXClk_F <= '1';
            RXAcumulatedXor <= '0';   -- Zero Acumulated Xor
            RXParity <= '0';   -- NO Parity Error
			   RXCountD <= 0;
			   RXCountS <= 0;
			end if;

         -- ???????? reinitializes CreditCount when in the ErrorReset state
         if ( Estado = ErrorReset ) then
            -- Limpa registrador de protocolo FCT (TX)
				CreditCountTX <= 0;
            -- Limpa registrador de protocolo FCT (RX)
            CreditCountRX <= 0;
            CreditCountRXmais8 <= 8;

            -- Limpa a Fifo de TX
	         TXFifoFull <= '0';
	         TXFifoEmpty <= '1';
            TXFifoReadPtr <= 0;
            TXFifoWritePtr <= 0;
            TXFifoDeltaUsado <= 0;
            TXFifoDeltaNaoUsado <= SIZETXFifo;
				
            -- Limpa a Fifo de RX
	         RXFifoFull <= '0';
	         RXFifoEmpty <= '1';
            RXFifoReadPtr <= 0;
            RXFifoWritePtr <= 0;
            RXFifoDeltaUsado <= 0;
            RXFifoDeltaNaoUsado <= SIZERXFifo;

            -- Limpa sinais e estados relativos à Fifo (TX)
            TX_Ready <= '0';
            TXFifoEstado <= TXFifoFirst;

            -- Limpa sinais e estados relativos à Fifo (RX)
            Buffer_Write <= '0';
            RXFifoEstado <= RXFifoFirst;
		   end if;
			
	      -- write in the TXFifo by the host if the TXFifo is NOT Full
         case TXFifoEstado is
            when TXFifoFirst =>
			      if (TXFifoFull = '1') then   -- we can't write inside the TXFifo because it's full
                  TX_Ready <= '0';
               else                         -- we can write inside the TXFifo because it's not full
                  if (TX_Write = '1') then   -- there exist a requisition to write a data inside the Codec
                     TXFifoEstado <= TXFifoSecond;
                  end if;
                  TX_Ready <= '1';
               end if;					
   			when TXFifoSecond =>
			      if (TX_Write = '1') then   -- there exist a requisition to write a data inside the Codec
					   if (TXSemaphore = '1') then   -- possible to use the TXFifo
                     TXFifo(TXFifoWritePtr) <= TX_Data;
                     if TXFifoWritePtr = SIZETXFifo-1 then
					         TXFifoWritePtr <= 0;
					      else
					         TXFifoWritePtr <= TXFifoWritePtr + 1;
					      end if;
                     if TXFifoDeltaUsado = SIZETXFifo-1 then
						      TXFifoFull <= '1';
   				      end if;
                     if TXFifoDeltaUsado = 0 then
						      TXFifoEmpty <= '0';
					      end if;
				         TXFifoDeltaUsado <= TXFifoDeltaUsado + 1;
				         TXFifoDeltaNaoUsado <= TXFifoDeltaNaoUsado - 1;
                     TXFifoEstado <= TXFifoThird;
                     TX_Ready <= '0';
						end if;
					else
                  TXFifoEstado <= TXFifoFirst;
					end if;
				when TXFifoThird =>
			         if (TX_Write = '0') then   -- no more requisition to write a data inside the Codec
						   TXFifoEstado <= TXFifoFirst;
						else
                     TXFifoEstado <= TXFifoThird;
                  end if;
				when OTHERS =>
			      if (TXFifoFull = '1') then   -- we can't write inside the TXFifo because it's full
                  TX_Ready <= '0';
               else                         -- we can write inside the TXFifo because it's not full
                  TX_Ready <= '1';
               end if;					
     				TXFifoEstado <= TXFifoFirst;
			end case;

	      -- read from the RXFifo by the host
         case RXFifoEstado is
            when RXFifoFirst =>
			      if (RXFifoEmpty = '0') then   -- we can read from the RxFifo because it's not empty
			         if (Buffer_Ready = '1') then   -- there exist a requisition to read a data from the Codec
                     RXFifoEstado <= RXFifoSecond;
                  end if;
					end if;
               Buffer_Write <= '0';
   			when RXFifoSecond =>
			      if (Buffer_Ready = '1') then   -- there exist a requisition to read a data from the Codec
	   		      if ( NOT (RXSemaphore = '1' and RXSemaphore_F = '0')) then   -- NOT (rising edge)
					      RX_Data <= RXFifo(RXFifoReadPtr);
                     if RXFifoReadPtr = SIZERXFifo-1 then
					         RXFifoReadPtr <= 0;
					      else
					         RXFifoReadPtr <= RXFifoReadPtr + 1;
					      end if;
                     if RXFifoDeltaUsado = SIZERXFifo then
						      RXFifoFull <= '0';
					      end if;
                     if RXFifoDeltaUsado = 1 then
						      RXFifoEmpty <= '1';
					      end if;
				         RXFifoDeltaUsado <= RXFifoDeltaUsado - 1;
				         RXFifoDeltaNaoUsado <= RXFifoDeltaNaoUsado + 1;
                     RXFifoEstado <= RXFifoThird;
                     Buffer_Write <= '1';
                  end if;
					else
                  RXFifoEstado <= RXFifoFirst;
					end if;
			   when RXFifoThird =>
			      if (Buffer_Ready = '0') then   -- no more requisition to read a data from the Codec
					   RXFifoEstado <= RXFifoFirst;
                  Buffer_Write <= '0';
					else
                  RXFifoEstado <= RXFifoThird;
               end if;
			   when OTHERS =>
               RXFifoEstado <= RXFifoFirst;
               Buffer_Write <= '0';
			end case;
			
			
   	end if;
   end process tx_rx_process;

  
   DOut <= SignalD;   -- actualize DOut output
	SOut <= SignalS;   -- actualize SOut output (strobe)

	DisconnectError <= DisconnectErrorD OR DisconnectErrorS;   -- Disconnect Error on D

   -- generation of the receive clock recovery
   RXClk <= DIn xor SIn;	

	LinkEnabled <= (NOT LinkDisable) AND (LinkStart OR (AutoStart AND GotNULL));
	
   reset_filtering_process : process (Clk) is   -- process to filter the reset with 2 cascaded registers
	begin
      if (rising_edge(Clk)) then  -- rising clock edge
         Reset <= Reset_F;
		   Reset_F <= MReset;
      end if;
   end process reset_filtering_process;

   -- Estado Interno do Codec
   EstadoInterno_process : process (DisconnectError, ParityError, EscapeError, CreditError, Estado) is   -- process to show EstadoInterno
	begin
		EstadoInterno(0) <= DisconnectError;
		EstadoInterno(1) <= ParityError;
		EstadoInterno(2) <= EscapeError;
		EstadoInterno(3) <= CreditError;
		if ( Estado = ErrorReset ) then
			EstadoInterno(4) <= '1';
		else
			EstadoInterno(4) <= '0';
		end if;
		if ( Estado = ErrorWait ) then
			EstadoInterno(5) <= '1';
		else
			EstadoInterno(5) <= '0';
		end if;
		if ( Estado = Ready ) then
			EstadoInterno(6) <= '1';
		else
			EstadoInterno(6) <= '0';
		end if;
		if ( Estado = Started ) then
			EstadoInterno(7) <= '1';
		else
			EstadoInterno(7) <= '0';
		end if;
		if ( Estado = Connecting ) then
			EstadoInterno(8) <= '1';
		else
			EstadoInterno(8) <= '0';
		end if;
		if ( Estado = Run ) then
			EstadoInterno(9) <= '1';
		else
			EstadoInterno(9) <= '0';
		end if;
   end process EstadoInterno_process;

end architecture behaviour;

