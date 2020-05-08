----------------------------------------------------------------------
-- A carry look-ahead incrementor with a configurable bus width
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- incrementor entity
entity inc_cla is
	-- generic parameter for bus width
	generic (g_BUS_WIDTH: positive);
	-- one input and one output
	port (i_data: in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		  o_data: out std_logic_vector(g_BUS_WIDTH-1 downto 0));
end inc_cla;

-- incrementor architecture
architecture struct of inc_cla is
begin
	-- instantiate a single incrementor carry look-ahead block
	-- and pass it an input carry of 1
	E_INC: entity work.inc_cla_block(struct)
		   generic map (g_BUS_WIDTH)
		   port map (i_data, '1', o_data);
end struct;
