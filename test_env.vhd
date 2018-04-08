library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
	PORT(clk: in std_logic;
	btn: in std_logic_vector (4 downto 0);
			sw : in std_logic_vector(15 downto 0);
			--Dg0, Dg1, Dg2,Dg3 : in std_logic_vector(3 downto 0);
			led : out std_logic_vector (15 downto 0);
			cat : out std_logic_vector(6 downto 0);
			an : out std_logic_vector(3 downto 0));
			
end test_env;




architecture Behavioral of test_env is





component InstructionFetch is 
	Port (clk: in STD_LOGIC;
		jump_address: in STD_logic (15 downto 0);
		branch_address: in std_logic (15 downto 0);
		PCSrc: in STD_LOGIC;
		jump: in STD_LOGIC;
		instruction: out STD_LOGIC (15 downto 0);
		pc: in std_logic(15 downto 0);
		WE: in STD_LOGIC;
		reset: in STD_LOGIC);
end component;

component MPG is
    Port ( btn : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           enable : out  STD_LOGIC);
end component;

component SSD is
    port ( clk : in STD_LOGIC;
           D0 : in STD_LOGIC_VECTOR (3 downto 0);
           D1 : in STD_LOGIC_VECTOR (3 downto 0);
           D2 : in STD_LOGIC_VECTOR (3 downto 0);
           D3 : in STD_LOGIC_VECTOR (3 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;


signal instruction,pc:STD_LOGIC_VECTOR(15 DOWNTO 0);
signal enable1: std_logic;
signal enable2: std_logic; 
signal afs: std_logic_vector(15 downto 0);

begin

	label_PC: MPG port map(clk, button(0), enable1);
	label_SSD: SSD port map (clk, afs(15 downto 12), afs(11 downto 8), afs(7 downto 4), afs(3 downto 0), an, cat);
	label_reset: MPG port map (clk, button(1), enable2);
	label_IF: InstructionFetch port map (clk, x"0000", x"0001", sw(1), sw(0), instruction, pc, enable1, enable2);
	
	
	afs <= instruction when sw(2) = '0' else pc;
end architecture;
