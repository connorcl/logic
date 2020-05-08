------------------------------------------------------------------
-- A ripple-carry adder with a configurable (generic) bus width
------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- adder entity
entity adder is
	-- generic parameter for bus width
	generic (g_BUS_WIDTH: integer := 8);
	-- two input vectors and an output vector
	port (i_a, i_b: in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		  o_s: out std_logic_vector(g_BUS_WIDTH-1 downto 0));
end adder;

-- adder architecture
architecture struct of adder is
	-- internal carry signal
	signal w_carry: std_logic_vector(g_BUS_WIDTH-1 downto 0);
begin
	-- one half adder for least significant bits
	E_HA: entity work.halfadder(behav1)
		  port map (i_a(0), i_b(0), o_s(0), w_carry(0));
 	-- generate full adders for remaining bits
 	G_FA_FOR: for ii in 1 to g_BUS_WIDTH-1 generate
 		E_FA: entity work.fulladder(struct)
 		 	  port map (i_a(ii), i_b(ii), w_carry(ii-1), o_s(ii), w_carry(ii));
	end generate G_FA_FOR;
end struct;
