library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--! | PC  |     Instruction     |
--! |-----|---------------------|
--! |  0  | lw   $t0, 4($zero)  |
--! |  1  | addi $t0, $zero, 1  |
--! |  2  | sw   $t2, 4($s0)    |
--   loop:
--! |  3  | add  $s0, $s1, $s2  |
--! |  4  | add  $t1, $t0, $t2  |
--! |  5  | add  $t2, $t1, $t0  |
--! |  6  | beq  $t0, $t1, loop |

entity InstructionMemory is
    port ( A  :  in STD_LOGIC_VECTOR (31 downto 0);
           RD : out STD_LOGIC_VECTOR (31 downto 0)
           );
end InstructionMemory;

architecture Behavioral of InstructionMemory is
type instruction is array(0 to 31) of std_logic_vector(31 downto 0);

signal I : instruction := ( x"8C080004", x"20080001", x"AE0A0004", x"02328020",
                            x"010A4820", x"01285020", x"1108FFFC", x"00000000",
                            x"00000000", x"00000000", x"00000000", x"00000000",
                            x"00000000", x"00000000", x"00000000", x"00000000",
                            x"00000000", x"00000000", x"00000000", x"00000000",
                            x"00000000", x"00000000", x"00000000", x"00000000",
                            x"00000000", x"00000000", x"00000000", x"00000000",
                            x"00000000", x"00000000", x"00000000", x"00000000" );
begin
    process(A)
    begin
        -- Send the instruction stored at PC
        RD <= I(to_integer(unsigned(A)));
    end process;
end Behavioral;