------------------------------------
-- A configurable width register
------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- register entity
entity reg is
	-- generic parameter for bus size
	generic (g_BUS_WIDTH: positive);
	-- an input vector, a load (write enable) input, 
	-- a clock input and an output vector
	port (
		i_data: in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		i_we: in std_logic;
		i_clk: in std_logic;
		o_data: out std_logic_vector(g_BUS_WIDTH-1 downto 0)
	);
end reg;

-- register architecture
architecture behav of reg is
begin
	-- clocked process
	P_WRITE_REG: process (i_clk)
	begin
		if rising_edge(i_clk) then
			if i_we = '1' then
				o_data <= i_data;
			end if;
		end if;
	end process;
end behav;
		
