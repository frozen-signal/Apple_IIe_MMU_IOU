--------------------------------------------------------------------------------
-- File: NOP\DELAY_OSCILLATOR.vhdl
-- Description: An entity that do not generate the DELAY_CLK. To be used when the delays are generated throught an external oscillator or another way (for example when using LCELLs on an ALTERA device).
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


-- NOTE: This is a no-operation implementation.
entity DELAY_OSCILLATOR is
    port (
        DELAY_CLK : out std_logic
    );
end DELAY_OSCILLATOR;

architecture RTL of DELAY_OSCILLATOR is
begin
    DELAY_CLK <= '0';
end RTL;
