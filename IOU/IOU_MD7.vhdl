--------------------------------------------------------------------------------
-- File: IOU_MD7.vhdl
-- Description: Handling of the MD7 output used to read the soft-switches of the IOU.
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

entity IOU_MD7 is
    port (
        Q3       : in std_logic;
        PHI_0    : in std_logic;
        PRAS_N   : in std_logic;
        KEYLE    : in std_logic;
        POC_N    : in std_logic;
        CLRKEY_N : in std_logic;
        RC00X_N  : in std_logic;
        RC01X_N  : in std_logic;
        LA       : in std_logic_vector(3 downto 0);
        AKD      : in std_logic;
        VBL_N    : in std_logic;
        ITEXT    : in std_logic;
        MIX      : in std_logic;
        PG2      : in std_logic;
        HIRES    : in std_logic;
        PAYMAR   : in std_logic;
        S_80COL  : in std_logic;

        MD7_ENABLE_N : out std_logic;
        MD7          : out std_logic
    );
end IOU_MD7;

architecture RTL of IOU_MD7 is
    signal KEY_S, KEY_R    : std_logic;
    signal KEY             : std_logic;
    signal RC010_N         : std_logic;
    signal XXX9_F_N        : std_logic;
    signal RC019_RC01F_N   : std_logic;
    signal TIMING_ENABLE_N : std_logic;
    signal MD7_C01X        : std_logic;
begin
    -- IOU_1 @A-3:M9-8
    KEY_S <= KEYLE nand POC_N;
    KEY_R <= CLRKEY_N and POC_N;
    process (KEY_S, KEY_R)
    begin
        if (KEY_S = '0' and KEY_R = '1') then
            KEY <= '1';
        elsif (KEY_S = '1' and KEY_R = '0') then
            KEY <= '0';
        end if;
    end process;

    -- The MD7 definition on IOU_2 at C-2 and D-2 have an enabling signal that is correct for a combined IOU-MMU,
    -- but incorrect for just the IOU or just the MMU.
    -- The enabling here has been based on "Understanding the Apple IIe" by Jim Sather.

    RC010_N <= RC01X_N or LA(0) or LA(1) or LA(2) or LA(3);

    XXX9_F_N      <= (not LA(3)) or ((not LA(2)) and (not LA(1)) and (not LA(0)));
    RC019_RC01F_N <= RC01X_N or XXX9_F_N;

    -- The MD7 enable gate is the last three 14M periods of PHASE 0 and the first 14M period of the following PHASE 1
    TIMING_ENABLE_N <= not (((not Q3) and PHI_0) or ((not PHI_0) and Q3 and PRAS_N));

    -- Active-low when in the correct period and any IOU soft switch is read
    MD7_ENABLE_N <= TIMING_ENABLE_N or (RC010_N and RC00X_N and RC019_RC01F_N);

    with (LA) select MD7_C01X <=
        AKD     when x"0",
        VBL_N   when x"9",
        ITEXT   when x"A",
        MIX     when x"B",
        PG2     when x"C",
        HIRES   when x"D",
        PAYMAR  when x"E",
        S_80COL when x"F",
        '0'     when others;

    MD7 <= ((not RC00X_N) and KEY)
        or ((not RC01X_N) and MD7_C01X);
end RTL;
