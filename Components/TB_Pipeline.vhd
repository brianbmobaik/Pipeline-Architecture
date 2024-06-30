library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_Pipeline is
end TB_Pipeline;

architecture Behavioral of TB_Pipeline is
component Pipeline is
    port ( CLK   : in STD_LOGIC;
           RST   : in STD_LOGIC;
           EndPC : out STD_LOGIC_VECTOR (31 downto 0)
           );
end component;

signal clk, rst : STD_LOGIC;
signal pc : STD_LOGIC_VECTOR (31 downto 0);

begin
    dut: Pipeline port map (
            CLK => clk,
            RST => rst,
            EndPC => pc
        );

    clk_process : process
    begin
        clk <= '0'; wait for 25 ns;
        clk <= '1'; wait for 25 ns;
    end process;

    stim_process : process
    begin
        rst <= '1'; wait for 50 ns;
        rst <= '0'; wait;
    end process;
end Behavioral;