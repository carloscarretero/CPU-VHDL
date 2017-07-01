----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:41:37 11/18/2015 
-- Design Name: 
-- Module Name:    Display7Seg_4ON - Structural 
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
--										Display7Seg_4ON
-- Structural architecture to interconnect the components that allow us
-- to use the 7 segment 4 displays of the Basys2 board.
--	For printing 4 different values in 4 different displays we use
-- a timer to show one value in one display during a short period
-- of time. We do this with all the displays so, at the end, it seems
-- that all the data it's being printed at the same time
--
---------------------------------------------------------------------------

entity Display7Seg_4ON is
    Port ( Dato1 : in  STD_LOGIC_VECTOR (3 downto 0);
           Dato2 : in  STD_LOGIC_VECTOR (3 downto 0);
           Dato3 : in  STD_LOGIC_VECTOR (3 downto 0);
           Dato4 : in  STD_LOGIC_VECTOR (3 downto 0);
           CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           Anodo : out  STD_LOGIC_VECTOR (3 downto 0);
           Catodo : out  STD_LOGIC_VECTOR (6 downto 0));
end Display7Seg_4ON;

architecture Structural of Display7Seg_4ON is

	-- Clock of 1 KHz
	COMPONENT CLK_1KHz
	PORT(
		CLK : IN std_logic;
		Reset : IN std_logic;          
		Out_1KHz : OUT std_logic
		);
	END COMPONENT;
	
	-- 2 bits Counter
	COMPONENT Counter_2bits
	PORT(
		CLK : IN std_logic;
		Reset : IN std_logic;
		Enable : IN std_logic;          
		Q : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;
	
	-- Mux of 2 entries of 4 bits
	COMPONENT Mux2_4bits
	PORT(
		A : IN std_logic_vector(3 downto 0);
		B : IN std_logic_vector(3 downto 0);
		Sel : IN std_logic;          
		Z : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	-- 7 segment display
	COMPONENT Disp7Seg
	PORT(
		Hex : IN std_logic_vector(3 downto 0);
		Select_Disp : IN std_logic_vector(1 downto 0);          
		Seg : OUT std_logic_vector(6 downto 0);
		Anode : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	-- Internal signals --
	signal clock1KHz_to_Counter: std_logic;
	signal Counter_to_Muxs_and_Disp7Seg: std_logic_vector (1 downto 0);
	signal Mux_a_to_Mux_c: std_logic_vector (3 downto 0);
	signal Mux_b_to_Mux_c: std_logic_vector (3 downto 0);
	signal Mux_c_to_Disp7Seg: std_logic_vector (3 downto 0);
	
begin

	-- Instantiation of 1KHz clock
	Inst_CLK_1KHz: CLK_1KHz PORT MAP(
		CLK => CLK,
		Reset => RESET,
		Out_1KHz => clock1KHz_to_Counter
	);
	
	-- Instantiation of 2bits counter
	Inst_Counter_2bits: Counter_2bits PORT MAP(
		CLK => CLK,
		Reset => RESET,
		Enable => clock1KHz_to_Counter,
		Q => Counter_to_Muxs_and_Disp7Seg
	);
	
	-- Instantiation Mux_a for dato1 y dato2
	Inst_Mux_a: Mux2_4bits PORT MAP(
		A => Dato1,
		B => Dato2,
		Sel => Counter_to_Muxs_and_Disp7Seg(0),
		Z => Mux_a_to_Mux_c
	);
	
	-- Instantiation Mux_b for dato3 y dato4
	Inst_Mux_b: Mux2_4bits PORT MAP(
		A => Dato3,
		B => Dato4,
		Sel => Counter_to_Muxs_and_Disp7Seg(0),
		Z => Mux_b_to_Mux_c
	);
	
	-- Instantiation Mux_c for Mux_a and Mux_b
	Inst_Mux_c: Mux2_4bits PORT MAP(
		A => Mux_a_to_Mux_c,
		B => Mux_b_to_Mux_c,
		Sel => Counter_to_Muxs_and_Disp7Seg(1),
		Z => Mux_c_to_Disp7Seg
	);
	
	-- Instantiation of 7 segment display
	Inst_Disp7Seg: Disp7Seg PORT MAP(
		Hex => Mux_c_to_Disp7Seg,
		Select_Disp => Counter_to_Muxs_and_Disp7Seg,
		Seg => Catodo,
		Anode => Anodo
	);

end Structural;

