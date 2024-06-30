library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX5 is
    port (S :  in STD_LOGIC;
          A :  in STD_LOGIC_VECTOR (4 downto 0);
          B :  in STD_LOGIC_VECTOR (4 downto 0);
          O : out STD_LOGIC_VECTOR (4 downto 0)
          );
end MUX5;

architecture Behavioral of MUX5 is
begin
    process(S, A, B)
    begin
        if S = '0' then
            O <= A;
        else
            O <= B;
        end if;
    end process;
end Behavioral;