------------------------------------------------------------------
-- A simple full adder desgined for use in a ripple-carry adder
------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- full adder entity
entity fulladder is
	-- three inputs, a sum output and a carry output
	port (i_a, i_b, i_c: in std_logic; o_s, o_c: out std_logic);
end fulladder;

-- full adder structural architecture
architecture struct of fulladder is
	-- internal signal declarations
	signal w_sum0, w_carry0, w_carry1: std_logic;
begin
	-- instantiate two half adders
	E_HA0: entity work.halfadder(behav1)
		   port map (i_a, i_b, w_sum0, w_carry0);
	E_HA1: entity work.halfadder(behav1)
		   port map (w_sum0, i_c, o_s, w_carry1);
	-- carry output is OR of two half-adder carries
	o_c <= w_carry0 or w_carry1;
end struct;
	

-- full adder behavioural/data flow architecture
architecture behav1 of fulladder is
begin
	-- sum is a XOR b XOR c
	o_s <= (i_a xor i_b) xor i_c;
	-- carry is 1 if two or more input bits are set
	o_c <= (i_a and i_b) or (i_a and i_c) or (i_b and i_c);
end behav1;
