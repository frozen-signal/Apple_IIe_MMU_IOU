-- MMU
library IEEE;
use IEEE.std_logic_1164.all;

entity MMU is
    port (
        A      : in std_logic_vector(15 downto 0);
        PHI_0  : in std_logic;
        Q3     : in std_logic;
        PRAS_N : in std_logic;
        R_W_N  : in std_logic;
        INH_N  : in std_logic;
        DMA_N  : in std_logic;

        ORA       : out std_logic_vector(7 downto 0); -- Tri-state
        EN80_N    : out std_logic;
        KBD_N     : out std_logic;
        ROMEN1_N  : out std_logic;
        ROMEN2_N  : out std_logic;
        MD7       : out std_logic; -- Tri-state
        R_W_N_245 : out std_logic; -- Also called MD IN/OUT'
        CASEN_N   : out std_logic;
        CXXXOUT   : out std_logic
    );
end MMU;

architecture RTL of MMU is
    -- FIXME: Use generics to switch
    -- component RAS_HOLD_TIME_ALTERA is
    --     port (
    --         PRAS_N : in std_logic;

    --         RAS_N : out std_logic
    --     );
    -- end component;
    component RAS_HOLD_TIME_TEST is
        port (
            PRAS_N : in std_logic;

            RAS_N : out std_logic
        );
    end component;

    component MMU_ADDR_DECODER is
        port (
            A     : in std_logic_vector(15 downto 0);
            PHI_0 : in std_logic;

            CXXX_FXXX : out std_logic;
            FXXX_N    : out std_logic;
            EXXX_N    : out std_logic;
            DXXX_N    : out std_logic;
            CXXX      : out std_logic;
            C8_FXX    : out std_logic;
            C8_FXX_N  : out std_logic;
            C0_7XX_N  : out std_logic;
            E_FXXX_N  : out std_logic;
            D_FXXX    : out std_logic;

            MC0XX_N : out std_logic;
            MC3XX   : out std_logic;
            MC00X_N : out std_logic;
            MC01X_N : out std_logic;
            MC04X_N : out std_logic;
            MC05X_N : out std_logic;
            MC06X_N : out std_logic;
            MC07X_N : out std_logic;
            MCFFF_N : out std_logic;

            PHI_0_7XX   : out std_logic;
            PHI_0_1XX_N : out std_logic;
            S_01XX_N    : out std_logic
        );
    end component;

    component MMU_MPON is
        port (
            A        : in std_logic_vector(15 downto 0);
            S_01XX_N : in std_logic;
            PHI_0    : in std_logic;
            Q3       : in std_logic;

            MPON_N : out std_logic
        );
    end component;

    component DEV_DECODER is
        port (
            A       : in std_logic_vector(15 downto 0);
            PHI_1   : in std_logic;
            MC0XX_N : in std_logic;

            DEV0_N : out std_logic;
            DEV1_N : out std_logic;
            DEV2_N : out std_logic;
            DEV5_N : out std_logic;
            DEV6_N : out std_logic
        );
    end component;

    component MMU_SOFT_SWITCHES_C08X is
        port (
            MPON_N     : in std_logic;
            A0, A1, A3 : in std_logic; -- A0-A1-A3: Not a typo (no A2)
            DEV0_N     : in std_logic;
            R_W_N      : in std_logic;
            IN_FST_ACC : in std_logic;
            IN_WREN    : in std_logic;

            BANK1, BANK2     : out std_logic;
            RDRAM, RDROM     : out std_logic;
            OUT_FST_ACC      : out std_logic;
            WRPROT, OUT_WREN : out std_logic
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

    component MMU_SELMB is
        port (
            A15, A14,
            A13, A10    : in std_logic;
            HIRES       : in std_logic;
            PHI_0_7XX   : in std_logic;
            EN80VID     : in std_logic;
            PG2         : in std_logic;
            FLG1        : in std_logic;
            FLG2        : in std_logic;
            R_W_N       : in std_logic;
            ALTSTKZP    : in std_logic;
            D_FXXX      : in std_logic;
            PHI_0_1XX_N : in std_logic;

            SELMB_N : out std_logic
        );
    end component;

    component MMU_CASEN is
        port (
            RDROM   : in std_logic;
            CXXX    : in std_logic;
            D_FXXX  : in std_logic;
            R_W_N   : in std_logic;
            WRPROT  : in std_logic;
            INH     : in std_logic;
            SELMB_N : in std_logic;
            PHI_0   : in std_logic;
            MPON_N  : in std_logic;

            PCASEN_N : out std_logic;
            OCASEN_N : out std_logic;
            CASEN_N  : out std_logic
        );
    end component;

    component MMU_INTERNALS is
        port (
            C8_FXX  : in std_logic;
            MCFFF_N : in std_logic;
            PHI_1   : in std_logic;
            INTC300 : in std_logic;
            MC00X_N : in std_logic;
            MC01X_N : in std_logic;
            MC3XX   : in std_logic;
            MPON_N  : in std_logic;
            PENIO_N : in std_logic;
            MC0XX_N : in std_logic;

            INTC8EN    : out std_logic;
            INTC8ACC   : out std_logic;
            INTC3ACC_N : out std_logic;
            CENROM1    : out std_logic;
            INTIO_N    : out std_logic
        );
    end component;

    component MMU_CXXXOUT is
        port (
            CENROM1    : in std_logic;
            INTC8ACC   : in std_logic;
            INTC3ACC_N : in std_logic;
            CXXX       : in std_logic;

            CXXXOUT_N : out std_logic
        );
    end component;

    component MMU_RW245 is
        port (
            INTIO_N   : in std_logic;
            CXXXOUT_N : in std_logic;
            R_W_N     : in std_logic;
            DMA_N     : in std_logic;
            INH_N     : in std_logic;
            PHI_0     : in std_logic;

            R_W_N_245 : out std_logic
        );
    end component;

    component MMU_ROMEN is
        port (
            PHI_0      : in std_logic;
            INTC8ACC   : in std_logic;
            INTC3ACC_N : in std_logic;
            CXXX       : in std_logic;
            DXXX_N     : in std_logic;
            E_FXXX_N   : in std_logic;
            INH        : in std_logic;
            RDROM      : in std_logic;
            CENROM1    : in std_logic;
            R_W_N      : in std_logic;

            ROMEN2_N : out std_logic;
            ROMEN1_N : out std_logic
        );
    end component;

    component MMU_MD7 is
        port (
            RC01X_N   : in std_logic;
            A         : in std_logic_vector(3 downto 0); -- Address lines A0 to A3
            PHI_0     : in std_logic;
            Q3        : in std_logic;
            PRAS_N    : in std_logic;
            BANK2     : in std_logic;
            RDRAM     : in std_logic;
            FLG1      : in std_logic;
            FLG2      : in std_logic;
            PENIO_N   : in std_logic;
            ALTSTKZP  : in std_logic;
            INTC300_N : in std_logic;
            EN80VID   : in std_logic;

            MD7      : out std_logic;
            ENABLE_N : out std_logic
        );
    end component;

    component MMU_EN80 is
        port (
            SELMB_N  : in std_logic;
            INH_N    : in std_logic;
            PHI_0    : in std_logic;
            PCASEN_N : in std_logic;

            EN80_N : out std_logic
        );
    end component;

    component MMU_KBD is
        port (
            INTIO_N : in std_logic;
            R_W_N   : in std_logic;
            PHI_1   : in std_logic;

            KBD_N : out std_logic
        );
    end component;

    component MMU_RA is
        port (
            A         : in std_logic_vector(15 downto 0);
            PRAS_N    : in std_logic;
            RAS_N     : in std_logic;
            P_PHI_0   : in std_logic;
            Q3_PRAS_N : in std_logic;
            DXXX_N    : in std_logic;
            BANK1     : in std_logic;

            RA          : out std_logic_vector(7 downto 0);
            RA_ENABLE_N : out std_logic
        );
    end component;

    signal RAS_N : std_logic;
    signal PHI_1, INH                                                                            : std_logic;
    signal CXXX_FXXX, FXXX_N, EXXX_N, DXXX_N, CXXX, C8_FXX, C8_FXX_N, C0_7XX_N, E_FXXX_N, D_FXXX : std_logic;
    signal MC0XX_N, MC3XX, MC00X_N, MC01X_N, MC04X_N, MC05X_N, MC06X_N, MC07X_N, MCFFF_N         : std_logic;
    signal PHI_0_7XX, PHI_0_1XX_N, S_01XX_N                                                      : std_logic;
    signal DEV0_N                                                                                : std_logic;
    signal MPON_N                                                                                : std_logic;
    signal BANK1, BANK2, RDRAM, RDROM, OUT_FST_ACC, WRPROT, OUT_WREN                             : std_logic;
    signal EN80VID, FLG1, FLG2, PENIO_N, ALTSTKZP, INTC300_N, INTC300                            : std_logic;
    signal PG2, HIRES                                                                            : std_logic;
    signal RC01X_N, P_PHI_0, P_PHI_1, Q3_PRAS_N                                                  : std_logic;
    signal SELMB_N                                                                               : std_logic;
    signal PCASEN_N, OCASEN_N                                                                    : std_logic;
    signal INTC8EN, INTC8ACC, INTC3ACC_N, CENROM1, INTIO_N                                       : std_logic;
    signal CXXXOUT_N                                                                             : std_logic;
    signal UNGATED_MD7, MD7_ENABLE_N                                                             : std_logic;
    signal UNGATED_RA                                                                            : std_logic_vector(7 downto 0);
    signal RA_ENABLE_N                                                                           : std_logic;

begin
    PHI_1 <= not PHI_0;
    INH   <= not INH_N;

    -- U_RAS_HOLD_TIME : RAS_HOLD_TIME_ALTERA port map(
    --     PRAS_N => PRAS_N,
    --     RAS_N => RAS_N
    -- );
    U_RAS_HOLD_TIME : RAS_HOLD_TIME_TEST port map(
        PRAS_N => PRAS_N,
        RAS_N => RAS_N
    );

    U_ADDR_DECODER : MMU_ADDR_DECODER port map(
        A           => A,
        PHI_0       => PHI_0,
        CXXX_FXXX   => CXXX_FXXX,
        FXXX_N      => FXXX_N,
        EXXX_N      => EXXX_N,
        DXXX_N      => DXXX_N,
        CXXX        => CXXX,
        C8_FXX      => C8_FXX,
        C8_FXX_N    => C8_FXX_N,
        C0_7XX_N    => C0_7XX_N,
        E_FXXX_N    => E_FXXX_N,
        D_FXXX      => D_FXXX,
        MC0XX_N     => MC0XX_N,
        MC3XX       => MC3XX,
        MC00X_N     => MC00X_N,
        MC01X_N     => MC01X_N,
        MC04X_N     => MC04X_N,
        MC05X_N     => MC05X_N,
        MC06X_N     => MC06X_N,
        MC07X_N     => MC07X_N,
        MCFFF_N     => MCFFF_N,
        PHI_0_7XX   => PHI_0_7XX,
        PHI_0_1XX_N => PHI_0_1XX_N,
        S_01XX_N    => S_01XX_N
    );

    U_MMU_MPON : MMU_MPON port map(
        A        => A,
        S_01XX_N => S_01XX_N,
        PHI_0    => PHI_0,
        Q3       => Q3,
        MPON_N   => MPON_N
    );

    U_DEV_DECODER : DEV_DECODER port map(
        A       => A,
        PHI_1   => PHI_1,
        MC0XX_N => MC0XX_N,
        DEV0_N  => DEV0_N,
        DEV1_N  => open,
        DEV2_N  => open,
        DEV5_N  => open,
        DEV6_N  => open
    );

    U_MMU_SOFT_SWITCHES_C08X : MMU_SOFT_SWITCHES_C08X port map(
        MPON_N     => MPON_N,
        A0         => A(0),
        A1         => A(1),
        A3         => A(3),
        DEV0_N     => DEV0_N,
        R_W_N      => R_W_N,
        IN_FST_ACC => OUT_FST_ACC,
        IN_WREN    => OUT_WREN,

        BANK1       => BANK1,
        BANK2       => BANK2,
        RDRAM       => RDRAM,
        RDROM       => RDROM,
        OUT_FST_ACC => OUT_FST_ACC,
        WRPROT      => WRPROT,
        OUT_WREN    => OUT_WREN
    );

    U_SOFT_SWITCHES_C00X : SOFT_SWITCHES_C00X port map(
        D           => A(0),
        SWITCH_ADDR => A(3 downto 1),
        C00X_N      => MC00X_N,
        R_W_N       => R_W_N,
        RESET_N     => MPON_N,
        PHI_0       => PHI_0,

        EN80VID   => EN80VID,
        FLG1      => FLG1,
        FLG2      => FLG2,
        PENIO_N   => PENIO_N,
        ALTSTKZP  => ALTSTKZP,
        INTC300_N => INTC300_N,
        INTC300   => INTC300,
        S_80COL   => open,
        PAYMAR    => open
    );

    U_SOFT_SWITCHES_C05X : SOFT_SWITCHES_C05X port map(
        D           => A(0),
        SWITCH_ADDR => A(3 downto 1),
        C05X_N      => MC05X_N,
        RESET_N     => MPON_N,

        ITEXT => open,
        MIX   => open,
        PG2   => PG2,
        HIRES => HIRES,
        AN0   => open,
        AN1   => open,
        AN2   => open,
        AN3   => open
    );

    U_COMMON_INTERNALS : COMMON_INTERNALS port map(
        R_W_N  => R_W_N,
        C01X_N => MC01X_N,
        PRAS_N => PRAS_N,
        Q3     => Q3,
        PHI_0  => PHI_0,

        RC01X_N   => RC01X_N,
        P_PHI_0   => P_PHI_0,
        P_PHI_1   => P_PHI_1,
        Q3_PRAS_N => Q3_PRAS_N
    );

    U_MMU_SELMB : MMU_SELMB port map(
        A15         => A(15),
        A14         => A(14),
        A13         => A(13),
        A10         => A(10),
        HIRES       => HIRES,
        PHI_0_7XX   => PHI_0_7XX,
        EN80VID     => EN80VID,
        PG2         => PG2,
        FLG1        => FLG1,
        FLG2        => FLG2,
        R_W_N       => R_W_N,
        ALTSTKZP    => ALTSTKZP,
        D_FXXX      => D_FXXX,
        PHI_0_1XX_N => PHI_0_1XX_N,
        SELMB_N     => SELMB_N
    );

    UMMU_CASEN : MMU_CASEN port map(
        RDROM    => RDROM,
        CXXX     => CXXX,
        D_FXXX   => D_FXXX,
        R_W_N    => R_W_N,
        WRPROT   => WRPROT,
        INH      => INH,
        SELMB_N  => SELMB_N,
        PHI_0    => PHI_0,
        MPON_N   => MPON_N,
        PCASEN_N => PCASEN_N,
        OCASEN_N => OCASEN_N,
        CASEN_N  => CASEN_N
    );

    UMMU_INTERNALS : MMU_INTERNALS port map(
        C8_FXX     => C8_FXX,
        MCFFF_N    => MCFFF_N,
        PHI_1      => PHI_1,
        INTC300    => INTC300,
        MC00X_N    => MC00X_N,
        MC01X_N    => MC01X_N,
        MC3XX      => MC3XX,
        MPON_N     => MPON_N,
        PENIO_N    => PENIO_N,
        MC0XX_N    => MC0XX_N,
        INTC8EN    => INTC8EN,
        INTC8ACC   => INTC8ACC,
        INTC3ACC_N => INTC3ACC_N,
        CENROM1    => CENROM1,
        INTIO_N    => INTIO_N
    );

    U_MMU_CXXXOUT : MMU_CXXXOUT port map(
        CENROM1    => CENROM1,
        INTC8ACC   => INTC8ACC,
        INTC3ACC_N => INTC3ACC_N,
        CXXX       => CXXX,
        CXXXOUT_N  => CXXXOUT_N
    );
    CXXXOUT <= not CXXXOUT_N;

    U_MMU_RW245 : MMU_RW245 port map(
        INTIO_N   => INTIO_N,
        CXXXOUT_N => CXXXOUT_N,
        R_W_N     => R_W_N,
        DMA_N     => DMA_N,
        INH_N     => INH_N,
        PHI_0     => PHI_0,
        R_W_N_245 => R_W_N_245
    );

    U_MMU_ROMEN : MMU_ROMEN port map(
        PHI_0      => PHI_0,
        INTC8ACC   => INTC8ACC,
        INTC3ACC_N => INTC3ACC_N,
        CXXX       => CXXX,
        DXXX_N     => DXXX_N,
        E_FXXX_N   => E_FXXX_N,
        INH        => INH,
        RDROM      => RDROM,
        CENROM1    => CENROM1,
        R_W_N      => R_W_N,

        ROMEN2_N => ROMEN2_N,
        ROMEN1_N => ROMEN1_N
    );

    U_MMU_MD7 : MMU_MD7 port map(
        RC01X_N   => RC01X_N,
        A         => A(3 downto 0),
        PHI_0     => PHI_0,
        Q3        => Q3,
        PRAS_N    => PRAS_N,
        BANK2     => BANK2,
        RDRAM     => RDRAM,
        FLG1      => FLG1,
        FLG2      => FLG2,
        PENIO_N   => PENIO_N,
        ALTSTKZP  => ALTSTKZP,
        INTC300_N => INTC300_N,
        EN80VID   => EN80VID,
        MD7       => UNGATED_MD7,
        ENABLE_N  => MD7_ENABLE_N
    );
    MD7 <= UNGATED_MD7 when MD7_ENABLE_N = '0' else 'Z';

    U_MMU_EN80 : MMU_EN80 port map(
        SELMB_N  => SELMB_N,
        INH_N    => INH_N,
        PHI_0    => PHI_0,
        PCASEN_N => PCASEN_N,
        EN80_N   => EN80_N
    );

    U_MMU_KBD : MMU_KBD port map(
        INTIO_N => INTIO_N,
        R_W_N   => R_W_N,
        PHI_1   => PHI_1,
        KBD_N   => KBD_N
    );

    U_MMU_RA : MMU_RA port map(
        A         => A,
        PRAS_N    => PRAS_N,
        RAS_N     => RAS_N,
        P_PHI_0   => P_PHI_0,
        Q3_PRAS_N => Q3_PRAS_N,
        DXXX_N    => DXXX_N,
        BANK1     => BANK1,

        RA       => UNGATED_RA,
        RA_ENABLE_N => RA_ENABLE_N
    );
    ORA <= UNGATED_RA when RA_ENABLE_N = '0' else "ZZZZZZZZ";

end RTL;
