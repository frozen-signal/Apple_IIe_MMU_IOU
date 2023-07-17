library IEEE;
use IEEE.std_logic_1164.all;

entity IOU_INTERNALS_TB is
    -- empty
end IOU_INTERNALS_TB;

architecture IOU_INTERNALS_TEST of IOU_INTERNALS_TB is
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

    signal V0, V1, V2, V3, V4, V5 : std_logic;
    signal VC                     : std_logic;
    signal H2, H3, H4, H5         : std_logic;
    signal NTSC                   : std_logic;
    signal ITEXT                  : std_logic;
    signal R_W_N                  : std_logic;
    signal PGR_TXT_N              : std_logic;
    signal HIRES                  : std_logic;
    signal C01X_N                 : std_logic;
    signal C04X_N                 : std_logic;
    signal LA0, LA1, LA2, LA3     : std_logic;
    signal IKSTRB                 : std_logic;
    signal IAKD                   : std_logic;
    signal P_PHI_2                : std_logic;
    signal HIRESEN_N              : std_logic;
    signal C040_7_N               : std_logic;
    signal HBL                    : std_logic;
    signal BL_N                   : std_logic;
    signal VBL_N                  : std_logic;
    signal V1_N_V5_N              : std_logic;
    signal V2_V2_N                : std_logic;
    signal SERR                   : std_logic;
    signal PCLRGAT                : std_logic;
    signal PSYNC_N                : std_logic;
    signal KSTRB                  : std_logic;
    signal AKD                    : std_logic;

begin
    dut : IOU_INTERNALS port map(
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
        HBL       => HBL,
        BL_N      => BL_N,
        VBL_N     => VBL_N,
        V1_N_V5_N => V1_N_V5_N,
        V2_V2_N   => V2_V2_N,
        SERR      => SERR,
        PCLRGAT   => PCLRGAT,
        PSYNC_N   => PSYNC_N,
        KSTRB     => KSTRB,
        AKD       => AKD
    );

    process begin
        IKSTRB  <= '0';
        IAKD    <= '0';
        P_PHI_2 <= '0';
        wait for 1 ns;
        P_PHI_2 <= '1';
        wait for 1 ns;
        P_PHI_2 <= '0';
        wait for 1 ns;
        P_PHI_2 <= '1';
        wait for 1 ns;
        P_PHI_2 <= '0';
        wait for 1 ns;
        P_PHI_2 <= '1';
        wait for 1 ns;
        -- HBL --------------------------------------------
        H3 <= '0';
        H4 <= '0';
        H5 <= '0';
        wait for 1 ns;
        assert(HBL = '1') report "expect HBL to be HIGH" severity error;

        H5 <= '1';
        wait for 1 ns;
        assert(HBL = '0') report "expect HBL to be LOW" severity error;

        H5 <= '0';
        H3 <= '1';
        wait for 1 ns;
        assert(HBL = '1') report "expect HBL to be HIGH" severity error;

        H3 <= '0';
        H4 <= '1';
        wait for 1 ns;
        assert(HBL = '1') report "expect HBL to be HIGH" severity error;

        H3 <= '1';
        H4 <= '1';
        wait for 1 ns;
        assert(HBL = '0') report "expect HBL to be LOW" severity error;

        -- BL_N -------------------------------------------
        V3 <= '0';
        V4 <= '0';
        H3 <= '0';
        H4 <= '0';
        H5 <= '1';
        wait for 1 ns;
        assert(BL_N = '1') report "expect BL_N to be HIGH" severity error;

        V3 <= '1';
        wait for 1 ns;
        assert(BL_N = '1') report "expect BL_N to be HIGH" severity error;

        V4 <= '1';
        wait for 1 ns;
        assert(BL_N = '0') report "expect BL_N to be LOW" severity error;

        V3 <= '0';
        V4 <= '0';
        H3 <= '0';
        H4 <= '0';
        H5 <= '0';
        wait for 1 ns;
        assert(BL_N = '0') report "expect BL_N to be LOW" severity error;

        -- PCLRGAT ---------------------------------------------------------------------
        H2    <= '1';
        H3    <= '1';
        H4    <= '0';
        H5    <= '0';
        ITEXT <= '0';
        wait for 1 ns;
        assert(PCLRGAT = '1') report "expect PCLRGAT to be HIGH" severity error;

        H2    <= '0';
        H3    <= '1';
        H4    <= '0';
        H5    <= '0';
        ITEXT <= '0';
        wait for 1 ns;
        assert(PCLRGAT = '0') report "expect PCLRGAT to be LOW" severity error;

        H2    <= '1';
        H3    <= '0';
        H4    <= '0';
        H5    <= '0';
        ITEXT <= '0';
        wait for 1 ns;
        assert(PCLRGAT = '0') report "expect PCLRGAT to be LOW" severity error;

        H2    <= '1';
        H3    <= '1';
        H4    <= '0';
        H5    <= '1';
        ITEXT <= '0';
        wait for 1 ns;
        assert(PCLRGAT = '0') report "expect PCLRGAT to be LOW" severity error;

        H2    <= '1';
        H3    <= '1';
        H4    <= '0';
        H5    <= '0';
        ITEXT <= '1';
        wait for 1 ns;
        assert(PCLRGAT = '0') report "expect PCLRGAT to be LOW" severity error;

        -- VBL_N --------------------------------------------
        V3 <= '0';
        V4 <= '0';
        wait for 1 ns;
        assert(VBL_N = '1') report "expect VBL_N to be HIGH" severity error;

        V3 <= '1';
        V4 <= '0';
        wait for 1 ns;
        assert(VBL_N = '1') report "expect VBL_N to be HIGH" severity error;

        V3 <= '0';
        V4 <= '1';
        wait for 1 ns;
        assert(VBL_N = '1') report "expect VBL_N to be HIGH" severity error;

        V3 <= '1';
        V4 <= '1';
        wait for 1 ns;
        assert(VBL_N = '0') report "expect VBL_N to be LOW" severity error;

        -- V1_N_V5_N --------------------------------------
        V1   <= '0';
        V5   <= '0';
        NTSC <= '0';
        wait for 1 ns;
        assert(V1_N_V5_N = '1') report "expect V1_N_V5_N to be HIGH" severity error;

        V1   <= '1';
        V5   <= '0';
        NTSC <= '0';
        wait for 1 ns;
        assert(V1_N_V5_N = '1') report "expect V1_N_V5_N to be HIGH" severity error;

        V1   <= '0';
        V5   <= '1';
        NTSC <= '0';
        wait for 1 ns;
        assert(V1_N_V5_N = '0') report "expect V1_N_V5_N to be LOW" severity error;

        V1   <= '1';
        V5   <= '0';
        NTSC <= '1';
        wait for 1 ns;
        assert(V1_N_V5_N = '0') report "expect V1_N_V5_N to be LOW" severity error;

        -- V2_V2_N ----------------------------------------
        NTSC <= '1';
        V2   <= '0';
        wait for 1 ns;
        assert(V2_V2_N = '0') report "expect V2_V2_N to be LOW" severity error;

        NTSC <= '0';
        V2   <= '0';
        wait for 1 ns;
        assert(V2_V2_N = '1') report "expect V2_V2_N to be HIGH" severity error;

        NTSC <= '1';
        V2   <= '1';
        wait for 1 ns;
        assert(V2_V2_N = '1') report "expect V2_V2_N to be HIGH" severity error;

        NTSC <= '0';
        V2   <= '1';
        wait for 1 ns;
        assert(V2_V2_N = '0') report "expect V2_V2_N to be LOW" severity error;

        -- SERR -------------------------------------------
        H3 <= '0';
        H4 <= '0';
        H5 <= '0';
        wait for 1 ns;
        assert(SERR = '1') report "expect SERR to be HIGH" severity error;

        H3 <= '1';
        H4 <= '0';
        H5 <= '0';
        wait for 1 ns;
        assert(SERR = '0') report "expect SERR to be LOW" severity error;

        H3 <= '0';
        H4 <= '1';
        H5 <= '0';
        wait for 1 ns;
        assert(SERR = '0') report "expect SERR to be LOW" severity error;

        H3 <= '0';
        H4 <= '0';
        H5 <= '1';
        wait for 1 ns;
        assert(SERR = '0') report "expect SERR to be LOW" severity error;
        -- PSYNC_N ----------------------------------------
        H3   <= '0';
        H4   <= '0';
        H5   <= '1'; -- HBL 0
        H2   <= '1';
        V1   <= '1';
        V5   <= '0';
        NTSC <= '1'; -- V1_N_V5_N 0
        V2   <= '0'; -- V2_V2_N 0
        V3   <= '0';
        V4   <= '0';
        V0   <= '0';
        VC   <= '1'; -- R9-6 0
        wait for 1 ns;
        assert(PSYNC_N = '1') report "expect PSYNC_N to be HIGH" severity error;

        H3   <= '0';
        H4   <= '0';
        H5   <= '1'; -- HBL 0
        H2   <= '1';
        V1   <= '0';
        V5   <= '1';
        NTSC <= '1'; -- V1_N_V5_N 1
        V2   <= '1'; -- V2_V2_N 1
        V3   <= '1';
        V4   <= '1';
        V0   <= '0';
        VC   <= '0'; -- R9-6 1
        wait for 1 ns;
        assert(PSYNC_N = '0') report "expect PSYNC_N to be HIGH" severity error;

        -- HIRESEN_N --------------------------------------
        PGR_TXT_N <= '0';
        HIRES     <= '0';
        wait for 1 ns;
        assert(HIRESEN_N = '1') report "expect HIRESEN_N to be HIGH" severity error;

        PGR_TXT_N <= '1';
        HIRES     <= '0';
        wait for 1 ns;
        assert(HIRESEN_N = '1') report "expect HIRESEN_N to be HIGH" severity error;

        PGR_TXT_N <= '0';
        HIRES     <= '1';
        wait for 1 ns;
        assert(HIRESEN_N = '1') report "expect HIRESEN_N to be HIGH" severity error;

        PGR_TXT_N <= '1';
        HIRES     <= '1';
        wait for 1 ns;
        assert(HIRESEN_N = '0') report "expect HIRESEN_N to be LOW" severity error;

        -- C040_7_N -----------------------------------------
        C04X_N <= '0';
        LA3    <= '0';
        R_W_N  <= '0';
        wait for 1 ns;
        assert(C040_7_N = '1') report "expect C040_7_N to be HIGH" severity error;

        C04X_N <= '1';
        LA3    <= '0';
        R_W_N  <= '0';
        wait for 1 ns;
        assert(C040_7_N = '1') report "expect C040_7_N to be HIGH" severity error;

        C04X_N <= '1';
        LA3    <= '0';
        R_W_N  <= '1';
        wait for 1 ns;
        assert(C040_7_N = '1') report "expect C040_7_N to be HIGH" severity error;

        C04X_N <= '0';
        LA3    <= '0';
        R_W_N  <= '1';
        wait for 1 ns;
        assert(C040_7_N = '0') report "expect C040_7_N to be LOW" severity error;

        -- IAKD & IKSTRB ----------------------------------
        -- Preload shift registers with 'U'
        IAKD    <= 'U';
        IKSTRB  <= 'U';
        P_PHI_2 <= '0';
        wait for 1 ns;
        P_PHI_2 <= '1';
        wait for 1 ns;
        P_PHI_2 <= '0';
        wait for 1 ns;
        P_PHI_2 <= '1';
        wait for 1 ns;

        -- Shift a 1, then a 0 through AKD & IKSTRB
        P_PHI_2 <= '0';
        wait for 1 ns;

        P_PHI_2 <= '1';
        IAKD    <= '1';
        IKSTRB  <= '1';
        wait for 1 ns;
        assert(AKD = 'U') report "expect AKD to be undefined" severity error;
        assert(KSTRB = 'U') report "expect KSTRB to be undefined" severity error;

        P_PHI_2 <= '0';
        wait for 1 ns;

        P_PHI_2 <= '1';
        IAKD    <= '0';
        IKSTRB  <= '0';
        wait for 1 ns;
        assert(AKD = '1') report "expect AKD to be HIGH" severity error;
        assert(KSTRB = '1') report "expect KSTRB to be HIGH" severity error;

        P_PHI_2 <= '0';
        wait for 1 ns;

        P_PHI_2 <= '1';
        IAKD    <= '0';
        IKSTRB  <= '0';
        wait for 1 ns;
        assert(AKD = '0') report "expect AKD to be LOW" severity error;
        assert(KSTRB = '0') report "expect KSTRB to be LOW" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end IOU_INTERNALS_TEST;
