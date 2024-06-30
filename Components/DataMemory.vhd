library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DataMemory is
    port ( Address   :  in STD_LOGIC_VECTOR (31 downto 0);
           WriteData :  in STD_LOGIC_VECTOR (31 downto 0);
           MemRead   :  in STD_LOGIC;
           MemWrite  :  in STD_LOGIC;
           ReadData  : out STD_LOGIC_VECTOR (31 downto 0)
           );
end DataMemory;

-- MemWrite = '1' Writes data onto Address
-- MemRead  = '1' Reads  data from Address

architecture Behavioral of DataMemory is
type mem_file is array (31 downto 0) of STD_LOGIC_VECTOR (31 downto 0);
signal mem : mem_file := ( x"00000000", x"00000001", x"00000002", x"00000003",
                           x"00000004", x"00000005", x"00000006", x"00000007",
                           x"00000008", x"00000009", x"0000000A", x"0000000B",
                           x"0000000C", x"0000000D", x"0000000E", x"0000000F",
                           x"00000010", x"00000011", x"00000012", x"00000013", 
                           x"00000014", x"00000015", x"00000016", x"00000017",
                           x"00000018", x"00000019", x"0000001A", x"0000001B",
                           x"0000001C", x"0000001D", x"0000001E", x"0000001F"
                        );

begin
    process(MemRead, MemWrite)
    begin
        if MemRead = '1' then
            ReadData <= mem(to_integer(unsigned(Address)));
        elsif MemWrite = '1' then
            mem(to_integer(unsigned(Address))) <= WriteData;
        end if;
    end process;
end Behavioral;