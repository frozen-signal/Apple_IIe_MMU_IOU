library IEEE;
use IEEE.std_logic_1164.all;

entity VIDEO_ADDR_MUX is
    port (
        PG2_N          : in std_logic;
        EN80VID        : in std_logic;
        HIRESEN_N      : in std_logic;
        VA, VB, VC     : in std_logic;
        Q3_PRAS_N      : in std_logic;
        PRAS_N         : in std_logic;
        P_PHI_1        : in std_logic;
        V0, V1, V2     : in std_logic;
        H0, H1, H2     : in std_logic;
        E0, E1, E2, E3 : in std_logic;

        ZA, ZB, ZC, ZD, ZE : out std_logic;
        RA_ENABLE_N        : out std_logic;
        RA0, RA1, RA2, RA3,
        RA4, RA5, RA6, RA7 : out std_logic
    );
end VIDEO_ADDR_MUX;

architecture RTL of VIDEO_ADDR_MUX is
    signal VID_PG2_N : std_logic;
begin
    -- IOU_2 @C-4:E2-8
    VID_PG2_N <= PG2_N or EN80VID;
    ZA        <= VA when HIRESEN_N = '0' else VID_PG2_N;
    ZB        <= VB when HIRESEN_N = '0' else not VID_PG2_N;
    ZC        <= VC when HIRESEN_N = '0' else '0';
    ZD        <= VID_PG2_N when HIRESEN_N = '0' else '0';
    ZE        <= HIRESEN_N nor VID_PG2_N;

    -- IOU_1 @D-3:A9
    RA_ENABLE_N <= Q3_PRAS_N nand P_PHI_1;

    RA0 <= V2 when PRAS_N = '0' else H0;
    RA1 <= E3 when PRAS_N = '0' else H1;
    RA2 <= ZA when PRAS_N = '0' else H2;
    RA3 <= ZB when PRAS_N = '0' else E0;

    RA4 <= ZC when PRAS_N = '0' else E1;
    RA5 <= ZD when PRAS_N = '0' else E2;
    RA6 <= ZE when PRAS_N = '0' else V0; -- ZE/V1 has been simplified to ZE since boning option 64K is always high
    RA7 <= '0' when PRAS_N = '0' else V1;
end RTL;
