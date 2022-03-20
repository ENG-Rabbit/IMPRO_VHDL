----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:36:23 01/25/2022 
-- Design Name: 
-- Module Name:    mirror - Behavioral 
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


entity mirror is
port(
		-- INPUT AND OUTPUT 
			tframe : inout frame; -- This frame is used as both input and output.
			
		-- INPUTS
			-- AXIS
				axis : in std_logic; -- The axis according to which the frame is symmetrical. Active means X axis.
				
			-- Data Validtion
				input_DV : in std_logic; -- Input Data Validation
			
			-- Clock
				clk : in std_logic;
				
		-- OUTPUT
			output_DV : out std_logic -- Output Data Validation

);
end mirror;

architecture Behavioral of mirror is

begin
process(clk,input_DV)

-- Variables
variable column : integer range 1 to tframe(1)'length; -- Number of line pixels
variable row    : integer range 1 to tframe'length; -- Number of frame lines
variable temp_DV : std_logic; -- Temporary single-bit DV

begin
if rising_edge(clk) and input_DV = '1' then
	if axis = '1' then -- X axis
		if column + 1 <= (tframe(1)'length)/2 then 
			tframe(row)(tframe(1)'length-column+1) <= tframe(row)(column); -- Pixel places the left axis on the right.
		end if;
	else -- Y axis
		if row + 1 <= (tframe'length)/2 then 
			tframe(tframe(1)'length - row + 1)(column) <= tframe(row)(column); -- Pixel places the bottom axis on top of the top axis.
		end if;
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