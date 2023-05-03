library IEEE;
use IEEE.std_logic_1164.all;

entity LATCH_9334 is
    port (
        C_N : in std_logic;
        E_N : in std_logic;

        D          : in std_logic;
        A0, A1, A2 : in std_logic;

        Q0, Q1, Q2, Q3,
        Q4, Q5, Q6, Q7 : out std_logic
    );
end LATCH_9334;

architecture RTL of LATCH_9334 is
begin
    process (C_N, E_N, D, A0, A1, A2) begin
        if C_N = '0' then
            -- CLEAR
            -- In the MMU/IOU, the Demultiplexer mode of the 9334 is never used, so it is not implemented here.
            Q0 <= '0';
            Q1 <= '0';
            Q2 <= '0';
            Q3 <= '0';
            Q4 <= '0';
            Q5 <= '0';
            Q6 <= '0';
            Q7 <= '0';
        elsif E_N = '0' then
            -- ADDRESSABLE LATCH (STORE)
            case (A2 & A1 & A0) is
                when "000"  => Q0 <= D;
                when "001"  => Q1 <= D;
                when "010"  => Q2 <= D;
                when "011"  => Q3 <= D;
                when "100"  => Q4 <= D;
                when "101"  => Q5 <= D;
                when "110"  => Q6 <= D;
                when "111"  => Q7 <= D;
                when others => null;
            end case;
        end if;
    end process;
end RTL;
