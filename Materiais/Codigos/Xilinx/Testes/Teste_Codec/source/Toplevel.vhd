-- Bibliotecas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity TopSpwTeste is
	generic (
		freq_clock : real := 100_000_000.0;   -- MHz,
		TB	   : boolean := false			
	);
	port(
		
		-- IOs
		OSC_50_BANK2 	: in std_logic;
		LED		: out std_logic_vector(7 downto 0);
		FAN_CTRL	: out std_logic;
		
		-- Global
		Clk_SpW		: in std_logic;
		CPU_RESET_n	: in std_logic := '1';
		
		-- Sync 
		--Sync_6		 : in std_logic;
		--Sync_25		 : in std_logic;

        -- Sinais externos LVDS
		HSMA_TX_0 : out std_logic_vector(0 downto 0);
		HSMA_TX_1 : out std_logic_vector(0 downto 0);
		HSMA_RX_0 : in std_logic_vector(0 downto 0)	;	
		HSMA_RX_1 : in std_logic_vector(0 downto 0)		
	
    );
end entity;



architecture bhv of TopSpwTeste is

--===============--
-- Clock 
--===============--  

  signal clk1 : std_logic := '0';
	
--===============--
-- CODEC 
--===============--  

 -- Status CODEC
  signal codec_status : std_logic_vector(7 downto 0);

-- Controller Codec
  signal codec_ctr    : std_logic_vector(7 downto 0) := "00000" & "011";    

-- TX clk divid rate
  signal txdivcnt     : std_logic_vector(7 downto 0) := (others => '0'); 

-- Input TC
  signal tick_in     : std_logic    := '0';
  signal ctrl_in     : std_logic_vector(1 downto 0) := (others => '0');
  signal time_in     : std_logic_vector(5 downto 0) := (others => '0');

-- Output TC
  signal tick_out    : std_logic;
  signal ctrl_out    : std_logic_vector(1 downto 0);
  signal time_out    : std_logic_vector(5 downto 0);	
 
-- FIFO
  
  -- READ
  signal empty        : std_logic;
  signal nread        : std_logic;
  signal dout         : std_logic_vector(8 downto 0);
     
  -- Output FIFO Write
  signal nwrite       : std_logic;
  signal full         : std_logic;
  signal din          : std_logic_vector(8 downto 0);
  
  -- Sinais externos 
  signal spw_si : std_logic_vector(0 downto 0);
  signal spw_so : std_logic_vector(0 downto 0);
  signal spw_di,spw_di_aux : std_logic_vector(0 downto 0);
  signal spw_do : std_logic_vector(0 downto 0);
 
  signal rst_n : std_logic := '0';

  type st is (s0, s1, s2);
  signal estado : st;

  signal led_i : std_logic_vector(7 downto 0);
  
  signal counter : unsigned(8 downto 0) := (others => '0');

  
--======================--
--  Components
--======================--  
  
component PLL 
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0			: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
end component;  
 
component RX_LVDS
	PORT
	(
		rx_in		: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
		rx_out	: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
end component;

component TX_LVDS
	PORT
	(
		tx_in		: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
		tx_out		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
end component;
 
begin



--======================--
--  Codec + Controller
--======================--
  codecC : entity Codec_Controller 
	generic map(
        sysfreq  	=> 100_000_000.0,
        txclkfreq       => 100_000_000.0,
        rxfifosize_bits	=> 11,
        txfifosize_bits	=> 11
		)
	port map(

	-- Global
	Clk_SpW		=> clk1,
	nMainReset	=> rst_n,		

        -- Sinais externos LVDS
        spw_si      => spw_si(0), 
        spw_so 	    => spw_so(0),
        spw_di      => spw_di(0),
        spw_do	    => spw_do(0),

        -- Status CODEC + controller
        codec_status => codec_status,
        codec_ctr    => codec_ctr,
        txdivcnt     => txdivcnt,

        -- Input TC
        tick_in     => tick_in,  
        ctrl_in     => ctrl_in, 
        time_in     => time_in, 

        -- Output TC
        tick_out   => tick_out,
        ctrl_out   => ctrl_out,
        time_out   => time_out,
     
        -- Output FIFO Write
        nwrite     => nwrite,
        full       => full,
        din        => STD_LOGIC_VECTOR(counter),

        -- Input FIFO READ
        empty      => empty,
        nread      => nread, 
        dout       => dout
    );

--======================--
-- simulaçao
--======================--	
tesbench: if TB generate
	spw_si <= spw_so;
	spw_di <= spw_do;
	
	process 
	begin
		clk1 <= not clk1;
		wait for 0.1 ns;
		clk1 <= not clk1;
		wait for 0.1 ns;
	end process;

    process
    begin
        rst_n <= '1';
        wait for 2 ns;
        rst_n <= '0';
        wait for 5 ns;
        rst_n <= '1';
        wait;
    end process;
end  generate tesbench;

--======================--
-- implementação 
--======================--	
imple : if TB = false generate

-- RST
    rst_n <= CPU_RESET_n;

-- PLL 100 Mhz
	PLL_CLK : PLL port map(
		areset  => '0',
		inclk0  => OSC_50_BANK2,
		c0 	  	=> clk1
	);

-- LVDS
	TX_LVDS_0 : TX_LVDS PORT MAP (
		tx_in  => spw_so,
		tx_out => HSMA_TX_0
	);
	
	TX_LVDS_1 : TX_LVDS PORT MAP (
		tx_in  => spw_do,
		tx_out => HSMA_TX_1
	);

	RX_LVDS_0 : RX_LVDS PORT MAP (
		rx_in  => HSMA_RX_0,
		rx_out => spw_di
	);

	RX_LVDS_1 : RX_LVDS PORT MAP (
		rx_in  => HSMA_RX_1,
		rx_out => spw_si
	);
end generate imple;


--======================--
-- Escrita
--======================--	
--process(clk1)	
--begin
--    if(rising_edge(clk1)) then    
--    	if codec_status(4) = '1' then
--    		if(full = '0') then
--    			nwrite <= '0';
--    		else
--				nwrite  <= '1';
--				counter(7 downto 0) <= counter(7 downto 0) + to_unsigned(1,8);
--    		end if;
--        else
--            nwrite  <= '1';
--				counter(7 downto 0) <= (others => '0');
--    	end if;
--	end if;
--end process;


--======================--
-- Leitura
--======================--
--process(clk1)	
--begin
--    if(rising_edge(clk1)) then
--        if(rst_n = '0') then
--            nread   <= '1';
--            led_i   <= X"0F";
--            estado  <= s0;
--        else
--            case estado is
--			
--                when s0 =>
--                    nread  <= '1';
--						  estado <= s0;
--						  led_i  <= led_i;
--					
--	                if(empty = '0') then
--		                led_i  <= dout(7 downto 0);
--						    nread  <= '0';
--                      estado <= s1;
--	                end if;
--					
--                when s1 =>
--                        nread  <= '1';
--                        estado <= s0;
--						
--                when others =>
--                        nread  <= '1';
--                        estado <= s0;
--						
--            end case;
--        end if;
--    end if;
--end process;

nwrite <= '1';
nread  <= '1';
counter(8) <= '0';

-- I/Os
led(0) <= codec_status(4);
led(7 downto 1) <= led_i(7 downto 1);
FAN_CTRL <= '1';

end bhv;
