----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:45:18 01/24/2022 
-- Design Name: 
-- Module Name:    combine - Behavioral 
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

entity combine is
port(
	-- INPUT and OUTPUT 
		tframe : inout frame; -- This frame is used as both input and output.
		
	-- INPUTs
		sframe : in frame; -- The second frame
		
		-- Date Validation
			input_DV : in std_logic; -- Input Data Validation 
		
		-- Clock
			clk : in std_logic;
	
	-- OUTPUT
		output_DV : out std_logic -- Output Data Validation
);
end combine;

architecture Behavioral of combine is

begin
process(clk,input_DV)

-- Variables
variable column : integer range 1 to tframe(1)'length; -- Number of line pixels
variable row    : integer range 1 to tframe'length; -- Number of frame lines
variable temp_DV : std_logic; -- Temporary single-bit DV

begin
if rising_edge(clk) and input_DV = '1' then
	-- RED
	if tframe(row)(column)(1) + sframe(row)(column)(1) > 510 then  -- More than the maximum
		tframe(row)(column)(1) <= 255;
	else
		tframe(row)(column)(1) <= (tframe(row)(column)(1) + sframe(row)(column)(1))/2; -- The average color of two pixels
	end if;
	-- GREEN
	if tframe(row)(column)(2) + sframe(row)(column)(2) > 510 then  -- More than the maximum
		tframe(row)(column)(2) <= 255;
	else
		tframe(row)(column)(2) <= (tframe(row)(column)(2) + sframe(row)(column)(2))/2; -- The average color of two pixels
	end if;
	-- BLUE
	if tframe(row)(column)(3) + sframe(row)(column)(3) > 510 then  -- More than the maximum
		tframe(row)(column)(3) <= 255;
	else
		tframe(row)(column)(3) <= (tframe(row)(column)(3) + sframe(row)(column)(3))/2; -- The average color of two pixels
	end if;
	
	-- Select pixels in row and column, respectively
	temp_DV := '0';
	if column >= line_length then 
		column := 1;
		if row >= line_number then
			row := 1;
			temp_DV := '1';
		else
			row := row + 1;
		end if;
	else
		column := column + 1;
	end if;
	output_DV <= temp_DV;

end if;
end process;
end Behavioral;