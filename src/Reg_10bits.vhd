----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:03:30 11/11/2015 
-- Design Name: 
-- Module Name:    Reg_10bits - Behavioral 
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
--											IR
-- We use a 10 bit register to implements the Instruction Register. It has
-- 3 fields:
--		- Cod_Op 	 (9-7)
--		- Dir/Inm/R1 (6-3)
--		- R2			 (2-0)
--
--------------------------------------------------------------------------	

entity Reg_10bits is
	port(	RESET, CLK, ENABLE : in std_logic;
			DataIn : in std_logic_vector (9 downto 0);
			DataOut: out std_logic_vector (9 downto 0)
			);
end Reg_10bits;

architecture Behavioral of Reg_10bits is
begin

	process (CLK,RESET)
	begin
		if RESET = '1' then
			DataOut <= "0000000000";
		elsif rising_edge(CLK) then
			if ENABLE = '1' then
				DataOut <= DataIn;
			end if;
		end if;
	end process;

end Behavioral;