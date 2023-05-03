library IEEE;
use IEEE.std_logic_1164.all;

entity LS74_SINGLE is
    port (
        PRE_N : in std_logic;
        CLR_N : in std_logic;
        CLK   : in std_logic;
        D     : in std_logic;

        Q : out std_logic
    );
end LS74_SINGLE;

architecture BEHAVIORAL of LS74_SINGLE is
begin
    process (CLK, PRE_N, CLR_N)
    begin
        if (PRE_N = '0') then
            Q <= '1';
        elsif (CLR_N = '0') then
            Q <= '0';
        elsif (rising_edge(CLK)) then
            Q <= D;
        end if;
    end process;
end BEHAVIORAL;
