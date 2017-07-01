----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:32:10 01/13/2016 
-- Design Name: 
-- Module Name:    Reg_Bank_8x4 - Behavioral 
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
--											8x4 Register Bank
-- Register Bank with:
--		- 2 address inputs: 	Font_1, Font_2
--		- 2 data outputs:		Op_1,	Op_2
--		- 1 data input:		DataIn	
--------------------------------------------------------------------------	


entity Reg_Bank_8x4 is
		Port ( Font_1			: in  STD_LOGIC_VECTOR  (2 downto 0);
				 Font_2 			: in  STD_LOGIC_VECTOR  (2 downto 0);
				 Write_Enable  : in  STD_LOGIC;
				 DataIn 		: in  STD_LOGIC_VECTOR  (3 downto 0);
             Op_1		 		: out  STD_LOGIC_VECTOR (3 downto 0);
				 Op_2				: out  STD_LOGIC_VECTOR (3 downto 0);
             CLK 				: in  STD_LOGIC);
end Reg_Bank_8x4;

architecture Behavioral of Reg_Bank_8x4 is
	type reg_bank_type is array(7 downto 0) of std_logic_vector(3 downto 0); -- Bank of 8 registers of 4 bits.
	signal REG_BANK : reg_bank_type := ("0000", "0000", "0000", "0000",		-- R7, R6, R5, R4
													"0000", "0000", "0000", "0000");		-- R3, R2, R1, R0
													
begin
		process(CLK)
		Begin
			if	rising_edge(CLK) then
			-- READ/WRITE synchronous operation
				if Write_Enable = '1' then
					REG_BANK(to_integer(unsigned(Font_2))) <= DataIn; 	 															
				else
				-- Read Only operation
					Op_1 <= REG_BANK(to_integer(unsigned(Font_1))); 	-- OP_1 = RB[Font_1]
					Op_2 <= REG_BANK(to_integer(unsigned(Font_2))); 	-- OP_1 = RB[Font_2]
				end if;
			end if;
		end process;
end Behavioral;

