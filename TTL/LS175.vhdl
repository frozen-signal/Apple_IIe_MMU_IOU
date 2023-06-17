-- LS175
library IEEE;
use IEEE.std_logic_1164.all;

entity LS175 is
    port (
        CLR_N                  : in std_logic;
        CLK                    : in std_logic;
        D1, D2, D3, D4         : in std_logic;
        Q1, Q2, Q3, Q4         : out std_logic;
        Q1_N, Q2_N, Q3_N, Q4_N : out std_logic
    );
end LS175;

architecture RTL of LS175 is
begin
    process (CLK, CLR_N)
    begin
        if (CLR_N = '0') then
            Q1   <= '0';
            Q2   <= '0';
            Q3   <= '0';
            Q4   <= '0';
            Q1_N <= '1';
            Q2_N <= '1';
            Q3_N <= '1';
            Q4_N <= '1';
        elsif (rising_edge(CLK)) then
            Q1   <= D1;
            Q2   <= D2;
            Q3   <= D3;
            Q4   <= D4;
            Q1_N <= not D1;
            Q2_N <= not D2;
            Q3_N <= not D3;
            Q4_N <= not D4;
        end if;
    end process;
end RTL;
