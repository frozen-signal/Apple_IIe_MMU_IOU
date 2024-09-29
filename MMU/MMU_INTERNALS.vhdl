--------------------------------------------------------------------------------
-- File: MMU_INTERNALS.vhdl
-- Description: Handling of several signals that are used internally by the MMU.
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

entity MMU_INTERNALS is
    port (
        C8_FXX  : in std_logic;
        MCFFF_N : in std_logic;
        PHI_1   : in std_logic;
        INTC300 : in std_logic;
        MC00X_N : in std_logic;
        MC01X_N : in std_logic;
        MC3XX   : in std_logic;
        MPON_N  : in std_logic;
        PENIO_N : in std_logic;
        MC0XX_N : in std_logic;

        INTC8EN    : out std_logic;
        INTC8ACC   : out std_logic;
        INTC3ACC_N : out std_logic;
        CENROM1    : out std_logic;
        INTIO_N    : out std_logic
    );
end MMU_INTERNALS;

architecture RTL of MMU_INTERNALS is
    signal L5_6, RSTC8_N               : std_logic;
    signal INTC3ACC_N_INT, INTC8EN_INT : std_logic;
begin

    -- MMU_2 @B-4:C2-3
    INTC3ACC_N_INT <= INTC300 nand MC3XX;

    -- MMU_2 @C-4:F2-5
    L5_6    <= INTC3ACC_N_INT or PHI_1;
    RSTC8_N <= MCFFF_N and MPON_N;
    process (L5_6, RSTC8_N)
    begin
        if (L5_6 = '0') then
            INTC8EN_INT <= '1';
        elsif (RSTC8_N = '0') then
            INTC8EN_INT <= '0';
        end if;
    end process;

    -- MMU_2 @D-4:J3-3
    INTC8ACC <= C8_FXX and INTC8EN_INT;

    -- MMU_2 @C-3:B2-8
    CENROM1 <= PENIO_N and MC0XX_N;

    -- MMU_2 @C-3:J3-11
    -- Note: In the emulator schematic, the output of J3-11 is labeled INTIO. It should be INTIO_N: this signal is active-low when the address is C00X-C01X
    -- The ASIC schematic confirms that this should be INTIO_N.
    INTIO_N <= MC00X_N and MC01X_N;

    INTC3ACC_N <= INTC3ACC_N_INT;
    INTC8EN    <= INTC8EN_INT;
end RTL;
