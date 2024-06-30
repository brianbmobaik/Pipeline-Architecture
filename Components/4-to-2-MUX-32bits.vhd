library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX42 is
    port (S :  in STD_LOGIC_VECTOR ( 1 downto 0);
          A :  in STD_LOGIC_VECTOR (31 downto 0);
          B :  in STD_LOGIC_VECTOR (31 downto 0);
          C :  in STD_LOGIC_VECTOR (31 downto 0);
          O : out STD_LOGIC_VECTOR (31 downto 0)
          );
end MUX42;

architecture Behavioral of MUX42 is
begin
    process(S, A, B, C)
    begin
        -- From ID/EX
        if S = "00" then
            O <= A;
        -- From MEM/WB
        elsif S = "01" then
            O <= B;
        -- From EX/MEM
        elsif S = "10" then
            O <= C;
        end if;
    end process;
end Behavioral;