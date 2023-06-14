library IEEE;
use IEEE.std_logic_1164.all;

entity IOU_INTERNALS is
    port (
        V0, V1, V2, V3, V4, V5 : in std_logic;
        VC                     : in std_logic;
        H2, H3, H4, H5         : in std_logic;
        NTSC                   : in std_logic;
        ITEXT                  : in std_logic;
        P_PHI_0                : in std_logic;
        PRAS_N                 : in std_logic;
        R_W_N                  : in std_logic;
        PGR_TXT_N              : in std_logic;
        HIRES                  : in std_logic;
        C01X_N                 : in std_logic;
        C04X_N                 : in std_logic;
        LA0, LA1, LA2, LA3     : in std_logic;
        IKSTRB                 : in std_logic;
        IAKD                   : in std_logic;

        P_PHI_2   : out std_logic;
        HIRESEN_N : out std_logic;
        C040_7_N  : out std_logic;
        HBL       : out std_logic;
        BL_N      : out std_logic;
        VBL_N     : out std_logic;
        V1_N_V5_N : out std_logic;
        V2_V2_N   : out std_logic;
        SERR      : out std_logic;
        PCLRGAT   : out std_logic;
        PSYNC_N   : out std_logic;
        KSTRB     : out std_logic;
        AKD       : out std_logic
    );
end IOU_INTERNALS;

architecture RTL of IOU_INTERNALS is
    signal PAL         : std_logic;
    signal HBL_N       : std_logic;
    signal H2_N, H3_N  : std_logic;
    signal R9_6        : std_logic;
    signal KSTRB_SHIFT : std_logic_vector(1 downto 0) := "00";
    signal AKD_SHIFT   : std_logic_vector(1 downto 0) := "00";
begin
    PAL  <= not NTSC;
    H2_N <= not H2;
    H3_N <= not H3;

    -- IOU_1 @C-1:J6-6
    HBL   <= (H3 and H4) nor H5;
    HBL_N <= not HBL;

    -- IOU_1 @B-1:K6-6
    BL_N <= (V3 and V4) nor HBL;

    -- IOU_1 @C-1:R9-5
    PCLRGAT <= not (H2_N or H3_N or HBL_N or ITEXT);

    --IOU_1 @C-2:M9_3
    VBL_N <= V3 nand V4;

    -- IOU_1 @D-2:N7-6
    V1_N_V5_N <= (V1 and NTSC) nor (V5 and PAL);

    -- IOU_1 @D-2:J8-3
    V2_V2_N <= PAL xor V2;

    -- IOU_1 @D-2:L6-12
    SERR <= not (H3 or H4 or H5);

    --IOU_1 @C-1:J6-8
    R9_6    <= not (VBL_N or V0 or VC or SERR);
    PSYNC_N <= (HBL and H2_N and H3) nor (V1_N_V5_N and V2_V2_N and R9_6);

    -- IOU_1 @C-3:P9-6
    P_PHI_2 <= P_PHI_0 and PRAS_N;

    -- IOU_2 @D-4:E3-3
    HIRESEN_N <= PGR_TXT_N nand HIRES;

    -- IOU_2 @A-3:R3-8
    C040_7_N <= (C04X_N nor LA3) nand R_W_N;

    -- IOU_2 @C-3:R5
    process (P_PHI_2)
    begin
        if (rising_edge(P_PHI_2)) then
            KSTRB_SHIFT(1) <= KSTRB_SHIFT(0);
            KSTRB_SHIFT(0) <= IKSTRB;

            AKD_SHIFT(1) <= AKD_SHIFT(0);
            AKD_SHIFT(0) <= IAKD;
        end if;
    end process;
    KSTRB <= KSTRB_SHIFT(1);
    AKD   <= AKD_SHIFT(1);
end RTL;
