--------------------------------------------------------------------------------
-- File: NOP/MMU_HOLD_TIME.vhdl
-- Description: An entity that do not add the hold times. To be used with testbenches and when the delays are added externally.
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
