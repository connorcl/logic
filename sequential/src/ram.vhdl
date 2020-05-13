-----------------------------------------------------
-- A single-port RAM chip
-----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ram chip entity
entity ram is
	-- generic parameters
	generic (
		g_ADDR_WIDTH: positive; 
		g_SIZE: positive;
		g_DATA_WIDTH: positive
	);
	-- pins
	port (
		i_data: in std_logic_vector(g_DATA_WIDTH-1 downto 0);
		i_addr: in std_logic_vector(g_ADDR_WIDTH-1 downto 0);
		i_we: in std_logic;
		i_clk: in std_logic;
		o_data: out std_logic_vector(g_DATA_WIDTH-1 downto 0)
	);
end ram;

-- ram chip architecture
architecture behav of ram is
	-- type and signal for ram array
	type ram_type is array (0 to g_SIZE-1) of std_logic_vector(g_DATA_WIDTH-1 downto 0);
	signal ram_arr: ram_type;
	-- read address which is updated every rising clock edge
	signal r_read_address: std_logic_vector(g_ADDR_WIDTH-1 downto 0);
begin
	-- clocked process
	p_RAM: process (i_clk) is
	begin
		if rising_edge(i_clk) then
			-- check address is valid for size
			if to_integer(unsigned(i_addr)) < g_SIZE then
				if i_we = '1' then
					ram_arr(to_integer(unsigned(i_addr))) <= i_data;
				end if;
				r_read_address <= i_addr;
			end if;
		end if;
	end process;
	-- output is set with registered read address
	o_data <= ram_arr(to_integer(unsigned(r_read_address)));
end architecture behav;
			
