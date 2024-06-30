library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Pipeline is
    port ( CLK   : in STD_LOGIC;
           RST   : in STD_LOGIC;
           EndPC : out STD_LOGIC_VECTOR (31 downto 0)
           );
end Pipeline;

architecture Behavioral of Pipeline is
-- IF
signal CurrentPC  : STD_LOGIC_VECTOR (31 downto 0);
signal NextPC     : STD_LOGIC_VECTOR (31 downto 0);
signal IF_PCPlus4 : STD_LOGIC_VECTOR (31 downto 0);
signal IF_Instr   : STD_LOGIC_VECTOR (31 downto 0);
signal PCWrite    : STD_LOGIC;
signal IFIDWrite  : STD_LOGIC;
signal IF_Flush   : STD_LOGIC;

-- ID
signal ID_WB       : STD_LOGIC_VECTOR ( 1 downto 0);
signal ID_MEM      : STD_LOGIC_VECTOR ( 2 downto 0);
signal ID_EX       : STD_LOGIC_VECTOR ( 3 downto 0);
signal ID_rs       : STD_LOGIC_VECTOR ( 4 downto 0);
signal ID_rt       : STD_LOGIC_VECTOR ( 4 downto 0);
signal ID_rd       : STD_LOGIC_VECTOR ( 4 downto 0);
signal ID_PCPlus4  : STD_LOGIC_VECTOR (31 downto 0); 
signal ID_RD1      : STD_LOGIC_VECTOR (31 downto 0); 
signal ID_RD2      : STD_LOGIC_VECTOR (31 downto 0); 
signal ID_SignImm  : STD_LOGIC_VECTOR (31 downto 0);
signal ID_Instr    : STD_LOGIC_VECTOR (31 downto 0);
signal ID_PCBranch : STD_LOGIC_VECTOR (31 downto 0);
signal ID_Zero     : STD_LOGIC;

-- EX
signal EX_WB            : STD_LOGIC_VECTOR ( 1 downto 0);
signal EX_MEM           : STD_LOGIC_VECTOR ( 2 downto 0);
signal IE_rt            : STD_LOGIC_VECTOR ( 4 downto 0);
signal IE_rd            : STD_LOGIC_VECTOR ( 4 downto 0);
signal EX_rd            : STD_LOGIC_VECTOR ( 4 downto 0);
signal EX_PCPlus4       : STD_LOGIC_VECTOR (31 downto 0); 
signal EX_RD1           : STD_LOGIC_VECTOR (31 downto 0);
signal EX_RD2           : STD_LOGIC_VECTOR (31 downto 0);
signal EX_SignImm       : STD_LOGIC_VECTOR (31 downto 0);
signal EX_PCBranch      : STD_LOGIC_VECTOR (31 downto 0);
signal EX_ALUResult     : STD_LOGIC_VECTOR (31 downto 0);
signal EX_WriteData     : STD_LOGIC_VECTOR (31 downto 0);
signal EX_Zero          : STD_LOGIC;

-- MEM
signal MEM_WB        : STD_LOGIC_VECTOR ( 1 downto 0);
signal MEM_PCBranch  : STD_LOGIC_VECTOR (31 downto 0);
signal MEM_ALUResult : STD_LOGIC_VECTOR (31 downto 0);
signal MEM_WriteData : STD_LOGIC_VECTOR (31 downto 0);
signal MEM_ReadData  : STD_LOGIC_VECTOR (31 downto 0);
signal MEM_rd        : STD_LOGIC_VECTOR ( 4 downto 0);
signal MEM_Zero      : STD_LOGIC;

-- WB
signal WB_ReadData  : STD_LOGIC_VECTOR (31 downto 0);
signal WB_ALUResult : STD_LOGIC_VECTOR (31 downto 0);
signal WB_Result    : STD_LOGIC_VECTOR (31 downto 0);
signal WB_rd        : STD_LOGIC_VECTOR ( 4 downto 0);

-- Control Signals
signal Control    : STD_LOGIC_VECTOR (8 downto 0); -- EX, MEM, WB
signal RegDst     : STD_LOGIC;
signal ALUSrc     : STD_LOGIC;
signal Branch     : STD_LOGIC;
signal MemRead    : STD_LOGIC;
signal MemWrite   : STD_LOGIC;
signal RegWrite   : STD_LOGIC;
signal MemtoReg   : STD_LOGIC;
signal ALUOp      : STD_LOGIC_VECTOR (1 downto 0);
signal ALUControl : STD_LOGIC_VECTOR (2 downto 0);
signal PCSrc      : STD_LOGIC;

-- Hazard Detection Unit Select Bit
signal NOP : STD_LOGIC := '0';

-- Forwarding Unit Select Bits
signal ForwardA : STD_LOGIC_VECTOR (1 downto 0);
signal ForwardB : STD_LOGIC_VECTOR (1 downto 0);

-- ALU Sources
signal SrcA : STD_LOGIC_VECTOR (31 downto 0);
signal SrcB : STD_LOGIC_VECTOR (31 downto 0);

begin
    -----------------------------
    -- Instruction Fetch Phase --
    -----------------------------
    -- PC Flip Flop
    process(CLK, RST)
    begin
        if RST = '1' then
            CurrentPC <= (others => '0');
        elsif rising_edge(CLK) then
            if PCWrite = '1' then
                CurrentPC <= NextPC;
            end if;
        end if;
    end process;
    
    -- Next PC
    IF_PCPlus4 <= STD_LOGIC_VECTOR(unsigned(CurrentPC) + 1);

    -- PC Branch MUX
    PCBranch_MUX : entity work.MUX32 port map (PCSrc, IF_PCPlus4, ID_PCBranch, NextPC);

    -- Instruction Memory
    InstructionMemory : entity work.InstructionMemory port map (CurrentPC, IF_Instr);

    -- IF/ID Register
    IFID_Register : entity work.IFID port map (IF_Instr, IF_PCPlus4, CLK, IFIDWrite, RST, ID_Instr, ID_PCPlus4);
    
    ------------------------------
    -- Instruction Decode Phase --
    ------------------------------
    ID_rs <= ID_Instr(25 downto 21);
    ID_rt <= ID_Instr(20 downto 16);
    ID_rd <= ID_Instr(15 downto 11);
    
    -- Branch PC
    ID_PCBranch <= STD_LOGIC_VECTOR(unsigned(ID_PCPlus4) + to_integer(signed(ID_SignImm)));

    -- Control Unit
    ControlUnit : entity work.ControlUnit port map (ID_Instr(31 downto 26), Control);

    -- Hazard Detection Unit
    HazardDetectionUnit : entity work.HazardDetectionUnit port map (ID_rs, ID_rt, EX_rd, EX_MEM(1), PCWrite, IFIDWrite, NOP);

    -- NOP MUX
    NOP_MUX : entity work.MUX9 port map (NOP, Control, ID_EX, ID_MEM, ID_WB);

    -- Register File
    RegisterFile : entity work.RegFile port map (ID_rs, ID_rt, WB_rd, WB_Result, RegWrite, ID_Instr(15 downto 0), CLK,
                                                 ID_SignImm, ID_RD1, ID_RD2);

    -- Check for Branch before EX
    process(ID_RD1, ID_RD2)
    begin
        if ID_RD1 = ID_RD2 then
            ID_Zero <= '1';
        end if;
    end process;
    
    PCSrc <= RST or (ID_Zero and ID_MEM(2));

    -- ID/EX Register
    IDEX_Register : entity work.IDEX port map (ID_WB, ID_MEM, ID_EX, ID_PCPlus4, ID_RD1, ID_RD2,
                                               ID_SignImm, ID_rt, ID_rd, CLK, RST,
                                               RegDst, ALUSrc, ALUOp, EX_WB, EX_MEM, EX_PCPlus4,
                                               EX_RD1, EX_RD2, EX_SignImm, IE_rt, IE_rd);
    -------------------------------
    -- Instruction Execute Phase --
    -------------------------------
    -- Forwarding Unit
    ForwardingUnit : entity work.ForwardingUnit port map (ID_rs, ID_rt, MEM_rd, WB_rd, MEM_WB(1), RegWrite, ForwardA, ForwardB);

    -- Destination Register
    rd_MUX : entity work.MUX5 port map (RegDst, IE_rt, IE_rd, EX_rd);

    -- ALU SrcA
    SrcA_MUX : entity work.MUX42 port map (ForwardA, EX_RD1, WB_Result, MEM_ALUResult, SrcA);

    -- Write Data
    WriteData_MUX : entity work.MUX42 port map (ForwardB, EX_RD2, WB_Result, MEM_ALUResult, EX_WriteData);

    -- ALU SrcB
    SrcB_MUX : entity work.MUX32 port map (ALUSrc, EX_WriteData, EX_SignImm, SrcB);

    -- ALU Decoder
    ALUDecoder : entity work.ALUDecoder port map (EX_SignImm(5 downto 0), ALUOp, ALUControl);

    -- ALU
    ALU : entity work.ALU port map (SrcA, SrcB, ALUControl, EX_ALUResult, EX_Zero);

    -- EX/MEM Register
    EXMEM_Register : entity work.EXMEM port map (EX_WB, EX_MEM, EX_PCBranch, EX_ALUResult, EX_WriteData, EX_rd,
                                                 EX_Zero, CLK, RST, Branch, MemRead, MemWrite,
                                                 MEM_WB, MEM_PCBranch, MEM_ALUResult, MEM_WriteData, MEM_rd, MEM_Zero);

    ------------------------------
    -- Instruction Memory Phase --
    ------------------------------
    -- Data Memory
    DataMemory : entity work.DataMemory port map (MEM_ALUResult, MEM_WriteData, MemRead, MemWrite, MEM_ReadData);

    -- MEM/WB Register
    MEMWB_Register : entity work.MEMWB port map (MEM_WB, MEM_ReadData, MEM_ALUResult, MEM_rd, CLK, RST,
                                                 RegWrite, MemtoReg, WB_ReadData, WB_ALUResult, WB_rd);

    ----------------------------------
    -- Instruction Write Back Phase --
    ----------------------------------
    -- Write Data
    RegWriteData : entity work.MUX32 port map (MemtoReg, WB_ALUResult, WB_ReadData, WB_Result);
    
end Behavioral;