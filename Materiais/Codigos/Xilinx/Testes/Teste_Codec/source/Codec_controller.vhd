-------------------------------------------------------------------------------
-- Instituto Maua de Tecnologia
-- 	Nucleo de Sistemas Eletronicos Embarcados
-- 
-- Rafael Corsi - rafael.corsi@maua.br
-- Platao Simucam 2.0
--
-- Set/2014
--
--------------------------------------------------------------------------------
-- Descriao
--  Bloco utilziado para controlar o Codec Spw e adapatar no RMAP e nos registradores
--  
--Funcionalidade
-- Transformar a FIFO do codec em uma autonomous FIFO (escrita e leitura)
-- Mapear as portas de configuração para o mapa de registradores (para poder
-- ser acessado via up/ Barramento)
--
-- TODO
--  o Gerar duas autonomous fifo via a fifo atual
--  o Mapear o controle para os registradores
--------------------------------------------------------------------------------

-- Bibliotecas
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.spwpkg.all;
--use work.all;

---use PkgTransfBlock.all;

-- SpW Light Codec

entity Codec_Controller is
	generic (
        -- System clock frequency in Hz.
        -- This must be set to the frequency of "clk". It is used to setup
        -- counters for reset timing, disconnect timeout and to transmit
        -- at 10 Mbit/s during the link handshake.
        sysfreq:        real := 10_000_000.0;

        -- Transmit clock frequency in Hz (only if tximpl = impl_fast).
        -- This must be set to the frequency of "txclk". It is used to
        -- transmit at 10 Mbit/s during the link handshake.
        txclkfreq:      real := 10_000_000.0;

        -- Selection of a receiver front-end implementation.
        rximpl:         spw_implementation_type := impl_fast;

        -- Maximum number of bits received per system clock
        -- (must be 1 in case of impl_generic).
        rxchunk:        integer range 1 to 4 := 1;

        -- Selection of a transmitter implementation.
        tximpl:         spw_implementation_type := impl_generic;

        -- Size of the receive FIFO as the 2-logarithm of the number of bytes.
        -- Must be at least 6 (64 bytes).
        rxfifosize_bits: integer range 6 to 14 := 11;

        -- Size of the transmit FIFO as the 2-logarithm of the number of bytes.
        txfifosize_bits: integer range 2 to 14 := 11

		);
	port(
		-- Global
		Clk_SpW		 : in std_logic;
		nMainReset	 : in std_logic;
		
        -- Sinais externos LVDS
        spw_si       : in  std_logic;
        spw_so 	     : out std_logic;
        spw_di       : in  std_logic;
        spw_do	     : out std_logic;

        -- Status CODEC
        codec_status : out std_logic_vector(7 downto 0);
        
        -- Controller Codec
        codec_ctr   : in  std_logic_vector(7 downto 0);    

        -- TX clk divid rate
        txdivcnt    : in std_logic_vector(7 downto 0);

        -- Input TC
        tick_in     : in std_logic;
        ctrl_in     : in std_logic_vector(1 downto 0);
        time_in     : in std_logic_vector(5 downto 0);

        -- Output TC
        tick_out    : out std_logic;
        ctrl_out    : out std_logic_vector(1 downto 0);
        time_out    : out std_logic_vector(5 downto 0);
     
        -- Output FIFO Write
        nwrite       : in  std_logic;
        full         : out std_logic;
        din          : in  std_logic_vector(8 downto 0);

        -- Input FIFO READ
        empty        : out std_logic;
        nread        : in  std_logic;
        dout         : out std_logic_vector(8 downto 0)

	);
end entity;

architecture bhv of Codec_Controller is


    component spwstream is
    generic (
        -- System clock frequency in Hz.
        -- This must be set to the frequency of "clk". It is used to setup
        -- counters for reset timing, disconnect timeout and to transmit
        -- at 10 Mbit/s during the link handshake.
        sysfreq:        real;

        -- Transmit clock frequency in Hz (only if tximpl = impl_fast).
        -- This must be set to the frequency of "txclk". It is used to
        -- transmit at 10 Mbit/s during the link handshake.
        txclkfreq:      real := 10_000_000.0;

        -- Selection of a receiver front-end implementation.
        rximpl:         spw_implementation_type := impl_generic;

        -- Maximum number of bits received per system clock
        -- (must be 1 in case of impl_generic).
        rxchunk:        integer range 1 to 4 := 1;

        -- Selection of a transmitter implementation.
        tximpl:         spw_implementation_type := impl_generic;

        -- Size of the receive FIFO as the 2-logarithm of the number of bytes.
        -- Must be at least 6 (64 bytes).
        rxfifosize_bits: integer range 6 to 14 := 11;

        -- Size of the transmit FIFO as the 2-logarithm of the number of bytes.
        txfifosize_bits: integer range 2 to 14 := 11
    );

    port (
        -- System clock.
        clk:        in  std_logic;

        -- Receiver sample clock (only for impl_fast)
        rxclk:      in  std_logic;

        -- Transmit clock (only for impl_fast)
        txclk:      in  std_logic;

        -- Synchronous reset (active-high).
        rst:        in  std_logic;

        -- Enables automatic link start on receipt of a NULL character.
        autostart:  in  std_logic;

        -- Enables link start once the Ready state is reached.
        -- Without autostart or linkstart, the link remains in state Ready.
        linkstart:  in  std_logic;

        -- Do not start link (overrides linkstart and autostart) and/or
        -- disconnect a running link.
        linkdis:    in  std_logic;

        -- Scaling factor minus 1, used to scale the transmit base clock into
        -- the transmission bit rate. The system clock (for impl_generic) or
        -- the txclk (for impl_fast) is divided by (unsigned(txdivcnt) + 1).
        -- Changing this signal will immediately change the transmission rate.
        -- During link setup, the transmission rate is always 10 Mbit/s.
        txdivcnt:   in  std_logic_vector(7 downto 0);

        -- High for one clock cycle to request transmission of a TimeCode.
        -- The request is registered inside the entity until it can be processed.
        tick_in:    in  std_logic;

        -- Control bits of the TimeCode to be sent. Must be valid while tick_in is high.
        ctrl_in:    in  std_logic_vector(1 downto 0);

        -- Counter value of the TimeCode to be sent. Must be valid while tick_in is high.
        time_in:    in  std_logic_vector(5 downto 0);

        -- Pulled high by the application to write an N-Char to the transmit
        -- queue. If "txwrite" and "txrdy" are both high on the rising edge
        -- of "clk", a character is added to the transmit queue.
        -- This signal has no effect if "txrdy" is low.
        txwrite:    in  std_logic;

        -- Control flag to be sent with the next N_Char.
        -- Must be valid while txwrite is high.
        txflag:     in  std_logic;

        -- Byte to be sent, or "00000000" for EOP or "00000001" for EEP.
        -- Must be valid while txwrite is high.
        txdata:     in  std_logic_vector(7 downto 0);

        -- High if the entity is ready to accept an N-Char for transmission.
        txrdy:      out std_logic;

        -- High if the transmission queue is at least half full.
        txhalff:    out std_logic;

        -- High for one clock cycle if a TimeCode was just received.
        tick_out:   out std_logic;

        -- Control bits of the last received TimeCode.
        ctrl_out:   out std_logic_vector(1 downto 0);

        -- Counter value of the last received TimeCode.
        time_out:   out std_logic_vector(5 downto 0);

        -- High if "rxflag" and "rxdata" contain valid data.
        -- This signal is high unless the receive FIFO is empty.
        rxvalid:    out std_logic;

        -- High if the receive FIFO is at least half full.
        rxhalff:    out std_logic;

        -- High if the received character is EOP or EEP; low if the received
        -- character is a data byte. Valid if "rxvalid" is high.
        rxflag:     out std_logic;

        -- Received byte, or "00000000" for EOP or "00000001" for EEP.
        -- Valid if "rxvalid" is high.
        rxdata:     out std_logic_vector(7 downto 0);

        -- Pulled high by the application to accept a received character.
        -- If "rxvalid" and "rxread" are both high on the rising edge of "clk",
        -- a character is removed from the receive FIFO and "rxvalid", "rxflag"
        -- and "rxdata" are updated.
        -- This signal has no effect if "rxvalid" is low.
        rxread:     in  std_logic;

        -- High if the link state machine is currently in the Started state.
        started:    out std_logic;

        -- High if the link state machine is currently in the Connecting state.
        connecting: out std_logic;

        -- High if the link state machine is currently in the Run state, indicating
        -- that the link is fully operational. If none of started, connecting or running
        -- is high, the link is in an initial state and the transmitter is not yet enabled.
        running:    out std_logic;

        -- Disconnect detected in state Run. Triggers a reset and reconnect of the link.
        -- This indication is auto-clearing.
        errdisc:    out std_logic;

        -- Parity error detected in state Run. Triggers a reset and reconnect of the link.
        -- This indication is auto-clearing.
        errpar:     out std_logic;

        -- Invalid escape sequence detected in state Run. Triggers a reset and reconnect of
        -- the link. This indication is auto-clearing.
        erresc:     out std_logic;

        -- Credit error detected. Triggers a reset and reconnect of the link.
        -- This indication is auto-clearing.
        errcred:    out std_logic;

        -- Data In signal from SpaceWire bus.
        spw_di:     in  std_logic;

        -- Strobe In signal from SpaceWire bus.
        spw_si:     in  std_logic;

        -- Data Out signal to SpaceWire bus.
        spw_do:     out std_logic;

        -- Strobe Out signal to SpaceWire bus.
        spw_so:     out std_logic
    );
    end component;



-----------------------------------------
-- Registros 
-----------------------------------------

   signal autostart:   std_logic;
   signal linkstart:   std_logic;
   signal linkdis:     std_logic;

   signal started:     std_logic;
   signal connecting:  std_logic;
   signal running:     std_logic;
   signal errdisc:     std_logic;
   signal errpar:      std_logic;
   signal erresc:      std_logic;
   signal errcred:     std_logic;
     
   signal txwrite:     std_logic;
   signal txflag:      std_logic;
   signal txdata:      std_logic_vector(7 downto 0);
   signal rxread:      std_logic;

   signal rxdata:      std_logic_vector(7 downto 0);
   signal txrdy:       std_logic;
   signal txhalff:     std_logic;
   signal rxvalid:     std_logic;
   signal rxhalff:     std_logic;
   signal rxflag:      std_logic := '0';
   
   -- Rst
   signal rst     :    std_logic; 

   -- Autonomous fifo 
   signal empty_i :    std_logic := '1';

Begin

-----------------------------------------
-- Codec
-----------------------------------------
codec1 : spwstream 
	GENERIC MAP(
		sysfreq => sysfreq
	)
	PORT MAP(
		clk 		=> Clk_SpW,
		rxclk		=> Clk_SpW,
		txclk		=> Clk_SpW,
		rst 		=> rst,

        autostart  => autostart, 
        linkstart  => linkstart, 
        linkdis    => linkdis  , 
        txdivcnt   => txdivcnt ,  

        tick_in    => tick_in  , 
        ctrl_in    => ctrl_in  ,  
        time_in    => time_in  ,  
        
        txwrite    => txwrite  , 
        txflag     => txflag   , 
        txdata     => txdata   ,  
        txrdy      => txrdy    , 
        txhalff    => txhalff  , 
        
        tick_out   => tick_out , 
        ctrl_out   => ctrl_out ,   
        time_out   => time_out ,  
        
        rxvalid    => rxvalid  , 
        rxhalff    => rxhalff  , 
        rxflag     => rxflag   , 
        rxdata     => rxdata   ,  
        rxread     => rxread   , 
        
        started    => started  , 
        connecting => connecting,
        running    => running  , 
        errdisc    => errdisc  , 
        errpar     => errpar   , 
        erresc     => erresc   , 
        errcred    => errcred  , 
		
		spw_di	   	=> spw_di,
		spw_do		=> spw_do,
		spw_si		=> spw_si,
		spw_so		=> spw_so
);


 -----------------------------
 -- Rst
 -----------------------------
 rst <= not nMainReset; 

 ------------------------------------------------------
 --         Autonomous Fifo 
 ------------------------------------------------------


 -----------------------------
 -- TX FIFO 
 -----------------------------

 -- EOP ou EEP
 txflag  <= din(8);
 txdata  <= din(7 downto 0);

 txwrite <= txrdy and not(nwrite);
 full    <= not(txrdy);

 -----------------------------
 -- RX FIFO 
 -----------------------------
 
 -- Dado concatenado de EOP e Nchar
 -- Se rxflag = 1 -> EOP/EEP
 -- se rxflag = 0 -> nchar
 dout <= rxflag & rxdata; 

 rxread <= not(nread);

-- process(Clk_SpW)
--  begin
--    if RISING_EDGE(Clk_SpW) then
--      if (rst = '1') then
--        empty_i <= '1';
--      else
--        empty_i <= not(rxvalid) and (empty_i or not(nread));
--      end if;
--    end if;
-- end process;

 empty <= not rxvalid;


 ------------------------------------------------------
 --  Codec Status & Controller 
 ------------------------------------------------------

 codec_status <= '0'     & 
                 started & 
                 connecting & 
                 running &
                 errdisc &
                 errpar  &
                 erresc  &
                 errcred;

 autostart <= codec_ctr(0);
 linkstart <= codec_ctr(1);
 linkdis   <= codec_ctr(2);

end bhv;

