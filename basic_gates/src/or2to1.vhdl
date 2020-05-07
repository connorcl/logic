-------------------------------------------------------------------
-- A 2-to-1 OR gate with a configurable (generic) bus width
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- OR gate entity
entity or2to1 is
	-- generic parameter for bus width
	generic (g_BUS_WIDTH: integer := 8);
	-- 2 inputs and 1 output
	port (
		i_data0, i_data1: in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		o_data: out std_logic_vector(g_BUS_WIDTH-1 downto 0)
	);
end or2to1;

-- OR gate architecture
architecture behav1 of or2to1 is
begin
	o_data <= i_data0 or i_data1;
end behav1;
