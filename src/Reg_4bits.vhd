----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:39:35 11/11/2015 
-- Design Name: 
-- Module Name:    Reg_4bits - Behavioral 
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

--------------------------------------------------------------------------
--											PC
-- We use a 4 bit register to implement the Program Counter of our CompRegReg
-- architecture
-- 
--------------------------------------------------------------------------	

entity Reg_4bits is
	port(	RESET, CLK, ENABLE : in std_logic;
			DataIn : in std_logic_vector (3 downto 0);
			DataOut: out std_logic_vector (3 downto 0)
			);
end Reg_4bits;

architecture Behavioral of Reg_4bits is
begin

	process (CLK,RESET)
	begin
		if RESET = '1' then
			DataOut <= "0000";
		elsif rising_edge(CLK) then
			if ENABLE = '1' then
				DataOut <= DataIn;
			end if;
		end if;
	end process;

end Behavioral;