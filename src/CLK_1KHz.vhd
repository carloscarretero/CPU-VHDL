----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:09:29 11/18/2015 
-- Design Name: 
-- Module Name:    CLK_1KHz - Behavioral 
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

entity CLK_1KHz is
		Port ( CLK : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Out_1KHz : out  STD_LOGIC);
end CLK_1KHz;

architecture Behavioral of Clk_1KHz is 
		constant EndCount: integer := 50000; -- Número de ciclos de CLK a contar. 
		signal Count: integer range 0 to EndCount; -- Subrango para contar de 0 a 50 mill. 
begin 
		process (CLK, RESET) 
		begin 
			--------------------------------------------------- 
			-- RESET pone a 0 el contador y la señal de salida 
			--------------------------------------------------- 
			if RESET='1' then 
				Count <= 0; 
				Out_1KHz <='0';
			-------------------------------------------------------------- 
			-- Mantiene a 0 la salida hasta que transcurren 5000000 ciclos 
			-- entonces asigna '1' a la salida durante un ciclo de CLK 
			-------------------------------------------------------------- 
			elsif rising_edge(CLK) then 
				if Count = EndCount -1 then -- Si ya ha contado 50.000.000 ciclos de CLK 
						Count <= 0; 	-- Pone el contador a 0 
						Out_1KHz <='1'; -- Manda un '1' durante un ciclo de CLK 
				else 
						Count <=Count +1; -- Si no ha llegado al final de la cuenta 
												-- incrementa la cuenta de ciclos 
						Out_1KHz <='0'; 	-- Mantiene la salida a '0', no hay pulso. 
				end if; 
			end if; 
		end process; 
end Behavioral;