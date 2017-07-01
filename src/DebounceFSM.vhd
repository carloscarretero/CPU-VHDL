----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:19:58 12/16/2015 
-- Design Name: 
-- Module Name:    DebounceFSM - Behavioral 
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

entity DebounceFSM is
    Port ( CLK 			: in  STD_LOGIC;
           RESET 			: in  STD_LOGIC;
           Flag_Timer 	: in  STD_LOGIC;
           Push 			: in  STD_LOGIC;
           EnableTimer 	: out  STD_LOGIC;
           FilteredPush : out  STD_LOGIC);
end DebounceFSM;

architecture Behavioral of DebounceFSM is
		type FSM_states is(inic, S0, S01, espera);
		signal Next_State: FSM_states;
begin

	process(CLK,RESET)
	begin
		if RESET='1' then
			Next_State  <= inic;	--INICIO CON RESET
			FilteredPush <= '0';	--Salida
			EnableTimer	 <= '0';	--Salida
		elsif rising_edge(CLK) then
			case Next_State is
			---------------
			-- EStado inic
			---------------
			when inic => -- Analizar entradas
				if Push = '0' then
					Next_State <= S0;
					FilteredPush <= '0';	-- Salida 
					EnableTimer <= '0';	-- Salida
				else
					Next_State <= inic;
					FilteredPush <= '0';	-- Salida
					EnableTimer <= '0';	-- Salida
				end if;
			---------------
			-- EStado S0
			---------------
			when S0 =>
				if Push='1' then
					Next_State <= S01;
					FilteredPush <= '1';	-- Salida
					EnableTimer <= '0';	-- Salida
				else
					Next_State <= S0;
					FilteredPush <= '0';	-- Salida
					EnableTimer <= '0';	-- Salida
				end if;
			---------------
			-- EStado S01
			---------------
			when S01 =>
				Next_State <= espera;
				FilteredPush <= '0';	-- Salida
				EnableTimer <= '1';	-- Salida
			---------------
			-- EStado espera
			---------------
			when espera =>
				if Flag_Timer='1' then
					Next_State <= inic;
					FilteredPush <= '0';	-- Salida
					EnableTimer <= '0';	-- Salida
				else Next_State <= espera;
						FilteredPush<='0';	-- Salida
						EnableTimer<='1';		-- Salida
				end if;
			end case;
		end if;
	end process;
	
end Behavioral;
