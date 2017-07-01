----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:25:32 01/16/2016 
-- Design Name: 
-- Module Name:    TOP - Structural 
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
--												TOP
-- Structural architecture that interconnect the CompRegReg architecture,
-- the Control Unit, the 7 segment 4 displays and a Debounce circuit:
--
--------------------------------------------------------------------------	

entity TOP is
		Port ( Push 		: in  STD_LOGIC;
           CLK 			: in  STD_LOGIC;
           RESET 			: in  STD_LOGIC;
           Instruction 	: out  STD_LOGIC_VECTOR (6 downto 0);
           Anodo 			: out  STD_LOGIC_VECTOR (3 downto 0);
           Catodo 		: out  STD_LOGIC_VECTOR (6 downto 0);
           SalCOP 		: out  STD_LOGIC_VECTOR (2 downto 0);
           SalFZ 			: out  STD_LOGIC);
end TOP;

architecture Structural of TOP is

		-- COMPONENTS -----------------------------
		COMPONENT Debounce
		PORT(
			CLK 				: IN std_logic;
			Reset 			: IN std_logic;
			Push 				: IN std_logic;          
			FilteredPush 	: OUT std_logic
		);
		END COMPONENT;
		
		COMPONENT ControlUnit_CompRegReg
		PORT(
			CLK 			: IN std_logic;
			RESET 		: IN std_logic;
			Push 			: IN std_logic;
			COP 			: IN std_logic_vector(2 downto 0);
			FZ 			: IN std_logic;          
			ControlWORD : OUT std_logic_vector(12 downto 0)
			);
		END COMPONENT;
		
		COMPONENT CompRegReg
		PORT(
			CLK 			: IN std_logic;
			RESET 		: IN std_logic;
			CW2_1_0 		: IN std_logic_vector(2 downto 0);
			CW4_3 		: IN std_logic_vector(1 downto 0);
			CW5 			: IN std_logic;
			CW6 			: IN std_logic;
			CW7 			: IN std_logic;
			CW8 			: IN std_logic;
			CW9 			: IN std_logic;
			CW10 			: IN std_logic;
			CW11 			: IN std_logic;
			CW12 			: IN std_logic;          
			Ope_A 		: OUT std_logic_vector(3 downto 0);
			Ope_B 		: OUT std_logic_vector(3 downto 0);
			Sal_FZ 		: OUT std_logic;
			Sal_Cop 		: OUT std_logic_vector(2 downto 0);
			Res_ALU 		: OUT std_logic_vector(3 downto 0);
			AddressRAM 	: OUT std_logic_vector(3 downto 0);
			Instruction : OUT std_logic_vector(6 downto 0)
			);
		END COMPONENT;
		
		COMPONENT Display7Seg_4ON
		PORT(
			Dato1 	: IN std_logic_vector(3 downto 0);
			Dato2 	: IN std_logic_vector(3 downto 0);
			Dato3 	: IN std_logic_vector(3 downto 0);
			Dato4 	: IN std_logic_vector(3 downto 0);
			CLK 		: IN std_logic;
			RESET 	: IN std_logic;          
			Anodo 	: OUT std_logic_vector(3 downto 0);
			Catodo 	: OUT std_logic_vector(6 downto 0)
			);
		END COMPONENT;
		
		-- SIGNALS --------------------------------
		-- From Debounce --------------------------
		signal Debounce_to_Control_Unit : std_logic;
		
		-- From Control Unit ----------------------
		signal Control_Unit_CW_to_CompRegReg 		: std_logic_vector(12 downto 0);
		signal Control_Unit_CW_to_CompRegReg_Filt : std_logic_vector(12 downto 0);
		
		-- From CompRegReg ------------------------
		signal CompRegReg_Cop_to_Control_Unit : std_logic_vector (2 downto 0);
		signal CompRegReg_FZ_to_Control_Unit  : std_logic;
		signal CompRegReg_AddressRam_to_Disp3 : std_logic_vector (3 downto 0);
		signal CompRegReg_Ope_A_to_Disp2		  : std_logic_vector (3 downto 0);
		signal CompRegReg_Ope_B_to_Disp1		  : std_logic_vector (3 downto 0);
		signal CompRegReg_Sal_ALU_to_Disp0	  : std_logic_vector (3 downto 0);
		signal CompRegReg_Sal_Instruction	  : std_logic_vector (6 downto 0);
		
begin

		-- Debounce_Circuit -----------------------------------------
		-- Filter of push entry to avoid bounces of the Basys2 button
		Debounce_Circuit: Debounce PORT MAP(
			CLK => 				CLK,
			Reset => 			RESET,
			Push => 				Push,
			FilteredPush => 	Debounce_to_Control_Unit
		);
		-------------------------------------------------------------
		
		-- Control_Unit ------------------------------------
		-- FSM that controls all our CompRegReg
		-- architecture
		Control_Unit: ControlUnit_CompRegReg PORT MAP(
			CLK => 			CLK,
			RESET => 		RESET,
			Push => 			Debounce_to_Control_Unit,
			COP => 			CompRegReg_Cop_to_Control_Unit,
			FZ => 			CompRegReg_FZ_to_Control_Unit,
			ControlWORD => Control_Unit_CW_to_CompRegReg
		);
		
		
		-- CompRegReg_Arch --------------------------------------------------------------------------------------
		-- Instatiation of our architecture 
		-- Some CW are filtered with the debounce circuit
		-- output to avoid a component's enabling during 
		-- a state, because we only want them to be enabled
		-- once per state
		Control_Unit_CW_to_CompRegReg_Filt(5 downto 0) <= Control_Unit_CW_to_CompRegReg(5 downto 0);
		Control_Unit_CW_to_CompRegReg_Filt(6) <= Control_Unit_CW_to_CompRegReg(6) and Debounce_to_Control_Unit;
		Control_Unit_CW_to_CompRegReg_Filt(8 downto 7) <= Control_Unit_CW_to_CompRegReg(8 downto 7);
		Control_Unit_CW_to_CompRegReg_Filt(9) <= Control_Unit_CW_to_CompRegReg(9) and Debounce_to_Control_Unit;
		Control_Unit_CW_to_CompRegReg_Filt(10) <= Control_Unit_CW_to_CompRegReg(10);
		Control_Unit_CW_to_CompRegReg_Filt(11) <= Control_Unit_CW_to_CompRegReg(11) and Debounce_to_Control_Unit;
		Control_Unit_CW_to_CompRegReg_Filt(12) <= Control_Unit_CW_to_CompRegReg(12);
			
		CompRegReg_Arch: CompRegReg PORT MAP(
			CLK => 			CLK,
			RESET => 		RESET,
			CW2_1_0 => 		Control_Unit_CW_to_CompRegReg_Filt(2 downto 0),
			CW4_3 => 		Control_Unit_CW_to_CompRegReg_Filt(4 downto 3),
			CW5 => 			Control_Unit_CW_to_CompRegReg_Filt(5),
			CW6 => 			Control_Unit_CW_to_CompRegReg_Filt(6),
			CW7 => 			Control_Unit_CW_to_CompRegReg_Filt(7),
			CW8 => 			Control_Unit_CW_to_CompRegReg_Filt(8),
			CW9 => 			Control_Unit_CW_to_CompRegReg_Filt(9),
			CW10 => 			Control_Unit_CW_to_CompRegReg_Filt(10),
			CW11 => 			Control_Unit_CW_to_CompRegReg_Filt(11),
			CW12 => 			Control_Unit_CW_to_CompRegReg_Filt(12),
			Ope_A => 		CompRegReg_Ope_A_to_Disp2,
			Ope_B => 		CompRegReg_Ope_B_to_Disp1,
			Sal_FZ => 		CompRegReg_FZ_to_Control_Unit,
			Sal_Cop => 		CompRegReg_Cop_to_Control_Unit,
			Res_ALU => 		CompRegReg_Sal_ALU_to_Disp0,
			AddressRAM => 	CompRegReg_AddressRam_to_Disp3,
			Instruction => CompRegReg_Sal_Instruction
		);
		
		Instruction <= CompRegReg_Sal_Instruction;
		SalCOP <= CompRegReg_Cop_to_Control_Unit;
		SalFZ <= CompRegReg_FZ_to_Control_Unit;
		---------------------------------------------------------------------------------------------------------
		
		-- 4 displays of 7 segment -----------------------
		-- We use them to print:
		-- 	Display3: RAM Address 
		--		Display2: ALU A operand
		-- 	Display1: ALU B operand
		--		Display0: ALU Result
		Inst_Display7Seg_4ON: Display7Seg_4ON PORT MAP(
			Dato1 => 	CompRegReg_Sal_ALU_to_Disp0,
			Dato2 => 	CompRegReg_Ope_B_to_Disp1,
			Dato3 => 	CompRegReg_Ope_A_to_Disp2,
			Dato4 => 	CompRegReg_AddressRam_to_Disp3,
			CLK => 		CLK,
			RESET => 	RESET,
			Anodo => 	Anodo,
			Catodo => 	Catodo
		);
		--------------------------------------------------
	
end Structural;

