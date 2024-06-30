library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PCUnit is
    port ( -- Control
           CLK     :  in STD_LOGIC;
           Enable  :  in STD_LOGIC;
           RST     :  in STD_LOGIC;

           -- PC Components
           PCIn    :  in STD_LOGIC_VECTOR (31 downto 0);
           PCOut   : out STD_LOGIC_VECTOR (31 downto 0);
           PCPlus4 : out STD_LOGIC_VECTOR (31 downto 0)
           );
end PCUnit;

architecture Behavioral of PCUnit is

signal CurrentPC, NextPC : STD_LOGIC_VECTOR (31 downto 0);

begin
    process(CLK, RST, Enable)
    begin
        if RST = '1' then
            CurrentPC <= (others => '0');
            NextPC    <= (others => '0');
        -- Write onto PC only on rising edge and Enable = 1
        elsif rising_edge(CLK) then
            if Enable = '1' then
                CurrentPC <= PCIn;
                NextPC    <= STD_LOGIC_VECTOR(unsigned(PCIn) + 1);
            end if;
        end if;
    end process;
    PCOut   <= CurrentPC;
    PCPlus4 <= NextPC;
end Behavioral;