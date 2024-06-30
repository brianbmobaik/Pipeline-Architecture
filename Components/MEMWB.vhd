library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MEMWB is
    port ( -- MEM Control Signal
           I_WB        : in STD_LOGIC_VECTOR ( 1 downto 0);
           
           -- Memory Signals
           I_ReadData  : in STD_LOGIC_VECTOR (31 downto 0);
           I_ALUResult : in STD_LOGIC_VECTOR (31 downto 0);
           I_rd        : in STD_LOGIC_VECTOR ( 4 downto 0);
           
           -- Control
           CLK         : in STD_LOGIC;
           RST         : in STD_LOGIC;

           -- WB Control Signal
           RegWrite    : out STD_LOGIC;
           MemtoReg    : out STD_LOGIC;

           -- Output to WB Phase
           O_ReadData  : out STD_LOGIC_VECTOR (31 downto 0);
           O_ALUResult : out STD_LOGIC_VECTOR (31 downto 0);
           O_rd        : out STD_LOGIC_VECTOR ( 4 downto 0)
           );
end MEMWB;

architecture Behavioral of MEMWB is

signal T_WB        : STD_LOGIC_VECTOR ( 1 downto 0);
signal T_ReadData  : STD_LOGIC_VECTOR (31 downto 0);
signal T_ALUResult : STD_LOGIC_VECTOR (31 downto 0);
signal T_rd        : STD_LOGIC_VECTOR ( 4 downto 0);

begin
    process(CLK, RST)
    begin
        if RST = '1' then
            T_WB        <= (others => '0');
            T_ReadData  <= (others => '0');
            T_ALUResult <= (others => '0');
            T_rd        <= (others => '0');
        elsif rising_edge(CLK) then
            T_WB        <= I_WB;
            T_ReadData  <= I_ReadData;
            T_ALUResult <= I_ALUResult;
            T_rd        <= I_rd;
        end if;
    end process;
    
    RegWrite    <= T_WB(1);
    MemtoReg    <= T_WB(0);
    O_ReadData  <= T_ReadData;
    O_ALUResult <= T_ALUResult;
    O_rd        <= T_rd;
end Behavioral;