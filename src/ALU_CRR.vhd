----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:38:39 01/13/2016 
-- Design Name: 
-- Module Name:    ALU_CRR - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--------------------------------------------------------------------------
--												ALU 
-- It has 6 operations 
--		- 	000 -> Pass A
-- 	- 	001 -> Pass A
--		- 	010 -> A + B
--		- 	011 -> A - B
--		- 	100 -> A + Inm
--		- 	101 -> A - Inm
--
--------------------------------------------------------------------------

entity ALU_CRR is
		Port ( A 		: in  STD_LOGIC_VECTOR (3 downto 0);
				 B 		: in  STD_LOGIC_VECTOR (3 downto 0);
				 OP		: in  STD_LOGIC_VECTOR (2 downto 0);
             Res	 	: out  STD_LOGIC_VECTOR (3 downto 0);
             FZ 		: out  STD_LOGIC);
end ALU_CRR;

architecture Behavioral of ALU_CRR is

		signal result : std_logic_vector (3 downto 0);
	
begin

		with OP select				-- SELECT OPERATION
				result <= 
				A		 	when "000",			-- LD - A clean pass
				A		 	when "001", 		-- ST - A clean pass
				std_logic_vector(unsigned(A)+unsigned(B)) when "010",	-- ADD A+B
				std_logic_vector(unsigned(A)-unsigned(B)) when "011",	-- SUB A-B
				std_logic_vector(unsigned(A)+unsigned(B)) when "100",	-- INC A+B
				std_logic_vector(unsigned(A)-unsigned(B)) when "101",	-- DEC A-B
				"----" 	when others;
				
		with result select	-- Zero Flag
				FZ <= 
				'1' when "0000",	
				'0' when others;
				
		Res <= result;
		
end Behavioral;

