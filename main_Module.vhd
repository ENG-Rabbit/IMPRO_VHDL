----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:52:27 01/20/2022 
-- Design Name: 
-- Module Name:    main_Module - Stractrual 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.image_types.all; -- Use pre-made types in this project


entity main_Module is
port(
	-- INPUTS
		-- COLORs
		input_red   : in std_logic_vector(7 downto 0);
		input_green : in std_logic_vector(7 downto 0);
		input_blue  : in std_logic_vector(7 downto 0);
		
		-- Control Bits
		EOL : in std_logic; -- End Of Line
		EOF : in std_logic; -- End Of Frame
		DV  : in std_logic; -- Data Validation
		
		-- CLOCK
		clk : in std_logic;
		
		
	-- OUTPUTs
		-- COLORs
		output_red   : out std_logic_vector(7 downto 0);
		output_green : out std_logic_vector(7 downto 0);
		output_blue  : out std_logic_vector(7 downto 0);
		
		-- Control Bits
		output_EOL : out std_logic; -- End Of Line
		output_EOF : out std_logic; -- End Of Frame
		output_DV  : out std_logic  -- Data Validation
);
end main_Module;

architecture Structural of main_Module is

-- Components
component build_frame
	port( 
	-- INPUTS
		-- COLORs
		input_red   : in std_logic_vector(7 downto 0);
		input_green : in std_logic_vector(7 downto 0);
		input_blue  : in std_logic_vector(7 downto 0);
		
		-- Control Bits
		EOL : in std_logic;
		EOF : in std_logic;
		DV  : in std_logic;
		
		-- CLOCK
		clk : in std_logic;
		
		-- OUTPUTs
			-- COLORs
			output_frame : out frame;
			output_DV : out std_logic
		);
end component;
component pixle_maker
	port(
	-- INPUTS
		input_frame : in frame;
	
		-- Clock
			clk         : in std_logic;

	-- OUTPUTS
		output_red   : out std_logic_vector(7 downto 0);
		output_green : out std_logic_vector(7 downto 0);
		output_blue  : out std_logic_vector(7 downto 0);
	
		EOL          : out std_logic;
		EOF          : out std_logic;
		DV           : out std_logic
	);
end component;
component contrast
	port(
	-- INPUT and OUTPUT
		tframe : inout frame;
		
	-- INPUTS
		sel : in std_logic_vector(1 downto 0);
		input_DV : in std_logic;
		value : in integer range 0 to 255;
		minmax : in std_logic; -- '1' max and '0' min
		clk : in std_logic;
		
	-- OUTPUTS
		output_DV : out std_logic
	);
end component;
component crop
	port(
		-- INPUT AND OUTPUT 
			tframe : inout frame;
			
		-- INPUTS
			-- Size
				x1 : in integer range 0 to line_length;
				x2 : in integer range 0 to line_length;
			
				y1 : in integer range 0 to line_number;
				y2 : in integer range 0 to line_number;
				
			-- Data Validtion
				input_DV : in std_logic;
			
			-- Clock
				clk : in std_logic;
				
		-- OUTPUT
			output_DV : out std_logic
	);
end component;
component mirror
	port(
		-- INPUT AND OUTPUT 
			tframe : inout frame;
			
		-- INPUTS
			-- AXIS
				axis : in std_logic;
				
			-- Data Validtion
				input_DV : in std_logic;
			
			-- Clock
				clk : in std_logic;
				
		-- OUTPUT
			output_DV : out std_logic
	);
end component;
component add_color
port(
	-- INPUT and OUTPUT
		tframe : inout frame;
		
	-- INPUTS
		color : in std_logic_vector(2 downto 0);
		value : in integer range 0 to 255;
		sub : in std_logic;
	-- Date Validation
	input_DV : in std_logic;
	
	-- Clock
	clk : in std_logic;
	
	-- OUTPUT
	output_DV : out std_logic
);
end component;
component combine
port(
	-- INPUT and OUTPUT 
		tframe : inout frame;
		
	-- INPUTs
		sframe : in frame;
		
		-- Date Validation
			input_DV : in std_logic;
		
		-- Clock
			clk : in std_logic;
	
	-- OUTPUT
		output_DV : out std_logic
);
end component;

-- Signals
signal DV1, DV2, DV3, DV4, DV5, DV6 : std_logic; -- 5 signals to check the validity of the outputs
signal entry_frame, temp_frame : frame; -- 2 temporary frames 

begin

c1: build_frame port map(input_red => input_red, input_green => input_green, input_blue => input_blue, EOL => EOL, EOF => EOF, DV => DV, clk => clk,output_frame=>entry_frame,output_DV=>DV1);
temp_frame <= entry_frame;
c2: mirror      port map(tframe => entry_frame, axis => '1', input_DV => DV, clk => clk, output_DV => DV2);
c3: contrast    port map(tframe => temp_frame, sel => "01", input_DV => DV1, value => 200, minmax => '1', clk => clk, output_DV => DV3);
c4: add_color   port map(tframe => entry_frame, color => "101", sub=>'0', value => 10 , input_DV => DV2,  clk => clk, output_DV => DV6);
c5: combine     port map(tframe => entry_frame, sframe => temp_frame, input_DV => DV6 and DV3,  clk => clk, output_DV => DV4);
c6: crop        port map(tframe => entry_frame, x1 => 2, x2=> 18, y1 => 2, y2 => 8, input_DV => DV4,  clk => clk, output_DV => DV5);
c7: pixle_maker port map(input_frame => entry_frame, clk => clk, output_red => output_red, output_green => output_green, output_blue => output_blue, EOL => output_EOL, EOF => output_EOF, DV => output_DV);

end Structural;

