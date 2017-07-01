----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:29:28 01/16/2016 
-- Design Name: 
-- Module Name:    ControlUnit_CompRegReg - Behavioral 
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
--									Control Unit 
-- FSM with these states: 
--		- Idle:		First state. When switched on or after a reset
--		- LoadInst:	Load instrcution on the Instruction Register
--		- Deco:		Instruction decodification 
--		- LDdirR2:	LD dir, R2 instruction
--		- STdirR2:	ST dir, R2 instruction
--		- R1addR2:	ADD R1, R2 instruction
--		- R1subR2:	SUB R1, R2 instruction
--		- INCinmR2:	INC Inm, R2 instruction
--		- DECinmR2:	DEC Inm, R2	instruction
--		- BEQdir:	BEQ Dir instruction
--
--------------------------------------------------------------------------

entity ControlUnit_CompRegReg is
		Port ( CLK 			: in  STD_LOGIC;
           RESET 			: in  STD_LOGIC;
           Push 			: in  STD_LOGIC;
           COP 			: in  STD_LOGIC_VECTOR (2 downto 0);
           FZ 				: in  STD_LOGIC;
           ControlWORD 	: out STD_LOGIC_VECTOR (12 downto 0));
end ControlUnit_CompRegReg;

architecture Behavioral of ControlUnit_CompRegReg is
	---------------------------------------------------------------------------------
	-- DEFINITION of STATES
	---------------------------------------------------------------------------------
	type States_FSM is (Idle, LoadInst, Deco, LDdirR2, STdirR2, R1addR2, R1subR2, INCinmR2, DECinmR2, BEQdir);
	signal Next_State: States_FSM;
	
	-----------------------------------------------------------------------------
	-- DEFINITION of the OUTPUTS for each STATE
	-----------------------------------------------------------------------------
	constant Outputs_Idle		: std_logic_Vector(12 downto 0) := "0000000000000";
	constant Outputs_LoadInst	: std_logic_Vector(12 downto 0) := "0101000000000";
	constant Outputs_Deco		: std_logic_Vector(12 downto 0) := "0000000000000";
	constant Outputs_LDdirR2	: std_logic_Vector(12 downto 0) := "0010011010000";
	constant Outputs_STdirR2	: std_logic_Vector(12 downto 0) := "0010101001001";
	constant Outputs_R1addR2	: std_logic_Vector(12 downto 0) := "0000011000010";
	constant Outputs_R1subR2	: std_logic_Vector(12 downto 0) := "0000011000011";
	constant Outputs_INCinmR2	: std_logic_Vector(12 downto 0) := "0000011101100";
	constant Outputs_DECinmR2	: std_logic_Vector(12 downto 0) := "0000011101101";
	constant Outputs_BEQdir		: std_logic_Vector(12 downto 0) := "1100000000110";
	-----------------------------------------------------------------------------

begin
	process(CLK,RESET)
	begin
		if RESET ='1' then
			-- Initial state if RESET 
			Next_State  <= Idle;	
			ControlWord <= Outputs_Idle; 
		elsif rising_edge(CLK)then
			case Next_State is
			----------------
			--State "Idle"--
			----------------
			when Idle =>
				if (Push = '1') then	-- Idle -> LoadInst
					Next_State <= LoadInst;
					ControlWord<= Outputs_LoadInst;
				else						-- Stay in Idle
					Next_State <= Idle;
					ControlWord<= Outputs_Idle;
				end if;
				
			--------------------
			--State "LoadInst"--
			--------------------
			when LoadInst =>
				if (Push = '1') then	-- LoadInst -> Deco
					Next_State <= Deco;
					ControlWord<= Outputs_Deco;
				else						-- Stay in LoadInst
					Next_State <= LoadInst;
					ControlWord<= Outputs_LoadInst;
				end if;
				
			--------------------
			--State "Deco"------
			--------------------
			when Deco =>
				if (Push = '1') then	-- Deco -> Next_Instruction
					if(COP = "000") then 		-- Deco -> LD dir, R2
						Next_State <= LDdirR2;
						ControlWord<= Outputs_LDdirR2;
					elsif(COP = "001") then 	-- Deco -> ST dir, R2
						Next_State <= STdirR2;
						ControlWord<= Outputs_STdirR2;
					elsif(COP = "010") then 	-- Deco -> ADD R1, R2
						Next_State <= R1addR2;
						ControlWord<= Outputs_R1addR2;
					elsif(COP = "011") then 	-- Deco -> SUB R1, R2
						Next_State <= R1subR2;
						ControlWord<= Outputs_R1subR2;
					elsif(COP = "100") then 	-- Deco -> INC Inm, R2
						Next_State <= INCinmR2;
						ControlWord<= Outputs_INCinmR2;
					elsif(COP = "101") then 	-- Deco -> DEC Inm, R2
						Next_State <= DECinmR2;
						ControlWord<= Outputs_DECinmR2;
					elsif(COP = "110") then 	-- Deco -> Branch
						if(FZ = '1') then				-- Deco -> BEQ dir
							Next_State <= BEQdir;
							ControlWord<= Outputs_BEQdir;
						elsif(FZ = '0') then		-- Deco -> LoadInst
							Next_State <= LoadInst;
							ControlWord<= Outputs_LoadInst;
						end if;
					end if;
				else						-- Stay in Deco
					Next_State <= Deco;
					ControlWord<= Outputs_Deco;
				end if;
				
			-------------------
			--State "LDdirR2"--
			-------------------
			when LDdirR2 =>
				if (Push = '1') then	-- LDdirR2 -> LoadInst
					Next_State <= LoadInst;
					ControlWord<= Outputs_LoadInst;
				else						-- Stay in LDdirR2
					Next_State <= LDdirR2;
					ControlWord<= Outputs_LDdirR2;
				end if;
				
			-------------------
			--State "STdirR2"--
			-------------------
			when STdirR2 =>
				if (Push = '1') then	-- STdirR2 -> LoadInst
					Next_State <= LoadInst;
					ControlWord<= Outputs_LoadInst;
				else						-- Stay in STdirR2
					Next_State <= STdirR2;
					ControlWord<= Outputs_STdirR2;
				end if;
				
			-------------------
			--State "R1addR2"--
			-------------------
			when R1addR2 =>
				if (Push = '1') then	-- R1addR2 -> LoadInst
					Next_State <= LoadInst;
					ControlWord<= Outputs_LoadInst;
				else						-- Stay in R1addR2
					Next_State <= R1addR2;
					ControlWord<= Outputs_R1addR2;
				end if;
			-------------------
			--State "R1subR2"--
			-------------------
			when R1subR2 =>
				if (Push = '1') then	-- R1subR2 -> LoadInst
					Next_State <= LoadInst;
					ControlWord<= Outputs_LoadInst;
				else						-- Stay in R1subR2
					Next_State <= R1subR2;
					ControlWord<= Outputs_R1subR2;
				end if;
			--------------------
			--State "INCinmR2"--
			--------------------
			when INCinmR2 =>
				if (Push = '1') then	-- INCinmR2 -> LoadInst
					Next_State <= LoadInst;
					ControlWord<= Outputs_LoadInst;
				else						-- Stay in INCinmR2
					Next_State <= INCinmR2;
					ControlWord<= Outputs_INCinmR2;
				end if;
			--------------------
			--State "DECinmR2"--
			--------------------
			when DECinmR2 =>
				if (Push = '1') then	-- DECinmR2 -> LoadInst
					Next_State <= LoadInst;
					ControlWord<= Outputs_LoadInst;
				else						-- Stay in DECinmR2
					Next_State <= DECinmR2;
					ControlWord<= Outputs_DECinmR2;
				end if;
			--------------------
			--State "BEQdir"----
			--------------------
			when BEQdir =>
				if (Push = '1') then	-- BEQdir -> LoadInst
					Next_State <= LoadInst;
					ControlWord<= Outputs_LoadInst;
				else						-- Stay in BEQdir
					Next_State <= BEQdir;
					ControlWord<= Outputs_BEQdir;
				end if;
			
			end case;
		end if;
	end process;

end Behavioral;

