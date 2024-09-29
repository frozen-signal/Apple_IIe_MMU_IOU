--------------------------------------------------------------------------------
-- File: MMU_MD7.vhdl
-- Description: Handling of the MD7 output used to read the soft-switches of the MMU.
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

entity MMU_MD7 is
    port (
        RC01X_N   : in std_logic;
        A         : in std_logic_vector(3 downto 0); -- Address lines A0 to A3
        PHI_0     : in std_logic;
        Q3        : in std_logic;
        PRAS_N    : in std_logic;
        BANK2     : in std_logic;
        RDRAM     : in std_logic;
        FLG1      : in std_logic;
        FLG2      : in std_logic;
        PENIO_N   : in std_logic;
        ALTSTKZP  : in std_logic;
        INTC300_N : in std_logic;
        EN80VID   : in std_logic;

        MD7      : out std_logic;
        ENABLE_N : out std_logic
    );
end MMU_MD7;

architecture RTL of MMU_MD7 is
    signal RC011_RC018_N : std_logic;
begin
    -- There is no definition in the MMU schematics for MD7. The one on IOU_2 at C-2 and D-2 has would have an incorrect enabling signal for the MMU.
    -- The enabling has been based on "Understanding the Apple IIe" by Jim Sather
    -- and confirmed with the circuits around MD7 on the ASIC schematic of the MMU.

    -- LOW on read to C011 - C018
    RC011_RC018_N <= RC01X_N
        or (A(3) and A(2)) or (A(3) and A(1)) or (A(3) and A(0)) or ((not A(3)) and (not A(2)) and (not A(1)) and (not A(0)));

    -- When a soft switch is accessed, MD7 is enabled during PHASE 0 and remains enabled for one 14M cycle into PHASE_1
    ENABLE_N <= RC011_RC018_N or not (PHI_0 or ((not PHI_0) and Q3 and PRAS_N));

    with A select MD7 <=
        BANK2     when x"1",
        RDRAM     when x"2",
        FLG1      when x"3",
        FLG2      when x"4",
        PENIO_N   when x"5",
        ALTSTKZP  when x"6",
        INTC300_N when x"7",
        EN80VID   when x"8",
        '0' when others;
end RTL;
