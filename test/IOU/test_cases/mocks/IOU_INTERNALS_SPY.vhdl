library IEEE;
use IEEE.std_logic_1164.all;
use work.IOU_TESTBENCH_PACKAGE.all;

entity IOU_INTERNALS_SPY is
    port (
        V0, V1, V2, V3, V4, V5 : in std_logic;
        VC                     : in std_logic;
        H2, H3, H4, H5         : in std_logic;
        NTSC                   : in std_logic;
        ITEXT                  : in std_logic;
        R_W_N                  : in std_logic;
        PGR_TXT_N              : in std_logic;
        HIRES                  : in std_logic;
        C01X_N                 : in std_logic;
        C04X_N                 : in std_logic;
        LA0, LA1, LA2, LA3     : in std_logic;
        IKSTRB                 : in std_logic;
        IAKD                   : in std_logic;
        P_PHI_2                : in std_logic;

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
end IOU_INTERNALS_SPY;

architecture SPY of IOU_INTERNALS_SPY is
    component IOU_INTERNALS is
        port (
            V0, V1, V2, V3, V4, V5 : in std_logic;
            VC                     : in std_logic;
            H2, H3, H4, H5         : in std_logic;
            NTSC                   : in std_logic;
            ITEXT                  : in std_logic;
            R_W_N                  : in std_logic;
            PGR_TXT_N              : in std_logic;
            HIRES                  : in std_logic;
            C01X_N                 : in std_logic;
            C04X_N                 : in std_logic;
            LA0, LA1, LA2, LA3     : in std_logic;
            IKSTRB                 : in std_logic;
            IAKD                   : in std_logic;
            P_PHI_2                : in std_logic;

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
    end component;

    signal HBL_INT, VBL_N_INT : std_logic;

begin
    U_IOU_INTERNALS : IOU_INTERNALS port map(
        V0        => V0,
        V1        => V1,
        V2        => V2,
        V3        => V3,
        V4        => V4,
        V5        => V5,
        VC        => VC,
        H2        => H2,
        H3        => H3,
        H4        => H4,
        H5        => H5,
        NTSC      => NTSC,
        ITEXT     => ITEXT,
        R_W_N     => R_W_N,
        PGR_TXT_N => PGR_TXT_N,
        HIRES     => HIRES,
        C01X_N    => C01X_N,
        C04X_N    => C04X_N,
        LA0       => LA0,
        LA1       => LA1,
        LA2       => LA2,
        LA3       => LA3,
        IKSTRB    => IKSTRB,
        IAKD      => IAKD,
        P_PHI_2   => P_PHI_2,
        HIRESEN_N => HIRESEN_N,
        C040_7_N  => C040_7_N,
        HBL       => HBL_INT,
        BL_N      => BL_N,
        VBL_N     => VBL_N_INT,
        V1_N_V5_N => V1_N_V5_N,
        V2_V2_N   => V2_V2_N,
        SERR      => SERR,
        PCLRGAT   => PCLRGAT,
        PSYNC_N   => PSYNC_N,
        KSTRB     => KSTRB,
        AKD       => AKD
    );

    TB_HBL   <= HBL_INT;
    TB_VBL_N <= VBL_N_INT;

    HBL   <= HBL_INT;
    VBL_N <= VBL_N_INT;

end SPY;
