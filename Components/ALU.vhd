library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    port ( A          :  in STD_LOGIC_VECTOR (31 downto 0);
           B          :  in STD_LOGIC_VECTOR (31 downto 0);
           ALUControl :  in STD_LOGIC_VECTOR ( 2 downto 0);
           Result     : out STD_LOGIC_VECTOR (31 downto 0);
           Zero       : out STD_LOGIC
           );
end ALU;

architecture Behavioral of ALU is

signal TEMP : STD_LOGIC_VECTOR (31 downto 0);  -- Temp Signal

begin
    process(ALUControl, A, B)
    begin
        -- ALU Controls
        case ALUControl is
            when "000" =>
                TEMP <= A and B;
            when "001" =>
                TEMP <= A or B;
            when "010" =>
                TEMP <= A + B;
            when "011" =>
                TEMP <= not(A);
            when "100" =>
                TEMP <= A xor B;
            when "110" =>
                TEMP <= A - B;
            when "111" =>
                if A < B then
                    TEMP <= (others => '1');
                else
                    TEMP <= (others => '0');
                end if;
            when others =>
                TEMP <= (others => '1');
        end case;
    end process;

    process(TEMP)
    begin
        -- Zero output is set when result is 0
        if (TEMP = x"00000000") then
            Zero <= '1';
        else
            Zero <= '0';
        end if;
    end process;

    Result <= TEMP;
end Behavioral;
        