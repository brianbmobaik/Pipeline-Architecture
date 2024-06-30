library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--! @title Forwarding Unit
--! @author Brian Baik
--!
--! {signal: [
--!     { name: "CLK",          wave: 'p.....'},
--!     { name: "ID.rs",        wave: '779===', data: ["00000", "00001", "01010", "10101", "00011"]},
--!     { name: "ID.rt",        wave: '==977=', data: ['11111', '10101', '11000', '10001', '01011']},
--!     { name: "MEM.rd",       wave: '7=97==', data: ['00000', '01001', '11011', '10001', '11001']},
--!     { name: "WB.rd",        wave: '=79=7=', data: ['10100', '00001', '11100', '00110', '01011']},
--!     { name: "MEM.RegWrite", wave: 'hl.hl.'},
--!     { name: "WB.RegWrite",  wave: 'l.hlhl'},
--!     { name: "ForwardA",     wave: '779===', data: ['10', '01', '00', '00', '00']},
--!     { name: "ForwardB",     wave: '==977=', data: ['00', '00', '00', '10', '01']}
--!     ],
--!     config: { hscale: 2},
--!     head: {
--!         text: 'Example Output of Forwarding Unit'
--!     }
--! }

entity ForwardingUnit is
    port ( ID_rs        :  in STD_LOGIC_VECTOR ( 4 downto 0 ); --! ID/EX rs
           ID_rt        :  in STD_LOGIC_VECTOR ( 4 downto 0 ); --! ID/EX rt
           MEM_rd       :  in STD_LOGIC_VECTOR ( 4 downto 0 ); --! EX/MEM rd
           WB_rd        :  in STD_LOGIC_VECTOR ( 4 downto 0 ); --! MEM/WB rd
           MEM_RegWrite :  in STD_LOGIC;                       --! EX/MEM RegWrite
           WB_RegWrite  :  in STD_LOGIC;                       --! MEM/WB RegWrite
           ForwardA     : out STD_LOGIC_VECTOR ( 1 downto 0 ); --! Forwarding bits for SrcA
           ForwardB     : out STD_LOGIC_VECTOR ( 1 downto 0 )  --! Forwarding bits for SrcB
           );
end ForwardingUnit;

architecture Behavioral of ForwardingUnit is
begin
    process(MEM_RegWrite, WB_RegWrite, WB_rd, MEM_rd, ID_rs, ID_rt)
    begin
        if (WB_RegWrite = '1' and WB_rd /= "00000") then
            if WB_rd = ID_rs then
                ForwardA <= "01";
                ForwardB <= "00";
            elsif WB_rd = ID_rt then
                ForwardA <= "00";
                ForwardB <= "01";
            else
                ForwardA <= "00";
                ForwardB <= "00";
            end if;
        elsif (MEM_RegWrite = '1' and MEM_rd /= "00000") and (MEM_rd /= WB_rd) then
            if MEM_rd = ID_rs then
                ForwardA <= "10";
                ForwardB <= "00";
            elsif MEM_rd = ID_rt then
                ForwardA <= "00";
                ForwardB <= "10";
            else
                ForwardA <= "00";
                ForwardB <= "00";
            end if;
        else
            ForwardA <= "00";
            ForwardB <= "00";
        end if;
    end process;
end Behavioral;