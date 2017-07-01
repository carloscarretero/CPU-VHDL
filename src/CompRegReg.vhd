----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:00:00 01/13/2016 
-- Design Name: 
-- Module Name:    CompRegReg - Structural 
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
--											CompRegReg
-- Structural architecture that interconnect the CompRegReg architecture 
-- components. These components are:
--		- 1) 4 bit Program Counter: 			PC
--		- 1) 10 bit Instruction Register: 	IR
--		- 1) 16x10 Von-Neumann RAM:			RAM
--		- 1) 8x4 Register Bank:					RB
--		- 1) 7 operations ALU:					ALU
--		- 1) Zero-Flag Type-D Flip-Flop:		FZ
--		- 1) 4 bit Adder:							INC_1
--		- 3) 2 entries Mux:						MUX_B	MUX_C	MUX_D
--		- 1) 4 entries Mux:						MUX_A
--
--------------------------------------------------------------------------	

entity CompRegReg is
    Port ( CLK 			: in  STD_LOGIC;
           RESET 			: in  STD_LOGIC;
			  CW2_1_0		: in 	STD_LOGIC_VECTOR (2 downto 0);
			  CW4_3			: in 	STD_LOGIC_VECTOR (1 downto 0);
			  CW5				: in 	STD_LOGIC;
			  CW6				: in 	STD_LOGIC;
			  CW7				: in 	STD_LOGIC;
			  CW8				: in 	STD_LOGIC;
			  CW9				: in 	STD_LOGIC;
			  CW10			: in 	STD_LOGIC;
			  CW11			: in 	STD_LOGIC;
			  CW12			: in 	STD_LOGIC;
           Ope_A 			: out  STD_LOGIC_VECTOR (3 downto 0);
           Ope_B 			: out  STD_LOGIC_VECTOR (3 downto 0);
           Sal_FZ 		: out  STD_LOGIC;
			  Sal_Cop 		: out  STD_LOGIC_VECTOR (2 downto 0);
           Res_ALU 		: out  STD_LOGIC_VECTOR (3 downto 0);
           AddressRAM 	: out  STD_LOGIC_VECTOR (3 downto 0);
           Instruction 	: out  STD_LOGIC_VECTOR (6 downto 0));
end CompRegReg;

architecture Structural of CompRegReg is

		-- Components -------------------------------------
		COMPONENT Reg_4bits
		PORT(
			RESET 	: IN std_logic;
			CLK 		: IN std_logic;
			ENABLE 	: IN std_logic;
			DataIn 	: IN std_logic_vector(3 downto 0);          
			DataOut 	: OUT std_logic_vector(3 downto 0)
			);
		END COMPONENT;
		
		COMPONENT Inc1_4bits
		PORT(
			Value 		: IN std_logic_vector(3 downto 0);          
			Value_Inc 	: OUT std_logic_vector(3 downto 0)
			);
		END COMPONENT;
		
		COMPONENT Mux2_4b
		PORT(
			A 		: IN std_logic_vector(3 downto 0);
			B 		: IN std_logic_vector(3 downto 0);
			Sel 	: IN std_logic;          
			Z 		: OUT std_logic_vector(3 downto 0)
			);
		END COMPONENT;
		
		COMPONENT Reg_10bits
		PORT(
			RESET 	: IN std_logic;
			CLK 		: IN std_logic;
			ENABLE 	: IN std_logic;
			DataIn 	: IN std_logic_vector(9 downto 0);          
			DataOut 	: OUT std_logic_vector(9 downto 0)
			);
		END COMPONENT;
		
		COMPONENT RAM_VN
		PORT(
			DataIn 			: IN std_logic_vector(9 downto 0);
			Write_Enable 	: IN std_logic;
			Address 			: IN std_logic_vector(3 downto 0);
			CLK 				: IN std_logic;          
			DataOut 			: OUT std_logic_vector(9 downto 0)
			);
		END COMPONENT;
		
		COMPONENT Reg_Bank_8x4
		PORT(
			Font_1 			: IN std_logic_vector(2 downto 0);
			Font_2 			: IN std_logic_vector(2 downto 0);
			Write_Enable 	: IN std_logic;
			DataIn 			: IN std_logic_vector(3 downto 0);
			CLK 				: IN std_logic;          
			Op_1 				: OUT std_logic_vector(3 downto 0);
			Op_2 				: OUT std_logic_vector(3 downto 0)
			);
		END COMPONENT;
		
		COMPONENT Mux4_4b
		PORT(
			A 		: IN std_logic_vector(3 downto 0);
			B 		: IN std_logic_vector(3 downto 0);
			C 		: IN std_logic_vector(3 downto 0);
			D 		: IN std_logic_vector(3 downto 0);
			Sel 	: IN std_logic_vector(1 downto 0);          
			Z 		: OUT std_logic_vector(3 downto 0)
			);
		END COMPONENT;
		
		COMPONENT ALU_CRR
		PORT(
			A 		: IN std_logic_vector(3 downto 0);
			B 		: IN std_logic_vector(3 downto 0);
			OP 	: IN std_logic_vector(2 downto 0);          
			Res 	: OUT std_logic_vector(3 downto 0);
			FZ 	: OUT std_logic
			);
		END COMPONENT;
		
		COMPONENT FFD
		PORT(
			D 			: IN std_logic;
			CLK 		: IN std_logic;
			ENABLE 	: IN std_logic;
			RESET 	: IN std_logic;          
			Q 			: OUT std_logic
			);
		END COMPONENT;
		-------------------------------------------------
		
		-- Signals --------------------------------------
		-- From PC --------------------------------------
		signal PC_to_MUX_C_Inc_1		: std_logic_vector (3 downto 0);
		
		-- From INC_1 -----------------------------------
		signal INC_1_to_MUX_D 			: std_logic_vector (3 downto 0);
		
		-- From MUX_C -----------------------------------
		signal MUX_C_to_RAM_Address	: std_logic_vector (3 downto 0);
		
		-- From MUX_D -----------------------------------
		signal MUX_D_to_PC				: std_logic_vector (3 downto 0);
		
		-- From IR --------------------------------------
		signal IR_Value					: std_logic_vector (9 downto 0);
		signal IR_Dir_to_MUX_D_C		: std_logic_vector (3 downto 0);
		signal IR_Inm_to_MUX_B			: std_logic_vector (3 downto 0);
		signal IR_R1_to_RB_Font_1		: std_logic_vector (2 downto 0);
		signal IR_R2_to_RB_Font_2		: std_logic_vector (2 downto 0);
		
		-- From RAM -------------------------------------
		signal RAM_DataOut_to_MUX_A_IR			: std_logic_vector (9 downto 0);
		signal RAM_DataOut_to_MUX_A_3_downto_0	: std_logic_vector (3 downto 0);
		
		-- From Register Bank ---------------------------
		signal RB_Op_1_to_MUX_A 	: std_logic_vector (3 downto 0);
		signal RB_Op_2_to_MUX_A_B 	: std_logic_vector (3 downto 0);
		
		-- From MUX_B -----------------------------------
		signal MUX_B_to_ALU_B 		: std_logic_vector (3 downto 0);	
		
		-- From MUX_A -----------------------------------
		signal MUX_A_to_ALU_A 		: std_logic_vector (3 downto 0);
		
		-- From ALU --------------------------------------
		signal Res_ALU_to_RB_DataIn_RAM_DataIn 	: std_logic_vector (3 downto 0);
		signal RAM_Zero_Extend 							: std_logic_vector (9 downto 0);
		signal ALU_to_FZ									: std_logic;
		
		-- From FZ ---------------------------------------
		signal FZ_value				: std_logic;
		-------------------------------------------------

begin
		-- 4 bit Program Counter ------------------------------
		PC: Reg_4bits PORT MAP(
			RESET => 	RESET,
			CLK => 		CLK,
			ENABLE => 	CW11,
			DataIn => 	MUX_D_to_PC,
			DataOut => 	PC_to_MUX_C_Inc_1
		);
		-------------------------------------------------
		
		-- 4 bit +1 adder -------------------------------
		-- Increments the value of the PC from 0000 to 1010
		-- and back to 0000
		INC_1: Inc1_4bits PORT MAP(
			Value => 		PC_to_MUX_C_Inc_1,
			Value_Inc => 	INC_1_to_MUX_D
		);
		-------------------------------------------------
		
		-- MUX_D ----------------------------------------
		-- For switching between incremented PC value or 
		-- branch (BEQ) 
		MUX_D: Mux2_4b PORT MAP(
			A => 		INC_1_to_MUX_D,
			B => 		IR_Dir_to_MUX_D_C,
			Sel => 	CW12,
			Z => 		MUX_D_to_PC
		);
		-------------------------------------------------
		
		-- MUX_C ----------------------------------------
		-- For choosing address for RAM between 
		-- PC and IR(Dir)
		MUX_C: Mux2_4b PORT MAP(
			A => 		PC_to_MUX_C_Inc_1,
			B => 		IR_Dir_to_MUX_D_C,
			Sel => 	CW10,
			Z => 		MUX_C_to_RAM_Address
		);
		
		addressRAM <= MUX_C_to_RAM_Address;
		-------------------------------------------------
		
		-- Instruction Register. 10 bit register --------
		-- 3 fields :
		-- 	Cod_Op 		(9-7), 
		--		Dir/Inm/R1 	(6-3), 
		--		R2 			(2-0)
		IR: Reg_10bits PORT MAP(
			RESET => 	RESET,
			CLK => 		CLK,
			ENABLE => 	CW9,
			DataIn => 	RAM_DataOut_to_MUX_A_IR,
			DataOut =>	IR_Value 
		);
		
		IR_Dir_to_MUX_D_C 	<= IR_Value (6 downto 3); 	-- IR(DIR)
		IR_Inm_to_MUX_B 		<= IR_Value (6 downto 3); 	-- IR(INM)
		IR_R1_to_RB_Font_1	<= IR_Value (5 downto 3);  -- IR(R1)
		IR_R2_to_RB_Font_2	<= IR_Value (2 downto 0);	-- IR(R2)
		Instruction 			<= IR_Value (6 downto 0);	-- IR
		Sal_Cop 					<= IR_Value (9 downto 7);	-- IR(COP)
		-------------------------------------------------
		
		-- RAM Von Neumann ------------------------------
		-- We extend the RAM data entry, which comes from the ALU, to 10 bits
		-- If the data output goes to the ALU, wee only
		-- take the 4 lower bits (3-0)
		RAM: RAM_VN PORT MAP(
			DataIn => 			RAM_Zero_Extend,
			Write_Enable => 	CW8,
			Address => 			MUX_C_to_RAM_Address,
			DataOut => 			RAM_DataOut_to_MUX_A_IR,
			CLK => 				CLK
		);
		
		 RAM_Zero_Extend <= "000000" & Res_ALU_to_RB_DataIn_RAM_DataIn;
		 RAM_DataOut_to_MUX_A_3_downto_0 <= RAM_DataOut_to_MUX_A_IR (3 downto 0);
		-------------------------------------------------
		
		-- Register Bank --------------------------------
		-- 8 registers of 4 bits
		RB: Reg_Bank_8x4 PORT MAP(
			Font_1 => 			IR_R1_to_RB_Font_1,
			Font_2 => 			IR_R2_to_RB_Font_2,
			Write_Enable => 	CW7,
			DataIn => 			Res_ALU_to_RB_DataIn_RAM_DataIn,
			Op_1 => 				RB_Op_1_to_MUX_A,
			Op_2 => 				RB_Op_2_to_MUX_A_B,
			CLK => 				CLK
		);
		------------------------------------------------
		
		-- MUX_B ----------------------------------------
		-- For choosing ALU's operand B between 
		-- RB_Op_2/R2 and IR_Inm
		MUX_B: Mux2_4b PORT MAP(
			A => 		RB_Op_2_to_MUX_A_B,
			B => 		IR_Inm_to_MUX_B,
			Sel => 	CW5,
			Z => 		MUX_B_to_ALU_B
		);
		
		Ope_B <= MUX_B_to_ALU_B;
		-------------------------------------------------
		
		-- MUX_A ----------------------------------------
		-- For choosing ALU's operand A between 
		-- RB_Op_1/R1 , IR_Dir, RB_Op_2/R2, 0000
		MUX_A: Mux4_4b PORT MAP(
			A => 		RB_Op_1_to_MUX_A,
			B => 		RB_Op_2_to_MUX_A_B,
			C => 		RAM_DataOut_to_MUX_A_3_downto_0,
			D => 		"0000",
			Sel => 	CW4_3,
			Z => 		MUX_A_to_ALU_A
		);
		
		Ope_A <= MUX_A_to_ALU_A;
		-------------------------------------------------
		
		-- ALU ------------------------------------------
		-- The data output goes to the RB and the RAM
		ALU: ALU_CRR PORT MAP(
			A => MUX_A_to_ALU_A,
			B => MUX_B_to_ALU_B,
			OP => CW2_1_0,
			Res => Res_ALU_to_RB_DataIn_RAM_DataIn,
			FZ => ALU_to_FZ
		);
		
		Res_ALU <= Res_ALU_to_RB_DataIn_RAM_DataIn; 
		-------------------------------------------------
		
		-- Zero Flag ------------------------------------
		FZ: FFD PORT MAP(
			D => 			ALU_to_FZ,
			CLK => 		CLK,
			ENABLE => 	CW6,
			RESET => 	RESET,
			Q => 			FZ_value
		);
		
		Sal_FZ <= FZ_value;
		-------------------------------------------------
		
		
end Structural;

