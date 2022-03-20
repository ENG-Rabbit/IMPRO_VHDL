----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:49:07 01/20/2022 
-- Design Name: 
-- Module Name:    build_frame - Behavioral 
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
use ieee.std_logic_arith.all;
use work.image_types.all; -- Use pre-made types in this project

entity build_frame is
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
		output_frame : out frame;
		
		-- Control Bits
		output_DV  : out std_logic
);

end build_frame;

architecture Behavioral of build_frame is

begin
process(clk,EOL,EOF,DV)

-- Variables
variable column : integer range 1 to line_length:=1; -- Number of line pixels
variable row : integer range 1 to line_number:=1; -- Number of frame lines
variable temp_frame : frame; -- Temporary frames of the frame type
variable temp_DV  : std_logic; -- Temporary single-bit DV
	
begin
if rising_edge(clk) then 

	temp_DV := '0'; -- Invalid data.
	
	if DV = '1' then -- Is the input data valid?
	
	   -- Convert 8-bit inputs to integers and insert inside temporary frame pixels
		temp_frame(row)(column)(1) := CONV_INTEGER(unsigned(input_red)); -- RED
		temp_frame(row)(column)(2) := CONV_INTEGER(unsigned(input_green)); -- GREEN
		temp_frame(row)(column)(3) := CONV_INTEGER(unsigned(input_blue)); -- BLUE
		
		-- Select pixels in row and column, respectively
		column := column + 1;
		
		if rising_edge(EOL) then -- EOL indicates the end of the line.
			column := 1; -- first column
			row := row + 1; -- next line
		end if;
		if rising_edge(EOF) then -- EOF indicates the end of the Frame.
			row := 1; -- first line
			temp_DV := '1'; -- The data is valid. 
		end if;
	else
		column := 1; -- first column
		row := 1; -- first line
	end if;
	
end if;
output_frame <= temp_frame; -- After completing the temporary frame is placed at the output.

output_DV <= temp_DV; -- After completing the temporary frame, this output is activated in order for the information to be valid.

end process;

end Behavioral;