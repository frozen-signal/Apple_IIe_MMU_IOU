library IEEE;
use IEEE.std_logic_1164.all;
use work.IOU_TESTBENCH_PACKAGE.all;

entity VIDEO_SCANNER_SPY is
    port (
        POC_N   : in std_logic;
        NTSC    : in std_logic;
        P_PHI_2 : in std_logic;

        HPE_N                  : out std_logic;
        V5, V4, V3, V2, V1, V0 : out std_logic;
        VC, VB, VA             : out std_logic;
        H5, H4, H3, H2, H1, H0 : out std_logic;
        PAKST                  : out std_logic;
        TC                     : out std_logic;
        TC14S                  : out std_logic;
        FLASH                  : out std_logic
    );
end VIDEO_SCANNER_SPY;

architecture SPY of VIDEO_SCANNER_SPY is
    component VIDEO_SCANNER is
        port (
            POC_N   : in std_logic;
            NTSC    : in std_logic;
            P_PHI_2 : in std_logic;

            HPE_N                  : out std_logic;
            V5, V4, V3, V2, V1, V0 : out std_logic;
            VC, VB, VA             : out std_logic;
            H5, H4, H3, H2, H1, H0 : out std_logic;
            PAKST                  : out std_logic;
            TC                     : out std_logic;
            TC14S                  : out std_logic;
            FLASH                  : out std_logic
        );
    end component;

    signal TC_INT                                                    : std_logic;
    signal V5_INT, V4_INT, V3_INT, V2_INT, V1_INT, V0_INT            : std_logic;
    signal VC_INT, VB_INT, VA_INT                                    : std_logic;
    signal HPE_N_INT, H5_INT, H4_INT, H3_INT, H2_INT, H1_INT, H0_INT : std_logic;
begin
    U_VIDEO_SCANNER : VIDEO_SCANNER port map(
        POC_N   => POC_N,
        NTSC    => NTSC,
        P_PHI_2 => P_PHI_2,
        HPE_N   => HPE_N_INT,
        V5      => V5_INT,
        V4      => V4_INT,
        V3      => V3_INT,
        V2      => V2_INT,
        V1      => V1_INT,
        V0      => V0_INT,
        VC      => VC_INT,
        VB      => VB_INT,
        VA      => VA_INT,
        H5      => H5_INT,
        H4      => H4_INT,
        H3      => H3_INT,
        H2      => H2_INT,
        H1      => H1_INT,
        H0      => H0_INT,
        PAKST   => PAKST,
        TC      => TC_INT,
        TC14S   => TC14S,
        FLASH   => FLASH
    );

    TB_HPE_N <= HPE_N_INT;
    TB_V5    <= V5_INT;
    TB_V4    <= V4_INT;
    TB_V3    <= V3_INT;
    TB_V2    <= V2_INT;
    TB_V1    <= V1_INT;
    TB_V0    <= V0_INT;
    TB_VC    <= VC_INT;
    TB_VB    <= VB_INT;
    TB_VA    <= VA_INT;
    TB_H5    <= H5_INT;
    TB_H4    <= H4_INT;
    TB_H3    <= H3_INT;
    TB_H2    <= H2_INT;
    TB_H1    <= H1_INT;
    TB_H0    <= H0_INT;
    TB_TC    <= TC_INT;

    HPE_N <= HPE_N_INT;
    V5    <= V5_INT;
    V4    <= V4_INT;
    V3    <= V3_INT;
    V2    <= V2_INT;
    V1    <= V1_INT;
    V0    <= V0_INT;
    VC    <= VC_INT;
    VB    <= VB_INT;
    VA    <= VA_INT;
    H5    <= H5_INT;
    H4    <= H4_INT;
    H3    <= H3_INT;
    H2    <= H2_INT;
    H1    <= H1_INT;
    H0    <= H0_INT;
    TC    <= TC_INT;

end SPY;
