library IEEE;
use IEEE.std_logic_1164.all;

entity IOU is
    port (
        -- IN only
        PHI_0      : in std_logic;
        Q3         : in std_logic;
        PRAS_N     : in std_logic;
        R_W_N      : in std_logic;
        C0XX_N     : in std_logic; -- C0XX_N is always HIGH during PHASE 1 (See Apple IIe board's schematics, page 2, component UB5 (upper right))
        VID6, VID7 : in std_logic;
        A6         : in std_logic;
        IKSTRB     : in std_logic;
        IAKD       : in std_logic;

        -- in/out
        PIN_RESET_N : inout std_logic; -- Tri-state
        ORA6, ORA5, ORA4, ORA3,
        ORA2, ORA1, ORA0 : inout std_logic; -- Tri-state

        -- out only
        ORA7               : out std_logic; -- Tri-state
        H0                 : out std_logic;
        SEGA, SEGB, SEGC   : out std_logic;
        LGR_TXT_N          : out std_logic;
        MD7                : out std_logic; -- Tri-state
        SPKR               : out std_logic;
        CASSO              : out std_logic;
        AN0, AN1, AN2, AN3 : out std_logic;
        S_80COL_N          : out std_logic;
        RA9_N, RA10_N      : out std_logic;
        CLRGAT_N           : out std_logic;
        SYNC_N             : out std_logic;
        WNDW_N             : out std_logic
    );
end IOU;

architecture RTL of IOU is
    constant NTSC : std_logic := '1'; -- FIXME: How should options be handled? Input pin? Leave as constant?

    component COMMON_INTERNALS is
        port (
            R_W_N  : in std_logic;
            C01X_N : in std_logic;
            PRAS_N : in std_logic;
            Q3     : in std_logic;
            PHI_0  : in std_logic;

            RC01X_N   : out std_logic;
            P_PHI_0   : out std_logic;
            P_PHI_1   : out std_logic;
            Q3_PRAS_N : out std_logic
        );
    end component;

    component IOU_TIMINGS is
        port (
            PHI_0   : in std_logic;
            P_PHI_0 : in std_logic;
            PRAS_N  : in std_logic;
            TC14S   : in std_logic;

            P_PHI_2 : out std_logic;
            PHI_1   : out std_logic;
            CTC14S  : out std_logic
        );
    end component;

    component IOU_RESET is
        port (
            PHI_1 : in std_logic;
            TC    : in std_logic;

            -- The IOU will force RESET_N low during power-on;
            -- otherwise RESET_N is driven by the value from the input of the RESET_N pin.
            FORCE_RESET_N_LOW : out std_logic;
            POC               : out std_logic
        );
    end component;

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

    component IOU_INTERNALS is
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
    end component;

    component SOFT_SWITCHES_C00X is
        port (
            D           : in std_logic;
            SWITCH_ADDR : in std_logic_vector(2 downto 0);
            C00X_N      : in std_logic;
            R_W_N       : in std_logic;
            RESET_N     : in std_logic;
            PHI_0       : in std_logic;

            EN80VID   : out std_logic;
            FLG1      : out std_logic;
            FLG2      : out std_logic;
            PENIO_N   : out std_logic;
            ALTSTKZP  : out std_logic;
            INTC300_N : out std_logic;
            INTC300   : out std_logic;
            S_80COL   : out std_logic;
            PAYMAR    : out std_logic
        );
    end component;

    component VIDEO_GRAPHICS is
        port (
            P_PHI_2    : in std_logic;
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
    end component;

    component VIDEO_GENERATOR is
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
    end component;

    component IOU_ADDR_DECODER is
        port (
            C0XX_N : in std_logic;
            LA7    : in std_logic;
            LA4    : in std_logic;
            LA5    : in std_logic;
            A6     : in std_logic;
            Q3     : in std_logic;

            C00X_N : out std_logic;
            C01X_N : out std_logic;
            C02X_N : out std_logic;
            C03X_N : out std_logic;
            C04X_N : out std_logic;
            C05X_N : out std_logic;
            C07X_N : out std_logic
        );
    end component;

    component SOFT_SWITCHES_C05X is
        port (
            D           : in std_logic;
            SWITCH_ADDR : in std_logic_vector(2 downto 0);
            C05X_N      : in std_logic;
            RESET_N     : in std_logic;

            ITEXT : out std_logic;
            MIX   : out std_logic;
            PG2   : out std_logic;
            HIRES : out std_logic;
            AN0   : out std_logic;
            AN1   : out std_logic;
            AN2   : out std_logic;
            AN3   : out std_logic
        );
    end component;

    component VIDEO_ADDR_MUX is
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
    end component;

    component VIDEO_ADDR_LATCH is
        port (
            P_PHI_2 : in std_logic;
            RA0, RA1, RA2, RA3,
            RA4, RA5, RA6 : in std_logic;

            LA0, LA1, LA2, LA3,
            LA4, LA5, LA7 : out std_logic
        );
    end component;

    component IOU_DEVICES is
        port (
            POC_N  : in std_logic;
            C02X_N : in std_logic;
            C03X_N : in std_logic;

            SPKR  : out std_logic;
            CASSO : out std_logic
        );
    end component;

    component IOU_KEYBOARD is
        port (
            P_PHI_2            : in std_logic;
            PAKST              : in std_logic;
            BL_N               : in std_logic;
            KSTRB              : in std_logic;
            AKD                : in std_logic;
            POC_N              : in std_logic;
            CTC14S             : in std_logic;
            LA0, LA1, LA2, LA3 : in std_logic;
            R_W_N              : in std_logic;
            C01X_N             : in std_logic;
            RC01X_N            : in std_logic;

            AKSTB             : out std_logic;
            WNDW_N            : out std_logic;
            D_KSTRB_N         : out std_logic;
            STRBLE_N          : out std_logic;
            CLR_DELAY_N       : out std_logic; -- This signal is P8-8 in the schematics
            SET_DELAY         : out std_logic; -- This signal is N8-4 in the schematics
            AUTOREPEAT_DELAY  : out std_logic; -- This signal is N9-7 in the schematics
            AUTOREPEAT_ACTIVE : out std_logic; -- This is P7-12 in the schematics
            CLRKEY_N          : out std_logic;
            KEYLE             : out std_logic
        );
    end component;

    component IOU_MD7 is
        port (
            Q3                 : in std_logic;
            PHI_0              : in std_logic;
            PRAS_N             : in std_logic;
            KEYLE              : in std_logic;
            POC_N              : in std_logic;
            CLRKEY_N           : in std_logic;
            RC00X_N            : in std_logic;
            RC01X_N            : in std_logic;
            LA3, LA2, LA1, LA0 : in std_logic;
            AKD                : in std_logic;
            VBL_N              : in std_logic;
            ITEXT              : in std_logic;
            MIX                : in std_logic;
            PG2                : in std_logic;
            HIRES              : in std_logic;
            PAYMAR             : in std_logic;
            S_80COL            : in std_logic;

            MD7_ENABLE_N : out std_logic;
            MD7          : out std_logic
        );
    end component;

    signal RC01X_N, P_PHI_0, P_PHI_1, Q3_PRAS_N                                                   : std_logic;
    signal P_PHI_2, PHI_1, CTC14S                                                                 : std_logic;
    signal FORCE_RESET_N_LOW, POC, RESET_N, IN_RESET                                              : std_logic;
    signal HPE_N, V5, V4, V3, V2, V1, V0, VC, VB, VA, H5, H4, H3, H2, H1, PAKST, TC, TC14S, FLASH : std_logic;
    signal HIRESEN_N, C040_7_N, HBL, BL_N, VBL_N, V1_N_V5_N, V2_V2_N, SERR, KSTRB, AKD            : std_logic;
    signal EN80VID, FLG1, FLG2, PENIO_N, ALTSTKZP, INTC300_N, INTC300, S_80COL, PAYMAR            : std_logic;
    signal E0, E1, E2, E3                                                                         : std_logic;
    signal LA0, LA1, LA2, LA3, LA4, LA5, LA7                                                      : std_logic;
    signal C00X_N, C01X_N, C02X_N, C03X_N, C04X_N, C05X_N, C07X_N, RC00X_N                        : std_logic;
    signal ITEXT, MIX, PG2, HIRES                                                                 : std_logic;
    signal MUX_RA0, MUX_RA1, MUX_RA2, MUX_RA3, MUX_RA4, MUX_RA5, MUX_RA6, MUX_RA7                 : std_logic;
    signal IN_RA0, IN_RA1, IN_RA2, IN_RA3, IN_RA4, IN_RA5, IN_RA6, IN_RA7                         : std_logic;
    signal ZA, ZB, ZC, ZD, ZE, RA_ENABLE_N                                                        : std_logic;
    signal MD7_ENABLE_N, UNGATED_MD7, PGR_TXT_N, PCLRGAT, PSYNC_N, POC_N, AKSTB,
    D_KSTRB_N, STRBLE_N, CLR_DELAY_N, SET_DELAY                 : std_logic;
    signal KEYLE, CLRKEY_N, AUTOREPEAT_DELAY, AUTOREPEAT_ACTIVE : std_logic;
begin

    U_COMMON_INTERNALS : COMMON_INTERNALS port map(
        R_W_N     => R_W_N,
        C01X_N    => C01X_N,
        PRAS_N    => PRAS_N,
        Q3        => Q3,
        PHI_0     => PHI_0,
        RC01X_N   => RC01X_N,
        P_PHI_0   => P_PHI_0,
        P_PHI_1   => P_PHI_1,
        Q3_PRAS_N => Q3_PRAS_N
    );

    U_IOU_TIMINGS : IOU_TIMINGS port map(
        PHI_0   => PHI_0,
        P_PHI_0 => P_PHI_0,
        PRAS_N  => PRAS_N,
        TC14S   => TC14S,
        P_PHI_2 => P_PHI_2,
        PHI_1   => PHI_1,
        CTC14S  => CTC14S
    );

    U_IOU_RESET : IOU_RESET port map(
        PHI_1             => PHI_1,
        TC                => TC,
        FORCE_RESET_N_LOW => FORCE_RESET_N_LOW,
        POC               => POC
    );
    IN_RESET    <= PIN_RESET_N;
    RESET_N     <= '0' when FORCE_RESET_N_LOW = '1' else IN_RESET;
    PIN_RESET_N <= '0' when FORCE_RESET_N_LOW = '1' else 'Z';

    POC_N <= POC;
    U_VIDEO_SCANNER : VIDEO_SCANNER port map(
        POC_N   => POC_N,
        NTSC    => NTSC,
        P_PHI_2 => P_PHI_2,
        HPE_N   => HPE_N,
        V5      => V5,
        V4      => V4,
        V3      => V3,
        V2      => V2,
        V1      => V1,
        V0      => V0,
        VC      => VC,
        VB      => VB,
        VA      => VA,
        H5      => H5,
        H4      => H4,
        H3      => H3,
        H2      => H2,
        H1      => H1,
        H0      => H0,
        PAKST   => PAKST,
        TC      => TC,
        TC14S   => TC14S,
        FLASH   => FLASH
    );

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
        P_PHI_0   => P_PHI_0,
        PRAS_N    => PRAS_N,
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

    U_SOFT_SWITCHES_C00X : SOFT_SWITCHES_C00X port map(
        D           => LA0,
        SWITCH_ADDR => LA3 & LA2 & LA1,
        C00X_N      => C00X_N,
        R_W_N       => R_W_N,
        RESET_N     => RESET_N,
        PHI_0       => PHI_0,
        EN80VID     => open,
        FLG1        => open,
        FLG2        => open,
        PENIO_N     => open,
        ALTSTKZP    => open,
        INTC300_N   => open,
        INTC300     => open,
        S_80COL     => S_80COL,
        PAYMAR      => PAYMAR
    );

    U_VIDEO_GRAPHICS : VIDEO_GRAPHICS port map(
        P_PHI_2   => P_PHI_2,
        V2        => V2,
        V4        => V4,
        VA        => VA,
        VB        => VB,
        VC        => VC,
        H0        => H0,
        HIRESEN_N => HIRESEN_N,
        ITEXT     => ITEXT,
        MIX       => MIX,
        PGR_TXT_N => PGR_TXT_N,
        SEGA      => SEGA,
        SEGB      => SEGB,
        SEGC      => SEGC,
        LGR_TXT_N => LGR_TXT_N
    );

    U_VIDEO_GENERATOR : VIDEO_GENERATOR port map(
        P_PHI_1   => P_PHI_1,
        H3        => H3,
        H4        => H4,
        H5        => H5,
        V3        => V3,
        V4        => V4,
        VID6      => VID6,
        VID7      => VID7,
        LGR_TXT_N => LGR_TXT_N,
        PAYMAR    => PAYMAR,
        FLASH     => FLASH,
        PCLRGAT   => PCLRGAT,
        PSYNC_N   => PSYNC_N,
        E0        => E0,
        E1        => E1,
        E2        => E2,
        E3        => E3,
        CLRGAT_N  => CLRGAT_N,
        SYNC_N    => SYNC_N,
        RA9_N     => RA9_N,
        RA10_N    => RA10_N
    );

    IN_RA0 <= ORA0;
    IN_RA1 <= ORA1;
    IN_RA2 <= ORA2;
    IN_RA3 <= ORA3;
    IN_RA4 <= ORA4;
    IN_RA5 <= ORA5;
    IN_RA6 <= ORA6;
    IN_RA7 <= ORA7;
    U_VIDEO_ADDR_LATCH : VIDEO_ADDR_LATCH port map(
        P_PHI_2 => P_PHI_2,
        RA0     => IN_RA0,
        RA1     => IN_RA1,
        RA2     => IN_RA2,
        RA3     => IN_RA3,
        RA4     => IN_RA4,
        RA5     => IN_RA5,
        RA6     => IN_RA6,
        LA0     => LA0,
        LA1     => LA1,
        LA2     => LA2,
        LA3     => LA3,
        LA4     => LA4,
        LA5     => LA5,
        LA7     => LA7
    );

    U_IOU_ADDR_DECODER : IOU_ADDR_DECODER port map(
        C0XX_N => C0XX_N,
        LA7    => LA7,
        LA4    => LA4,
        LA5    => LA5,
        A6     => A6,
        Q3     => Q3,
        C00X_N => C00X_N,
        C01X_N => C01X_N,
        C02X_N => C02X_N,
        C03X_N => C03X_N,
        C04X_N => C04X_N,
        C05X_N => C05X_N,
        C07X_N => C07X_N
    );

    U_SOFT_SWITCHES_C05X : SOFT_SWITCHES_C05X port map(
        D           => LA0,
        SWITCH_ADDR => LA3 & LA2 & LA1,
        C05X_N      => C05X_N,
        RESET_N     => RESET_N,
        ITEXT       => ITEXT,
        MIX         => MIX,
        PG2         => PG2,
        HIRES       => HIRES,
        AN0         => AN0,
        AN1         => AN1,
        AN2         => AN2,
        AN3         => AN3
    );

    U_VIDEO_ADDR_MUX : VIDEO_ADDR_MUX port map(
        PG2_N       => not PG2,
        EN80VID     => EN80VID,
        HIRESEN_N   => HIRESEN_N,
        VA          => VA,
        VB          => VB,
        VC          => VC,
        Q3_PRAS_N   => Q3_PRAS_N,
        PRAS_N      => PRAS_N,
        P_PHI_1     => P_PHI_1,
        V0          => V0,
        V1          => V1,
        V2          => V2,
        H0          => H0,
        H1          => H1,
        H2          => H2,
        E0          => E0,
        E1          => E1,
        E2          => E2,
        E3          => E3,
        ZA          => ZA,
        ZB          => ZB,
        ZC          => ZC,
        ZD          => ZD,
        ZE          => ZE,
        RA_ENABLE_N => RA_ENABLE_N,
        RA0         => MUX_RA0,
        RA1         => MUX_RA1,
        RA2         => MUX_RA2,
        RA3         => MUX_RA3,
        RA4         => MUX_RA4,
        RA5         => MUX_RA5,
        RA6         => MUX_RA6,
        RA7         => MUX_RA7
    );

    ORA0 <= MUX_RA0 when RA_ENABLE_N = '0' else 'Z';
    ORA1 <= MUX_RA1 when RA_ENABLE_N = '0' else 'Z';
    ORA2 <= MUX_RA2 when RA_ENABLE_N = '0' else 'Z';
    ORA3 <= MUX_RA3 when RA_ENABLE_N = '0' else 'Z';
    ORA4 <= MUX_RA4 when RA_ENABLE_N = '0' else 'Z';
    ORA5 <= MUX_RA5 when RA_ENABLE_N = '0' else 'Z';
    ORA6 <= MUX_RA6 when RA_ENABLE_N = '0' else 'Z';
    ORA7 <= MUX_RA7 when RA_ENABLE_N = '0' else 'Z';

    U_IOU_DEVICES : IOU_DEVICES port map(
        POC_N  => POC_N,
        C02X_N => C02X_N,
        C03X_N => C03X_N,
        SPKR   => SPKR,
        CASSO  => CASSO
    );

    U_IOU_KEYBOARD : IOU_KEYBOARD port map(
        P_PHI_2           => P_PHI_2,
        PAKST             => PAKST,
        BL_N              => BL_N,
        KSTRB             => KSTRB,
        AKD               => AKD,
        POC_N             => POC_N,
        CTC14S            => CTC14S,
        LA0               => LA0,
        LA1               => LA1,
        LA2               => LA2,
        LA3               => LA3,
        R_W_N             => R_W_N,
        C01X_N            => C01X_N,
        RC01X_N           => RC01X_N,
        AKSTB             => AKSTB,
        WNDW_N            => WNDW_N,
        D_KSTRB_N         => D_KSTRB_N,
        STRBLE_N          => STRBLE_N,
        CLR_DELAY_N       => CLR_DELAY_N,
        SET_DELAY         => SET_DELAY,
        AUTOREPEAT_DELAY  => AUTOREPEAT_DELAY,
        AUTOREPEAT_ACTIVE => AUTOREPEAT_ACTIVE,
        CLRKEY_N          => CLRKEY_N,
        KEYLE             => KEYLE
    );

    RC00X_N <= (not R_W_N) or C00X_N;
    U_IOU_MD7 : IOU_MD7 port map(
        Q3           => Q3,
        PHI_0        => PHI_0,
        PRAS_N       => PRAS_N,
        KEYLE        => KEYLE,
        POC_N        => POC_N,
        CLRKEY_N     => CLRKEY_N,
        RC00X_N      => RC00X_N,
        RC01X_N      => RC01X_N,
        LA3          => LA3,
        LA2          => LA2,
        LA1          => LA1,
        LA0          => LA0,
        AKD          => AKD,
        VBL_N        => VBL_N,
        ITEXT        => ITEXT,
        MIX          => MIX,
        PG2          => PG2,
        HIRES        => HIRES,
        PAYMAR       => PAYMAR,
        S_80COL      => S_80COL,
        MD7_ENABLE_N => MD7_ENABLE_N,
        MD7          => UNGATED_MD7
    );
    MD7       <= UNGATED_MD7 when MD7_ENABLE_N = '0' else 'Z';
    S_80COL_N <= not S_80COL;
end RTL;
