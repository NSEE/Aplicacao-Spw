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

	-- Component Declaration for the Unit Under Test (UUT)
    COMPONENT CodecSpWXNSEE2
    PORT(
         Clk            : IN  std_logic;
         MReset         : IN  std_logic;
         LinkStart      : IN  std_logic;
         LinkDisable    : IN  std_logic;
         AutoStart      : IN  std_logic;
         TX_Write       : IN  std_logic;
         TX_Data        : IN  std_logic_vector(8 downto 0);
         Tick_IN        : IN  std_logic;
         Time_IN        : IN  std_logic_vector(7 downto 0);
         DIn            : IN  std_logic;
         SIn            : IN  std_logic;
         Buffer_Ready   : IN  std_logic;
         DOut           : OUT  std_logic;
         SOut           : OUT  std_logic;
         TX_Ready       : OUT  std_logic;
         Buffer_Write   : OUT  std_logic;
         RX_Data        : OUT  std_logic_vector(8 downto 0);
         Tick_OUT       : OUT  std_logic;
         Time_OUT       : OUT  std_logic_vector(7 downto 0);
         EstadoInterno  : OUT  std_logic_vector(9 downto 0) 	-- 0 --> '1'= "Disconnect Error" | 5 --> '1'= "ErrorWait"
																				-- 1 --> '1'= "Parity Error"		| 6 --> '1'= "Ready" 
																				-- 2 --> '1'= "Escape Error" 		| 7 --> '1'= "Started"
																				-- 3 --> '1'= "Credit Error"		| 8 --> '1'= "Connecting"
																				-- 4 --> '1'= "ErrorReset"   		| 9 -> '1'= "Run"

        );
    END COMPONENT;
	 -------------------------------------------------------------------------------------------------------------

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

	-- Inputs CodecSpWXNSEE2:
	signal Clk           : std_logic :='0';
	signal MReset        : std_logic :='0';
	signal LinkStart     : std_logic :='0';
	signal LinkDisable   : std_logic :='0';
	signal AutoStart     : std_logic :='0';
	signal TX_Write      : std_logic :='0';
	signal TX_Data       : std_logic_vector(8 downto 0) := (others => '0');
	signal Tick_IN       : std_logic :='0';
	signal Time_IN       : std_logic_vector(7 downto 0) := (others => '0');
	signal DIn           : std_logic :='0';
	signal SIn           : std_logic :='0';
	signal Buffer_Ready  : std_logic :='0';
	-------------------------------------------------------------------
	
	-- Outputs CodecSpWXNSEE2:
	signal DOut          : std_logic;
	signal SOut          : std_logic;
	signal TX_Ready      : std_logic;
	signal Buffer_Write  : std_logic;
	signal RX_Data       : std_logic_vector(8 downto 0);
	signal Tick_OUT      : std_logic;
	signal Time_OUT      : std_logic_vector(7 downto 0);
	signal EstadoInterno : std_logic_vector(9 downto 0);
	------------------------------------------------------------------

begin

 LinkStart 		<= '1';
 LinkDisable 	<= '0';
 AutoStart 	 	<= '1';
 
   c_SpW: CodecSpWXNSEE2 PORT MAP (
          Clk           => Clk,
          MReset        => MReset,
          LinkStart     => LinkStart,
          LinkDisable   => LinkDisable,
          AutoStart     => AutoStart,
          TX_Write      => TX_Write,
          TX_Data       => TX_Data,
          Tick_IN       => Tick_IN,
          Time_IN       => Time_IN,
          DIn           => DIn, 				--LVDS
          SIn           => SIn,				--LVDS
          Buffer_Ready  => Buffer_Ready,
          DOut          => DOut,				--LVDS
          SOut          => SOut,				--LVDS
          TX_Ready      => TX_Ready,
          Buffer_Write  => Buffer_Write,
          RX_Data       => RX_Data,
          Tick_OUT      => Tick_OUT,
          Time_OUT      => Time_OUT,
          EstadoInterno => EstadoInterno
        );

	PROCESS (CLOCK)
	begin
		if (rising_edge(CLOCK)) then
			
			if (EstadoInterno(9) = '1') then
				
				
			end if;
		end if;
	end PROCESS;

-------------------------------------------------------------------------------
-- Lvds J1
-------------------------------------------------------------------------------
  OBUFDS_INSTANCE_LVDSd : OBUFDS port map
    (
      O  => LVDS_DOUT_p,
      OB => LVDS_DOUT_n,
      I  => DOut
      );
	  
  OBUFDS_INSTANCE_LVDSs : OBUFDS port map
    (
      O  => LVDS_SOUT_p,
      OB => LVDS_SOUT_n,
      I  => Sout
      );
	  
  IBUFDS_inst_d : IBUFDS port map
    (
      O  => Din,
      I  => LVDS_DIN_p,
      IB => LVDS_DIN_n
      );
	  
  IBUFDS_inst_s : IBUFDS port map
    (
      O  => Sin,
      I  => LVDS_SIN_p,
      IB => LVDS_SIN_n
      );	

end Behavioral;

