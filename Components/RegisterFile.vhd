library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegFile is
    port( A1  :  in STD_LOGIC_VECTOR( 4 downto 0);      -- Instr[25 : 21]
          A2  :  in STD_LOGIC_VECTOR( 4 downto 0);      -- Instr[20 : 16]
          A3  :  in STD_LOGIC_VECTOR( 4 downto 0);      -- Instr[20 : 16] when RegDst = 0; Instr[15 : 11] when RegDst = 1;
          WD3 :  in STD_LOGIC_VECTOR(31 downto 0);
          WE3 :  in STD_LOGIC;
          SEI :  in STD_LOGIC_VECTOR(15 downto 0);      -- Instr[15 : 0]
          CLK :  in STD_LOGIC;
          SEO : out STD_LOGIC_VECTOR(31 downto 0);      -- Sign Extended Immidiate
          RD1 : out STD_LOGIC_VECTOR(31 downto 0);
          RD2 : out STD_LOGIC_VECTOR(31 downto 0)
          );
end RegFile;

architecture Behavioral of RegFile is

type reg_file is array(31 downto 0) of std_logic_vector(31 downto 0);   -- Read/Writeable Registers
signal mem : reg_file := ( x"0000001F", x"0000001E", x"0000001D", x"0000001C",
                           x"0000001B", x"0000001A", x"00000019", x"00000018",
                           x"00000017", x"00000016", x"00000015", x"00000014",
                           x"00000013", x"00000012", x"00000011", x"00000010",
                           x"0000000F", x"0000000E", x"0000000D", x"0000000C",
                           x"0000000B", x"0000000A", x"00000009", x"00000008",
                           x"00000007", x"00000006", x"00000005", x"00000004",
                           x"00000003", x"00000002", x"00000001", x"00000000"
                           );

begin
    process(CLK, WE3, WD3, A1, A2, SEI)
    begin
    -- Register Files are read Immediately
    RD1 <= mem(to_integer(unsigned(A1)));
    RD2 <= mem(to_integer(unsigned(A2)));
    SEO <= STD_LOGIC_VECTOR(resize(signed(SEI),SEO'length));    -- Extends the Signed Immediate to 32 bits
        -- Writing onto the register only happens when...
        if rising_edge(CLK) then                                -- Clock is on rising edge and
            if WE3 = '1' then                                   -- WE3 = 1
                mem(to_integer(unsigned(A3))) <= WD3;
            end if;
        end if;
    end process;
end Behavioral;