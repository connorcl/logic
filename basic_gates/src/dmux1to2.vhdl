-----------------------------------------------------------------------
-- A 1-to-2 demultiplexor with a configurable (generic) bus width
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- dmux entity
entity dmux1to2 is
	-- generic parameter for bus width
	generic (g_BUS_WIDTH: integer := 8);
	-- 1 input, a select bit and 2 outputs
	port (
		i_data: in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		i_sel: in std_logic;
		o_data1, o_data2: out std_logic_vector(g_BUS_WIDTH-1 downto 0)
	);
end dmux1to2;

-- dmux architecture
architecture behav1 of dmux1to2 is
begin
	o_data1 <= i_data when i_sel = '0' else (others => '0');
	o_data2 <= i_data when i_sel = '1' else (others => '0');
end behav1;
