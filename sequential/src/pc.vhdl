---------------------------------
-- A program counter circuit
---------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- program counter entity
entity pc is
	-- generic parameter for bus width
	generic (g_BUS_WIDTH: positive);
	-- an input vector, load, increment and reset bits, 
	-- a clock input and an output vector
	port (
		i_data: in std_logic_vector(g_BUS_WIDTH-1 downto 0);
		i_inc, i_load, i_rst: in std_logic;
		i_clk: in std_logic;
		o_data: out std_logic_vector(g_BUS_WIDTH-1 downto 0)
	);
end pc;

-- program counter architecture
architecture struct of pc is
	-- internal signals
	signal w_null: std_logic_vector(g_BUS_WIDTH-1 downto 0);
	signal w_next_data: std_logic_vector(g_BUS_WIDTH-1 downto 0);
	signal w_reg_o_data: std_logic_vector(g_BUS_WIDTH-1 downto 0);
	signal w_reg_inc: std_logic_vector(g_BUS_WIDTH-1 downto 0);
	signal w_mux_inc: std_logic_vector(g_BUS_WIDTH-1 downto 0);
	signal w_mux_load: std_logic_vector(g_BUS_WIDTH-1 downto 0);
begin
	-- null signal of bus size
	w_null <= (others => '0');
	-- register to store program counter value, write enable is always set
	E_REG: entity work.reg(behav)
		   generic map (g_BUS_WIDTH)
		   port map (
		       i_data => w_next_data,
		       i_we => '1',
		       i_clk => i_clk,
		       o_data => w_reg_o_data
		   );
	-- output register output
	o_data <= w_reg_o_data;
	-- incrementor to increment register value
	E_INC: entity work.inc_cla(struct)
		   generic map (g_BUS_WIDTH)
		   port map (
		       i_data => w_reg_o_data,
		       o_data => w_reg_inc
		   );
	-- multiplexor to choose between current and incremented value
	E_MUX_INC: entity work.mux2to1(behav1)
			   generic map (g_BUS_WIDTH)
			   port map (
			       i_data0 => w_reg_o_data,
			       i_data1 => w_reg_inc,
			       i_sel => i_inc,
			       o_data => w_mux_inc
			   );
	-- multiplexor to choose whether to load value
	E_MUX_LOAD: entity work.mux2to1(behav1)
			    generic map (g_BUS_WIDTH)
			    port map (
			        i_data0 => w_mux_inc,
			        i_data1 => i_data,
			        i_sel => i_load,
			        o_data => w_mux_load
			    );
	-- multiplexor to choose whether to reset value
	E_MUX_RST: entity work.mux2to1(behav1)
			   generic map (g_BUS_WIDTH)
			   port map (
			       i_data0 => w_mux_load,
			       i_data1 => w_null,
			       i_sel => i_rst,
			       o_data => w_next_data
			   );
end struct;

