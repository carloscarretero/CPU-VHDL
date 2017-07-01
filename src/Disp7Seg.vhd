----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:49:16 10/21/2015 
-- Design Name: 
-- Module Name:    Disp7Seg - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Disp7Seg is
    Port ( Hex : in  STD_LOGIC_VECTOR (3 downto 0);
           Select_Disp : in  STD_LOGIC_VECTOR (1 downto 0);
           Seg : out  STD_LOGIC_VECTOR (6 downto 0);
           Anode : out  STD_LOGIC_VECTOR (3 downto 0));
end Disp7Seg;

architecture Behavioral of Disp7Seg is
begin
	-- Anode select
	Anode <=  "1110" when Select_Disp = "00" else --disp 0
             "1101" when Select_Disp = "01" else --disp 1
				 "1011" when Select_Disp = "10" else --disp 2
				 "0111" when Select_Disp = "11" else --disp 3
             "0000";
				 
	-- Number display
	Seg <= "0000001" when Hex = "0000" else --0
			"1001111" when Hex = "0001" else --1
			"0010010" when Hex = "0010" else	--2	
			"0000110" when Hex = "0011" else	--3
			"1001100" when Hex = "0100" else	--4
			"0100100" when Hex = "0101" else	--5
			"0100000" when Hex = "0110" else	--6
			"0001111" when Hex = "0111" else	--7
			"0000000" when Hex = "1000" else	--8
			"0000100" when Hex = "1001" else	--9
			"0001000" when Hex = "1010" else	--a
			"1100000" when Hex = "1011" else	--b
			"0110001" when Hex = "1100" else	--c
			"1000010" when Hex = "1101" else	--d
			"0110000" when Hex = "1110" else	--e
			"0111000" when Hex = "1111" else	--f
         "0000000";
end Behavioral;

