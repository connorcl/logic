-----------------------------------------------------------------------
-- A 1-to-4 demultiplexor with a configurable (generic) bus width
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- 4-way dmux entity
entity dmux1to4 is
	-- generic parameter for bus width
	generic (g_BUS_WIDTH: integer := 8);
	-- 1 input, 2 select bits and 4 outputs
	port (
		i_data: in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		i_sel: in std_logic_vector(1 downto 0);
		o_data0, o_data1, o_data2, o_data3:
			out std_logic_vector(g_BUS_WIDTH-1 downto 0)
	);
end dmux1to4;

-- 4-way dmux architecture
architecture struct of dmux1to4 is
	-- internal signal declarations
	signal w_dmux0, w_dmux1: std_logic_vector(g_BUS_WIDTH-1 downto 0);
begin
	-- one 1-to-2 dmux to choose between output 0-1 or 2-3
	-- using the most significant select bit
	E_D0: entity work.dmux1to2(behav1)
		  generic map (g_BUS_WIDTH)
		  port map (i_data, i_sel(1), w_dmux0, w_dmux1);
	-- one 1-to-2 dmux to choose between output 0 and 1
	-- using the least significant select bit
	E_D1: entity work.dmux1to2(behav1)
		  generic map (g_BUS_WIDTH)
		  port map (w_dmux0, i_sel(0), o_data0, o_data1);
	-- one 1-to-2 dmux to choose between output 2 and 3
	-- using the least significant select bit
	E_D2: entity work.dmux1to2(behav1)
		  generic map (g_BUS_WIDTH)
		  port map (w_dmux1, i_sel(0), o_data2, o_data3);
end struct;
