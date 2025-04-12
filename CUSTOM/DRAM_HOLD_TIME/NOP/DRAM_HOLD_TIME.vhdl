--------------------------------------------------------------------------------
-- File: NOP/DRAM_HOLD_TIME.vhdl
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

-- NOTE: This implementation of DRAM_HOLD_TIME should only be used when the delays are added externally, and with the testbenches.
entity DRAM_HOLD_TIME is
    port (
        DELAY_CLK : in std_logic; -- Ignored in this implementation
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
