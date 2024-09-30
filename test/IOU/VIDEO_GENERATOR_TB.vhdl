library IEEE;
use IEEE.std_logic_1164.all;

entity VIDEO_GENERATOR_TB is
    -- empty
end VIDEO_GENERATOR_TB;

architecture TESTBENCH of VIDEO_GENERATOR_TB is
    component VIDEO_GENERATOR is
        port (
            PHI_0      : in std_logic;
            PRAS_N     : in std_logic;
            H3, H4, H5 : in std_logic;
            V3, V4     : in std_logic;
            VID6, VID7 : in std_logic;
            LGR_TXT_N  : in std_logic;
            PAYMAR     : in std_logic;
            FLASH      : in std_logic;
            PCLRGAT    : in std_logic;
            PSYNC_N    : in std_logic;
            BL_N       : in std_logic;

            E0, E1, E2, E3 : out std_logic;
            WNDW_N         : out std_logic;
            CLRGAT_N       : out std_logic;
            SYNC_N         : out std_logic;
            RA9_N          : out std_logic;
            RA10_N         : out std_logic
        );
    end component;

    signal PHI_0, PRAS_N : std_logic;

    signal H3, H4, H5 : std_logic;
    signal V3, V4     : std_logic;
    signal VID6, VID7 : std_logic;
    signal LGR_TXT_N  : std_logic;
    signal PAYMAR     : std_logic;
    signal FLASH      : std_logic;
    signal PCLRGAT    : std_logic;
    signal PSYNC_N    : std_logic;
    signal BL_N       : std_logic;

    signal E0, E1, E2, E3 : std_logic;
    signal WNDW_N         : std_logic;
    signal CLRGAT_N       : std_logic;
    signal SYNC_N         : std_logic;
    signal RA9_N          : std_logic;
    signal RA10_N         : std_logic;

begin
    dut : VIDEO_GENERATOR port map(
        PHI_0     => PHI_0,
        PRAS_N    => PRAS_N,
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
        BL_N      => BL_N,
        E0        => E0,
        E1        => E1,
        E2        => E2,
        E3        => E3,
        WNDW_N    => WNDW_N,
        CLRGAT_N  => CLRGAT_N,
        SYNC_N    => SYNC_N,
        RA9_N     => RA9_N,
        RA10_N    => RA10_N
    );

    process begin
        -- E0-E3 tests ----------
        H3 <= '0';
        H4 <= '0';
        H5 <= '0';
        V3 <= '0';
        V4 <= '0';
        wait for 1 ns;
        assert(E3 = '1') report "expect E3 HIGH" severity error;
        assert(E2 = '1') report "expect E2 HIGH" severity error;
        assert(E1 = '0') report "expect E1 LOW" severity error;
        assert(E0 = '1') report "expect E0 HIGH" severity error;

        H3 <= '0';
        H4 <= '0';
        H5 <= '0';
        V3 <= '0';
        V4 <= '1';
        wait for 1 ns;
        assert(E3 = '0') report "expect E3 LOW" severity error;
        assert(E2 = '1') report "expect E2 HIGH" severity error;
        assert(E1 = '1') report "expect E1 HIGH" severity error;
        assert(E0 = '1') report "expect E0 HIGH" severity error;

        H3 <= '0';
        H4 <= '0';
        H5 <= '0';
        V3 <= '1';
        V4 <= '0';
        wait for 1 ns;
        assert(E3 = '0') report "expect E3 LOW" severity error;
        assert(E2 = '0') report "expect E2 LOW" severity error;
        assert(E1 = '1') report "expect E1 HIGH" severity error;
        assert(E0 = '0') report "expect E0 LOW" severity error;

        H3 <= '0';
        H4 <= '0';
        H5 <= '0';
        V3 <= '1';
        V4 <= '1';
        wait for 1 ns;
        assert(E3 = '1') report "expect E3 HIGH" severity error;
        assert(E2 = '1') report "expect E2 HIGH" severity error;
        assert(E1 = '0') report "expect E1 LOW" severity error;
        assert(E0 = '0') report "expect E0 LOW" severity error;

        H3 <= '0';
        H4 <= '0';
        H5 <= '1';
        V3 <= '0';
        V4 <= '0';
        wait for 1 ns;
        assert(E3 = '0') report "expect E3 LOW" severity error;
        assert(E2 = '0') report "expect E2 LOW" severity error;
        assert(E1 = '0') report "expect E1 LOW" severity error;
        assert(E0 = '1') report "expect E0 HIGH" severity error;

        H3 <= '0';
        H4 <= '0';
        H5 <= '1';
        V3 <= '0';
        V4 <= '1';
        wait for 1 ns;
        assert(E3 = '1') report "expect E3 HIGH" severity error;
        assert(E2 = '0') report "expect E2 LOW" severity error;
        assert(E1 = '1') report "expect E1 HIGH" severity error;
        assert(E0 = '1') report "expect E0 HIGH" severity error;

        H3 <= '0';
        H4 <= '0';
        H5 <= '1';
        V3 <= '1';
        V4 <= '0';
        wait for 1 ns;
        assert(E3 = '0') report "expect E3 LOW" severity error;
        assert(E2 = '1') report "expect E2 HIGH" severity error;
        assert(E1 = '1') report "expect E1 HIGH" severity error;
        assert(E0 = '0') report "expect E0 LOW" severity error;

        H3 <= '0';
        H4 <= '0';
        H5 <= '1';
        V3 <= '1';
        V4 <= '1';
        wait for 1 ns;
        assert(E3 = '0') report "expect E3 LOW" severity error;
        assert(E2 = '0') report "expect E2 LOW" severity error;
        assert(E1 = '0') report "expect E1 LOW" severity error;
        assert(E0 = '0') report "expect E0 LOW" severity error;

        H3 <= '0';
        H4 <= '1';
        H5 <= '0';
        V3 <= '0';
        V4 <= '0';
        wait for 1 ns;
        assert(E3 = '1') report "expect E3 HIGH" severity error;
        assert(E2 = '1') report "expect E2 HIGH" severity error;
        assert(E1 = '1') report "expect E1 HIGH" severity error;
        assert(E0 = '1') report "expect E0 HIGH" severity error;

        H3 <= '0';
        H4 <= '1';
        H5 <= '0';
        V3 <= '0';
        V4 <= '1';
        wait for 1 ns;
        assert(E3 = '1') report "expect E3 HIGH" severity error;
        assert(E2 = '0') report "expect E2 LOW" severity error;
        assert(E1 = '0') report "expect E1 LOW" severity error;
        assert(E0 = '1') report "expect E0 HIGH" severity error;

        H3 <= '0';
        H4 <= '1';
        H5 <= '0';
        V3 <= '1';
        V4 <= '0';
        wait for 1 ns;
        assert(E3 = '0') report "expect E3 LOW" severity error;
        assert(E2 = '1') report "expect E2 HIGH" severity error;
        assert(E1 = '0') report "expect E1 LOW" severity error;
        assert(E0 = '0') report "expect E0 LOW" severity error;

        H3 <= '0';
        H4 <= '1';
        H5 <= '0';
        V3 <= '1';
        V4 <= '1';
        wait for 1 ns;
        assert(E3 = '1') report "expect E3 HIGH" severity error;
        assert(E2 = '1') report "expect E2 HIGH" severity error;
        assert(E1 = '1') report "expect E1 HIGH" severity error;
        assert(E0 = '0') report "expect E0 LOW" severity error;

        H3 <= '0';
        H4 <= '1';
        H5 <= '1';
        V3 <= '0';
        V4 <= '0';
        wait for 1 ns;
        assert(E3 = '0') report "expect E3 LOW" severity error;
        assert(E2 = '0') report "expect E2 LOW" severity error;
        assert(E1 = '1') report "expect E1 HIGH" severity error;
        assert(E0 = '1') report "expect E0 HIGH" severity error;

        H3 <= '0';
        H4 <= '1';
        H5 <= '1';
        V3 <= '0';
        V4 <= '1';
        wait for 1 ns;
        assert(E3 = '1') report "expect E3 HIGH" severity error;
        assert(E2 = '1') report "expect E2 HIGH" severity error;
        assert(E1 = '0') report "expect E1 LOW" severity error;
        assert(E0 = '1') report "expect E0 HIGH" severity error;

        H3 <= '0';
        H4 <= '1';
        H5 <= '1';
        V3 <= '1';
        V4 <= '0';
        wait for 1 ns;
        assert(E3 = '1') report "expect E3 HIGH" severity error;
        assert(E2 = '0') report "expect E2 LOW" severity error;
        assert(E1 = '0') report "expect E1 LOW" severity error;
        assert(E0 = '0') report "expect E0 LOW" severity error;

        H3 <= '0';
        H4 <= '1';
        H5 <= '1';
        V3 <= '1';
        V4 <= '1';
        wait for 1 ns;
        assert(E3 = '0') report "expect E3 LOW" severity error;
        assert(E2 = '0') report "expect E2 LOW" severity error;
        assert(E1 = '1') report "expect E1 HIGH" severity error;
        assert(E0 = '0') report "expect E0 LOW" severity error;

        H3 <= '0';
        H4 <= '0';
        H5 <= '0';
        V3 <= '0';
        V4 <= '0';
        wait for 1 ns;
        assert(E3 = '1') report "expect E3 HIGH" severity error;
        assert(E2 = '1') report "expect E2 HIGH" severity error;
        assert(E1 = '0') report "expect E1 LOW" severity error;
        assert(E0 = '1') report "expect E0 HIGH" severity error;

        H3 <= '0';
        H4 <= '0';
        H5 <= '0';
        V3 <= '0';
        V4 <= '1';
        wait for 1 ns;
        assert(E3 = '0') report "expect E3 LOW" severity error;
        assert(E2 = '1') report "expect E2 HIGH" severity error;
        assert(E1 = '1') report "expect E1 HIGH" severity error;
        assert(E0 = '1') report "expect E0 HIGH" severity error;

        H3 <= '0';
        H4 <= '0';
        H5 <= '0';
        V3 <= '1';
        V4 <= '0';
        wait for 1 ns;
        assert(E3 = '0') report "expect E3 LOW" severity error;
        assert(E2 = '0') report "expect E2 LOW" severity error;
        assert(E1 = '1') report "expect E1 HIGH" severity error;
        assert(E0 = '0') report "expect E0 LOW" severity error;

        H3 <= '0';
        H4 <= '0';
        H5 <= '0';
        V3 <= '1';
        V4 <= '1';
        wait for 1 ns;
        assert(E3 = '1') report "expect E3 HIGH" severity error;
        assert(E2 = '1') report "expect E2 HIGH" severity error;
        assert(E1 = '0') report "expect E1 LOW" severity error;
        assert(E0 = '0') report "expect E0 LOW" severity error;

        H3 <= '0';
        H4 <= '0';
        H5 <= '1';
        V3 <= '0';
        V4 <= '0';
        wait for 1 ns;
        assert(E3 = '0') report "expect E3 LOW" severity error;
        assert(E2 = '0') report "expect E2 LOW" severity error;
        assert(E1 = '0') report "expect E1 LOW" severity error;
        assert(E0 = '1') report "expect E0 HIGH" severity error;

        H3 <= '0';
        H4 <= '0';
        H5 <= '1';
        V3 <= '0';
        V4 <= '1';
        wait for 1 ns;
        assert(E3 = '1') report "expect E3 HIGH" severity error;
        assert(E2 = '0') report "expect E2 LOW" severity error;
        assert(E1 = '1') report "expect E1 HIGH" severity error;
        assert(E0 = '1') report "expect E0 HIGH" severity error;

        H3 <= '0';
        H4 <= '0';
        H5 <= '1';
        V3 <= '1';
        V4 <= '0';
        wait for 1 ns;
        assert(E3 = '0') report "expect E3 LOW" severity error;
        assert(E2 = '1') report "expect E2 HIGH" severity error;
        assert(E1 = '1') report "expect E1 HIGH" severity error;
        assert(E0 = '0') report "expect E0 LOW" severity error;

        H3 <= '0';
        H4 <= '0';
        H5 <= '1';
        V3 <= '1';
        V4 <= '1';
        wait for 1 ns;
        assert(E3 = '0') report "expect E3 LOW" severity error;
        assert(E2 = '0') report "expect E2 LOW" severity error;
        assert(E1 = '0') report "expect E1 LOW" severity error;
        assert(E0 = '0') report "expect E0 LOW" severity error;

        H3 <= '0';
        H4 <= '1';
        H5 <= '0';
        V3 <= '0';
        V4 <= '0';
        wait for 1 ns;
        assert(E3 = '1') report "expect E3 HIGH" severity error;
        assert(E2 = '1') report "expect E2 HIGH" severity error;
        assert(E1 = '1') report "expect E1 HIGH" severity error;
        assert(E0 = '1') report "expect E0 HIGH" severity error;

        H3 <= '0';
        H4 <= '1';
        H5 <= '0';
        V3 <= '0';
        V4 <= '1';
        wait for 1 ns;
        assert(E3 = '1') report "expect E3 HIGH" severity error;
        assert(E2 = '0') report "expect E2 LOW" severity error;
        assert(E1 = '0') report "expect E1 LOW" severity error;
        assert(E0 = '1') report "expect E0 HIGH" severity error;

        H3 <= '0';
        H4 <= '1';
        H5 <= '0';
        V3 <= '1';
        V4 <= '0';
        wait for 1 ns;
        assert(E3 = '0') report "expect E3 LOW" severity error;
        assert(E2 = '1') report "expect E2 HIGH" severity error;
        assert(E1 = '0') report "expect E1 LOW" severity error;
        assert(E0 = '0') report "expect E0 LOW" severity error;

        H3 <= '0';
        H4 <= '1';
        H5 <= '0';
        V3 <= '1';
        V4 <= '1';
        wait for 1 ns;
        assert(E3 = '1') report "expect E3 HIGH" severity error;
        assert(E2 = '1') report "expect E2 HIGH" severity error;
        assert(E1 = '1') report "expect E1 HIGH" severity error;
        assert(E0 = '0') report "expect E0 LOW" severity error;

        H3 <= '0';
        H4 <= '1';
        H5 <= '1';
        V3 <= '0';
        V4 <= '0';
        wait for 1 ns;
        assert(E3 = '0') report "expect E3 LOW" severity error;
        assert(E2 = '0') report "expect E2 LOW" severity error;
        assert(E1 = '1') report "expect E1 HIGH" severity error;
        assert(E0 = '1') report "expect E0 HIGH" severity error;

        H3 <= '0';
        H4 <= '1';
        H5 <= '1';
        V3 <= '0';
        V4 <= '1';
        wait for 1 ns;
        assert(E3 = '1') report "expect E3 HIGH" severity error;
        assert(E2 = '1') report "expect E2 HIGH" severity error;
        assert(E1 = '0') report "expect E1 LOW" severity error;
        assert(E0 = '1') report "expect E0 HIGH" severity error;

        H3 <= '0';
        H4 <= '1';
        H5 <= '1';
        V3 <= '1';
        V4 <= '0';
        wait for 1 ns;
        assert(E3 = '1') report "expect E3 HIGH" severity error;
        assert(E2 = '0') report "expect E2 LOW" severity error;
        assert(E1 = '0') report "expect E1 LOW" severity error;
        assert(E0 = '0') report "expect E0 LOW" severity error;

        H3 <= '0';
        H4 <= '1';
        H5 <= '1';
        V3 <= '1';
        V4 <= '1';
        wait for 1 ns;
        assert(E3 = '0') report "expect E3 LOW" severity error;
        assert(E2 = '0') report "expect E2 LOW" severity error;
        assert(E1 = '1') report "expect E1 HIGH" severity error;
        assert(E0 = '0') report "expect E0 LOW" severity error;

        -- WNDW_N tests -----------------------
        PHI_0   <= '0';
        BL_N    <= '0';
        wait for 1 ns;
        assert(WNDW_N = 'U') report "expect WNDW_N unchanged" severity error;

        PHI_0 <= '1';
        wait for 1 ns;
        assert(WNDW_N = '1') report "expect WNDW_N HIGH" severity error;

        BL_N  <= '1';
        wait for 1 ns;
        assert(WNDW_N = '1') report "expect WNDW_N HIGH" severity error;

        PHI_0 <= '0';
        wait for 1 ns;

        PHI_0 <= '1';
        wait for 1 ns;
        assert(WNDW_N = '0') report "expect WNDW_N LOW" severity error;

        -- RA9_N tests
        VID6      <= '0';
        LGR_TXT_N <= '0';
        PAYMAR    <= '0';
        VID7      <= '0';
        wait for 1 ns;
        assert(RA9_N = '0') report "expect RA9_N LOW" severity error;

        VID6      <= '1';
        LGR_TXT_N <= '0';
        PAYMAR    <= '0';
        VID7      <= '0';
        wait for 1 ns;
        assert(RA9_N = '0') report "expect RA9_N LOW" severity error;

        VID6      <= '1';
        LGR_TXT_N <= '1';
        PAYMAR    <= '1';
        VID7      <= '1';
        wait for 1 ns;
        assert(RA9_N = '1') report "expect RA9_N HIGH" severity error;

        -- RA10_N tests
        VID6      <= '0';
        PAYMAR    <= '0';
        FLASH     <= '0';
        LGR_TXT_N <= '0';
        VID7      <= '0';
        wait for 1 ns;
        assert(RA10_N = '0') report "expect RA10_N LOW" severity error;

        VID6      <= '0';
        PAYMAR    <= '0';
        FLASH     <= '0';
        LGR_TXT_N <= '0';
        VID7      <= '1';
        wait for 1 ns;
        assert(RA10_N = '1') report "expect RA10_N HIGH" severity error;

        VID6      <= '1';
        PAYMAR    <= '0';
        FLASH     <= '0';
        LGR_TXT_N <= '0';
        VID7      <= '0';
        wait for 1 ns;
        assert(RA10_N = '1') report "expect RA10_N HIGH" severity error;

        VID6      <= '1';
        PAYMAR    <= '1';
        FLASH     <= '0';
        LGR_TXT_N <= '0';
        VID7      <= '0';
        wait for 1 ns;
        assert(RA10_N = '0') report "expect RA10_N LOW" severity error;

        VID6      <= '1';
        PAYMAR    <= '0';
        FLASH     <= '1';
        LGR_TXT_N <= '0';
        VID7      <= '0';
        wait for 1 ns;
        assert(RA10_N = '0') report "expect RA10_N LOW" severity error;

        -- CLRGAT_N ---------------------------------------
        PHI_0 <= '0';
        PRAS_N <= '1';
        PCLRGAT <= '0';
        wait for 1 ns;
        assert(CLRGAT_N = 'U') report "expect CLRGAT_N unchanged" severity error;

        PHI_0 <= '1';
        PRAS_N <= '0';
        wait for 1 ns;
        assert(CLRGAT_N = 'U') report "expect CLRGAT_N unchanged" severity error;

        PRAS_N <= '1';
        PCLRGAT <= '0';
        wait for 1 ns;
        assert(CLRGAT_N = '1') report "expect CLRGAT_N HIGH" severity error;

        PRAS_N <= '0';
        wait for 1 ns;

        PRAS_N <= '1';
        PCLRGAT <= '1';
        wait for 1 ns;
        assert(CLRGAT_N = '0') report "expect CLRGAT_N LOW" severity error;

        -- SYNC_N ---------------------------------------
        PHI_0 <= '0';
        PRAS_N <= '1';
        PSYNC_N <= '0';
        wait for 1 ns;
        assert(SYNC_N = 'U') report "expect SYNC_N unchanged" severity error;

        PHI_0 <= '1';
        PRAS_N <= '0';
        wait for 1 ns;
        assert(SYNC_N = 'U') report "expect SYNC_N unchanged" severity error;

        PHI_0 <= '1';
        PRAS_N <= '1';
        wait for 1 ns;
        assert(SYNC_N = '0') report "expect SYNC_N LOW" severity error;

        PRAS_N <= '0';
        wait for 1 ns;

        PRAS_N <= '1';
        PSYNC_N <= '1';
        wait for 1 ns;
        assert(SYNC_N = '1') report "expect SYNC_N HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
