----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:06:17 01/27/2022 
-- Design Name: 
-- Module Name:    pixle_maker - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.all;
use work.image_types.all; -- Use pre-made types in this project

entity pixle_maker is
port(
	-- INPUTS
		input_frame : in frame; -- Input frame
		
		-- Clock
			clk         : in std_logic;

	-- OUTPUTS
		output_red   : out std_logic_vector(7 downto 0);
		output_green : out std_logic_vector(7 downto 0);
		output_blue  : out std_logic_vector(7 downto 0);
	
		EOL          : out std_logic; -- End Of Line
		EOF          : out std_logic; -- End Of Frame
		DV           : out std_logic -- Data Validation
);
end pixle_maker;

architecture Behavioral of pixle_maker is
begin
process(clk)

-- Variables
variable column : integer range 1 to line_length:=1; -- Number of line pixels
variable row : integer range 1 to line_number:=1; -- Number of frame lines
variable temp_red, temp_green, temp_blue : std_logic_vector(7 downto 0) ; -- Temporary red, temporary green and temporary blue
variable temp_EOL, temp_EOF, temp_DV : std_logic; -- Temporary EOL, temporary EOF and temporary DV

begin
if rising_edge(clk) then

	-- Convert pixel colors to 8-bit outputs
	temp_red   := conv_std_logic_vector(input_frame(row)(column)(1),output_red'length);
	temp_green := conv_std_logic_vector(input_frame(row)(column)(2),output_green'length);
	temp_blue  := conv_std_logic_vector(input_frame(row)(column)(3),output_blue'length);
	
	-- Select pixels in row and column, respectively
	temp_DV := '1';
	if column >= line_length then 
		column := 1;
		temp_EOL := '1'; -- END of Line
		if row >= line_number then
			row := 1;
			temp_EOF := '1'; -- END of Frame
		else
			row := row + 1;
			temp_EOF := '0';
			temp_DV := '0';
		end if;
	else
		column := column + 1;
		temp_EOL := '0';
	end if;
end if;
output_red   <= temp_red;
output_green <= temp_green;
output_blue  <= temp_blue;
EOL          <= temp_EOL;
EOF          <= temp_EOF;
DV           <= temp_DV;
end process;

end Behavioral;