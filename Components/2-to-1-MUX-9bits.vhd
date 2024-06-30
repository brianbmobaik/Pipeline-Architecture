library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX9 is
    port (S     :  in STD_LOGIC;
          A     :  in STD_LOGIC_VECTOR (8 downto 0);
          O_EX  : out STD_LOGIC_VECTOR (3 downto 0);
          O_MEM : out STD_LOGIC_VECTOR (2 downto 0);
          O_WB  : out STD_LOGIC_VECTOR (1 downto 0)
          );
end MUX9;

architecture Behavioral of MUX9 is

signal T_EX : STD_LOGIC_VECTOR (3 downto 0);
signal T_MEM : STD_LOGIC_VECTOR (2 downto 0);
signal T_WB : STD_LOGIC_VECTOR (1 downto 0);

begin
    process(S, A)
    begin
        if S = '0' then
            T_EX  <= A(8 downto 5);
            T_MEM <= A(4 downto 2);
            T_WB  <= A(1 downto 0);
        else
            T_EX  <= (others => '0');
            T_MEM <= (others => '0');
            T_WB  <= (others => '0');
        end if;
    end process;
    
    O_EX  <= T_EX;
    O_MEM <= T_MEM;
    O_WB  <= T_WB;
        
end Behavioral;