library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IDEX is
    port ( -- ID Control Signals
           I_WB      :  in STD_LOGIC_VECTOR ( 1 downto 0);      -- RegWrite, MemWrite
           I_MEM     :  in STD_LOGIC_VECTOR ( 2 downto 0);      -- Branch, MemRead, MemWrite
           I_EX      :  in STD_LOGIC_VECTOR ( 3 downto 0);      -- RegDst, ALUOp, ALUSrc

           -- Decoded Signals
           I_PCPlus4 :  in STD_LOGIC_VECTOR (31 downto 0);
           I_RD1     :  in STD_LOGIC_VECTOR (31 downto 0);
           I_RD2     :  in STD_LOGIC_VECTOR (31 downto 0);
           I_SignImm :  in STD_LOGIC_VECTOR (31 downto 0);
           I_rt      :  in STD_LOGIC_VECTOR ( 4 downto 0);      -- Instruction[20-16]
           I_rd      :  in STD_LOGIC_VECTOR ( 4 downto 0);      -- Instruction[15-11]

           -- Control
           CLK       :  in STD_LOGIC;
           RST       :  in STD_LOGIC;

           -- EX Control Signals
           RegDst    : out STD_LOGIC;
           ALUSrc    : out STD_LOGIC;
           ALUOp     : out STD_LOGIC_VECTOR ( 1 downto 0);

           -- Output to EX Phase
           O_WB      : out STD_LOGIC_VECTOR ( 1 downto 0);
           O_MEM     : out STD_LOGIC_VECTOR ( 2 downto 0);
           O_PCPlus4 : out STD_LOGIC_VECTOR (31 downto 0);
           O_RD1     : out STD_LOGIC_VECTOR (31 downto 0);
           O_RD2     : out STD_LOGIC_VECTOR (31 downto 0);
           O_SignImm : out STD_LOGIC_VECTOR (31 downto 0);
           O_rt      : out STD_LOGIC_VECTOR ( 4 downto 0);
           O_rd      : out STD_LOGIC_VECTOR ( 4 downto 0)
           );
end IDEX;

architecture Behavioral of IDEX is

signal T_WB      : STD_LOGIC_VECTOR ( 1 downto 0);
signal T_MEM     : STD_LOGIC_VECTOR ( 2 downto 0);
signal T_EX      : STD_LOGIC_VECTOR ( 3 downto 0);
signal T_PCPlus4 : STD_LOGIC_VECTOR (31 downto 0);
signal T_RD1     : STD_LOGIC_VECTOR (31 downto 0);
signal T_RD2     : STD_LOGIC_VECTOR (31 downto 0);
signal T_SignImm : STD_LOGIC_VECTOR (31 downto 0);
signal T_rt      : STD_LOGIC_VECTOR ( 4 downto 0);
signal T_rd      : STD_LOGIC_VECTOR ( 4 downto 0);

begin
    process(CLK, RST)
    begin
        if RST = '1' then
            T_WB      <= (others => '0');
            T_MEM     <= (others => '0');
            T_EX      <= (others => '0');
            T_PCPlus4 <= (others => '0');
            T_RD1     <= (others => '0');
            T_RD2     <= (others => '0');
            T_SignImm <= (others => '0');
            T_rt      <= (others => '0');
            T_rd      <= (others => '0');
        -- Write to the register only during rising edge
        elsif rising_edge(CLK) then
            T_WB      <= I_WB;
            T_MEM     <= I_MEM;
            T_EX      <= I_EX;
            T_PCPlus4 <= I_PCPlus4;
            T_RD1     <= I_RD1;
            T_RD2     <= I_RD2;
            T_SignImm <= I_SignImm;
            T_rt      <= I_rt;
            T_rd      <= I_rd;
        end if;
    end process;

    O_WB      <= T_WB;
    O_MEM     <= T_MEM;
    RegDst    <= T_EX(3);
    ALUOp     <= T_EX(2 downto 1);
    ALUSrc    <= T_EX(0);
    O_PCPlus4 <= T_PCPlus4;
    O_RD1     <= T_RD1;
    O_RD2     <= T_RD2;
    O_SignImm <= T_SignImm;
    O_rt      <= T_rt;
    O_rd      <= T_rd;
end Behavioral; 