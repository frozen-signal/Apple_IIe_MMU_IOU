library IEEE;
use IEEE.std_logic_1164.all;

-- NOTE: This implementation of MMU_HOLD_TIME should only be used when the delays are added externally, and with the testbenches.
entity MMU_HOLD_TIME is
    port (
        PHI_0 : in std_logic;

        D_PHI_0 : out std_logic
    );
end MMU_HOLD_TIME;

architecture RTL of MMU_HOLD_TIME is
begin
    D_PHI_0 <= PHI_0;
end RTL;
