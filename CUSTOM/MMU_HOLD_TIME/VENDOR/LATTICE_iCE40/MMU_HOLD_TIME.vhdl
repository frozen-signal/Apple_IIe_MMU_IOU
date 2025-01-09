--------------------------------------------------------------------------------
-- File: MMU_HOLD_TIME.vhdl
-- Description: An entity that uses Lattice's SB_HFOSC IP to add the hold times. Only to be used with Lattice iCE40 FPGAs that supports the SB_HFOSC primitive.
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

-- NOTE 1: This implementation of MMU_HOLD_TIME can only be used with Lattice Semiconductors' iCE40 FPGAs that supports the SB_HFOSC primitive.
-- NOTE 2: The timings have been tuned to be used with a 48 MHz oscillator. The acceptable timing range is pretty wide so, the oscillator don't need
--         to be very precise.
--         See https://github.com/frozen-signal/Apple_IIe_MMU_IOU/blob/master/CUSTOM/MMU_HOLD_TIME/readme.md
entity MMU_HOLD_TIME is
    port (
        PHI_0 : in std_logic;

        D_PHI_0 : out std_logic
    );
end MMU_HOLD_TIME;

architecture RTL of MMU_HOLD_TIME is
    constant DELAY_NUM_CLK_TICKS : positive := 2; -- FIXME: Adjust so that the delay is no less that 40ns, and ideally close to 50ns

    component SB_HFOSC
        generic (CLKHF_DIV : string := "0b00");
        port (
                CLKHFEN : in std_logic ;
                CLKHFPU : in std_logic;
                CLKHF : out std_logic
            );
    end component;

    signal DELAY_CLK : std_logic;
    signal SHIFT_REGISTER : unsigned((DELAY_NUM_CLK_TICKS-1) downto 0) := (others => '0');
begin
    U_SB_HFOSC : SB_HFOSC
    generic map (CLKHF_DIV => "0b00")
    port map (
        CLKHFEN  => '1',
        CLKHFPU  => '1',
        CLKHF    => DELAY_CLK
    );

    process (PHI_0, DELAY_CLK)
    begin
        if (rising_edge(DELAY_CLK)) then
            D_PHI_0 <= SHIFT_REGISTER(SHIFT_REGISTER'high);
            SHIFT_REGISTER <= shift_left(SHIFT_REGISTER, 1);
            SHIFT_REGISTER(SHIFT_REGISTER'low) <= PHI_0;
        end if;
    end process;

end RTL;
