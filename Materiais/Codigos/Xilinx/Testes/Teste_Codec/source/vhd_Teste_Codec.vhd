----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:22:24 03/09/2015 
-- Design Name: 
-- Module Name:    vhd_Teste_Codec - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vhd_Teste_Codec is
    Port ( -- Entradas Gerais
             CLOCK : in  STD_LOGIC;
             RESET : in  STD_LOGIC;
               
             -- Saida LEDS
             LED   : out std_logic_vector(1 to 3);
              
             -- Sinais LVDS
             -- saídas
             LVDS_DOUT_p : out std_logic;
             LVDS_DOUT_n : out std_logic;
             LVDS_SOUT_p : out std_logic;
             LVDS_SOUT_n : out std_logic;
                 -- entradas
             LVDS_DIN_p : in std_logic;
             LVDS_DIN_n : in std_logic;
             LVDS_SIN_p : in std_logic;
             LVDS_SIN_n : in std_logic
         );
end vhd_Teste_Codec;

architecture Behavioral of vhd_Teste_Codec is

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
  signal nread        : std_logic := '1';
  signal dout         : std_logic_vector(8 downto 0);
     
  -- Output FIFO Write
  signal nwrite       : std_logic := '1';
  signal full         : std_logic;
  signal din          : std_logic_vector(8 downto 0);
  
  -- Sinais externos 
  signal spw_si : std_logic;
  signal spw_so : std_logic;
  signal spw_di : std_logic;
  signal spw_do : std_logic;
 
  signal rst_n : std_logic := '0';
  
  signal counter : unsigned(8 downto 0) := (others => '0');


	 -- Component LVDS Outputs
	 COMPONENT OBUFDS PORT(
         O  : out std_ulogic;
         OB : out std_ulogic;
         I  : in  std_ulogic
			);
	 END COMPONENT;
	----------------------------
	
	-- Component LVDS Inputs
	COMPONENT IBUFDS PORT(
         I  : in  std_ulogic;
         IB : in  std_ulogic;
         O  : out std_ulogic
         );
	END COMPONENT;
	----------------------------
	
	-- Component Double clock frequency (DCM)
	COMPONENT clock_pll
	PORT(
		CLKIN_IN : IN std_logic;
		RST_IN : IN std_logic;  	
		CLKIN_IBUFG_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic;
		CLK2X_OUT : OUT std_logic;
		LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;
	----------------------------

begin

	Inst_clock_pll: clock_pll PORT MAP(
		CLKIN_IN => CLOCK,
		RST_IN =>   not(RESET),
		CLKIN_IBUFG_OUT => OPEN,
		CLK0_OUT => OPEN,
		CLK2X_OUT => Clk1,
		LOCKED_OUT => rst_n 
	);

--======================--
--  Codec + Controller
--======================--
  codecC : entity Codec_Controller 
	generic map(
        sysfreq  		=> 100_000_000.0,
        txclkfreq       => 100_000_000.0,
        rxfifosize_bits	=> 11,
        txfifosize_bits	=> 11
		)
	port map(

		-- Global
		Clk_SpW		=> clk1,
		nMainReset	=> rst_n,		

        -- Sinais externos LVDS
        spw_si      => spw_si, 
        spw_so 	    => spw_so,
        spw_di      => spw_di,
        spw_do	    => spw_do,

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

	 
	PROCESS(rst_n)
	begin
		if (not(rst_n)='1') then
			LED(1) <= '0'; -- Status para saber se o programa está rodando na fpga.
			LED(2) <= '1'; -- Status para saber se o programa está rodando na fpga.
		else
			LED(1) <= '1'; -- Status para saber se o programa está rodando na fpga.
			LED(2) <= '0'; -- Status para saber se o programa está rodando na fpga.
		end if;	
	end PROCESS;

LED(3) <= codec_status(4); -- Exibir status do estado "running".

-------------------------------------------------------------------------------
-- Lvds J1
-------------------------------------------------------------------------------
  OBUFDS_INSTANCE_LVDSd : OBUFDS port map
    (
      O  => LVDS_DOUT_p,
      OB => LVDS_DOUT_n,
      I  => spw_do
      );
	  
  OBUFDS_INSTANCE_LVDSs : OBUFDS port map
    (
      O  => LVDS_SOUT_p,
      OB => LVDS_SOUT_n,
      I  => spw_so
      );
	  
  IBUFDS_inst_d : IBUFDS port map
    (
      O  => spw_di,
      I  => LVDS_DIN_p,
      IB => LVDS_DIN_n
      );
	  
  IBUFDS_inst_s : IBUFDS port map
    (
      O  => spw_si,
      I  => LVDS_SIN_p,
      IB => LVDS_SIN_n
      );	

end Behavioral;

