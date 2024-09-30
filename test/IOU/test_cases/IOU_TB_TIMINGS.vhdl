library IEEE;
library work;
use work.all;

configuration IOU_TB_TIMINGS of IOU_TEST_TIMINGS_ENTITY is
    for TESTBENCH
        for c_iou : IOU
            use entity work.IOU(RTL);
            for RTL
                for U_VIDEO_SCANNER : VIDEO_SCANNER
                    use entity VIDEO_SCANNER_SPY(SPY);
                end for;
                for U_VIDEO_ADDR_MUX : VIDEO_ADDR_MUX
                    use entity VIDEO_ADDR_MUX_SPY(SPY);
                end for;
                for U_POWER_ON_DETECTION : POWER_ON_DETECTION
                    use entity POWER_ON_DETECTION_MOCK(MOCK);
                end for;
                for U_IOU_INTERNALS : IOU_INTERNALS
                    use entity IOU_INTERNALS_SPY(SPY);
                end for;
                for U_IOU_RESET : IOU_RESET
                    use entity IOU_RESET_SPY(SPY);
                end for;
            end for;
        end for;
    end for;
end IOU_TB_TIMINGS;

library IEEE;
library work;
use IEEE.std_logic_1164.all;
use work.TEST_UTILS.all;
use work.IOU_TESTBENCH_PACKAGE.all;
use work.all;

entity IOU_TEST_TIMINGS_ENTITY is
    -- empty
end IOU_TEST_TIMINGS_ENTITY;

architecture TESTBENCH of IOU_TEST_TIMINGS_ENTITY is

    component HAL_TIMING_MOCK is
        port (
            FINISHED : in std_logic;

            CLK_14M : inout std_logic;
            PHI_0   : out std_logic;
            Q3      : out std_logic;
            RAS_N   : out std_logic
        );
    end component;

    component CPU_MMU_MOCK is
        port (
            PRAS_N    : in std_logic;
            Q3        : in std_logic;
            PHI_0     : in std_logic;
            TEST_ORA0 : in std_logic;
            TEST_ORA1 : in std_logic;
            TEST_ORA2 : in std_logic;
            TEST_ORA3 : in std_logic;
            TEST_ORA4 : in std_logic;
            TEST_ORA5 : in std_logic;
            TEST_ORA6 : in std_logic;
            TEST_ORA7 : in std_logic;

            IOU_INPUT_ORA0 : out std_logic;
            IOU_INPUT_ORA1 : out std_logic;
            IOU_INPUT_ORA2 : out std_logic;
            IOU_INPUT_ORA3 : out std_logic;
            IOU_INPUT_ORA4 : out std_logic;
            IOU_INPUT_ORA5 : out std_logic;
            IOU_INPUT_ORA6 : out std_logic;
            IOU_INPUT_ORA7 : out std_logic
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

    signal FINISHED : std_logic := '0';
    signal DEBUG    : std_logic;

    signal R_W_N, C0XX_N, VID6, VID7, A6, IKSTRB, IAKD, RESET_N,
    ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, ORA7, H0, SEGA, SEGB, SEGC, LGR_TXT_N,
    MD7, SPKR, CASSO, AN0, AN1, AN2, AN3, S_80COL_N, RA9_N, RA10_N, CLRGAT_N, SYNC_N, WNDW_N : std_logic;
    signal TEST_ORA0, TEST_ORA1, TEST_ORA2, TEST_ORA3, TEST_ORA4,
    TEST_ORA5, TEST_ORA6, TEST_ORA7 : std_logic;
begin
    hal_mock : HAL_TIMING_MOCK port map(
        FINISHED => FINISHED,
        CLK_14M  => CLK_14M,
        PHI_0    => PHI_0,
        Q3       => Q3,
        RAS_N    => PRAS_N
    );

    u_cpu_mmu_mock : CPU_MMU_MOCK port map(
        PRAS_N         => PRAS_N,
        Q3             => Q3,
        PHI_0          => PHI_0,
        TEST_ORA0      => TEST_ORA0,
        TEST_ORA1      => TEST_ORA1,
        TEST_ORA2      => TEST_ORA2,
        TEST_ORA3      => TEST_ORA3,
        TEST_ORA4      => TEST_ORA4,
        TEST_ORA5      => TEST_ORA5,
        TEST_ORA6      => TEST_ORA6,
        TEST_ORA7      => TEST_ORA7,
        IOU_INPUT_ORA0 => ORA0,
        IOU_INPUT_ORA1 => ORA1,
        IOU_INPUT_ORA2 => ORA2,
        IOU_INPUT_ORA3 => ORA3,
        IOU_INPUT_ORA4 => ORA4,
        IOU_INPUT_ORA5 => ORA5,
        IOU_INPUT_ORA6 => ORA6,
        IOU_INPUT_ORA7 => ORA7
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
        ORA6        => ORA6,
        ORA5        => ORA5,
        ORA4        => ORA4,
        ORA3        => ORA3,
        ORA2        => ORA2,
        ORA1        => ORA1,
        ORA0        => ORA0,
        ORA7        => ORA7,
        H0          => H0,
        SEGA        => SEGA,
        SEGB        => SEGB,
        SEGC        => SEGC,
        LGR_TXT_N   => LGR_TXT_N,
        MD7         => MD7,
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
        wait until falling_edge(TB_TC);
        wait until falling_edge(WNDW_N);

        -- WNDW_N timing
        -- The rising edge of WNDW_N should be one full PHI cycle before the long cycle.
        -- The long cycle is not modeled in the textbenches so we use the doulble-low H0 to check that
        -- the rising edge of WNDW_N is happening at the correct timing.
        wait until falling_edge(TB_HPE_N);
        assert(WNDW_N = '0') report "WNDW_N in the phase prior to the rising edge of WNDW_N should be LOW" severity error;
        assert(H0 = '0') report "H0 in the phase prior to the rising edge of WNDW_N should be LOW" severity error;
        wait until rising_edge(PHI_0);
        wait for 1 ns;
        assert(WNDW_N = '1') report "WNDW_N should have been driven HIGH" severity error;
        assert(H0 = '0') report "H0 on the rising edge of WNDW_N should still be LOW" severity error;

        -- MD7
        -- MD7 should be enabled when accessing a soft-switch and from the last three 14M periods of PHASE 0 to
        -- the first 14M period of the following PHASE 1

        FINISHED <= '1';
        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
