--------------------------------------------------------------------------------
-- File: ALTERA/DRAM_HOLD_TIME.vhdl
-- Description: An entity that uses ALTERA LCELL IP to add the hold times. Only to be used with ALTERA devices that support the LCELL primitive.
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

-- NOTE 1: This implementation of DRAM_HOLD_TIME can only be used with Altera devices that support the LCELL primitive.
-- NOTE 2: The timings have been tuned to be used with the EPM7128STC100-10N. Using another device may require
--         changing NUM_LCELLS_RAS and NUM_LCELLS_Q3 below. See https://github.com/frozen-signal/Apple_IIe_MMU_IOU/blob/master/CUSTOM/DRAM_HOLD_TIME/readme.md
entity DRAM_HOLD_TIME is
    port (
        PRAS_N : in std_logic;
        Q3     : in std_logic;

        D_RAS_N : out std_logic;
        D_Q3    : out std_logic
    );
end DRAM_HOLD_TIME;

architecture RTL of DRAM_HOLD_TIME is
    constant NUM_LCELLS_RAS : positive := 14;
    constant NUM_LCELLS_Q3  : positive := 10;

    component LCELL
        port (
            A_IN : in std_logic;
            A_OUT : out std_logic
        );
    end component;

    signal PRAS_N_DELAY     : std_logic_vector((NUM_LCELLS_RAS-1) downto 0);
    signal DELAYED_Q3_DELAY : std_logic_vector(NUM_LCELLS_Q3-1 downto 0);
begin
    -- PRAS_N DELAY -------------------
    INITIAL_RAS_DELAY : LCELL port map(
        A_IN => PRAS_N,
        A_OUT => PRAS_N_DELAY(0)
    );

    g_GENERATE_RAS_DELAY: for i in 0 to (NUM_LCELLS_RAS-2) generate
        DELAY : LCELL port map(
            A_IN => PRAS_N_DELAY(i),
            A_OUT => PRAS_N_DELAY(i+1)
        );
    end generate g_GENERATE_RAS_DELAY;

    D_RAS_N <= PRAS_N_DELAY(NUM_LCELLS_RAS-1);

    -- Q3 DELAY -----------------------
    INITIAL_Q3_DELAY : LCELL port map(
        A_IN => Q3,
        A_OUT => DELAYED_Q3_DELAY(0)
    );

    g_GENERATE_Q3: for i in 0 to (NUM_LCELLS_Q3-2) generate
        DELAY : LCELL port map(
            A_IN => DELAYED_Q3_DELAY(i),
            A_OUT => DELAYED_Q3_DELAY(i+1)
        );
    end generate g_GENERATE_Q3;

    D_Q3 <= DELAYED_Q3_DELAY(NUM_LCELLS_Q3-1);
end RTL;
