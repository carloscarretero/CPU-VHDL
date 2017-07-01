----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:45:42 10/21/2015 
-- Design Name: 
-- Module Name:    Mux2_4bits - Behavioral 
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

entity Mux2_4bits is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           Sel : in  STD_LOGIC;
           Z : out  STD_LOGIC_VECTOR (3 downto 0));
end Mux2_4bits;

architecture Behavioral of Mux2_4bits is
begin
	Mux: process(A,B,Sel)
	begin
		if(Sel = '0') then Z <= A;
		elsif (Sel = '1') then Z <= B;
		else Z <= "0000";
		end if;
	end process Mux;
end Behavioral;

