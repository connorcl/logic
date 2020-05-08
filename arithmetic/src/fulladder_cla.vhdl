----------------------------------------------------------------
-- A full adder designed for use in a carry look-ahead adder
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- full adder entity
entity fulladder_cla is
	-- three inputs, a sum output, a carry
	-- propagate output and a carry generate output
	port (i_a, i_b, i_c: in std_logic; o_s, o_p, o_g: out std_logic);
end fulladder_cla;

-- full adder architecture
architecture struct of fulladder_cla is
	-- internal signal declarations
	signal w_sum0, w_carry0, w_carry1: std_logic;
begin
	-- one half-adder which adds a and b
	E_HA0: entity work.halfadder(behav1)
		   port map (i_a, i_b, w_sum0, w_carry0);
	-- carry propagate is sum of a and b (a XOR b)
	o_p <= w_sum0;
	-- carry generate is carry of a and b (a AND b)
	o_g <= w_carry0;
	-- another half-adder which adds (sum of a and b) and c
	E_HA1: entity work.halfadder(behav1)
		   port map (w_sum0, i_c, o_s, w_carry1);
end struct;
