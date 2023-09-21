library IEEE;
use IEEE.std_logic_1164.all;

-- NOTE: This implementation of RAS_HOLD_TIME should only be used in simulation.
entity RAS_HOLD_TIME is
    port (
        PRAS_N : in std_logic;

        RAS_N : out std_logic
    );
end RAS_HOLD_TIME;

architecture RTL of RAS_HOLD_TIME is
begin
    RAS_N <= PRAS_N;
end RTL;
