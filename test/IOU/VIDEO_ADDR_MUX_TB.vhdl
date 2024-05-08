library IEEE;
use IEEE.std_logic_1164.all;

entity VIDEO_ADDR_MUX_TB is
    -- empty
end VIDEO_ADDR_MUX_TB;

architecture VIDEO_ADDR_MUX_TEST of VIDEO_ADDR_MUX_TB is
    component VIDEO_ADDR_MUX is
        port (
            PHI_1          : in std_logic;
            PRAS_N         : in std_logic;
            Q3             : in std_logic;
            PG2_N          : in std_logic;
            EN80VID        : in std_logic;
            HIRESEN_N      : in std_logic;
            VA, VB, VC     : in std_logic;
            V0, V1, V2     : in std_logic;
            H0, H1, H2     : in std_logic;
            E0, E1, E2, E3 : in std_logic;

            RA_ENABLE_N        : out std_logic;
            RA0, RA1, RA2, RA3,
            RA4, RA5, RA6, RA7 : out std_logic
        );
    end component;

    signal PHI_1          : std_logic;
    signal Q3             : std_logic;
    signal PG2_N          : std_logic;
    signal EN80VID        : std_logic;
    signal HIRESEN_N      : std_logic;
    signal VA, VB, VC     : std_logic;
    signal PRAS_N         : std_logic;
    signal V0, V1, V2     : std_logic;
    signal H0, H1, H2     : std_logic;
    signal E0, E1, E2, E3 : std_logic;

    signal RA_ENABLE_N        : std_logic;
    signal RA0, RA1, RA2, RA3,
    RA4, RA5, RA6, RA7 : std_logic;

begin
    dut : VIDEO_ADDR_MUX port map(
        PHI_1       => PHI_1,
        Q3          => Q3,
        PG2_N       => PG2_N,
        EN80VID     => EN80VID,
        HIRESEN_N   => HIRESEN_N,
        VA          => VA,
        VB          => VB,
        VC          => VC,
        PRAS_N      => PRAS_N,
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
        RA_ENABLE_N => RA_ENABLE_N,
        RA0         => RA0,
        RA1         => RA1,
        RA2         => RA2,
        RA3         => RA3,
        RA4         => RA4,
        RA5         => RA5,
        RA6         => RA6,
        RA7         => RA7
    );

    process begin
        -- ZA-ZE tests
        PRAS_N <= '0';

        PG2_N     <= '0';
        EN80VID   <= '0';
        HIRESEN_N <= '0';
        VA        <= '1';
        VB        <= '1';
        VC        <= '1';
        wait for 1 ns;
        assert(RA2 = '1') report "expect ZA HIGH" severity error;
        assert(RA3 = '1') report "expect ZB HIGH" severity error;
        assert(RA4 = '1') report "expect ZC HIGH" severity error;
        assert(RA5 = '0') report "expect ZD LOW" severity error;
        assert(RA6 = '1') report "expect ZE HIGH" severity error;

        PG2_N   <= '1';
        EN80VID <= '0';
        wait for 1 ns;
        assert(RA2 = '1') report "expect ZA HIGH" severity error;
        assert(RA3 = '1') report "expect ZB HIGH" severity error;
        assert(RA4 = '1') report "expect ZC HIGH" severity error;
        assert(RA5 = '1') report "expect ZD HIGH" severity error;
        assert(RA6 = '0') report "expect ZE LOW" severity error;

        PG2_N   <= '0';
        EN80VID <= '1';
        wait for 1 ns;
        assert(RA2 = '1') report "expect ZA HIGH" severity error;
        assert(RA3 = '1') report "expect ZB HIGH" severity error;
        assert(RA4 = '1') report "expect ZC HIGH" severity error;
        assert(RA5 = '1') report "expect ZD HIGH" severity error;
        assert(RA6 = '0') report "expect ZE LOW" severity error;

        EN80VID   <= '0';
        HIRESEN_N <= '1';
        wait for 1 ns;
        assert(RA2 = '0') report "expect ZA LOW" severity error;
        assert(RA3 = '1') report "expect ZB HIGH" severity error;
        assert(RA4 = '0') report "expect ZC LOW" severity error;
        assert(RA5 = '0') report "expect ZD LOW" severity error;
        assert(RA6 = '0') report "expect ZE LOW" severity error;

        PG2_N   <= '1';
        EN80VID <= '0';
        wait for 1 ns;
        assert(RA2 = '1') report "expect ZA HIGH" severity error;
        assert(RA3 = '0') report "expect ZB LOW" severity error;
        assert(RA4 = '0') report "expect ZC LOW" severity error;
        assert(RA5 = '0') report "expect ZD LOW" severity error;
        assert(RA6 = '0') report "expect ZE LOW" severity error;

        PG2_N   <= '0';
        EN80VID <= '1';
        wait for 1 ns;
        assert(RA2 = '1') report "expect ZA HIGH" severity error;
        assert(RA3 = '0') report "expect ZB LOW" severity error;
        assert(RA4 = '0') report "expect ZC LOW" severity error;
        assert(RA5 = '0') report "expect ZD LOW" severity error;
        assert(RA6 = '0') report "expect ZE LOW" severity error;

        -- RA0-RA7 tests
        PRAS_N    <= '0';
        V1        <= '1';
        V2        <= '1';
        E3        <= '1';
        PG2_N     <= '0';
        EN80VID   <= '0';
        HIRESEN_N <= '0';
        VA        <= '1';
        VB        <= '1';
        VC        <= '1';
        wait for 1 ns;
        assert(RA0 = '1') report "expect RA0 HIGH" severity error;
        assert(RA1 = '1') report "expect RA1 HIGH" severity error;
        assert(RA2 = '1') report "expect RA2 HIGH" severity error;
        assert(RA3 = '1') report "expect RA3 HIGH" severity error;
        assert(RA4 = '1') report "expect RA4 HIGH" severity error;
        assert(RA5 = '0') report "expect RA5 LOW" severity error;
        assert(RA6 = '1') report "expect RA6 HIGH" severity error;
        assert(RA7 = '0') report "expect RA7 LOW" severity error;

        PRAS_N    <= '1';
        VA        <= 'U';
        VB        <= 'U';
        VC        <= 'U';
        V2        <= 'U';
        H0        <= '1';
        H1        <= '1';
        H2        <= '1';
        E0        <= '1';
        E1        <= '1';
        E2        <= '1';
        E3        <= 'U';
        V0        <= '1';
        V1        <= '1';
        EN80VID   <= 'U';
        HIRESEN_N <= 'U';
        PG2_N     <= 'U';
        wait for 1 ns;
        assert(RA0 = '1') report "expect RA0 HIGH" severity error;
        assert(RA1 = '1') report "expect RA1 HIGH" severity error;
        assert(RA2 = '1') report "expect RA2 HIGH" severity error;
        assert(RA3 = '1') report "expect RA3 HIGH" severity error;
        assert(RA4 = '1') report "expect RA4 HIGH" severity error;
        assert(RA5 = '1') report "expect RA5 HIGH" severity error;
        assert(RA6 = '1') report "expect RA6 HIGH" severity error;
        assert(RA7 = '1') report "expect RA7 LOW" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end VIDEO_ADDR_MUX_TEST;
