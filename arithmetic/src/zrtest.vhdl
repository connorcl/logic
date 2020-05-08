---------------------------------------------------------
-- A simple circuit to test whether an input is 0
---------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- zrtest entity
entity zrtest is
	-- generic bus width
	generic (g_BUS_WIDTH: positive);
	-- an n-bit input and a single output bit
	port (i_data: in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		  o_zr: out std_logic);
end zrtest;

-- zrtest architecture
architecture struct of zrtest is
	-- signal for whether all previous bits were 0
	signal w_prev_zero: std_logic;
begin
	-- recursively calculate whether all but MSB are 0
	G_RECURS_ZR: if g_BUS_WIDTH > 2 generate
		E_ZRTEST: entity work.zrtest(struct)
				  generic map (g_BUS_WIDTH-1)
				  port map (i_data(g_BUS_WIDTH-2 downto 0), w_prev_zero);
	end generate;
	-- base case: with bus size of 2, whether all but MSB are zero
	-- is simply previous bit
	G_BASE_ZR: if g_BUS_WIDTH = 2 generate
		w_prev_zero <= not i_data(0);
	end generate;
	-- if bus size is 1, there is no previous bit to consider
	G_SINGLE_BIT: if g_BUS_WIDTH = 1 generate
		w_prev_zero <= '1';
	end generate;
	-- all bits are zero if MSB is zero and all previous bits are zero
	o_zr <= (not i_data(g_BUS_WIDTH-1)) and w_prev_zero;
end struct;

