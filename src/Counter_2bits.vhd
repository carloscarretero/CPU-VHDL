----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:38:01 11/11/2015 
-- Design Name: 
-- Module Name:    Counter_2bits - Behavioral 
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

entity Counter_2bits is 
	Port ( CLK : in STD_LOGIC; 
			 Reset : in STD_LOGIC; 
			 Enable : in STD_LOGIC; 
			 Q : out STD_LOGIC_VECTOR (1 downto 0)); 
end Counter_2bits; 

architecture Behavioral of Counter_2bits is 	
	signal CUENTA: unsigned (1 downto 0); -- Señal donde se acumula la cuenta 
begin 
	
	process (CLK, Reset) 
	begin 
		if Reset = '1' then -- reset asíncrono 
			CUENTA <= "00"; 
		elsif rising_edge(CLK) then 
			if Enable = '1' then 
				CUENTA <= CUENTA + 1; 
			end if; 
		end if; 
	end process; 
	
	Q <= std_logic_vector(CUENTA); 	-- asignación al puerto de salida el 
												-- valor de la señal CUENTA. Conversión. 
end Behavioral;

