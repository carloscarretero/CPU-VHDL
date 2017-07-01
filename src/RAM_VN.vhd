----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:52:53 01/13/2016 
-- Design Name: 
-- Module Name:    RAM_VN - Behavioral 
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
--											Von Neumann RAM
-- This RAM follows the Von Neumann architecture
-- 	RAM[15-11] 	: 4 bit data
--		RAM[10-0]	: 10 bit instructions
--
--------------------------------------------------------------------------	

entity RAM_VN is
		Port ( DataIn  		: in  STD_LOGIC_VECTOR  (9 downto 0);
				 Write_Enable  : in  STD_LOGIC;
				 Address 		: in  STD_LOGIC_VECTOR  (3 downto 0);
             DataOut 		: out  STD_LOGIC_VECTOR (9 downto 0);
             CLK 				: in  STD_LOGIC);
end RAM_VN;

architecture Behavioral of RAM_VN is
	type ram_type is array(15 downto 0) of std_logic_vector(9 downto 0);	
									--------------------------------------------------------- (Data 4 bits Low)
	signal RAM : ram_type :=("0000000111", "0000000110", "0000000101", "0000000100", "0000000000",-- 15, 14, 13, 12, 11 
									---------------------------------------------------------- (Instruction 10 bits)
														"0100000000", "0100000000", "0100000000", --     10,  9,  8 -----------------
									 "1100110000", "1010001001", "0110000001", "1000001000", --  7,  6,  5,  4 
									 "0001011010", "0011011001", "0100000001", "0001110000");--  3,  2,  1,  0	--------------------
begin

	process(CLK)
	Begin
		if	rising_edge(CLK) then
		-- WRITE/READ syncrhonous operation
			if Write_Enable = '1' then
				RAM(to_integer(unsigned(Address))) <= DataIn; 	
				DataOut <= DataIn; -- The data which is being written is placed in the utput
			else
			-- Only Read operation
				DataOut <= RAM(to_integer(unsigned(Address))); -- Read data on Address
			end if;
		end if;
	end process;
	
end Behavioral;
