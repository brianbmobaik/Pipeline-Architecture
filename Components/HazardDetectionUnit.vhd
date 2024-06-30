library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--! @title Hazard Detection Unit
--! @author Brian Baik
--!
--! {signal: [
--!     { name: "CLK",           wave: 'p.....'},
--!     { node: 'a.bcd.e' },
--!     { name: "IF/ID rs",      wave: '7.===.', data: ["00000", "00001", "01010", "00011"]},
--!     { name: "IF/ID rt",      wave: '=.=97.', data: ['11111', '10101', '11000', '01011']},
--!     { name: "ID/EX rd",      wave: '7.=97.', data: ['00000', '01001', '11000', '01011']},
--!     { name: "ID/EX MemRead", wave: 'h.l.h.'},
--!     {},
--!     { name: "PCWrite",       wave: 'l.h.l.'},
--!     {},
--!     { name: "IFIDWrite",     wave: 'l.h.l.'},
--!     {},
--!     { name: "NOP",           wave: 'h.l.h.'}
--!     ],
--!     config: { hscale: 2},
--!     head: {
--!         text: 'Example Output of Hazard Detection Unit'
--!     },
--!     edge: [ 'a+b 2 CC', 'b+c 1 CC', 'c+d 1 CC', 'd+e 2 CC'
--!     ]
--! }

entity HazardDetectionUnit is
    port ( ID_rs      :  in STD_LOGIC_VECTOR ( 4 downto 0);
           ID_rt      :  in STD_LOGIC_VECTOR ( 4 downto 0);
           EX_rd      :  in STD_LOGIC_VECTOR ( 4 downto 0);
           EX_MemRead :  in STD_LOGIC;
           PCWrite    : out STD_LOGIC;
           IFIDWrite  : out STD_LOGIC;
           NOP        : out STD_LOGIC
           );
end HazardDetectionUnit;

architecture Behavioral of HazardDetectionUnit is

signal T_PCWrite, T_IFIDWrite, T_NOP : STD_LOGIC;

begin
    process(ID_rs, ID_rt, EX_MemRead)
    begin
        -- If hazard is detected
        if (EX_MemRead = '1') AND ((ID_rs = EX_rd) OR (ID_rt = EX_rd)) then
            T_PCWrite   <= '0';   -- Disable write to next PC
            T_IFIDWrite <= '0';   -- Disable Write to IFID Register
            T_NOP       <= '1';   -- Send out NOP Control Bits
        else
            T_PCWrite   <= '1';
            T_IFIDWrite <= '1';
            T_NOP       <= '0';
        end if;
    end process;
    
    PCWrite   <= T_PCWrite;
    IFIDWrite <= T_IFIDWrite;
    NOP       <= T_NOP;
end Behavioral;