library IEEE;
use IEEE.std_logic_1164.all;

-- NOTE: This implementation of DRAM_HOLD_TIME should only be used when the delays are added externally, and with the testbenches.
entity DRAM_HOLD_TIME is
    port (
        PRAS_N : in std_logic;
        Q3     : in std_logic;

        D_RAS_N : out std_logic;
        D_Q3    : out std_logic
    );
end DRAM_HOLD_TIME;

architecture RTL of DRAM_HOLD_TIME is
begin
    D_RAS_N <= PRAS_N;
    D_Q3 <= Q3;
end RTL;
