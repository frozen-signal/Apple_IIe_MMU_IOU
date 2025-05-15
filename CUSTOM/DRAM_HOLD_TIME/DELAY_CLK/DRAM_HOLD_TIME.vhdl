--------------------------------------------------------------------------------
-- File: DELAY_CLK/DRAM_HOLD_TIME.vhdl
-- Description: An entity that uses a clock to add the hold times. Only to be used when DELAY_CLK is connected to a clock.
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

-- NOTE : The timings have been tuned to be used with a 133 MHz oscillator. The acceptable timing range is pretty wide so, the oscillator don't need
--        to be very precise.
--        See https://github.com/frozen-signal/Apple_IIe_MMU_IOU/blob/master/CUSTOM/DRAM_HOLD_TIME/readme.md
entity DRAM_HOLD_TIME is
    port (
        DELAY_CLK : in std_logic;
        PRAS_N : in std_logic;
        Q3     : in std_logic;

        D_RAS_N : out std_logic;
        D_Q3    : out std_logic
    );
end DRAM_HOLD_TIME;

architecture RTL of DRAM_HOLD_TIME is
    constant DELAY_NUM_CLK_TICKS_RAS : positive := 6;
    constant DELAY_NUM_CLK_TICKS_Q3  : positive := 5;

    signal PRAS_N_SHIFT_REGISTER : unsigned((DELAY_NUM_CLK_TICKS_RAS-1) downto 0) := (others => '0');
    signal Q3_SHIFT_REGISTER : unsigned((DELAY_NUM_CLK_TICKS_Q3-1) downto 0) := (others => '0');
begin
    process (PRAS_N, DELAY_CLK)
    begin
        if (rising_edge(DELAY_CLK)) then
            D_RAS_N <= PRAS_N_SHIFT_REGISTER(DELAY_NUM_CLK_TICKS_RAS-1);
            PRAS_N_SHIFT_REGISTER <= PRAS_N_SHIFT_REGISTER(DELAY_NUM_CLK_TICKS_RAS-2 downto 0) & PRAS_N;
        end if;
    end process;

    process (Q3, DELAY_CLK)
    begin
        if (rising_edge(DELAY_CLK)) then
            D_Q3 <= Q3_SHIFT_REGISTER(DELAY_NUM_CLK_TICKS_Q3-1);
            Q3_SHIFT_REGISTER <= Q3_SHIFT_REGISTER(DELAY_NUM_CLK_TICKS_Q3-2 downto 0) & Q3;
        end if;
    end process;

end RTL;
