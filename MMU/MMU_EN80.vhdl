library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_EN80 is
    port (
        SELMB_N  : in std_logic;
        INH_N    : in std_logic;
        PHI_0    : in std_logic;
        PCASEN_N : in std_logic;

        EN80_N : out std_logic
    );
end MMU_EN80;

architecture RTL of MMU_EN80 is
begin
    -- MMU_2 @C1:C2-11
    -- NOTE: According to the ASIC schematic, EN80_N should be held low during MPON_N. Not done because I don't know how this can make sense.
    EN80_N <= PHI_0                            -- C2-11
        nand (INH_N                            -- J3-6
            and (PCASEN_N nor (not SELMB_N))); -- L3-10
end RTL;
