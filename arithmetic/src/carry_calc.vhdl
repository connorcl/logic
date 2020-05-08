-------------------------------------------------------------
-- Calculates a carry-in value for a carry look-ahead adder
-------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- carry-in calculator entity
entity carry_calc is
	-- generic paramter for which carry-in bit to calculate, e.g.
	-- 3 will calculate carry-in for index 3
	generic (g_BIT_INDEX: positive);
	-- inputs are original carry in, plus carry propagate and
	-- carry generate for all previous bits. Output is the 
	-- carry-in bit for the given index
	port (i_c0: in std_logic;
		  i_p, i_g: in std_logic_vector(g_BIT_INDEX-1 downto 0);
		  o_c: out std_logic);
end carry_calc;

-- carry-in calculator architecture
architecture struct of carry_calc is
	-- internal signal for previous (less significant index) carry-in bit
	signal w_c_prev: std_logic;
begin
	-- recursively calculate previous carry in
	G_RECURSIVE_CARRY_CALC: if g_BIT_INDEX > 1 generate
		E_CARRY_CALC: entity work.carry_calc(struct)
					  generic map (g_BIT_INDEX-1)
					  port map (i_c0,
					  			i_p(g_BIT_INDEX-2 downto 0),
					  			i_g(g_BIT_INDEX-2 downto 0),
					  			w_c_prev);
	end generate;
	-- base condition for recursive calculation: previous carry-in bit
	-- is original carry-in bit when calculating carry-in at index 1
	G_BASE_CARRY_CALC: if g_BIT_INDEX = 1 generate
		w_c_prev <= i_c0;
	end generate;
	-- calculate carry-in based on recursively calculated previous carry-in
	o_c <= i_g(g_BIT_INDEX-1) or (i_p(g_BIT_INDEX-1) and w_c_prev);
end struct;
