library IEEE;
use IEEE.std_logic_1164.all;

entity LS174_SINGLE is
    port (
        CLR_N : in std_logic;
        CLK   : in std_logic;
        D     : in std_logic;
        Q     : out std_logic;
        Q_N   : out std_logic
    );
end LS174_SINGLE;

architecture RTL of LS174_SINGLE is
begin
    process (CLK, CLR_N)
    begin
        if (CLR_N = '0') then
            Q   <= '0';
            Q_N <= '1';
        elsif (rising_edge(CLK)) then
            Q   <= D;
            Q_N <= not D;
        end if;
    end process;
end RTL;
