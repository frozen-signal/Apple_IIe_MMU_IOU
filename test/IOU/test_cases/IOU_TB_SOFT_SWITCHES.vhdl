library IEEE;
library work;
use work.all;

configuration IOU_TB_SOFT_SWITCHES of IOU_TEST_SOFT_SWITCHES_ENTITY is
    for IOU_TEST_SOFT_SWITCHES
        for c_iou : IOU
            use entity work.IOU(RTL);
            for RTL
                for U_IOU_RESET : IOU_RESET
                    use entity IOU_RESET_MOCK(MOCK);
                end for;
            end for;
        end for;
    end for;
end IOU_TB_SOFT_SWITCHES;

library IEEE;
library work;
use IEEE.std_logic_1164.all;
use work.TEST_UTILS.all;
use work.IOU_TESTBENCH_PACKAGE.all;
use work.all;

entity IOU_TEST_SOFT_SWITCHES_ENTITY is
    -- empty
end IOU_TEST_SOFT_SWITCHES_ENTITY;

architecture IOU_TEST_SOFT_SWITCHES of IOU_TEST_SOFT_SWITCHES_ENTITY is

    component HAL_TIMING_MOCK is
        port (
            CLK_14M  : out std_logic;
            PHI_0    : out std_logic;
            Q3       : out std_logic;
            RAS_N    : out std_logic;
            FINISHED : out std_logic
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

    signal R_W_N, C0XX_N, VID6, VID7, A6, IKSTRB, IAKD, PIN_RESET_N                                 : std_logic;
    signal ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, ORA7, H0, SEGA, SEGB, SEGC, LGR_TXT_N          : std_logic;
    signal MD7, SPKR, CASSO, AN0, AN1, AN2, AN3, S_80COL_N, RA9_N, RA10_N, CLRGAT_N, SYNC_N, WNDW_N : std_logic;
    signal TEST_ORA0, TEST_ORA1, TEST_ORA2, TEST_ORA3, TEST_ORA4                                    : std_logic;
    signal TEST_ORA5, TEST_ORA6, TEST_ORA7                                                          : std_logic;
begin
    hal_mock : HAL_TIMING_MOCK port map(
        CLK_14M  => CLK_14M,
        PHI_0    => PHI_0,
        Q3       => Q3,
        RAS_N    => PRAS_N,
        FINISHED => FINISHED
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
        PIN_RESET_N    <= '1';
        TB_FORCE_RESET <= '0';
        wait until falling_edge(PHI_0);

        -- SOFT SWITCH SET/RESET TESTS (with PAYMAR) ------------------------------------------------------------------
        -- RESET PAYMAR (Write $C00E)
        R_W_N     <= '0';
        C0XX_N    <= '0';
        A6        <= '0';
        TEST_ORA0 <= '0';
        TEST_ORA1 <= '1';
        TEST_ORA2 <= '1';
        TEST_ORA3 <= '1';
        TEST_ORA4 <= '0';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait until falling_edge(PHI_0);

        -- READ PAYMAR (Read $C01E)
        R_W_N     <= '1';
        C0XX_N    <= '0';
        A6        <= '0';
        TEST_ORA0 <= '0';
        TEST_ORA1 <= '1';
        TEST_ORA2 <= '1';
        TEST_ORA3 <= '1';
        TEST_ORA4 <= '1';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(MD7 = '0') report "PAYMAR should be LOW" severity error;

        -- SET PAYMAR (Write $C00D)
        R_W_N     <= '0';
        C0XX_N    <= '0';
        A6        <= '0';
        TEST_ORA0 <= '1';
        TEST_ORA1 <= '1';
        TEST_ORA2 <= '1';
        TEST_ORA3 <= '1';
        TEST_ORA4 <= '0';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);

        -- READ PAYMAR (Read $C01E)
        R_W_N     <= '1';
        C0XX_N    <= '0';
        A6        <= '0';
        TEST_ORA0 <= '0';
        TEST_ORA1 <= '1';
        TEST_ORA2 <= '1';
        TEST_ORA3 <= '1';
        TEST_ORA4 <= '1';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(MD7 = '1') report "PAYMAR should be HIGH" severity error;

        wait until rising_edge(PHI_0);

        -- SOFT SWITCH STATE AFTER IOU RESET --------------------------------------------------------------------------
        -- All soft switches except KEYSTROBE, TEXT, and MIXED are reset when the RESET' line drops low.

        -- PRECONDITION: ALL CONTROLLABLE SOFT SWITCHES ARE SET
        -- SET ITEXT (Write $C051)
        R_W_N     <= '0';
        C0XX_N    <= '0';
        A6        <= '1';
        TEST_ORA0 <= '1';
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

        -- SET MIX (Write $C053)
        TEST_ORA0 <= '1';
        TEST_ORA1 <= '1';
        TEST_ORA2 <= '0';
        TEST_ORA3 <= '0';
        TEST_ORA4 <= '1';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);

        -- SET PG2 (Write $C055)
        TEST_ORA0 <= '1';
        TEST_ORA1 <= '0';
        TEST_ORA2 <= '1';
        TEST_ORA3 <= '0';
        TEST_ORA4 <= '1';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);

        -- SET S_80COL (Write $C00D)
        A6        <= '0';
        TEST_ORA0 <= '1';
        TEST_ORA1 <= '0';
        TEST_ORA2 <= '1';
        TEST_ORA3 <= '1';
        TEST_ORA4 <= '0';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);

        -- System reset
        PIN_RESET_N <= '0';
        wait until rising_edge(PHI_0);
        PIN_RESET_N <= '1';

        -- VBL_N (C019)
        R_W_N     <= '1';
        C0XX_N    <= '0';
        A6        <= '0';
        TEST_ORA0 <= '1';
        TEST_ORA1 <= '0';
        TEST_ORA2 <= '0';
        TEST_ORA3 <= '1';
        TEST_ORA4 <= '0';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(MD7 = '0') report "VBL_N should be RESET by RESET_N LOW" severity error;

        -- ITEXT (C01A)
        R_W_N     <= '1';
        C0XX_N    <= '0';
        A6        <= '0';
        TEST_ORA0 <= '0';
        TEST_ORA1 <= '1';
        TEST_ORA2 <= '0';
        TEST_ORA3 <= '1';
        TEST_ORA4 <= '1';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(MD7 = '0') report "ITEXT should be RESET by RESET_N LOW" severity error;

        -- MIX (C01B)
        R_W_N     <= '1';
        C0XX_N    <= '0';
        A6        <= '0';
        TEST_ORA0 <= '1';
        TEST_ORA1 <= '1';
        TEST_ORA2 <= '0';
        TEST_ORA3 <= '1';
        TEST_ORA4 <= '1';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(MD7 = '0') report "MIX should be RESET by RESET_N LOW" severity error;

        -- PG2 (C01C)
        R_W_N     <= '1';
        C0XX_N    <= '0';
        A6        <= '0';
        TEST_ORA0 <= '0';
        TEST_ORA1 <= '0';
        TEST_ORA2 <= '1';
        TEST_ORA3 <= '1';
        TEST_ORA4 <= '1';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(MD7 = '0') report "PG2 should be LOW after a system reset" severity error;

        -- HIRES (C01D)
        R_W_N     <= '1';
        C0XX_N    <= '0';
        A6        <= '0';
        TEST_ORA0 <= '1';
        TEST_ORA1 <= '0';
        TEST_ORA2 <= '1';
        TEST_ORA3 <= '1';
        TEST_ORA4 <= '1';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(MD7 = '0') report "HIRES should be LOW after a system reset" severity error;

        -- S_80COL (C01D)
        R_W_N     <= '1';
        C0XX_N    <= '0';
        A6        <= '0';
        TEST_ORA0 <= '1';
        TEST_ORA1 <= '1';
        TEST_ORA2 <= '1';
        TEST_ORA3 <= '1';
        TEST_ORA4 <= '1';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(MD7 = '0') report "S_80COL should be LOW after a system reset" severity error;

        -- MD7 ENABLING
        R_W_N     <= '1';
        C0XX_N    <= '0';
        A6        <= '0';
        TEST_ORA0 <= '1';
        TEST_ORA1 <= '1';
        TEST_ORA2 <= '1';
        TEST_ORA3 <= '1';
        TEST_ORA4 <= '1';
        TEST_ORA5 <= '0';
        TEST_ORA6 <= '0';
        TEST_ORA7 <= '0';
        wait until falling_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(MD7 = '0') report "MD7 should be enabled" severity error;

        wait until falling_edge(PHI_0);
        wait for 1 ns;
        assert(MD7 = 'Z') report "MD7 should be High-Impedence" severity error;

        wait until falling_edge(PRAS_N);
        wait for 1 ns;
        assert(MD7 = 'Z') report "MD7 should be High-Impedence" severity error;

        wait until falling_edge(Q3);
        wait for 1 ns;
        assert(MD7 = 'Z') report "MD7 should be High-Impedence" severity error;

        wait until rising_edge(PRAS_N);
        wait for 1 ns;
        assert(MD7 = 'Z') report "MD7 should be High-Impedence" severity error;

        wait until rising_edge(PHI_0);
        wait for 1 ns;
        assert(MD7 = 'Z') report "MD7 should be High-Impedence" severity error;

        wait until falling_edge(PRAS_N);
        wait for 1 ns;
        assert(MD7 = 'Z') report "MD7 should be High-Impedence" severity error;

        FINISHED <= '1';
        assert false report "Test done." severity note;
        wait;

    end process;
end IOU_TEST_SOFT_SWITCHES;
