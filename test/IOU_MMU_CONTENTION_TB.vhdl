library IEEE;
library work;
use work.all;

configuration IOU_MMU_CONTENTION_TB of IOU_MMU_CONTENTION_ENTITY is
    for TESTBENCH
        for c_iou : IOU
            use entity work.IOU(RTL);
            for RTL
                for U_POWER_ON_DETECTION : POWER_ON_DETECTION
                    use entity POWER_ON_DETECTION_MOCK(MOCK);
                end for;
                for U_IOU_RESET : IOU_RESET
                    use entity IOU_RESET_SPY(SPY);
                end for;
            end for;
        end for;
    end for;
end IOU_MMU_CONTENTION_TB;

library IEEE;
library work;
use IEEE.std_logic_1164.all;
use work.TEST_UTILS.all;
use work.IOU_TESTBENCH_PACKAGE.all;
use work.all;

entity IOU_MMU_CONTENTION_ENTITY is
    -- empty
end IOU_MMU_CONTENTION_ENTITY;

architecture TESTBENCH of IOU_MMU_CONTENTION_ENTITY is

    component HAL_TIMING_MOCK is
        port (
            FINISHED : in std_logic;

            CLK_14M : inout std_logic;
            PHI_0   : out std_logic;
            Q3      : out std_logic;
            RAS_N   : out std_logic
        );
    end component;

    component MMU is
        port (
            A      : in std_logic_vector(15 downto 0);
            PHI_0  : in std_logic;
            Q3     : in std_logic;
            PRAS_N : in std_logic;
            R_W_N  : in std_logic;
            INH_N  : in std_logic;
            DMA_N  : in std_logic;

            ORA       : out std_logic_vector(7 downto 0);
            EN80_N    : out std_logic;
            KBD_N     : out std_logic;
            ROMEN1_N  : out std_logic;
            ROMEN2_N  : out std_logic;
            MD7       : out std_logic;
            R_W_N_245 : out std_logic;
            CASEN_N   : out std_logic;
            CXXXOUT   : out std_logic
        );
    end component;

    component IOU is
        port (
            PHI_0      : in std_logic;
            Q3         : in std_logic;
            PRAS_N     : in std_logic;
            R_W_N      : in std_logic;
            C0XX_N     : in std_logic;
            VID6, VID7 : in std_logic;
            A6         : in std_logic;
            IKSTRB     : in std_logic;
            IAKD       : in std_logic;

            RESET_N    : inout std_logic;
            ORA6, ORA5, ORA4, ORA3,
            ORA2, ORA1, ORA0 : inout std_logic;

            ORA7               : out std_logic;
            H0                 : out std_logic;
            SEGA, SEGB, SEGC   : out std_logic;
            LGR_TXT_N          : out std_logic;
            MD7                : out std_logic;
            SPKR               : out std_logic;
            CASSO              : out std_logic;
            AN0, AN1, AN2, AN3 : out std_logic;
            S_80COL_N          : out std_logic;
            RA9_N, RA10_N      : out std_logic;
            CLRGAT_N           : out std_logic;
            SYNC_N             : out std_logic;
            WNDW_N             : out std_logic
        );
    end component;

    signal CLK_14M : std_logic := '0';
    signal PHI_0   : std_logic := '1';
    signal Q3      : std_logic := '1';
    signal PRAS_N  : std_logic;

    signal FINISHED  : std_logic := '0';
    signal TEST_STEP : std_logic_vector(7 downto 0);

    signal R_W_N : std_logic;

    signal A     : std_logic_vector(15 downto 0);
    signal INH_N : std_logic;
    signal DMA_N : std_logic;

    signal MMU_ORA   : std_logic_vector(7 downto 0);
    signal EN80_N    : std_logic;
    signal KBD_N     : std_logic;
    signal ROMEN1_N  : std_logic;
    signal ROMEN2_N  : std_logic;
    signal MMU_MD7   : std_logic;
    signal R_W_N_245 : std_logic;
    signal CASEN_N   : std_logic;
    signal CXXXOUT   : std_logic;

    signal C0XX_N, VID6, VID7, A6, IKSTRB, IAKD, RESET_N : std_logic;
    signal IOU_ORA7, IOU_ORA6, IOU_ORA5, IOU_ORA4,
    IOU_ORA3, IOU_ORA2, IOU_ORA1, IOU_ORA0, H0, SEGA, SEGB, SEGC, LGR_TXT_N                                : std_logic;
    signal IOU_TB_MD7, SPKR, CASSO, AN0, AN1, AN2, AN3, S_80COL_N, RA9_N, RA10_N, CLRGAT_N, SYNC_N, WNDW_N : std_logic;

begin
    hal_mock : HAL_TIMING_MOCK port map(
        FINISHED => FINISHED,
        CLK_14M  => CLK_14M,
        PHI_0    => PHI_0,
        Q3       => Q3,
        RAS_N    => PRAS_N
    );

    c_mmu : MMU port map(
        A      => A,
        PHI_0  => PHI_0,
        Q3     => Q3,
        PRAS_N => PRAS_N,
        R_W_N  => R_W_N,
        INH_N  => INH_N,
        DMA_N  => DMA_N,

        ORA       => MMU_ORA,
        EN80_N    => EN80_N,
        KBD_N     => KBD_N,
        ROMEN1_N  => ROMEN1_N,
        ROMEN2_N  => ROMEN2_N,
        MD7       => MMU_MD7,
        R_W_N_245 => R_W_N_245,
        CASEN_N   => CASEN_N,
        CXXXOUT   => CXXXOUT
    );

    c_iou : IOU port map(
        PHI_0       => PHI_0,
        Q3          => Q3,
        PRAS_N      => PRAS_N,
        R_W_N       => R_W_N,
        C0XX_N      => C0XX_N,
        VID6        => VID6,
        VID7        => VID7,
        A6          => A6,
        IKSTRB      => IKSTRB,
        IAKD        => IAKD,
        RESET_N     => RESET_N,
        ORA7        => IOU_ORA7,
        ORA6        => IOU_ORA6,
        ORA5        => IOU_ORA5,
        ORA4        => IOU_ORA4,
        ORA3        => IOU_ORA3,
        ORA2        => IOU_ORA2,
        ORA1        => IOU_ORA1,
        ORA0        => IOU_ORA0,
        H0          => H0,
        SEGA        => SEGA,
        SEGB        => SEGB,
        SEGC        => SEGC,
        LGR_TXT_N   => LGR_TXT_N,
        MD7         => IOU_TB_MD7,
        SPKR        => SPKR,
        CASSO       => CASSO,
        AN0         => AN0,
        AN1         => AN1,
        AN2         => AN2,
        AN3         => AN3,
        S_80COL_N   => S_80COL_N,
        RA9_N       => RA9_N,
        RA10_N      => RA10_N,
        CLRGAT_N    => CLRGAT_N,
        SYNC_N      => SYNC_N,
        WNDW_N      => WNDW_N
    );

    process begin
        TB_FORCE_POC_N <= '0';
        wait for 1 ns;
        TB_FORCE_POC_N <= '1';
        wait for 1 ns;
        wait until falling_edge(TB_FORCE_RESET_N_LOW);

        for i in 1 to 14 loop
            assert((MMU_ORA(0) = 'Z' and IOU_ORA0 /= 'Z') or (MMU_ORA(0) /= 'Z' and IOU_ORA0 = 'Z'))
                report "BUS CONTENTION: MMU and IOU are both driving ORA BUS" severity error;
        end loop;

        FINISHED <= '1';
        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
