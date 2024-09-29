--------------------------------------------------------------------------------
-- File: VIDEO_GENERATOR.vhdl
-- Description: The generation of several signals used in the display system.
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

entity VIDEO_GENERATOR is
    port (
        PHI_0      : in std_logic;
        PRAS_N     : in std_logic;
        H3, H4, H5 : in std_logic;
        V3, V4     : in std_logic;
        VID6, VID7 : in std_logic;
        LGR_TXT_N  : in std_logic;
        PAYMAR     : in std_logic;
        FLASH      : in std_logic;
        PCLRGAT    : in std_logic;
        PSYNC_N    : in std_logic;
        BL_N       : in std_logic;

        E0, E1, E2, E3 : out std_logic;
        WNDW_N         : out std_logic;
        CLRGAT_N       : out std_logic;
        SYNC_N         : out std_logic;
        RA9_N          : out std_logic;
        RA10_N         : out std_logic
    );
end VIDEO_GENERATOR;

architecture RTL of VIDEO_GENERATOR is
    signal VID6_N : std_logic;
    signal H5_N   : std_logic;
    signal H3_N   : std_logic;
    signal SUMS   : unsigned(3 downto 0);
begin
    H3_N <= not H3;
    H5_N <= not H5;

    -- The schematics seems to have some problems with the computation of Σ0, Σ1, Σ2, and Σ3
    -- Instead we use here what is described in "Understanding the Apple IIe" by Jim Sather, P.5-9:
    --                      1
    --    H5'   H5'   H4   H3
    --  + V4    V3    V4   V3
    --    -------------------
    --    Σ3    Σ2    Σ1   Σ0
    --
    -- In the schematics, the location of these elements are:
    --   * almost all of IOU_1 @D-2
    --   * Σ0: IOU_1 @C-2:J8-8
    --   * Σ1: IOU_1 @C-2:J8-6
    --   * Σ2: IOU_1 @D-1:H8-11
    --   * Σ3: IOU_1 @D-1:H8-6

    SUMS <= ("0001" + (H5_N & H5_N & H4 & H3) + (V4 & V3 & V4 & V3));
    E0   <= SUMS(0); -- SUM-A3
    E1   <= SUMS(1); -- SUM-A4
    E2   <= SUMS(2); -- SUM-A5
    E3   <= SUMS(3); -- SUM-A6

    -- IOU_2 @D-4:L9-1
    VID6_N <= not VID6;
    RA9_N  <= VID6_N nor (not (LGR_TXT_N or PAYMAR or VID7));

    -- IOU_2 @D-4:L8-3
    RA10_N <= (not (VID6_N or PAYMAR or (FLASH or LGR_TXT_N))) or VID7;

    -- IOU_1 @C-3:M8
    process (PHI_0)
    begin
        if (rising_edge(PHI_0)) then
            WNDW_N <= not BL_N;
        end if;
    end process;

    process (PHI_0, PRAS_N)
    begin
        if (PHI_0 = '1' and rising_edge(PRAS_N)) then
            -- IOU_1 @B-2:R7-1
            CLRGAT_N <= not PCLRGAT;

            -- IOU_1 @B-2:R7-15
            SYNC_N <= PSYNC_N;
        end if;
    end process;

end RTL;
