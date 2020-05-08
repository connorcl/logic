--------------------------------------------------------------
-- A ripple-carry incrementor with a configurable bus width
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- incrementor entity
entity inc is
	-- generic parameter for bus width
	generic (g_BUS_WIDTH: positive);
	-- one input and one output
	port (i_data: in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		  o_data: out std_logic_vector(g_BUS_WIDTH-1 downto 0));
end inc;

-- incrementor architecture
architecture struct of inc is
	-- internal signal for carries
	signal w_c: std_logic_vector(g_BUS_WIDTH downto 0);
begin
	-- set first carry-in to 1
	w_c(0) <= '1';
	-- generate half-adders
	G_HALF_ADDER: for ii in g_BUS_WIDTH-1 downto 0 generate
		E_HA: entity work.halfadder(behav1)
			  port map (i_data(ii), w_c(ii), o_data(ii), w_c(ii+1));
	end generate;
end struct;

