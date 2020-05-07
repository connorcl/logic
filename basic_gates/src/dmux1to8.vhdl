-----------------------------------------------------------------------
-- A 1-to-8 demultiplexor with a configurable (generic) bus width
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- 8-way dmux entity
entity dmux1to8 is
	-- generic parameter for bus width
	generic (g_BUS_WIDTH: integer := 8);
	-- 1 input, 3 select bits and 8 outputs
	port (
		i_data: in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		i_sel: in std_logic_vector(2 downto 0);
		o_data0, o_data1, o_data2, o_data3,
		o_data4, o_data5, o_data6, o_data7:
			out std_logic_vector(g_BUS_WIDTH-1 downto 0)
	);
end dmux1to8;

-- 8-way dmux architecture
architecture struct of dmux1to8 is
	-- internal signal declarations
	signal w_dmux0, w_dmux1: std_logic_vector(g_BUS_WIDTH-1 downto 0);
begin
	-- one 1-to-2 dmux to choose between outputs 0-3 or 4-7
	-- using the most significant select bit
	E_D0: entity work.dmux1to2(behav1)
		  generic map (g_BUS_WIDTH)
		  port map (i_data, i_sel(2), w_dmux0, w_dmux1);
	-- one 1-to-4 dmux to choose between outputs 0-3
	-- using the 2 least significant select bits
	E_D1: entity work.dmux1to4(struct)
		  generic map (g_BUS_WIDTH)
		  port map (w_dmux0, i_sel(1 downto 0),
		  			o_data0, o_data1, o_data2, o_data3);
	-- one 1-to-4 dmux to choose between outputs 4-7
	-- using the 2 least significant select bits
	E_D2: entity work.dmux1to4(struct)
		  generic map (g_BUS_WIDTH)
		  port map (w_dmux1, i_sel(1 downto 0),
		  			o_data4, o_data5, o_data6, o_data7);
end struct;
