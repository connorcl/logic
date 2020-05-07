-----------------------------------------------------------------------
-- A 4-to-1 multiplexor with a configurable (generic) bus width
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- 4-way mux entity
entity mux4to1 is
	-- generic parameter for bus width
	generic (g_BUS_WIDTH: integer := 8);
	-- 4 inputs, 2 select bits and 1 output
	port (
		i_data1, i_data2, i_data3, i_data4: 
			in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		i_sel: in std_logic_vector(1 downto 0);
		o_data: out std_logic_vector(g_BUS_WIDTH-1 downto 0)
	);
end mux4to1;

-- 4-way mux structural architecture
architecture struct of mux4to1 is
	-- internal signal declarations
	signal w_mux1, w_mux2: std_logic_vector(g_BUS_WIDTH-1 downto 0);
begin
	-- one 2-way mux uses least significant select bit
	-- to choose between inputs 1 and 2
	E_M0: entity work.mux2to1(behav1)
	 	  generic map (g_BUS_WIDTH)
		  port map (i_data1, i_data2, i_sel(0), w_mux1);
	-- one 2-way mux uses least significant select bit
	-- to choose between inputs 3 and 4
	E_M1: entity work.mux2to1(behav1)
	 	  generic map (g_BUS_WIDTH)
		  port map (i_data3, i_data4, i_sel(0), w_mux2);
	-- one 2-way mux uses most significant select bit
	-- to choose between intermediate results
	E_M2: entity work.mux2to1(behav1)
	 	  generic map (g_BUS_WIDTH)
		  port map (w_mux1, w_mux2, i_sel(1), o_data);
end struct;

-- behavioural/data flow architecture
architecture behav1 of mux4to1 is
begin
	o_data <= i_data1 when i_sel = "00" else
			  i_data2 when i_sel = "01" else
			  i_data3 when i_sel = "10" else
			  i_data4;
end behav1;
