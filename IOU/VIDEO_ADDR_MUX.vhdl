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
        RAS_N          : in std_logic;
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
    component RA_MUX is
        port (
            Q3_PRAS_N      : in std_logic;
            PRAS_N         : in std_logic;
            RAS_N          : in std_logic;  -- RAS_N is PRAS_N delayed by t_RAH (for example, t_RAH is 25 ns for the 4564-20 DRAM)
            P_PHI          : in std_logic;
            ROW_RA0, ROW_RA1, ROW_RA2, ROW_RA3,
            ROW_RA4, ROW_RA5, ROW_RA6, ROW_RA7 : in std_logic;
            COL_RA0, COL_RA1, COL_RA2, COL_RA3,
            COL_RA4, COL_RA5, COL_RA6, COL_RA7 : in std_logic;

            RA_ENABLE_N        : out std_logic;
            RA0, RA1, RA2, RA3,
            RA4, RA5, RA6, RA7 : out std_logic
        );
    end component;

    signal VID_PG2_N : std_logic;
    signal ZA_INT, ZB_INT, ZC_INT, ZD_INT, ZE_INT : std_logic;
begin
    IOU_RA_MUX : RA_MUX port map(
        Q3_PRAS_N => Q3_PRAS_N,
        PRAS_N => PRAS_N,
        RAS_N => RAS_N,
        P_PHI => P_PHI_1,

        -- IOU_1 @C-D-3:A9 & B9
        -- The inputs of the LS257 are incorrect on the schematics. Doulble-checked against
        -- "Understanding the Apple IIe" by Jim Sather, p.5-8
        -- and "Apple II reference manual for //e only", p.157
        ROW_RA0 => H0,
        ROW_RA1 => H1,
        ROW_RA2 => H2,
        ROW_RA3 => E0,
        ROW_RA4 => E1,
        ROW_RA5 => E2,
        ROW_RA6 => E3,
        ROW_RA7 => V0,
        COL_RA0 => V1,
        COL_RA1 => V2,
        COL_RA2 => ZA_INT,
        COL_RA3 => ZB_INT,
        COL_RA4 => ZC_INT,
        COL_RA5 => ZD_INT,
        COL_RA6 => ZE_INT, -- ZE/V1 has been simplified to ZE since bonding option 64K is always high
        COL_RA7 => '0',

        RA_ENABLE_N => RA_ENABLE_N,  -- IOU_1 @D-3:A9
        RA0 => RA0,
        RA1 => RA1,
        RA2 => RA2,
        RA3 => RA3,
        RA4 => RA4,
        RA5 => RA5,
        RA6 => RA6,
        RA7 => RA7
    );

    -- IOU_2 @C-4:E2-8
    VID_PG2_N <= PG2_N or EN80VID;
    ZA_INT    <= VA when HIRESEN_N = '0' else VID_PG2_N;
    ZB_INT    <= VB when HIRESEN_N = '0' else not VID_PG2_N;
    ZC_INT    <= VC when HIRESEN_N = '0' else '0';
    ZD_INT    <= VID_PG2_N when HIRESEN_N = '0' else '0';
    ZE_INT    <= HIRESEN_N nor VID_PG2_N; -- IOU_2 @A-4:L9-4

    ZA <= ZA_INT;
    ZB <= ZB_INT;
    ZC <= ZC_INT;
    ZD <= ZD_INT;
    ZE <= ZE_INT;

end RTL;
