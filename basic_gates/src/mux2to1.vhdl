-------------------------------------------------------------------
-- A 2-to-1 multiplexor with a configurable (generic) bus width
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- mux entity
entity mux2to1 is
	-- generic parameter for bus width
	generic (g_BUS_WIDTH: positive);
	-- two input buses, a select bit and an output bus
	port (
		i_data0, i_data1: in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		i_sel: in std_logic;
		o_data: out std_logic_vector(g_BUS_WIDTH-1 downto 0)
	);
end mux2to1;

-- mux architecture
architecture behav1 of mux2to1 is
begin
	-- 0 selects first data input, 1 selects second
	o_data <= i_data0 when i_sel = '0' else i_data1;
end architecture behav1;

-- explicit logical architecture
architecture behav2 of mux2to1 is
	-- signal for expanding select bit to bus width
	signal sel_expanded: std_logic_vector(g_BUS_WIDTH-1 downto 0);
begin
	sel_expanded <= (others => i_sel);
	o_data <= (i_data0 and not sel_expanded) or 
			  (i_data1 and sel_expanded);
end behav2;

