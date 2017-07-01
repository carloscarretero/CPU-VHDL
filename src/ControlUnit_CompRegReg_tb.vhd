--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:08:01 01/16/2016
-- Design Name:   
-- Module Name:   C:/Users/GII/Desktop/TDC/Proyecto/pruebas/ControlUnit_CompRegReg_tb.vhd
-- Project Name:  pruebas
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ControlUnit_CompRegReg
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ControlUnit_CompRegReg_tb IS
END ControlUnit_CompRegReg_tb;
 
ARCHITECTURE behavior OF ControlUnit_CompRegReg_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ControlUnit_CompRegReg
    PORT(
         CLK : IN  std_logic;
         RESET : IN  std_logic;
         Push : IN  std_logic;
         COP : IN  std_logic_vector(2 downto 0);
         FZ : IN  std_logic;
         ControlWORD : OUT  std_logic_vector(12 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal Push : std_logic := '0';
   signal COP : std_logic_vector(2 downto 0) := (others => '0');
   signal FZ : std_logic := '0';

 	--Outputs
   signal ControlWORD : std_logic_vector(12 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ControlUnit_CompRegReg PORT MAP (
          CLK => CLK,
          RESET => RESET,
          Push => Push,
          COP => COP,
          FZ => FZ,
          ControlWORD => ControlWORD
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		-- IDLE -> LoadInst
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		
      ----------------------------
		--        LDdirR2         --
		----------------------------
		-- LoadInst -> Deco
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		-- Deco -> LDdirR2
		COP <= "000";
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		-- LDdirR2 -> LoadInst
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		
		----------------------------
		--        STdirR2         --
		----------------------------
		-- LoadInst -> Deco
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		-- Deco -> STdirR2
		COP <= "001";
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		-- STdirR2 -> LoadInst
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		
		----------------------------
		--        R1addR2         --
		----------------------------
		-- LoadInst -> Deco
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		-- Deco -> R1addR2
		COP <= "010";
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		-- R1addR2 -> LoadInst
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		
		----------------------------
		--        R1subR2         --
		----------------------------
		-- LoadInst -> Deco
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		-- Deco -> R1subR2
		COP <= "011";
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		-- R1subR2 -> LoadInst
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		
		----------------------------
		--        INCinmR2        --
		----------------------------
		-- LoadInst -> Deco
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		-- Deco -> INCinmR2
		COP <= "100";
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		-- INCinmR2 -> LoadInst
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		
		----------------------------
		--        DECinmR2        --
		----------------------------
		-- LoadInst -> Deco
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		-- Deco -> DECinmR2 
		COP <= "101";
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		-- DECinmR2 -> LoadInst
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		
		----------------------------
		--        BEQdir          --
		----------------------------
		-- LoadInst -> Deco
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		-- Deco -> BEQdir 
		COP <= "110";
		FZ <= '1';
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		-- DECinmR2 -> LoadInst
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		-- LoadInst -> Deco
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		-- Deco -> LoadInst 
		COP <= "110";
		FZ <= '0';
		Push <= '1'; wait for 20 ns;
		Push <= '0'; wait for 20 ns;
		
      wait;
   end process;

END;

