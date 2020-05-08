----------------------------------------------------------------------
-- A simple ALU, with the same interface as the nand2tetris.org ALU,
-- except for a configurable bus width
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- ALU entity
entity alu is
	-- generic parameter for bus width
	generic (g_BUS_WIDTH: positive);
	-- 2 input vectors, 6 control bits, 1 output vector and 2 status bits
	port (
		i_x, i_y: in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		i_zx, i_nx, i_zy, i_ny, i_f, i_no: in std_logic;
		o_data: out std_logic_vector(g_BUS_WIDTH-1 downto 0);
		o_zr, o_ng: out std_logic
	);
end alu;

-- ALU architecture
architecture struct of alu is
	-- 'null' signal of bus size
	signal w_null: std_logic_vector(g_BUS_WIDTH-1 downto 0);
	-- possibly zeroed x
	signal w_x_zx: std_logic_vector(g_BUS_WIDTH-1 downto 0);
	-- inverted possibly zeroed x
	signal w_x_zx_inv: std_logic_vector(g_BUS_WIDTH-1 downto 0);
	-- possibly zeroed and then possibly inverted x
	signal w_x_zx_nx: std_logic_vector(g_BUS_WIDTH-1 downto 0);
	-- possibly zeroed y
	signal w_y_zy: std_logic_vector(g_BUS_WIDTH-1 downto 0);
	-- inverted possibly zeroed y
	signal w_y_zy_inv: std_logic_vector(g_BUS_WIDTH-1 downto 0);
	-- possibly zeroed and then possibly inverted y
	signal w_y_zy_ny: std_logic_vector(g_BUS_WIDTH-1 downto 0);
	-- x and y (after zero/inv)
	signal w_x_and_y: std_logic_vector(g_BUS_WIDTH-1 downto 0);
	-- x plus y (after zero/inv)
	signal w_x_plus_y: std_logic_vector(g_BUS_WIDTH-1 downto 0);
	-- output of chosen function
	signal w_x_y_f: std_logic_vector(g_BUS_WIDTH-1 downto 0);
	-- inverted output
	signal w_o_inv: std_logic_vector(g_BUS_WIDTH-1 downto 0);
	-- possibly inverted output
	signal w_o_no: std_logic_vector(g_BUS_WIDTH-1 downto 0);
begin
	-- send zeroes to 'null' signal
	w_null <= (others => '0');
	-- multiplexor which uses zx to choose whether to zero x
	E_ZXMUX: entity work.mux2to1(behav1)
			 generic map (g_BUS_WIDTH)
			 port map (i_x, w_null, i_zx, w_x_zx);
	-- multiplexor which uses nx to choose whether to invert x
	w_x_zx_inv <= not w_x_zx;
	E_NXMUX: entity work.mux2to1(behav1)
			 generic map (g_BUS_WIDTH)
			 port map (w_x_zx, w_x_zx_inv, i_nx, w_x_zx_nx);
	-- multiplexor which uses zy to choose whether to zero y
	E_ZYMUX: entity work.mux2to1(behav1)
			 generic map (g_BUS_WIDTH)
			 port map (i_y, w_null, i_zy, w_y_zy);
	-- multiplexor which uses ny to choose whether to invert y
	w_y_zy_inv <= not w_y_zy;
	E_NYMUX: entity work.mux2to1(behav1)
			 generic map (g_BUS_WIDTH)
			 port map (w_y_zy, w_y_zy_inv, i_ny, w_y_zy_ny);
	-- x and y
	w_x_and_y <= w_x_zx_nx and w_y_zy_ny;
	-- x plus y with carry look-ahead adder
	E_ADDER: entity work.adder_cla(struct)
			 generic map (g_BUS_WIDTH)
			 port map (w_x_zx_nx, w_y_zy_ny, '0', w_x_plus_y);
	-- multiplexor to choose between AND and ADD
	E_FMUX: entity work.mux2to1(behav1)
			generic map (g_BUS_WIDTH)
			port map (w_x_and_y, w_x_plus_y, i_f, w_x_y_f);
	-- multiplexor to choose whether to invert output
	w_o_inv <= not w_x_y_f;
	E_NOMUX: entity work.mux2to1(behav1)
			 generic map (g_BUS_WIDTH)
			 port map (w_x_y_f, w_o_inv, i_no, w_o_no);
	-- write output
	o_data <= w_o_no;
	-- set zr if output is all zeroes
	E_ZRTEST: entity work.zrtest(struct)
			  generic map (g_BUS_WIDTH)
			  port map (w_o_no, o_zr);
	-- set ng if MSB is 1 (2's complement assumed)
	o_ng <= w_o_no(g_BUS_WIDTH-1);
end struct;

