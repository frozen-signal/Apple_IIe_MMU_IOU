-- This is a mock component that emulate the HAL timings
library IEEE;
use IEEE.std_logic_1164.all;

entity HAL_TIMING_MOCK is
    port (
        CLK_14M  : out std_logic;
        PHI_0    : out std_logic;
        Q3       : out std_logic;
        RAS_N    : out std_logic;
        FINISHED : out std_logic
    );
end HAL_TIMING_MOCK;

architecture MOCK of HAL_TIMING_MOCK is
    constant HALF_14M_CYCLE : time := 35 ns;

    signal CLK_COUNTER : integer := 0;
begin
    process begin
        CLK_14M     <= '1' when CLK_14M = 'U' else not CLK_14M;
        CLK_COUNTER <= (CLK_COUNTER + 1) mod 14;

        PHI_0 <= '1' when (CLK_COUNTER <= 6) else '0';
        RAS_N <= '1' when ((CLK_COUNTER mod 7) = 0 or (CLK_COUNTER mod 7) = 6) else '0';
        Q3    <= '1' when ((CLK_COUNTER mod 7) >= 0 and (CLK_COUNTER mod 7) < 4) else '0';

        wait for HALF_14M_CYCLE;
        CLK_14M <= not CLK_14M;
        wait for HALF_14M_CYCLE;

        if FINISHED = '1' then
            wait;
        end if;

    end process;
end MOCK;
