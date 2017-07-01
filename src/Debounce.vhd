----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:10:27 12/16/2015 
-- Design Name: 
-- Module Name:    Debounce - Structural 
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
--										Debounce
-- Structural architecture that implements a debounce circuit that allow us
-- to filter a button entry to avoid bounces of it. The debounce circuit uses:
--		- Type-D Flip-Flop
--		- Finite State Machine
--		- 300 ms Timer
--
--------------------------------------------------------------------------

entity Debounce is
    Port ( CLK 			: in  STD_LOGIC;
           Reset 			: in  STD_LOGIC;
           Push 			: in  STD_LOGIC;
           FilteredPush : out  STD_LOGIC);
end Debounce;

architecture Structural of Debounce is

	COMPONENT FFD
	PORT(
		D 			: IN std_logic;
		CLK 		: IN std_logic;
		ENABLE 	: IN std_logic;
		RESET 	: IN std_logic;          
		Q 			: OUT std_logic
		);
	END COMPONENT;
	
	signal FFD_DebounceFSM : std_logic;
	
	COMPONENT DebounceFSM
	PORT(
		CLK 				: IN std_logic;
		RESET 			: IN std_logic;
		Flag_Timer 		: IN std_logic;
		Push 				: IN std_logic;          
		EnableTimer 	: OUT std_logic;
		FilteredPush 	: OUT std_logic
		);
	END COMPONENT;
	
	signal Timer300ms_DebounceFSM_FlagTimer 	: std_logic;
	signal DebounceFSM_Timer300ms_EnableTimer	: std_logic;
	
	COMPONENT Timer300ms
	PORT(
		CLK 			: IN std_logic;
		Reset 		: IN std_logic;
		EnableTimer : IN std_logic;          
		End300ms 	: OUT std_logic
		);
	END COMPONENT;

begin

	-- Type-D Flip-Flop --------------------------------------------
	-- We use this flip-flop for synchronising the push entry, since
	-- that push is provided by a asynchronous button
	Inst_FFD: FFD PORT MAP(
		D 			=> Push,
		CLK 		=> CLK,
		ENABLE 	=> '1',
		RESET 	=> RESET,
		Q 			=> FFD_DebounceFSM 
	);
	----------------------------------------------------------------
	
	-- Finite State Machine ----------------------------------------
	-- This FSM represents all the states that the debounce circuit 
	-- could have
	Inst_DebounceFSM: DebounceFSM PORT MAP(
		CLK 				=> CLK,
		RESET 			=> RESET,
		Flag_Timer 		=> Timer300ms_DebounceFSM_FlagTimer,
		Push 				=> FFD_DebounceFSM,
		EnableTimer 	=> DebounceFSM_Timer300ms_EnableTimer,
		FilteredPush 	=> FilteredPush
	);
	----------------------------------------------------------------
	
	-- Timer300ms --------------------------------------------------
	-- When it's enabled, it sends back a signal 300 miliseconds after
	-- the enabling
	Inst_Timer300ms: Timer300ms PORT MAP(
		CLK 			=> CLK,
		Reset 		=> RESET,
		EnableTimer => DebounceFSM_Timer300ms_EnableTimer,
		End300ms 	=> Timer300ms_DebounceFSM_FlagTimer
	);
	----------------------------------------------------------------


end Structural;

