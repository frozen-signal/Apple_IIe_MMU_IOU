library IEEE;
use IEEE.std_logic_1164.all;

-- NOTE: This implementation of ROMEN_HOLD_TIME should only be used in simulation.
entity ROMEN_HOLD_TIME is
    port (
        PHI_0 : in std_logic;

        DELAYED_PHI_0 : out std_logic
    );
end ROMEN_HOLD_TIME;

architecture RTL of ROMEN_HOLD_TIME is
begin
    DELAYED_PHI_0 <= PHI_0;
end RTL;
