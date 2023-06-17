-- This is a mock component that emulate the HAL timings
library IEEE;
use IEEE.std_logic_1164.all;

entity HAL_TIMING_MOCK is
    port (
        FINISHED : in std_logic;

        CLK_14M  : inout std_logic;
        PHI_0    : out std_logic;
        Q3       : out std_logic;
        RAS_N    : out std_logic
    );
end HAL_TIMING_MOCK;

architecture MOCK of HAL_TIMING_MOCK is
    constant HALF_14M_CYCLE : time := 35 ns;

    signal CLK_COUNTER : integer := 0;
begin
    process begin
        if (CLK_14M = 'U') then
            CLK_14M <= '1';
        else
            CLK_14M <= not CLK_14M;
        end if;
        CLK_COUNTER <= (CLK_COUNTER + 1) mod 14;

        if (CLK_COUNTER <= 6) then
            PHI_0 <= '1';
        else
            PHI_0 <= '0';
        end if;

        if ((CLK_COUNTER mod 7) = 0 or (CLK_COUNTER mod 7) = 6) then
            RAS_N <= '1';
        else
            RAS_N <= '0';
        end if;

        if ((CLK_COUNTER mod 7) >= 0 and (CLK_COUNTER mod 7) < 4) then
            Q3 <= '1';
        else
            Q3 <= '0';
        end if;

        wait for HALF_14M_CYCLE;
        CLK_14M <= not CLK_14M;
        wait for HALF_14M_CYCLE;

        if FINISHED = '1' then
            wait;
        end if;
    end process;
end MOCK;
