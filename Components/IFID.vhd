library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IFID is
    port ( -- Fetched Signals
           I_Instr   :  in STD_LOGIC_VECTOR (31 downto 0);
           I_PCPlus4 :  in STD_LOGIC_VECTOR (31 downto 0);

           -- Control
           CLK       :  in STD_LOGIC;
           Enable    :  in STD_LOGIC;
           RST       :  in STD_LOGIC;

           -- Output to ID Phase
           O_Instr   : out STD_LOGIC_VECTOR (31 downto 0);
           O_PCPlus4 : out STD_LOGIC_VECTOR (31 downto 0)
           );
end IFID;

architecture Behavioral of IFID is

signal T_Instr, T_PCPlus4 : STD_LOGIC_VECTOR (31 downto 0);

begin
    process(CLK, RST, Enable)
    begin
        if RST = '1' then
            T_Instr   <= (others => '0');
            T_PCPlus4 <= (others => '0');
        -- Write to the register only on rising edge and enable = 1
        elsif rising_edge(CLK) then
            if Enable = '1' then
                T_Instr   <= I_Instr;
                T_PCPlus4 <= I_PCPlus4;
            end if;
        end if;
    end process;
    
    O_Instr   <= T_Instr;
    O_PCPlus4 <= T_PCPlus4;
end Behavioral;