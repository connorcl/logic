---------------------
-- A half-adder
---------------------

library ieee;
use ieee.std_logic_1164.all;

-- half-adder entity
entity halfadder is
	-- two inputs, a sum output and a carry output
	port (i_a, i_b: in std_logic; o_s, o_c: out std_logic);
end halfadder;

-- half-adder architecture
architecture behav1 of halfadder is
begin
	-- sum is a XOR b
	o_s <= i_a xor i_b;
	-- carry is a AND b
	o_c <= i_a and i_b;
end behav1;
