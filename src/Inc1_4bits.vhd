----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:46:31 10/28/2015 
-- Design Name: 
-- Module Name:    Inc1_3bits - Behavioral 
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
--											INC_1
-- We use a 4 bit 1 adder. The range of the adder is [0x0,0xA]
-- 
--------------------------------------------------------------------------	

entity Inc1_4bits is
    Port ( Value : in  STD_LOGIC_VECTOR (3 downto 0);
           Value_Inc : out  STD_LOGIC_VECTOR (3 downto 0)
		 );
end Inc1_4bits;

architecture Behavioral of Inc1_4bits is
begin
	
	-- The value goes from 0x0 to 0xA, and back to 0x0
	with Value select
      Value_Inc <= "0000" when "1010",
						 std_logic_vector(unsigned(Value)+1) when others;

end Behavioral;

