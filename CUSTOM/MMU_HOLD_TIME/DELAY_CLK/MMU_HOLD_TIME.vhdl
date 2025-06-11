--------------------------------------------------------------------------------
-- File: DELAY_CLK\MMU_HOLD_TIME.vhdl
-- Description: An entity that uses a clock to add the hold times. Only to be used when DELAY_CLK is connected to a clock singal.
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
use ieee.numeric_std.all;

-- NOTE: DELAY_NUM_CLK_TICKS have been tuned to be used with a 133 MHz oscillator. The acceptable timing range is pretty wide so, the oscillator don't need
--       to be very precise.
--       See https://github.com/frozen-signal/Apple_IIe_MMU_IOU/blob/master/CUSTOM/MMU_HOLD_TIME/readme.md
entity MMU_HOLD_TIME is
    port (
        DELAY_CLK : in std_logic;
        PHI_0     : in std_logic;

        D_PHI_0 : out std_logic
    );
end MMU_HOLD_TIME;

architecture RTL of MMU_HOLD_TIME is
    constant DELAY_NUM_CLK_TICKS : positive := 3;

    signal SHIFT_REGISTER : unsigned((DELAY_NUM_CLK_TICKS-1) downto 0) := (others => '0');
begin

    process (PHI_0, DELAY_CLK)
    begin
        if (rising_edge(DELAY_CLK)) then
            D_PHI_0 <= SHIFT_REGISTER(DELAY_NUM_CLK_TICKS-1);
            SHIFT_REGISTER <= SHIFT_REGISTER(DELAY_NUM_CLK_TICKS-2 downto 0) & PHI_0;
        end if;
    end process;

end RTL;
