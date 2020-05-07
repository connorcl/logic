-------------------------------------------------------------------
-- An inverter with a configurable (generic) bus width
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- inverter entity
entity inverter is
	-- generic parameter for bus width, defaults to 8-bit
	generic (g_BUS_WIDTH: integer := 8);
	-- 1 input port and 1 output port
	port (
		i_data: in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		o_data: out std_logic_vector(g_BUS_WIDTH-1 downto 0)
	);
end inverter;

-- inverter architecture
architecture behav1 of inverter is
begin
	o_data <= not i_data;
end behav1;

-- architecture which explicitly inverts each bit
architecture behav2 of inverter is
begin
	G_INV_FOR: for ii in g_BUS_WIDTH-1 downto 0 generate
		o_data(ii) <= not i_data(ii);
	end generate G_INV_FOR;
end behav2;
