library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUDecoder is
    port ( FUNCT      :  in STD_LOGIC_VECTOR (5 downto 0); --! Instr[5 : 0]
           ALUOp      :  in STD_LOGIC_VECTOR (1 downto 0); --! From Control Unit
           ALUControl : out STD_LOGIC_VECTOR (2 downto 0)  --! Operation to be performed
           );
end ALUDecoder;

architecture Behavioral of ALUDecoder is
begin
    ALUControl <= (ALUOp(0) or (ALUOp(1) and FUNCT(1))) &   -- B + AE      -> MSB
                  (not(ALUOp(1)) or not(FUNCT(2))) &        -- A' + D'
                  (ALUOp(1) and (FUNCT(3) or FUNCT(0)));    -- A(C + F)    -> LSB
end Behavioral;