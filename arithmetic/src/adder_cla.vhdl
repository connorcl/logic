---------------------------------------------------------------------
-- A carry look-ahead adder with a configurable (generic) bus width
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- adder entity
entity adder_cla is
	-- generic parameter for bus width
	generic (g_BUS_WIDTH: positive);
	-- two input vectors, a carry input, an output vector and a carry output.
	-- Carry input and output allow use in hybrid adders
	port (i_a, i_b: in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		  i_c: in std_logic;
		  o_s: out std_logic_vector(g_BUS_WIDTH-1 downto 0);
		  o_c: out std_logic);
end adder_cla;

-- adder architecture
architecture struct of adder_cla is
	-- internal carry, carry propagate and carry generate signals
	signal w_c: std_logic_vector(g_BUS_WIDTH downto 0);
	signal w_p, w_g: std_logic_vector(g_BUS_WIDTH-1 downto 0);
begin
	-- set original carry in
	w_c(0) <= i_c;
	-- generate logic to calculate carry bits
	G_CARRY_CALC: for ii in g_BUS_WIDTH downto 1 generate
		E_CARRY_CALC: entity work.carry_calc(struct)
					  generic map (ii)
					  port map (w_c(0), 
					  			w_p(ii-1 downto 0),
					  			w_g(ii-1 downto 0),
					  			w_c(ii));
	end generate;
	-- generate full adders
	G_FULL_ADDERS: for ii in g_BUS_WIDTH-1 downto 0 generate
		E_FA: entity work.fulladder_cla(struct)
			  port map (i_a(ii), i_b(ii), w_c(ii), o_s(ii), w_p(ii), w_g(ii));
	end generate;
	-- set output carry
	o_c <= w_c(g_BUS_WIDTH);
end struct;
