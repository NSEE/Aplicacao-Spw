library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity Reg_Geral is
	port (

    ---------------------------------------------------------------------------
    -- Global
    ---------------------------------------------------------------------------

    clock       : in std_logic;
    aclr        : in std_logic;

    ---------------------------------------------------------------------------
    -- Comunicação com o controlador
    ---------------------------------------------------------------------------
	reg_addr 		: in std_logic_vector(6 downto 0);
	reg_dado_in   	: in std_logic_vector(7 downto 0);
	reg_dado_out  	: out std_logic_vector(7 downto 0);
    reg_rw			: in std_logic;						-- 0 : read, 1 : write
	reg_en			: in std_logic;						-- enable read/write
	
    ---------------------------------------------------------------------------
    -- Comunicação com D/A
    ---------------------------------------------------------------------------	
	DA_CH0_en 	: out STD_LOGIC;
	DA_CH0_next  : in  STD_LOGIC;
  	DA_CH0_dado : out STD_LOGIC_VECTOR(11 DOWNTO 0);
	
	DA_CH1_en 	: out STD_LOGIC;
	DA_CH1_next  : in  STD_LOGIC;
  	DA_CH1_dado : out STD_LOGIC_VECTOR(11 DOWNTO 0);

    );
end Reg_Geral;

architecture rtl of Reg_Geral is

	type Mem_Type is array (0 to 127) of std_logic_vector(7 downto 0);
	signal MEM : Mem_Type ;
	
	-- 
	constant ADDR_DA_0_MSB : integer := 70;
	constant ADDR_DA_0_LSB : integer := 71;
	constant ADDR_DA_1_MSB : integer := 72;
	constant ADDR_DA_1_LSB : integer := 73;

	begin
	process(clk) 
	begin
		if(rising_edge(clk)
    	
			-- Clear bit 7 -> D/A CH0			|'1': Dado pronto para ser enviado. '0': Dado foi enviado.
			if (DA_CH0_next = '1') then  -- Verifica se foi feito pedido do próximo dado.
				MEM(to_integer(unsigned(ADDR_DA_0_MSB)))(7) <= '0';
			end if;
			
			-- Clear bit 7 -> D/A CH1			|'1': Dado pronto para ser enviado. '0': Dado foi enviado.
			if (DA_CH1_next = '1') then  -- Verifica se foi feito pedido do próximo dado.
				MEM(to_integer(unsigned(ADDR_DA_1_MSB)))(7) <= '0';
			end if;
			
			----- Escrita/leitura no registrador
			if (reg_en = '1') then
		
				-- Leitura
				if(reg_rw = '0') then
					MEM(to_integer(unsigned(reg_addr))) <= reg_dado_in;
			
				-- Escrita
				else
					reg_dado_out <= MEM(to_integer(unsigned(reg_addr)));
				end if;
				
			end if;
			
		end if;		
		
	end process;
  
	-- D/A channel 0 dado
	DA_CH0_dado <= MEM(to_integer(unsigned(ADDR_DA_0_MSB)))(3 downto 0) & MEM(to_integer(unsigned(ADDR_DA_0_LSB)));
	DA_CH0_en   <= MEM(to_integer(unsigned(ADDR_DA_0_MSB)))(7);
	
	-- D/A channel 1 dado
	DA_CH1_dado <= MEM(to_integer(unsigned(ADDR_DA_1_MSB)))(3 downto 0) & MEM(to_integer(unsigned(ADDR_DA_1_LSB)));
	DA_CH1_en   <= MEM(to_integer(unsigned(ADDR_DA_1_MSB)))(7);
  
end rtl;