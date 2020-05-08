-------------------------------------------------------------------
-- Calculates a carry-in value for a carry look-ahead incrementor
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- carry-in calculator entity
entity carry_calc_inc is
	-- generic paramter for which carry-in bit to calculate, e.g.
	-- 3 will calculate carry-in for index 3
	generic (g_BIT_INDEX: positive);
	-- inputs are all previous input bits plus original carry in
	-- Output is the carry-in bit for the given index
	port (i_c: in std_logic;
		  i_p: in std_logic_vector(g_BIT_INDEX-1 downto 0);
		  o_c: out std_logic);
end carry_calc_inc;

-- carry-in calculator architecture
architecture struct of carry_calc_inc is
	-- signal for previous carry-in
	signal w_c_p: std_logic;
begin
	-- recursively calculate previous carry-in
	G_RECURSIVE_CARRY_CALC: if g_BIT_INDEX > 1 generate
		E_CC: entity work.carry_calc_inc(struct)
			  generic map (g_BIT_INDEX-1)
			  port map (i_c, i_p(g_BIT_INDEX-2 downto 0), w_c_p);
	end generate;
	-- base case: if bit index is 1, previous carry-in is
	-- original carry-in
	G_BASE_CARRY_CALC: if g_BIT_INDEX = 1 generate
		w_c_p <= i_c;
	end generate;
	-- carry-in for bit index is previous bit AND previous carry-in
	o_c <= i_p(g_BIT_INDEX-1) and w_c_p;
end struct;
