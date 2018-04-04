library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity InstructionFetch is port (
		clk: in STD_LOGIC;
		jump_address: in STD_logic (15 downto 0);
		branch_address: in std_logic (15 downto 0);
		PCSrc: in STD_LOGIC;
		jump: in STD_LOGIC;
		instruction: out STD_LOGIC (15 downto 0);
		pc: in std_logic(15 downto 0);
		WE: in STD_LOGIC;
		reset: in STD_LOGIC);
end entity;

architecture Behavioral of InstructionFetch is 
signal PCaux : std_logic(15 downto 0);
type ROM is array (0 to 255) of std_logic_vector(15 downto 0);
signal ins: ROM: (0 => B"000_001_010_011_0_000", --add $1 $2 $3
         1  => B"000_001_010_011_0_001", --sub $1 $2 $3
         2  => B"000_001_010_011_0_010", --sll $1 $2 $3
         3  => B"000_001_010_011_0_011", --srl $1 $2 $3
         4  => B"000_001_010_011_0_100", --and $1 $2 $3
         5  => B"000_001_010_011_0_101", --or $1 $2 $3
         6  => B"000_001_010_011_0_110", --xor $1 $2 $3
         7  => B"000_001_010_011_0_111", --mul $1 $2 $3
         8  => B"001_001_010_0000011", --addi $1 $2 3
         9  => B"010_001_010_0001010", --lw $1 $10($2)
        10  => B"011_001_010_0001010", --sw $1 $10($2)
        11  => B"100_001_010_0001010", --beq $1 $2 10
        12  => B"101_001_010_0000011", --ori $1 $2 3
        13  => B"110_001_010_0000011", --xori $1 $2 3
        14  => B"111_0000000000100", --j 4
		others => x"0000");
signal muxOut1 : std_logic(15 downto 0);
signal muxOut2 : std_logic(15 downto 0);
signal adderOut: std_logic(15 downto 0);
begin

--Program Counter
	PC: process(clk, Reset)
		begin
		if(Reset = '1') then
			pc <= x"0000";
		elsif(rising_edge(clk)) then
			if(WE='1') then 
				pc<=muxOut2;
			end if;
		end if;
	end process;
	
--Sum
	adderOut <= pc+1;
	
--Mux1
process(PCSrc,branch_address,adderOut)
begin
    if(PRSrc = '0') then muxOut1 <= adderOut;
	else muxOut1<=branch_address;
	end if;
    
end process;
			
--Mux2
process(jump,branch_address,muxOut1)
begin
    if(jump = '0') then muxOut2 <= muxOut1;
	else muxOut2<=jump_address;
	end if;
    
end process;

instruction <= ins(conv_integer(pc));

end architecture
		
		