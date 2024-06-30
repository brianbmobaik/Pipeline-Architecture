library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MainDecoder is
    port ( Opcode   :  in STD_LOGIC_VECTOR (5 downto 0);
           RegDst   : out STD_LOGIC;
           ALUOp    : out STD_LOGIC_VECTOR (1 downto 0);
           ALUSrc   : out STD_LOGIC;
           Branch   : out STD_LOGIC;
           MemRead  : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           Jump     : out STD_LOGIC
           );
end MainDecoder;
-- Execution/Address Calculation Stage : RegDst, ALUOp1, ALUOp0, ALUSrc
--                 Memory Access Stage : Branch, MemRead, MemWrite
--                    Write-Back Stage : RegWrite, MemtoReg
architecture Behavioral of MainDecoder is
begin
    RegDst   <=  not(Opcode(5));
    ALUOp    <= (not(Opcode(5)) and not(Opcode(2)) ) & Opcode(2);
    ALUSrc   <=      Opcode(0);
    Branch   <=      Opcode(2);
    MemRead  <=  not(Opcode(3)) and Opcode(0);
    MemWrite <=      Opcode(3);
    RegWrite <= (not(Opcode(2)) and not(Opcode(1))) or (not(Opcode(3)) and Opcode(0));
    MemtoReg <=      Opcode(0);
    Jump     <=  not(Opcode(5)) and Opcode(1);
end Behavioral;