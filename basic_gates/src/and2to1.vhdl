-------------------------------------------------------------------
-- A 2-to-1 AND gate with a configurable (generic) bus width
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- AND gate entity
entity and2to1 is
	-- generic parameter for bus width
	generic (g_BUS_WIDTH: integer := 8);
	-- 2 inputs and 1 output
	port (
		i_data0, i_data1: in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		o_data: out std_logic_vector(g_BUS_WIDTH-1 downto 0)
	);
end and2to1;

-- AND gate architecture
architecture behav1 of and2to1 is
begin
	o_data <= i_data0 and i_data1;
end behav1;

-- architecture which explicitly AND's each pair of bits
architecture behav2 of and2to1 is
begin
	G_AND_FOR: for ii in g_BUS_WIDTH-1 downto 0 generate
		o_data(ii) <= i_data0(ii) and i_data1(ii);
	end generate G_AND_FOR;
end behav2;
