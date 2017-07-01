----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:36:55 11/18/2015 
-- Design Name: 
-- Module Name:    CLK_1Hz - Behavioral 
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

entity Timer300ms is
    Port ( CLK 			: in  STD_LOGIC;
           Reset 			: in  STD_LOGIC;
			  EnableTimer	: in STD_LOGIC;
           End300ms		: out  STD_LOGIC);
end Timer300ms;

architecture Behavioral of Timer300ms is 
		constant EndCount: integer := 15000000; -- Número de ciclos de CLK a contar. 
		signal Count: integer range 0 to EndCount; -- Subrango para contar de 0 a 50 mill.
		signal makeCount: std_logic;
begin 
		process (CLK, RESET) 
		begin 
			--------------------------------------------------- 
			-- RESET pone a 0 el contador y la señal de salida 
			--------------------------------------------------- 
			if RESET = '1' then 
				Count <= 0; 
				End300ms <= '0';
			-------------------------------------------------------------- 
			-- Mantiene a 0 la salida hasta que transcurren 15.000 ciclos 
			-- entonces asigna '1' a la salida durante un ciclo de CLK 
			-------------------------------------------------------------- 
			elsif rising_edge(CLK) then 
			
				if EnableTimer = '1' then
					makeCount <= '1';	-- Activamos el contador
				end if;
				
				if makeCount = '1' then
					if Count = EndCount-1 then -- Si ya ha contado 15.000 ciclos de CLK 
							Count <= 0; 			-- Pone el contador a 0 
							End300ms <= '1';		-- Manda un '1' durante un ciclo de CLK 
							makeCount <= '0';		-- Para el contador
					else 
							Count <= Count+1; -- Si no ha llegado al final de la cuenta 
													 -- incrementa la cuenta de ciclos 
							End300ms <= '0'; 	 -- Mantiene la salida a '0', no hay pulso. 
					end if;
				else 
					End300ms <= '0'; -- Cuando paramos el contador, en el siguiente ciclo(20ns)
				end if;
				
			end if;
		end process; 
end Behavioral;
