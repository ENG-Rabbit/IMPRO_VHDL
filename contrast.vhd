----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:06:24 01/25/2022 
-- Design Name: 
-- Module Name:    contrast - Behavioral 
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


entity contrast is
port(
	-- INPUT and OUTPUT
		tframe : inout frame; -- This frame is used as both input and output.
		
	-- INPUTS
		sel : in std_logic_vector(1 downto 0); -- Choose which color to check. "00" is used for red, "01" for green, "10" for blue and "11" for all colors
		input_DV : in std_logic; -- Input Data Validation
		value : in integer range 0 to 255; -- The value to which the input should be compared.
		minmax : in std_logic; -- '1' max and '0' min
		
		-- Clock
		clk : in std_logic;
		
	-- OUTPUTS
		output_DV : out std_logic -- Output Data Validation


);
end contrast;

architecture Behavioral of contrast is

begin
process(clk,input_DV)

-- Variables
variable column : integer range 1 to tframe(1)'length; -- Number of line pixels
variable row : integer range 1 to tframe'length; -- Number of frame lines
variable temp_pixle : pixle; -- Temporary pixle
variable temp_DV : std_logic; -- Temporary single-bit DV

begin
if rising_edge(clk) and input_DV = '1' then
	temp_pixle := tframe(row)(column);
	case sel is
		when "00" => -- RED
			if minmax = '1' then -- MAX
				if value < temp_pixle(1) then
					temp_pixle(1) := value; -- The value of red was higher than the value entered and was replaced.
				end if;
			else -- min
				if value > temp_pixle(1) then
					temp_pixle(1) := value; -- The value of red was less than the value entered and was replaced.
				end if;
			end if;
		when "01" => -- GREEN
			if minmax = '1' then -- MAX
				if value < temp_pixle(2) then
					temp_pixle(2) := value; -- The value of green was higher than the value entered and was replaced.
				end if;
			else -- min
				if value > temp_pixle(1) then
					temp_pixle(2) := value; -- The value of green was less than the value entered and was replaced.
				end if;
			end if;
		when "10" => -- BLUE
			if minmax = '1' then -- MAX
				if value < temp_pixle(3) then
					temp_pixle(3) := value; -- The value of blue was higher than the value entered and was replaced.
				end if;
			else -- min
				if value > temp_pixle(1) then
					temp_pixle(3) := value; -- The value of blue was less than the value entered and was replaced.
				end if;
			end if;
		when others => -- RED GRENN BLUE
			if minmax = '1' then -- MAX
				if value < temp_pixle(1) or value < temp_pixle(2) or value < temp_pixle(3) then
					-- The color values were higher than the entered values and were replaced.
					temp_pixle(1) := value; 
					temp_pixle(2) := value;
					temp_pixle(3) := value;
				end if;
			else -- min
				if value > temp_pixle(1) or value > temp_pixle(2) or value > temp_pixle(3) then
					-- The color values were less than the entered values and were replaced.
					temp_pixle(1) := value;
					temp_pixle(2) := value;
					temp_pixle(3) := value;
				end if;
			end if;
		end case;
	tframe(row)(column) <= temp_pixle; -- Pixels are replaced.
	
	-- Select pixels in row and column, respectively
	temp_DV := '0';
	if column >= tframe(row)'length then 
		column := 1;
		if row >= tframe'length then
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