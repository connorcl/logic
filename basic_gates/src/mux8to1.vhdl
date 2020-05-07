-----------------------------------------------------------------------
-- An 8-to-1 multiplexor with a configurable (generic) bus width
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- 8-way mux entity
entity mux8to1 is
	-- generic parameter for bus width
	generic (g_BUS_WIDTH: integer := 8);
	-- 8 inputs, 3 select bits and 1 output
	port (
		i_data0, i_data1, i_data2, i_data3,
		i_data4, i_data5, i_data6, i_data7: 
			in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		i_sel: in std_logic_vector(2 downto 0);
		o_data: out std_logic_vector(g_BUS_WIDTH-1 downto 0)
	);
end mux8to1;

-- 8-way mux structural architecture
architecture struct of mux8to1 is
	-- internal signal declarations
	signal w_mux0, w_mux1: std_logic_vector(g_BUS_WIDTH-1 downto 0);
begin
	-- one 4-way mux uses 2 least significant select bits
	-- to choose between inputs 0-3
	E_M0: entity work.mux4to1(behav1)
	 	  generic map (g_BUS_WIDTH)
		  port map (i_data0, i_data1, i_data2, i_data3, 
		  			i_sel(1 downto 0), w_mux0);
	-- one 4-way mux uses 2 least significant select bits
	-- to choose between inputs 4-7
	E_M1: entity work.mux4to1(behav1)
	 	  generic map (g_BUS_WIDTH)
		  port map (i_data4, i_data5, i_data6, i_data7, 
		  			i_sel(1 downto 0), w_mux1);
	-- one 2-way mux uses most significant select bit
	-- to choose between intermediate results
	E_M2: entity work.mux2to1(behav1)
	 	  generic map (g_BUS_WIDTH)
		  port map (w_mux0, w_mux1, i_sel(2), o_data);
end struct;
