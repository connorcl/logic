----------------------------------------------------------------------
-- A hybrid incrementor which makes use of ripple-carry between
-- carry look-ahead blocks of configurable number and size
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- incrementor entity
entity inc_hybrid is
	-- generic parameters for number and size of carry look-ahead blocks
	generic (g_CLA_BLOCKS: positive; g_CLA_WIDTH: positive);
	-- one input and one output
	port (
		i_data: in std_logic_vector((g_CLA_BLOCKS * g_CLA_WIDTH)-1 downto 0);
		o_data: out std_logic_vector((g_CLA_BLOCKS * g_CLA_WIDTH)-1 downto 0)
	);
end inc_hybrid;

-- incrementor architecture
architecture struct of inc_hybrid is
	-- internal signal for carries
	signal w_c: std_logic_vector(g_CLA_BLOCKS downto 0);
begin
	-- set original carry in to 1
	w_c(0) <= '1';
	-- generate CLA blocks
	G_CLA_INCS: for ii in g_CLA_BLOCKS-1 downto 0 generate
		E_CLA_INC: entity work.inc_cla_block(struct)
				   generic map (g_CLA_WIDTH)
				   port map (
				   	   i_data(((ii+1) * g_CLA_WIDTH)-1 downto (ii * g_CLA_WIDTH)),
				       w_c(ii),
				       o_data(((ii+1) * g_CLA_WIDTH)-1 downto (ii * g_CLA_WIDTH)),
				       w_c(ii+1)
				   );
	end generate;
end struct;

