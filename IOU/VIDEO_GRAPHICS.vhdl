--------------------------------------------------------------------------------
-- File: VIDEO_GRAPHICS.vhdl
-- Description: Handling of the signals indicating the segment part of the display
--              address, and the signal handling TEXT/GRAPHICS mode.
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

entity VIDEO_GRAPHICS is
    port (
        PHI_0      : in std_logic;
        V2, V4     : in std_logic;
        VA, VB, VC : in std_logic;
        H0         : in std_logic;
        HIRESEN_N  : in std_logic;
        ITEXT      : in std_logic;
        MIX        : in std_logic;

        PGR_TXT_N        : out std_logic;
        SEGA, SEGB, SEGC : out std_logic;
        LGR_TXT_N        : out std_logic
    );
end VIDEO_GRAPHICS;

architecture RTL of VIDEO_GRAPHICS is
    signal PGR_TXT_N_INT : std_logic;
begin

    process (PHI_0)
    begin
        if (rising_edge(PHI_0)) then
            -- IOU_1 @B-1:R5-12
            PGR_TXT_N_INT <= (MIX and V2 and V4) nor ITEXT;  -- Called GR in "Understanding the Apple IIe" by Jim Sather

            -- IOU_1 @B-2:N6
            -- The value of PGR_TXT_N_INT is GR+1 in "Understanding the Apple IIe" by Jim Sather
            if (PGR_TXT_N_INT = '0') then
                SEGA      <= VA;
                SEGB      <= VB;
            else
                SEGA <= H0;
                SEGB <= HIRESEN_N;
            end if;

            SEGC      <= VC;
            LGR_TXT_N <= PGR_TXT_N_INT;  -- Called GR+2 in "Understanding the Apple IIe" by Jim Sather
        end if;
    end process;

    PGR_TXT_N <= PGR_TXT_N_INT;

end RTL;
