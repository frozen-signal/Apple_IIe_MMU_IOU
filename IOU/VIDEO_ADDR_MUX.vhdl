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

    signal ZA_INT, ZB_INT, ZC_INT, ZD_INT, ZE_INT : std_logic;
begin
    -- IOU_2 @C-4:E2-8
    VID_PG2_N <= PG2_N or EN80VID;
    ZA_INT    <= VA when HIRESEN_N = '0' else VID_PG2_N;
    ZB_INT    <= VB when HIRESEN_N = '0' else not VID_PG2_N;
    ZC_INT    <= VC when HIRESEN_N = '0' else '0';
    ZD_INT    <= VID_PG2_N when HIRESEN_N = '0' else '0';
    ZE_INT    <= HIRESEN_N nor VID_PG2_N; -- IOU_2 @A-4:L9-4

    -- IOU_1 @D-3:A9
    RA_ENABLE_N <= Q3_PRAS_N nand P_PHI_1;

    -- IOU_1 @C-D-3:A9 & B9
    -- The inputs of the LS257 are incorrect on the schematics. Doulble-checked against
    -- "Understanding the Apple IIe" by Jim Sather, p.5-8
    -- and "Apple II reference manual for //e only", p.157
    RA0 <= H0 when PRAS_N = '1' else V1;
    RA1 <= H1 when PRAS_N = '1' else V2;
    RA2 <= H2 when PRAS_N = '1' else ZA_INT;
    RA3 <= E0 when PRAS_N = '1' else ZB_INT;

    RA4 <= E1 when PRAS_N = '1' else ZC_INT;
    RA5 <= E2 when PRAS_N = '1' else ZD_INT;
    RA6 <= E3 when PRAS_N = '1' else ZE_INT; -- ZE/V1 has been simplified to ZE since bonding option 64K is always high
    RA7 <= V0 when PRAS_N = '1' else '0';

    ZA <= ZA_INT;
    ZB <= ZB_INT;
    ZC <= ZC_INT;
    ZD <= ZD_INT;
    ZE <= ZE_INT;

end RTL;
