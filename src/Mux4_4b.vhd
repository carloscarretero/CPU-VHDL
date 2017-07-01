----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:24:38 01/13/2016 
-- Design Name: 
-- Module Name:    Mux4_4b - Behavioral 
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

entity Mux4_4b is
		Port ( A 	: in  STD_LOGIC_VECTOR (3 downto 0);
				 B 	: in  STD_LOGIC_VECTOR (3 downto 0);
				 C 	: in  STD_LOGIC_VECTOR (3 downto 0);
				 D 	: in  STD_LOGIC_VECTOR (3 downto 0);
				 Sel 	: in  STD_LOGIC_VECTOR (1 downto 0);
				 Z 	: out  STD_LOGIC_VECTOR (3 downto 0));
end Mux4_4b;

architecture Behavioral of Mux4_4b is
begin
		Mux: process(A,B,C,D,Sel)
			begin
				if(Sel = "00") then 
					Z <= A;
				elsif (Sel = "01") then 
					Z <= B;
				elsif (Sel = "10") then 
					Z <= C;
				elsif (Sel = "11") then 
					Z <= D;
				else 
					Z <= "0000";
			end if;
		end process Mux;
end Behavioral;

