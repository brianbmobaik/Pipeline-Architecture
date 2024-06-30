library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
    port ( CLK   :  in STD_LOGIC;
           RST   :  in STD_LOGIC;
           State : out STD_LOGIC_VECTOR ( 3 downto 0 );
           );
end FSM;

architecture Behavioral of FSM is
type phase is (P_IF, P_ID, P_EX, P_MEM, P_WB);   -- (IF, ID, EX, MEM, WB)

signal PST, NXT : phase;

begin
    process (CLK, RST)
    begin
        if RST = '1' then
            PST <= S0;
        elsif rising_edge(CLK) then
            PST <= NXT;
        end if;
    end process;

    process (PST)
    begin
        case PST is
            when S0 =>
end Behavioral;