--------------------------------------------------------------------------------
-- File: NOP/DELAY_OSCILLATOR.vhdl
-- Description: An entity that do generate the DELAY_CLK signal using . To be used with testbenches and when the delays are not added through a clock signal.
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

-- NOTE: This implementation of DELAY_OSCILLATOR should only be used with testbenches and when the delays are not added through a clock signal.
entity DELAY_OSCILLATOR is
    port (
        DELAY_CLK : out std_logic
    );
end DELAY_OSCILLATOR;

architecture RTL of DELAY_OSCILLATOR is
begin
    DELAY_CLK <= '0';
end RTL;
