library IEEE;
use IEEE.std_logic_1164.all;

entity COMMON_INTERNALS_TB is
    -- empty
end COMMON_INTERNALS_TB;
architecture COMMON_INTERNALS_TEST of COMMON_INTERNALS_TB is
    component COMMON_INTERNALS is
        port (
            R_W_N  : in std_logic;
            C01X_N : in std_logic;
            PRAS_N : in std_logic;
            Q3     : in std_logic;
            PHI_0  : in std_logic;

            RC01X_N   : out std_logic;
            RAS_N     : out std_logic;
            P_PHI_0   : out std_logic;
            P_PHI_1   : out std_logic;
            Q3_PRAS_N : out std_logic
        );
    end component;

    signal R_W_N  : std_logic;
    signal C01X_N : std_logic;
    signal PRAS_N : std_logic;
    signal Q3     : std_logic;
    signal PHI_0  : std_logic;

    signal RC01X_N   : std_logic;
    signal RAS_N     : std_logic;
    signal P_PHI_0   : std_logic;
    signal P_PHI_1   : std_logic;
    signal Q3_PRAS_N : std_logic;

begin
    dut : COMMON_INTERNALS port map(
        R_W_N  => R_W_N,
        C01X_N => C01X_N,
        PRAS_N => PRAS_N,
        Q3     => Q3,
        PHI_0  => PHI_0,

        RC01X_N   => RC01X_N,
        RAS_N     => RAS_N,
        P_PHI_0   => P_PHI_0,
        P_PHI_1   => P_PHI_1,
        Q3_PRAS_N => Q3_PRAS_N
    );

    process begin
        -- RC01X_N --------------------------------------------------------
        R_W_N  <= '0';
        C01X_N <= '0';
        wait for 1 ns;
        assert(RC01X_N = '1') report "When R_W_N LOW, C01X_N LOW; expect RC01X_N HIGH" severity error;

        R_W_N  <= '1';
        C01X_N <= '0';
        wait for 1 ns;
        assert(RC01X_N = '0') report "When R_W_N HIGH, C01X_N LOW; expect RC01X_N LOW" severity error;

        R_W_N  <= '0';
        C01X_N <= '1';
        wait for 1 ns;
        assert(RC01X_N = '1') report "When R_W_N LOW, C01X_N HIGH; expect RC01X_N HIGH" severity error;

        R_W_N  <= '1';
        C01X_N <= '1';
        wait for 1 ns;
        assert(RC01X_N = '1') report "When R_W_N HIGH, C01X_N HIGH; expect RC01X_N HIGH" severity error;

        -- RAS_N ----------------------------------------------------------
        PRAS_N <= '0';
        wait for 1 ns;
        assert(RAS_N = '0') report "When PRAS_N LOW; expect PRAS_N LOW" severity error;

        PRAS_N <= '1';
        wait for 1 ns;
        assert(RAS_N = '1') report "When PRAS_N HIGH; expect PRAS_N HIGH" severity error;

        -- Q3_PRAS_N ------------------------------------------------------
        Q3     <= '0';
        PRAS_N <= '0';
        wait for 1 ns;
        assert(Q3_PRAS_N = '0') report "When Q3 LOW, PRAS_N LOW; expect Q3_PRAS_N LOW" severity error;

        Q3     <= '1';
        PRAS_N <= '0';
        wait for 1 ns;
        assert(Q3_PRAS_N = '1') report "When Q3 HIGH, PRAS_N LOW; expect Q3_PRAS_N HIGH" severity error;

        Q3     <= '0';
        PRAS_N <= '1';
        wait for 1 ns;
        assert(Q3_PRAS_N = '1') report "When Q3 LOW, PRAS_N HIGH; expect Q3_PRAS_N HIGH" severity error;

        Q3     <= '1';
        PRAS_N <= '1';
        wait for 1 ns;
        assert(Q3_PRAS_N = '1') report "When Q3 HIGH, PRAS_N HIGH; expect Q3_PRAS_N HIGH" severity error;

        -- P_PHI_0 & P_PHI_1 ----------------------------------------------
        Q3     <= '1';
        PRAS_N <= '0';
        PHI_0  <= '0';
        wait for 1 ns;
        assert(Q3_PRAS_N = '1') report "Precondition: expect Q3_PRAS_N HIGH" severity error;
        assert(P_PHI_0 = 'U') report "When not enabled; expect P_PHI_0 unchanged" severity error;
        assert(P_PHI_1 = 'U') report "When not enabled; expect P_PHI_1 unchanged" severity error;

        Q3     <= '0';
        PRAS_N <= '0';
        PHI_0  <= '0';
        wait for 1 ns;
        assert(Q3_PRAS_N = '0') report "Precondition: expect Q3_PRAS_N LOW" severity error;
        assert(P_PHI_0 = '1') report "When enabled, PHI_0 LOW; expect P_PHI_0 HIGH" severity error;
        assert(P_PHI_1 = '0') report "When enabled, PHI_0 LOW; expect P_PHI_1 LOW" severity error;

        PHI_0 <= '1';
        wait for 1 ns;
        assert(P_PHI_0 = '0') report "When enabled, PHI_0 LOW; expect P_PHI_0 LOW" severity error;
        assert(P_PHI_1 = '1') report "When enabled, PHI_0 LOW; expect P_PHI_1 HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end COMMON_INTERNALS_TEST;
