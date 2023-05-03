library IEEE;
use IEEE.std_logic_1164.all;

entity SOFT_SWITCHES_C00X_TB is
    -- empty
end SOFT_SWITCHES_C00X_TB;
architecture SOFT_SWITCHES_C00X_TEST of SOFT_SWITCHES_C00X_TB is
    component SOFT_SWITCHES_C00X is
        port (
            D           : in std_logic;
            SWITCH_ADDR : in std_logic_vector(2 downto 0);
            C00X_N      : in std_logic;
            R_W_N       : in std_logic;
            RESET_N     : in std_logic;
            PHI         : in std_logic;

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

    signal D       : std_logic;
    signal A       : std_logic_vector(2 downto 0);
    signal C00X_N  : std_logic;
    signal R_W_N   : std_logic;
    signal RESET_N : std_logic;
    signal PHI     : std_logic;

    signal EN80VID   : std_logic;
    signal FLG1      : std_logic;
    signal FLG2      : std_logic;
    signal PENIO_N   : std_logic;
    signal ALTSTKZP  : std_logic;
    signal INTC300_N : std_logic;
    signal INTC300   : std_logic;
    signal S_80COL   : std_logic;
    signal PAYMAR    : std_logic;

begin
    dut : SOFT_SWITCHES_C00X port map(
        D           => D,
        SWITCH_ADDR => A,
        C00X_N      => C00X_N,
        R_W_N       => R_W_N,
        RESET_N     => RESET_N,
        PHI         => PHI,

        EN80VID   => EN80VID,
        FLG1      => FLG1,
        FLG2      => FLG2,
        PENIO_N   => PENIO_N,
        ALTSTKZP  => ALTSTKZP,
        INTC300_N => INTC300_N,
        INTC300   => INTC300,
        S_80COL   => S_80COL,
        PAYMAR    => PAYMAR
    );

    process begin
        PHI <= '1';

        RESET_N <= '0';
        wait for 1 ns;
        wait for 1 ns;
        assert(EN80VID = '0') report "When RESET_N is LOW, value of EN80VID be LOW" severity error;
        assert(FLG1 = '0') report "When RESET_N is LOW, value of FLG1 should be LOW" severity error;
        assert(FLG2 = '0') report "When RESET_N is LOW, value of FLG2 should be LOW" severity error;
        assert(PENIO_N = '0') report "When RESET_N is LOW, value of PENIO_N should be LOW" severity error;
        assert(ALTSTKZP = '0') report "When RESET_N is LOW, value of ALTSTKZP should be LOW" severity error;
        assert(INTC300_N = '0') report "When RESET_N is LOW, value of INTC300_N should be LOW" severity error;
        assert(S_80COL = '0') report "When RESET_N is LOW, value of S_80COL should be LOW" severity error;
        assert(PAYMAR = '0') report "When RESET_N is LOW, value of PAYMAR should be LOW" severity error;

        RESET_N <= '1';
        wait for 1 ns;

        R_W_N  <= '1';
        C00X_N <= '1';

        A <= "000";
        D <= '1';
        wait for 1 ns;
        assert(EN80VID = '0') report "When switches are disabled, value of EN80VID should not change" severity error;
        assert(FLG1 = '0') report "When switches are disabled, value of FLG1 should not change" severity error;
        assert(FLG2 = '0') report "When switches are disabled, value of FLG2 should not change" severity error;
        assert(PENIO_N = '0') report "When switches are disabled, value of PENIO_N should not change" severity error;
        assert(ALTSTKZP = '0') report "When switches are disabled, value of ALTSTKZP should not change" severity error;
        assert(INTC300_N = '0') report "When switches are disabled, value of INTC300_N should not change" severity error;
        assert(S_80COL = '0') report "When switches are disabled, value of S_80COL should not change" severity error;
        assert(PAYMAR = '0') report "When switches are disabled, value of PAYMAR should not change" severity error;

        R_W_N  <= '0';
        C00X_N <= '0';
        A      <= "000";
        D      <= '1';
        wait for 1 ns;
        assert(EN80VID = '1') report "When address 000, value of EN80VID should take the value of D" severity error;
        assert(FLG1 = '0') report "When address 000, value of FLG1 should not change" severity error;
        assert(FLG2 = '0') report "When address 000, value of FLG2 should not change" severity error;
        assert(PENIO_N = '0') report "When address 000, value of PENIO_N should not change" severity error;
        assert(ALTSTKZP = '0') report "When address 000, value of ALTSTKZP should not change" severity error;
        assert(INTC300_N = '0') report "When address 000, value of INTC300_N should not change" severity error;
        assert(S_80COL = '0') report "When address 000, value of S_80COL should not change" severity error;
        assert(PAYMAR = '0') report "When address 000, value of PAYMAR should not change" severity error;

        A <= "001";
        wait for 1 ns;
        assert(EN80VID = '1') report "When address 001, value of EN80VID should not change" severity error;
        assert(FLG1 = '1') report "When address 001, value of FLG1 should take the value of D" severity error;
        assert(FLG2 = '0') report "When address 001, value of FLG2 should not change" severity error;
        assert(PENIO_N = '0') report "When address 001, value of PENIO_N should not change" severity error;
        assert(ALTSTKZP = '0') report "When address 001, value of ALTSTKZP should not change" severity error;
        assert(INTC300_N = '0') report "When address 001, value of INTC300_N should not change" severity error;
        assert(S_80COL = '0') report "When address 001, value of S_80COL should not change" severity error;
        assert(PAYMAR = '0') report "When address 001, value of PAYMAR should not change" severity error;

        A <= "010";
        wait for 1 ns;
        assert(EN80VID = '1') report "When address 010, value of EN80VID should not change" severity error;
        assert(FLG1 = '1') report "When address 010, value of FLG1 should not change" severity error;
        assert(FLG2 = '1') report "When address 010, value of FLG2 should take the value of D" severity error;
        assert(PENIO_N = '0') report "When address 010, value of PENIO_N should not change" severity error;
        assert(ALTSTKZP = '0') report "When address 010, value of ALTSTKZP should not change" severity error;
        assert(INTC300_N = '0') report "When address 010, value of INTC300_N should not change" severity error;
        assert(S_80COL = '0') report "When address 010, value of S_80COL should not change" severity error;
        assert(PAYMAR = '0') report "When address 010, value of PAYMAR should not change" severity error;

        A <= "011";
        wait for 1 ns;
        assert(EN80VID = '1') report "When address 011, value of EN80VID should not change" severity error;
        assert(FLG1 = '1') report "When address 011, value of FLG1 should not change" severity error;
        assert(FLG2 = '1') report "When address 011, value of FLG2 should not change" severity error;
        assert(PENIO_N = '1') report "When address 011, value of PENIO_N should take the value of D" severity error;
        assert(ALTSTKZP = '0') report "When address 011, value of ALTSTKZP should not change" severity error;
        assert(INTC300_N = '0') report "When address 011, value of INTC300_N should not change" severity error;
        assert(S_80COL = '0') report "When address 011, value of S_80COL should not change" severity error;
        assert(PAYMAR = '0') report "When address 011, value of PAYMAR should not change" severity error;

        A <= "100";
        wait for 1 ns;
        assert(EN80VID = '1') report "When address 100, value of EN80VID should not change" severity error;
        assert(FLG1 = '1') report "When address 100, value of FLG1 should not change" severity error;
        assert(FLG2 = '1') report "When address 100, value of FLG2 should not change" severity error;
        assert(PENIO_N = '1') report "When address 100, value of PENIO_N should not change" severity error;
        assert(ALTSTKZP = '1') report "When address 100, value of ALTSTKZP should take the value of D" severity error;
        assert(INTC300_N = '0') report "When address 100, value of INTC300_N should not change" severity error;
        assert(S_80COL = '0') report "When address 100, value of S_80COL should not change" severity error;
        assert(PAYMAR = '0') report "When address 100, value of PAYMAR should not change" severity error;

        A <= "101";
        wait for 1 ns;
        assert(EN80VID = '1') report "When address 101, value of EN80VID should not change" severity error;
        assert(FLG1 = '1') report "When address 101, value of FLG1 should not change" severity error;
        assert(FLG2 = '1') report "When address 101, value of FLG2 should not change" severity error;
        assert(PENIO_N = '1') report "When address 101, value of PENIO_N should not change" severity error;
        assert(ALTSTKZP = '1') report "When address 101, value of ALTSTKZP should not change" severity error;
        assert(INTC300_N = '1') report "When address 101, value of INTC300_N should take the value of D" severity error;
        assert(S_80COL = '0') report "When address 101, value of S_80COL should not change" severity error;
        assert(PAYMAR = '0') report "When address 101, value of PAYMAR should not change" severity error;

        A <= "110";
        wait for 1 ns;
        assert(EN80VID = '1') report "When address 110, value of EN80VID should not change" severity error;
        assert(FLG1 = '1') report "When address 110, value of FLG1 should not change" severity error;
        assert(FLG2 = '1') report "When address 110, value of FLG2 should not change" severity error;
        assert(PENIO_N = '1') report "When address 110, value of PENIO_N should not change" severity error;
        assert(ALTSTKZP = '1') report "When address 110, value of ALTSTKZP should not change" severity error;
        assert(INTC300_N = '1') report "When address 110, value of INTC300_N should not change" severity error;
        assert(S_80COL = '1') report "When address 110, value of S_80COL should take the value of D" severity error;
        assert(PAYMAR = '0') report "When address 110, value of PAYMAR should not change" severity error;

        A <= "111";
        wait for 1 ns;
        assert(EN80VID = '1') report "When address 111, value of EN80VID should not change" severity error;
        assert(FLG1 = '1') report "When address 111, value of FLG1 should not change" severity error;
        assert(FLG2 = '1') report "When address 111, value of FLG2 should not change" severity error;
        assert(PENIO_N = '1') report "When address 111, value of PENIO_N should not change" severity error;
        assert(ALTSTKZP = '1') report "When address 111, value of ALTSTKZP should not change" severity error;
        assert(INTC300_N = '1') report "When address 111, value of INTC300_N should not change" severity error;
        assert(S_80COL = '1') report "When address 111, value of S_80COL should not change" severity error;
        assert(PAYMAR = '1') report "When address 111, value of PAYMAR should take the value of D" severity error;

        PHI <= '0';
        wait for 1 ns;

        A <= "000";
        D <= '0';
        wait for 1 ns;
        assert(EN80VID = '1') report "During opposite PHASE, value of EN80VID should not change" severity error;
        assert(FLG1 = '1') report "During opposite PHASE, value of FLG1 should not change" severity error;
        assert(FLG2 = '1') report "During opposite PHASE, value of FLG2 should not change" severity error;
        assert(PENIO_N = '1') report "During opposite PHASE, value of PENIO_N should not change" severity error;
        assert(ALTSTKZP = '1') report "During opposite PHASE, value of ALTSTKZP should not change" severity error;
        assert(INTC300_N = '1') report "During opposite PHASE, value of INTC300_N should not change" severity error;
        assert(S_80COL = '1') report "During opposite PHASE, value of S_80COL should not change" severity error;
        assert(PAYMAR = '1') report "During opposite PHASE, value of PAYMAR should not change" severity error;
        assert false report "Test done." severity note;
        wait;

    end process;
end SOFT_SWITCHES_C00X_TEST;
