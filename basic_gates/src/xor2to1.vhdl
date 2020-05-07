-------------------------------------------------------------------
-- A 2-to-1 XOR gate with a configurable (generic) bus width
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- XOR gate entity
entity xor2to1 is
	-- generic parameter for bus width
	generic (g_BUS_WIDTH: integer := 8);
	-- 2 inputs and 1 output
	port (
		i_data1, i_data2: in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		o_data: out std_logic_vector(g_BUS_WIDTH-1 downto 0)
	);
end xor2to1;

-- XOR gate architecture
architecture behav1 of xor2to1 is
begin
	o_data <= i_data1 xor i_data2;
end behav1;
