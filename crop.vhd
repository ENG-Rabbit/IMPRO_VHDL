----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:50:59 01/24/2022 
-- Design Name: 
-- Module Name:    crop - Behavioral 
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


entity crop is
port(
		-- INPUT AND OUTPUT 
			tframe : inout frame; -- This frame is used as both input and output.
			
		-- INPUTS
			-- Size
				x1 : in integer range 0 to line_length; --   _______________
				x2 : in integer range 0 to line_length; --y1|_|__________|__|
													 		       --  | |          |  |
				y1 : in integer range 0 to line_number; --  | |          |  |
				y2 : in integer range 0 to line_number; --y2|_|__________|__|
																    --  |_|__________|__|
																    -- 	 x1         x2
			-- Data Validtion
				input_DV : in std_logic; -- Input Data Validation 
			
			-- Clock
				clk : in std_logic;
				
		-- OUTPUT
			output_DV : out std_logic -- Output Data Validation

);
end crop;

architecture Behavioral of crop is

begin
process(clk,input_DV)

-- Variables
variable column : integer range 1 to tframe(1)'length; -- Number of line pixels
variable row    : integer range 1 to tframe'length; -- Number of frame lines
variable temp_DV : std_logic; -- Temporary single-bit DV

begin
if rising_edge(clk) and input_DV = '1' then
	if column < x1 or (x2 > 0 and column > x2) then -- Pixels behind x1 or after x2 are not acceptable.
		tframe(row)(column) <= (0,0,0); 
	elsif row < y1 or (y2 > 0 and row > y2) then -- Pixels higher than x1 or lower than x2 are not acceptable.
		tframe(row)(column) <= (0,0,0);
	end if;
	
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