library IEEE;
use IEEE.std_logic_1164.all;

-- NOTE: This implementation of DRAM_HOLD_TIME should only be used when the delays are added externally, and with the testbenches.
entity DRAM_HOLD_TIME is
    port (
        PRAS_N : in std_logic;
        Q3     : in std_logic;

        RAS_N      : out std_logic;
        DELAYED_Q3 : out std_logic
    );
end DRAM_HOLD_TIME;

architecture RTL of DRAM_HOLD_TIME is
begin
    RAS_N      <= PRAS_N;
    DELAYED_Q3 <= Q3;
end RTL;
