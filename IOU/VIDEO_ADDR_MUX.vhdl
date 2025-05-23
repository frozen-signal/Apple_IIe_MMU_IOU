--------------------------------------------------------------------------------
-- File: VIDEO_ADDR_MUX.vhdl
-- Description: The MUX for the display address: the enabling and switching
--              between the ROW and COL display address.
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

entity VIDEO_ADDR_MUX is
    port (
        DELAY_CLK      : in std_logic;
        PHI_1          : in std_logic;
        PRAS_N         : in std_logic;
        Q3             : in std_logic;
        PG2_N          : in std_logic;
        EN80VID        : in std_logic;
        HIRESEN_N      : in std_logic;
        VA, VB, VC     : in std_logic;
        V0, V1, V2     : in std_logic;
        H0, H1, H2     : in std_logic;
        E0, E1, E2, E3 : in std_logic;

        RA_ENABLE_N        : out std_logic;
        RA0, RA1, RA2, RA3,
        RA4, RA5, RA6, RA7 : out std_logic
    );
end VIDEO_ADDR_MUX;

architecture RTL of VIDEO_ADDR_MUX is
    component RA_MUX is
        port (
            DELAY_CLK : in std_logic;
            PHI     : in std_logic;
            PRAS_N  : in std_logic;
            Q3      : in std_logic;
            ROW_RA0, ROW_RA1, ROW_RA2, ROW_RA3,
            ROW_RA4, ROW_RA5, ROW_RA6, ROW_RA7 : in std_logic;
            COL_RA0, COL_RA1, COL_RA2, COL_RA3,
            COL_RA4, COL_RA5, COL_RA6, COL_RA7 : in std_logic;

            RA_ENABLE_N : out std_logic;
            RA0, RA1, RA2, RA3,
            RA4, RA5, RA6, RA7 : out std_logic
        );
    end component;

    signal VID_PG2_N : std_logic;
    signal ZA, ZB, ZC, ZD, ZE : std_logic;
begin
    -- IOU_2 @C-4:E2-8
    VID_PG2_N <= PG2_N or EN80VID;
    ZA    <= VA when HIRESEN_N = '0' else VID_PG2_N;
    ZB    <= VB when HIRESEN_N = '0' else not VID_PG2_N;
    ZC    <= VC when HIRESEN_N = '0' else '0';
    ZD    <= VID_PG2_N when HIRESEN_N = '0' else '0';
    ZE    <= HIRESEN_N nor VID_PG2_N; -- IOU_2 @A-4:L9-4

    IOU_RA_MUX : RA_MUX port map(
        DELAY_CLK => DELAY_CLK,
        PHI    => PHI_1,
        PRAS_N => PRAS_N,
        Q3     => Q3,

        -- IOU_1 @C-D-3:A9 & B9
        ROW_RA0 => H0,
        ROW_RA1 => H1,
        ROW_RA2 => H2,
        ROW_RA3 => E0,
        ROW_RA4 => E1,
        ROW_RA5 => E2,
        ROW_RA6 => V0,
        ROW_RA7 => V1,

        COL_RA0 => V2,
        COL_RA1 => E3,
        COL_RA2 => ZA,
        COL_RA3 => ZB,
        COL_RA4 => ZC,
        COL_RA5 => ZD,
        COL_RA6 => ZE, -- ZE/V1 has been simplified to ZE since bonding option 64K is always high
        COL_RA7 => '0',

        RA_ENABLE_N => RA_ENABLE_N,
        RA0 => RA0,
        RA1 => RA1,
        RA2 => RA2,
        RA3 => RA3,
        RA4 => RA4,
        RA5 => RA5,
        RA6 => RA6,
        RA7 => RA7
    );

end RTL;
