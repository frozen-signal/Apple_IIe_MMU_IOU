library IEEE;
library work;
use work.all;

configuration IOU_TB_ADDRESSING of IOU_TEST_ADDRESSING_ENTITY is
    for IOU_TEST_ADDRESSING
        for c_iou : IOU
            use entity work.IOU(RTL);
            for RTL
                for U_VIDEO_ADDR_LATCH : VIDEO_ADDR_LATCH
                    use entity VIDEO_ADDR_LATCH_SPY(SPY);
                end for;
                for U_IOU_ADDR_DECODER : IOU_ADDR_DECODER
                    use entity IOU_ADDR_DECODER_SPY(SPY);
                end for;
                for U_VIDEO_ADDR_MUX : VIDEO_ADDR_MUX
                    use entity VIDEO_ADDR_MUX_SPY(SPY);
                end for;
            end for;
        end for;
    end for;
end IOU_TB_ADDRESSING;

library IEEE;
library work;
use IEEE.std_logic_1164.all;
use work.TEST_UTILS.all;
use work.IOU_TESTBENCH_PACKAGE.all;
use work.all;

entity IOU_TEST_ADDRESSING_ENTITY is
    -- empty
end IOU_TEST_ADDRESSING_ENTITY;

architecture IOU_TEST_ADDRESSING of IOU_TEST_ADDRESSING_ENTITY is

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

            PIN_RESET_N : inout std_logic;
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

    signal R_W_N, C0XX_N, VID6, VID7, A6, IKSTRB, IAKD, PIN_RESET_N,
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
        PIN_RESET_N => PIN_RESET_N,
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
        -- ORA0-ORA6 are latched to LA0-LA5 and LA7 at RAS' rising during PHASE 1
        TEST_ORA0 <= '0';
        TEST_ORA1 <= '0';
        TEST_ORA2 <= '0';
        TEST_ORA3 <= '0';
        TEST_ORA4 <= '0';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until rising_edge(PRAS_N); -- RAS' rising of PHASE 0
        wait for 1 ns;
        assert(TB_LA0 = 'U') report "TB_LA0 should not have changed" severity error;
        assert(TB_LA1 = 'U') report "TB_LA1 should not have changed" severity error;
        assert(TB_LA2 = 'U') report "TB_LA2 should not have changed" severity error;
        assert(TB_LA3 = 'U') report "TB_LA3 should not have changed" severity error;
        assert(TB_LA4 = 'U') report "TB_LA4 should not have changed" severity error;
        assert(TB_LA5 = 'U') report "TB_LA5 should not have changed" severity error;
        assert(TB_LA7 = 'U') report "TB_LA6 should not have changed" severity error;

        wait until rising_edge(PRAS_N); -- RAS' rising of PHASE 1
        wait for 1 ns;
        assert(TB_LA0 = '0') report "TB_LA0 should be LOW" severity error;
        assert(TB_LA1 = '0') report "TB_LA1 should be LOW" severity error;
        assert(TB_LA2 = '0') report "TB_LA2 should be LOW" severity error;
        assert(TB_LA3 = '0') report "TB_LA3 should be LOW" severity error;
        assert(TB_LA4 = '0') report "TB_LA4 should be LOW" severity error;
        assert(TB_LA5 = '0') report "TB_LA5 should be LOW" severity error;
        assert(TB_LA7 = '0') report "TB_LA6 should be LOW" severity error;

        TEST_ORA0 <= '1';
        TEST_ORA1 <= '1';
        TEST_ORA2 <= '1';
        TEST_ORA3 <= '1';
        TEST_ORA4 <= '1';
        TEST_ORA5 <= '1';
        TEST_ORA6 <= '1';
        TEST_ORA7 <= '1';
        wait until rising_edge(PRAS_N); -- RAS' rising of PHASE 0
        wait for 1 ns;
        assert(TB_LA0 = '0') report "TB_LA0 should not have changed" severity error;
        assert(TB_LA1 = '0') report "TB_LA1 should not have changed" severity error;
        assert(TB_LA2 = '0') report "TB_LA2 should not have changed" severity error;
        assert(TB_LA3 = '0') report "TB_LA3 should not have changed" severity error;
        assert(TB_LA4 = '0') report "TB_LA4 should not have changed" severity error;
        assert(TB_LA5 = '0') report "TB_LA5 should not have changed" severity error;
        assert(TB_LA7 = '0') report "TB_LA6 should not have changed" severity error;

        -- Test ORA output enabling
        wait until falling_edge(PHI_0);
        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(TB_RA_ENABLE_N = '1') report "TB_RA_ENABLE_N should be HIGH" severity error;

        wait until rising_edge(PRAS_N);
        wait for 1 ns;
        assert(TB_RA_ENABLE_N = '1') report "TB_RA_ENABLE_N should be HIGH" severity error;

        wait until rising_edge(PHI_0);
        wait for 1 ns;
        assert(TB_RA_ENABLE_N = '1') report "TB_RA_ENABLE_N should be HIGH" severity error;

        wait until falling_edge(PRAS_N);
        wait for 1 ns;
        assert(TB_RA_ENABLE_N = '1') report "TB_RA_ENABLE_N should be HIGH" severity error;

        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(TB_RA_ENABLE_N = '1') report "TB_RA_ENABLE_N should be HIGH" severity error;

        wait until rising_edge(PRAS_N);
        wait for 1 ns;
        assert(TB_RA_ENABLE_N = '0') report "TB_RA_ENABLE_N should be LOW" severity error;

        wait until falling_edge(PHI_0);
        wait for 1 ns;
        assert(TB_RA_ENABLE_N = '0') report "TB_RA_ENABLE_N should be LOW" severity error;

        wait until falling_edge(PRAS_N);
        wait for 1 ns;
        assert(TB_RA_ENABLE_N = '0') report "TB_RA_ENABLE_N should be LOW" severity error;

        -- ORA is driven by the MMU during the last 14M of PHASE 1 and first 4 14M of PHASE 0
        -- ORA is driven by the IOU during the last 14M of PHASE 0 and first 4 14M of PHASE 1
        wait until falling_edge(PHI_0);
        wait until rising_edge(PRAS_N);
        wait for 1 ns;
        assert(ORA0 = '1') report "During the last 14M of PHASE 1, ORA0 should be driven by the MMU" severity error;
        assert(ORA1 = '1') report "During the last 14M of PHASE 1, ORA1 should be driven by the MMU" severity error;
        assert(ORA2 = '1') report "During the last 14M of PHASE 1, ORA2 should be driven by the MMU" severity error;
        assert(ORA3 = '1') report "During the last 14M of PHASE 1, ORA3 should be driven by the MMU" severity error;
        assert(ORA4 = '1') report "During the last 14M of PHASE 1, ORA4 should be driven by the MMU" severity error;
        assert(ORA5 = '1') report "During the last 14M of PHASE 1, ORA5 should be driven by the MMU" severity error;
        assert(ORA6 = '1') report "During the last 14M of PHASE 1, ORA6 should be driven by the MMU" severity error;
        assert(ORA7 = '1') report "During the last 14M of PHASE 1, ORA7 should be driven by the MMU" severity error;

        -- 1st 14M
        wait until rising_edge(PHI_0);
        wait for 1 ns;
        assert(ORA0 = '1') report "During the first 4 14M of PHASE 0, ORA0 should be driven by the MMU" severity error;
        assert(ORA1 = '1') report "During the first 4 14M of PHASE 0, ORA1 should be driven by the MMU" severity error;
        assert(ORA2 = '1') report "During the first 4 14M of PHASE 0, ORA2 should be driven by the MMU" severity error;
        assert(ORA3 = '1') report "During the first 4 14M of PHASE 0, ORA3 should be driven by the MMU" severity error;
        assert(ORA4 = '1') report "During the first 4 14M of PHASE 0, ORA4 should be driven by the MMU" severity error;
        assert(ORA5 = '1') report "During the first 4 14M of PHASE 0, ORA5 should be driven by the MMU" severity error;
        assert(ORA6 = '1') report "During the first 4 14M of PHASE 0, ORA6 should be driven by the MMU" severity error;
        assert(ORA7 = '1') report "During the first 4 14M of PHASE 0, ORA7 should be driven by the MMU" severity error;

        -- 2nd 14M
        wait until rising_edge(CLK_14M);
        wait for 1 ns;
        assert(ORA0 = '1') report "During the first 4 14M of PHASE 0, ORA0 should be driven by the MMU" severity error;
        assert(ORA1 = '1') report "During the first 4 14M of PHASE 0, ORA1 should be driven by the MMU" severity error;
        assert(ORA2 = '1') report "During the first 4 14M of PHASE 0, ORA2 should be driven by the MMU" severity error;
        assert(ORA3 = '1') report "During the first 4 14M of PHASE 0, ORA3 should be driven by the MMU" severity error;
        assert(ORA4 = '1') report "During the first 4 14M of PHASE 0, ORA4 should be driven by the MMU" severity error;
        assert(ORA5 = '1') report "During the first 4 14M of PHASE 0, ORA5 should be driven by the MMU" severity error;
        assert(ORA6 = '1') report "During the first 4 14M of PHASE 0, ORA6 should be driven by the MMU" severity error;
        assert(ORA7 = '1') report "During the first 4 14M of PHASE 0, ORA7 should be driven by the MMU" severity error;

        -- 3rd 14M
        wait until rising_edge(CLK_14M);
        wait for 1 ns;
        assert(ORA0 = '1') report "During the first 4 14M of PHASE 0, ORA0 should be driven by the MMU" severity error;
        assert(ORA1 = '1') report "During the first 4 14M of PHASE 0, ORA1 should be driven by the MMU" severity error;
        assert(ORA2 = '1') report "During the first 4 14M of PHASE 0, ORA2 should be driven by the MMU" severity error;
        assert(ORA3 = '1') report "During the first 4 14M of PHASE 0, ORA3 should be driven by the MMU" severity error;
        assert(ORA4 = '1') report "During the first 4 14M of PHASE 0, ORA4 should be driven by the MMU" severity error;
        assert(ORA5 = '1') report "During the first 4 14M of PHASE 0, ORA5 should be driven by the MMU" severity error;
        assert(ORA6 = '1') report "During the first 4 14M of PHASE 0, ORA6 should be driven by the MMU" severity error;
        assert(ORA7 = '1') report "During the first 4 14M of PHASE 0, ORA7 should be driven by the MMU" severity error;

        -- 4th 14M
        wait until rising_edge(CLK_14M);
        wait for 1 ns;
        assert(ORA0 = '1') report "During the first 4 14M of PHASE 0, ORA0 should be driven by the MMU" severity error;
        assert(ORA1 = '1') report "During the first 4 14M of PHASE 0, ORA1 should be driven by the MMU" severity error;
        assert(ORA2 = '1') report "During the first 4 14M of PHASE 0, ORA2 should be driven by the MMU" severity error;
        assert(ORA3 = '1') report "During the first 4 14M of PHASE 0, ORA3 should be driven by the MMU" severity error;
        assert(ORA4 = '1') report "During the first 4 14M of PHASE 0, ORA4 should be driven by the MMU" severity error;
        assert(ORA5 = '1') report "During the first 4 14M of PHASE 0, ORA5 should be driven by the MMU" severity error;
        assert(ORA6 = '1') report "During the first 4 14M of PHASE 0, ORA6 should be driven by the MMU" severity error;
        assert(ORA7 = '1') report "During the first 4 14M of PHASE 0, ORA7 should be driven by the MMU" severity error;
        TEST_ORA0 <= 'U';
        TEST_ORA1 <= 'U';
        TEST_ORA2 <= 'U';
        TEST_ORA3 <= 'U';
        TEST_ORA4 <= 'U';
        TEST_ORA5 <= 'U';
        TEST_ORA6 <= 'U';
        TEST_ORA7 <= 'U';
        wait until rising_edge(PRAS_N);
        wait for 1 ns;
        assert(ORA0 = '1') report "During the last 14M of PHASE 0, ORA0 should be driven by the IOU" severity error;
        assert(ORA1 = '1') report "During the last 14M of PHASE 0, ORA1 should be driven by the IOU" severity error;
        assert(ORA2 = '0') report "During the last 14M of PHASE 0, ORA2 should be driven by the IOU" severity error;
        assert(ORA3 = '1') report "During the last 14M of PHASE 0, ORA3 should be driven by the IOU" severity error;
        assert(ORA4 = '0') report "During the last 14M of PHASE 0, ORA4 should be driven by the IOU" severity error;
        assert(ORA5 = '1') report "During the last 14M of PHASE 0, ORA5 should be driven by the IOU" severity error;
        assert(ORA6 = '0') report "During the last 14M of PHASE 0, ORA6 should be driven by the IOU" severity error;
        assert(ORA7 = '0') report "During the last 14M of PHASE 0, ORA7 should be driven by the IOU" severity error;

        -- 1st 14M
        wait until falling_edge(PHI_0);
        wait for 1 ns;
        assert(ORA0 = '1') report "During the first 4 14M of PHASE 1, ORA0 should be driven by the IOU" severity error;
        assert(ORA1 = '1') report "During the first 4 14M of PHASE 1, ORA1 should be driven by the IOU" severity error;
        assert(ORA2 = '0') report "During the first 4 14M of PHASE 1, ORA2 should be driven by the IOU" severity error;
        assert(ORA3 = '1') report "During the first 4 14M of PHASE 1, ORA3 should be driven by the IOU" severity error;
        assert(ORA4 = '0') report "During the first 4 14M of PHASE 1, ORA4 should be driven by the IOU" severity error;
        assert(ORA5 = '1') report "During the first 4 14M of PHASE 1, ORA5 should be driven by the IOU" severity error;
        assert(ORA6 = '0') report "During the first 4 14M of PHASE 1, ORA6 should be driven by the IOU" severity error;
        assert(ORA7 = '0') report "During the first 4 14M of PHASE 1, ORA7 should be driven by the IOU" severity error;

        -- 2nd 14M
        wait until rising_edge(CLK_14M);
        wait for 1 ns;
        assert(ORA0 = '0') report "During the first 4 14M of PHASE 1, ORA0 should be driven by the IOU" severity error;
        assert(ORA1 = '1') report "During the first 4 14M of PHASE 1, ORA1 should be driven by the IOU" severity error;
        assert(ORA2 = '1') report "During the first 4 14M of PHASE 1, ORA2 should be driven by the IOU" severity error;
        assert(ORA3 = '0') report "During the first 4 14M of PHASE 1, ORA3 should be driven by the IOU" severity error;
        assert(ORA4 = '0') report "During the first 4 14M of PHASE 1, ORA4 should be driven by the IOU" severity error;
        assert(ORA5 = '0') report "During the first 4 14M of PHASE 1, ORA5 should be driven by the IOU" severity error;
        assert(ORA6 = '0') report "During the first 4 14M of PHASE 1, ORA6 should be driven by the IOU" severity error;
        assert(ORA7 = '0') report "During the first 4 14M of PHASE 1, ORA7 should be driven by the IOU" severity error;

        -- 3rd 14M
        wait until rising_edge(CLK_14M);
        wait for 1 ns;
        assert(ORA0 = '0') report "During the first 4 14M of PHASE 1, ORA0 should be driven by the IOU" severity error;
        assert(ORA1 = '1') report "During the first 4 14M of PHASE 1, ORA1 should be driven by the IOU" severity error;
        assert(ORA2 = '1') report "During the first 4 14M of PHASE 1, ORA2 should be driven by the IOU" severity error;
        assert(ORA3 = '0') report "During the first 4 14M of PHASE 1, ORA3 should be driven by the IOU" severity error;
        assert(ORA4 = '0') report "During the first 4 14M of PHASE 1, ORA4 should be driven by the IOU" severity error;
        assert(ORA5 = '0') report "During the first 4 14M of PHASE 1, ORA5 should be driven by the IOU" severity error;
        assert(ORA6 = '0') report "During the first 4 14M of PHASE 1, ORA6 should be driven by the IOU" severity error;
        assert(ORA7 = '0') report "During the first 4 14M of PHASE 1, ORA7 should be driven by the IOU" severity error;

        -- 4th 14M
        wait until rising_edge(CLK_14M);
        wait for 1 ns;
        assert(ORA0 = '0') report "During the first 4 14M of PHASE 1, ORA0 should be driven by the IOU" severity error;
        assert(ORA1 = '1') report "During the first 4 14M of PHASE 1, ORA1 should be driven by the IOU" severity error;
        assert(ORA2 = '1') report "During the first 4 14M of PHASE 1, ORA2 should be driven by the IOU" severity error;
        assert(ORA3 = '0') report "During the first 4 14M of PHASE 1, ORA3 should be driven by the IOU" severity error;
        assert(ORA4 = '0') report "During the first 4 14M of PHASE 1, ORA4 should be driven by the IOU" severity error;
        assert(ORA5 = '0') report "During the first 4 14M of PHASE 1, ORA5 should be driven by the IOU" severity error;
        assert(ORA6 = '0') report "During the first 4 14M of PHASE 1, ORA6 should be driven by the IOU" severity error;
        assert(ORA7 = '0') report "During the first 4 14M of PHASE 1, ORA7 should be driven by the IOU" severity error;

        -- Address decoding
        -- C00X
        C0XX_N    <= '0';
        A6        <= '0';
        TEST_ORA0 <= '0';
        TEST_ORA1 <= '0';
        TEST_ORA2 <= '0';
        TEST_ORA3 <= '0';
        TEST_ORA4 <= '0';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(TB_C00X_N = '0') report "C00X_N should be LOW when C00X address selected" severity error;
        assert(TB_C01X_N = '1') report "C01X_N should be HIGH when C01X address selected" severity error;
        assert(TB_C02X_N = '1') report "C02X_N should be HIGH when C02X address selected" severity error;
        assert(TB_C03X_N = '1') report "C03X_N should be HIGH when C03X address selected" severity error;
        assert(TB_C04X_N = '1') report "C04X_N should be HIGH when C04X address selected" severity error;
        assert(TB_C05X_N = '1') report "C05X_N should be HIGH when C05X address selected" severity error;
        assert(TB_C07X_N = '1') report "C07X_N should be HIGH when C07X address selected" severity error;

        -- C01X
        TEST_ORA0 <= '0';
        TEST_ORA1 <= '0';
        TEST_ORA2 <= '0';
        TEST_ORA3 <= '0';
        TEST_ORA4 <= '1';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(TB_C00X_N = '1') report "C00X_N should be HIGH when C00X address selected" severity error;
        assert(TB_C01X_N = '0') report "C01X_N should be LOW when C01X address selected" severity error;
        assert(TB_C02X_N = '1') report "C02X_N should be HIGH when C02X address selected" severity error;
        assert(TB_C03X_N = '1') report "C03X_N should be HIGH when C03X address selected" severity error;
        assert(TB_C04X_N = '1') report "C04X_N should be HIGH when C04X address selected" severity error;
        assert(TB_C05X_N = '1') report "C05X_N should be HIGH when C05X address selected" severity error;
        assert(TB_C07X_N = '1') report "C07X_N should be HIGH when C07X address selected" severity error;

        -- C02X
        TEST_ORA0 <= '0';
        TEST_ORA1 <= '0';
        TEST_ORA2 <= '0';
        TEST_ORA3 <= '0';
        TEST_ORA4 <= '0';
        TEST_ORA5 <= '1';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(TB_C00X_N = '1') report "C00X_N should be HIGH when C00X address selected" severity error;
        assert(TB_C01X_N = '1') report "C01X_N should be HIGH when C01X address selected" severity error;
        assert(TB_C02X_N = '0') report "C02X_N should be LOW when C02X address selected" severity error;
        assert(TB_C03X_N = '1') report "C03X_N should be HIGH when C03X address selected" severity error;
        assert(TB_C04X_N = '1') report "C04X_N should be HIGH when C04X address selected" severity error;
        assert(TB_C05X_N = '1') report "C05X_N should be HIGH when C05X address selected" severity error;
        assert(TB_C07X_N = '1') report "C07X_N should be HIGH when C07X address selected" severity error;

        -- C03X
        TEST_ORA0 <= '0';
        TEST_ORA1 <= '0';
        TEST_ORA2 <= '0';
        TEST_ORA3 <= '0';
        TEST_ORA4 <= '1';
        TEST_ORA5 <= '1';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(TB_C00X_N = '1') report "C00X_N should be HIGH when C00X address selected" severity error;
        assert(TB_C01X_N = '1') report "C01X_N should be HIGH when C01X address selected" severity error;
        assert(TB_C02X_N = '1') report "C02X_N should be HIGH when C02X address selected" severity error;
        assert(TB_C03X_N = '0') report "C03X_N should be LOW when C03X address selected" severity error;
        assert(TB_C04X_N = '1') report "C04X_N should be HIGH when C04X address selected" severity error;
        assert(TB_C05X_N = '1') report "C05X_N should be HIGH when C05X address selected" severity error;
        assert(TB_C07X_N = '1') report "C07X_N should be HIGH when C07X address selected" severity error;

        -- C04X
        A6        <= '1';
        TEST_ORA0 <= '0';
        TEST_ORA1 <= '0';
        TEST_ORA2 <= '0';
        TEST_ORA3 <= '0';
        TEST_ORA4 <= '0';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(TB_C00X_N = '1') report "C00X_N should be HIGH when C00X address selected" severity error;
        assert(TB_C01X_N = '1') report "C01X_N should be HIGH when C01X address selected" severity error;
        assert(TB_C02X_N = '1') report "C02X_N should be HIGH when C02X address selected" severity error;
        assert(TB_C03X_N = '1') report "C03X_N should be HIGH when C03X address selected" severity error;
        assert(TB_C04X_N = '0') report "C04X_N should be LOW when C04X address selected" severity error;
        assert(TB_C05X_N = '1') report "C05X_N should be HIGH when C05X address selected" severity error;
        assert(TB_C07X_N = '1') report "C07X_N should be HIGH when C07X address selected" severity error;

        -- C05X
        TEST_ORA0 <= '0';
        TEST_ORA1 <= '0';
        TEST_ORA2 <= '0';
        TEST_ORA3 <= '0';
        TEST_ORA4 <= '1';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(TB_C00X_N = '1') report "C00X_N should be HIGH when C00X address selected" severity error;
        assert(TB_C01X_N = '1') report "C01X_N should be HIGH when C01X address selected" severity error;
        assert(TB_C02X_N = '1') report "C02X_N should be HIGH when C02X address selected" severity error;
        assert(TB_C03X_N = '1') report "C03X_N should be HIGH when C03X address selected" severity error;
        assert(TB_C04X_N = '1') report "C04X_N should be HIGH when C04X address selected" severity error;
        assert(TB_C05X_N = '0') report "C05X_N should be LOW when C05X address selected" severity error;
        assert(TB_C07X_N = '1') report "C07X_N should be HIGH when C07X address selected" severity error;

        -- C07X
        TEST_ORA0 <= '0';
        TEST_ORA1 <= '0';
        TEST_ORA2 <= '0';
        TEST_ORA3 <= '0';
        TEST_ORA4 <= '1';
        TEST_ORA5 <= '1';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(TB_C00X_N = '1') report "C00X_N should be HIGH when C00X address selected" severity error;
        assert(TB_C01X_N = '1') report "C01X_N should be HIGH when C01X address selected" severity error;
        assert(TB_C02X_N = '1') report "C02X_N should be HIGH when C02X address selected" severity error;
        assert(TB_C03X_N = '1') report "C03X_N should be HIGH when C03X address selected" severity error;
        assert(TB_C04X_N = '1') report "C04X_N should be HIGH when C04X address selected" severity error;
        assert(TB_C05X_N = '1') report "C05X_N should be HIGH when C05X address selected" severity error;
        assert(TB_C07X_N = '0') report "C07X_N should be LOW when C07X address selected" severity error;

        FINISHED <= '1';
        assert false report "Test done." severity note;
        wait;

    end process;
end IOU_TEST_ADDRESSING;
