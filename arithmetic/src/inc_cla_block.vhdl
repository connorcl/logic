----------------------------------------------------------------------
-- A carry look-ahead incrementor block with a configurable bus width
-- which will be used either as one block in a hybrid incrementor
-- or the only block in a full carry look-ahead incrementor
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- incrementor block entity
entity inc_cla_block is
	-- generic parameter for bus width
	generic (g_BUS_WIDTH: positive);
	-- one input and one output, plus carry in and out bits
	-- to allow use in hybrid incrementors
	port (i_data: in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		  i_c: in std_logic;
		  o_data: out std_logic_vector(g_BUS_WIDTH-1 downto 0);
		  o_c: out std_logic);
end inc_cla_block;

-- incrementor block architecture
architecture struct of inc_cla_block is
	-- internal signals for carries
	signal w_c: std_logic_vector(g_BUS_WIDTH-1 downto 0);
begin
	-- set input carry
	w_c(0) <= i_c;
	-- generate logic to calculate carry-in bits
	G_CARRY_CALC: for ii in g_BUS_WIDTH-1 downto 1 generate
		E_CC: entity work.carry_calc_inc(struct)
			  generic map (ii)
			  port map (i_c, i_data(ii-1 downto 0), w_c(ii));
	end generate;
	-- generate half-adders for all but most significant bit
	G_HALF_ADDERS: for ii in g_BUS_WIDTH-2 downto 0 generate
		E_HA: entity work.halfadder(behav1)
			  port map (i_data(ii), w_c(ii), o_data(ii));
	end generate;
	-- half adder for most significant bit which writes carry out
	E_HA_MSB: entity work.halfadder(behav1)
		      port map (
		      	  i_data(g_BUS_WIDTH-1), 
		      	  w_c(g_BUS_WIDTH-1),
		      	  o_data(g_BUS_WIDTH-1),
		      	  o_c
		      );
end struct;

