----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:31:20 01/24/2022 
-- Design Name: 
-- Module Name:    add_color - Behavioral 
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


entity add_color is
port(
	-- INPUT and OUTPUT
		tframe : inout frame; -- This frame is used as both input and output.
		
	-- INPUTS
		color : in std_logic_vector(2 downto 0); -- Choose which color to check. The most valuable bit is for red, the lowest value is for blue, and the remaining bit is for
		value : in integer range 0 to 255; -- Value to be increased or decreased.
		sub : in std_logic; -- If active, the desired amount of colors will be reduced
		
		-- Data Validation
		input_DV : in std_logic; -- Input Data Validation 
		
		-- Clock
		clk : in std_logic;
	
	-- OUTPUT
	output_DV : out std_logic -- Output Data Validation
);
end add_color;

architecture Behavioral of add_color is

begin
process(clk,input_DV)

-- Variables
variable column : integer range 1 to tframe(1)'length; -- Number of line pixels
variable row    : integer range 1 to tframe'length; -- Number of frame lines
variable temp_DV : std_logic; -- Temporary single-bit DV

begin
if rising_edge(clk) and input_DV = '1' then
	if color(2) = '1' then -- RED
		if sub = '0' then
			if tframe(row)(column)(1) + value >= 255 then -- More than the maximum
				tframe(row)(column)(1) <= 255;
			else
				tframe(row)(column)(1) <= tframe(row)(column)(1) + value; -- RED + value
			end if;
		else
			if tframe(row)(column)(1) - value <= 0 then -- Less than the minimum
				tframe(row)(column)(1) <= 0;
			else
				tframe(row)(column)(1) <= tframe(row)(column)(1) - value; -- RED - value
			end if;
		end if;
	end if;
	
	if color(1) = '1' then -- GREEN
		if sub = '0' then
			if tframe(row)(column)(2) + value >= 255 then -- More than the maximum
				tframe(row)(column)(2) <= 255;
			else
				tframe(row)(column)(2) <= tframe(row)(column)(2) + value; -- GREEN + value
			end if;
		else
			if tframe(row)(column)(2) - value <= 0 then -- Less than the minimum
				tframe(row)(column)(2) <= 0;
			else
				tframe(row)(column)(2) <= tframe(row)(column)(2) - value; -- GREEN - value
			end if;
		end if;
	end if;
	
	if color(0) = '1' then -- BLUE
		if sub = '0' then
			if tframe(row)(column)(3) + value >= 255 then -- More than the maximum
				tframe(row)(column)(3) <= 255;
			else
				tframe(row)(column)(3) <= tframe(row)(column)(3) + value; -- BLUE + value
			end if;
		else
			if tframe(row)(column)(3) - value <= 0 then -- Less than the minimum
				tframe(row)(column)(3) <= 0;
			else
				tframe(row)(column)(3) <= tframe(row)(column)(3) - value; -- BLUE - value
			end if;
		end if;
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