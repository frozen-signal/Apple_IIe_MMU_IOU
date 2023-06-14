library IEEE;
use IEEE.std_logic_1164.all;

entity VIDEO_GENERATOR is
    port (
        P_PHI_1    : in std_logic;
        H3, H4, H5 : in std_logic;
        V3, V4     : in std_logic;
        VID6, VID7 : in std_logic;
        LGR_TXT_N  : in std_logic;
        PAYMAR     : in std_logic;
        FLASH      : in std_logic;
        PCLRGAT    : in std_logic;
        PSYNC_N    : in std_logic;

        E0, E1, E2, E3 : out std_logic;
        CLRGAT_N       : out std_logic;
        SYNC_N         : out std_logic;
        RA9_N          : out std_logic;
        RA10_N         : out std_logic
    );
end VIDEO_GENERATOR;

architecture RTL of VIDEO_GENERATOR is
    signal K8_6   : std_logic;
    signal K8_8   : std_logic;
    signal L9_13  : std_logic;
    signal K8_3   : std_logic;
    signal H8_8   : std_logic;
    signal N7_8   : std_logic;
    signal VID6_N : std_logic;
    signal L6_6   : std_logic;
    signal H5_N   : std_logic;
    signal H3_N   : std_logic;
begin
    H3_N <= not H3;
    H5_N <= not H5;

    -- IOU_1 @D-2
    K8_6  <= H4 nand V4;
    K8_8  <= (H4 or V4) nand K8_6;
    L9_13 <= H3 nor V3;
    K8_3  <= K8_6 nand (L9_13 or K8_8);
    H8_8  <= H5_N xor V3;
    N7_8  <= (H5_N and V3) nor (K8_3 and H8_8);

    E0 <= V3 xor H3_N;          -- IOU_1 @C-2:J8-8
    E1 <= K8_8 xor L9_13;       -- IOU_1 @C-2:J8-6
    E2 <= H8_8 xor K8_3;        -- IOU_1 @D-1:H8-11
    E3 <= (H5 xor V4) xor N7_8; -- IOU_1 @D-1:H8-6

    -- IOU_2 @D-4:L9-1
    VID6_N <= not VID6;
    L6_6   <= not (LGR_TXT_N or PAYMAR or VID7);
    RA9_N  <= VID6_N nor L6_6;

    -- IOU_2 @D-4:L8-3
    RA10_N <= (not (VID6_N or PAYMAR or (FLASH or LGR_TXT_N))) or VID7;

    -- IOU_1 @B-2:R7-1
    process (P_PHI_1, PCLRGAT)
    begin
        if (P_PHI_1 = '1') then
            CLRGAT_N <= PCLRGAT;
        end if;
    end process;

    -- IOU_1 @B-2:R7-15
    process (P_PHI_1, PSYNC_N)
    begin
        if (P_PHI_1 = '1') then
            SYNC_N <= PSYNC_N;
        end if;
    end process;

end RTL;
