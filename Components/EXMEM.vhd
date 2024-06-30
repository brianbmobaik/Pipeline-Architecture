library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EXMEM is
    port ( -- EX Control Signals
           I_WB        :  in STD_LOGIC_VECTOR ( 1 downto 0);
           I_MEM       :  in STD_LOGIC_VECTOR ( 2 downto 0);
           
           -- Executed Signals
           I_PCBranch  :  in STD_LOGIC_VECTOR (31 downto 0);
           I_ALUResult :  in STD_LOGIC_VECTOR (31 downto 0);
           I_WriteData :  in STD_LOGIC_VECTOR (31 downto 0);
           I_rd        :  in STD_LOGIC_VECTOR ( 4 downto 0);
           I_Zero      :  in STD_LOGIC;

           -- Control
           CLK         :  in STD_LOGIC;
           RST         :  in STD_LOGIC;

           -- MEM Control Signals
           Branch      : out STD_LOGIC;
           MemRead     : out STD_LOGIC;
           MemWrite    : out STD_LOGIC;

           -- Output to MEM Phase
           O_WB        : out STD_LOGIC_VECTOR ( 1 downto 0);
           O_PCBranch  : out STD_LOGIC_VECTOR (31 downto 0);
           O_ALUResult : out STD_LOGIC_VECTOR (31 downto 0);
           O_WriteData : out STD_LOGIC_VECTOR (31 downto 0);
           O_rd        : out STD_LOGIC_VECTOR ( 4 downto 0);
           O_Zero      : out STD_LOGIC
           );
end EXMEM;

architecture Behavioral of EXMEM is

signal T_WB        : STD_LOGIC_VECTOR ( 1 downto 0);
signal T_MEM       : STD_LOGIC_VECTOR ( 2 downto 0);
signal T_PCBranch  : STD_LOGIC_VECTOR (31 downto 0);
signal T_ALUResult : STD_LOGIC_VECTOR (31 downto 0);
signal T_WriteData : STD_LOGIC_VECTOR (31 downto 0);
signal T_rd        : STD_LOGIC_VECTOR ( 4 downto 0);
signal T_Zero      : STD_LOGIC;

begin
    process(CLK, RST)
    begin
        if RST = '1' then
            T_WB        <= (others => '0');
            T_MEM       <= (others => '0');
            T_PCBranch  <= (others => '0');
            T_ALUResult <= (others => '0');
            T_WriteData <= (others => '0');
            T_rd        <= (others => '0');
            T_Zero      <= '0';
        elsif rising_edge(CLK) then
            T_WB        <= I_WB;
            T_MEM       <= I_MEM;
            T_PCBranch  <= I_PCBranch;
            T_ALUResult <= I_ALUResult;
            T_WriteData <= I_WriteData;
            T_rd        <= I_rd;
            T_Zero      <= I_Zero;
        end if;
    end process;
    
    O_WB        <= T_WB;
    Branch      <= T_MEM(2);
    MemRead     <= T_MEM(1);
    MemWrite    <= T_MEM(0);
    O_PCBranch  <= T_PCBRanch;
    O_ALUResult <= T_ALUResult;
    O_WriteData <= T_WriteData;
    O_rd        <= T_rd;
    O_Zero      <= T_Zero;
end Behavioral;