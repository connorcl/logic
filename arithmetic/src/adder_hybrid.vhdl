-----------------------------------------------------------------
-- A hybrid adder which makes use of ripple carry between 
-- carry look-ahead blocks of configurable number and width
-----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- adder entity
entity adder_hybrid is
	-- generic parameters for number and width of carry look-ahead blocks
	generic (g_CLA_BLOCKS: positive;
			 g_CLA_WIDTH: positive);
	-- two input vectors and an output vector
	port (i_a, i_b: in std_logic_vector((g_CLA_BLOCKS * g_CLA_WIDTH)-1 downto 0);
		  o_s: out std_logic_vector((g_CLA_BLOCKS * g_CLA_WIDTH)-1 downto 0));
end adder_hybrid;

-- adder architecture
architecture struct of adder_hybrid is
	-- internal carry vector
	signal w_c: std_logic_vector(g_CLA_BLOCKS downto 0);
begin
	-- set input carry
	w_c(0) <= '0';
	-- generate carry look-ahead adder blocks
	G_CLA_ADDERS: for ii in g_CLA_BLOCKS-1 downto 0 generate
		E_CLA_ADDER: entity work.adder_cla(struct)
					 generic map (g_CLA_WIDTH)
					 port map (
					 	i_a(((ii+1) * g_CLA_WIDTH)-1 downto (ii * g_CLA_WIDTH)),
					 	i_b(((ii+1) * g_CLA_WIDTH)-1 downto (ii * g_CLA_WIDTH)),
					 	w_c(ii),
					 	o_s(((ii+1) * g_CLA_WIDTH)-1 downto (ii * g_CLA_WIDTH)),
					 	w_c(ii+1)
					 );
	end generate;
end struct;
