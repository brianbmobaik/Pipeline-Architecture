library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlUnit is
    port ( Opcode  :  in STD_LOGIC_VECTOR (5 downto 0); --! Instr(31 downto 26)
           Control : out STD_LOGIC_VECTOR (8 downto 0)  --! EX & MEM & WB
           );
end ControlUnit;

architecture Behavioral of ControlUnit is

signal ALUOp : STD_LOGIC_VECTOR(1 downto 0);
signal RegDst, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemtoReg: STD_LOGIC;

begin
    RegDst   <=  not(Opcode(5)) and not(Opcode(3));
    ALUOp    <= (not(Opcode(5)) and not(Opcode(3)) and not(Opcode(2))) & Opcode(2);
    ALUSrc   <=      Opcode(0)   or Opcode(3);
    Branch   <=      Opcode(2);
    MemRead  <=  not(Opcode(3)) and Opcode(0);
    MemWrite <=      Opcode(3)  and Opcode(0);
    RegWrite <= (not(Opcode(5))  or not(Opcode(3))) and not(Opcode(2));
    MemtoReg <=      Opcode(0);

    Control <= RegDst & ALUOp & ALUSrc &        -- EX
               Branch & MemRead & MemWrite &    -- MEM
               RegWrite & MemtoReg;             -- WB
end Behavioral;