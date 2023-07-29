library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- NOTE: This implementation of RAS_HOLD_TIME should only be used in simulation.
entity RAS_HOLD_TIME_TEST is
    port (
        PRAS_N : in std_logic;

        RAS_N : out std_logic
    );
end RAS_HOLD_TIME_TEST;

architecture RTL of RAS_HOLD_TIME_TEST is
begin
    RAS_N <= PRAS_N;
end RTL;
