----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:00:45 11/04/2015 
-- Design Name: 
-- Module Name:    FFD - Behavioral 
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

entity FFD is
    Port ( D : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           ENABLE : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           Q : out  STD_LOGIC);
end FFD;

architecture Behavioral of FFD is
begin
	process (CLK,RESET)
	begin
		if RESET = '1' then
			Q <= '0';
		elsif rising_edge(CLK) then
			if ENABLE = '1' then
				Q <= D;
			end if;
		end if;
	end process;


end Behavioral;

