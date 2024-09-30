--------------------------------------------------------------------------------
-- File: MMU_EN80.vhdl
-- Description: Handling of the EN80_N signal which indicates that the AUX Card
--              is referenced.
-- Author: frozen-signal
-- Project: Apple_IIe_MMU_IOU
-- Project location: https://github.com/frozen-signal/Apple_IIe_MMU_IOU/
--
-- This work is licensed under the Creative Commons CC0 1.0 Universal license.
-- To view a copy of this license, visit:
-- https://github.com/frozen-signal/Apple_IIe_MMU_IOU/blob/master/LICENSE
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_EN80 is
    port (
        SELMB_N  : in std_logic;
        INH_N    : in std_logic;
        PHI_0    : in std_logic;
        PCASEN_N : in std_logic;
        MPON_N   : in std_logic;

        EN80_N : out std_logic
    );
end MMU_EN80;

architecture RTL of MMU_EN80 is
begin
    -- MMU_2 @C1:C2-11
    -- NOTE: According to the ASIC schematic, EN80_N should be held HIGH during MPON_N.
    EN80_N <= (not MPON_N)                      -- From the ASIC schematic
        or (PHI_0                               -- C2-11
        nand (INH_N                             -- J3-6
            and (PCASEN_N nor (not SELMB_N)))); -- L3-10


end RTL;
