library IEEE;
use IEEE.std_logic_1164.all;

entity SOFT_SWITCHES_C05X_TB is
    -- empty
end SOFT_SWITCHES_C05X_TB;
architecture SOFT_SWITCHES_C05X_TEST of SOFT_SWITCHES_C05X_TB is
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

    signal D       : std_logic;
    signal A       : std_logic_vector(2 downto 0);
    signal C05X_N  : std_logic;
    signal RESET_N : std_logic;

    signal ITEXT : std_logic;
    signal MIX   : std_logic;
    signal PG2   : std_logic;
    signal HIRES : std_logic;
    signal AN0   : std_logic;
    signal AN1   : std_logic;
    signal AN2   : std_logic;
    signal AN3   : std_logic;

begin
    dut : SOFT_SWITCHES_C05X port map(
        D           => D,
        SWITCH_ADDR => A,
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

    process begin
        RESET_N <= '0';
        wait for 1 ns;
        wait for 1 ns;
        assert(ITEXT = 'U') report "When RESET_N is LOW, value of ITEXT should not change" severity error;
        assert(MIX = 'U') report "When RESET_N is LOW, value of MIX should not change" severity error;
        assert(PG2 = '0') report "When RESET_N is LOW, value of PG2 should be LOW" severity error;
        assert(HIRES = '0') report "When RESET_N is LOW, value of HIRES should be LOW" severity error;
        assert(AN0 = '0') report "When RESET_N is LOW, value of AN0 should be LOW" severity error;
        assert(AN1 = '0') report "When RESET_N is LOW, value of AN1 should be LOW" severity error;
        assert(AN2 = '0') report "When RESET_N is LOW, value of AN2 should be LOW" severity error;
        assert(AN3 = '0') report "When RESET_N is LOW, value of AN3 should be LOW" severity error;

        RESET_N <= '1';
        wait for 1 ns;

        C05X_N <= '1';
        A      <= "000";
        D      <= '1';
        wait for 1 ns;
        assert(ITEXT = 'U') report "When switches are disabled, value of ITEXT should not change" severity error;
        assert(MIX = 'U') report "When switches are disabled, value of MIX should not change" severity error;
        assert(PG2 = '0') report "When switches are disabled, value of PG2 should not change" severity error;
        assert(HIRES = '0') report "When switches are disabled, value of HIRES should not change" severity error;
        assert(AN0 = '0') report "When switches are disabled, value of AN0 should not change" severity error;
        assert(AN1 = '0') report "When switches are disabled, value of AN1 should not change" severity error;
        assert(AN2 = '0') report "When switches are disabled, value of AN2 should not change" severity error;
        assert(AN3 = '0') report "When switches are disabled, value of AN3 should not change" severity error;

        C05X_N <= '0';
        A      <= "000";
        D      <= '1';
        wait for 1 ns;
        assert(ITEXT = '1') report "When address 000, value of ITEXT should take the value of D" severity error;
        assert(MIX = 'U') report "When address 000, value of MIX should not change" severity error;
        assert(PG2 = '0') report "When address 000, value of PG2 should not change" severity error;
        assert(HIRES = '0') report "When address 000, value of HIRES should not change" severity error;
        assert(AN0 = '0') report "When address 000, value of AN0 should not change" severity error;
        assert(AN1 = '0') report "When address 000, value of AN1 should not change" severity error;
        assert(AN2 = '0') report "When address 000, value of AN2 should not change" severity error;
        assert(AN3 = '0') report "When address 000, value of AN3 should not change" severity error;

        A <= "001";
        wait for 1 ns;
        assert(ITEXT = '1') report "When address 001, value of ITEXT should not change" severity error;
        assert(MIX = '1') report "When address 001, value of MIX should take the value of D" severity error;
        assert(PG2 = '0') report "When address 001, value of PG2 should not change" severity error;
        assert(HIRES = '0') report "When address 001, value of HIRES should not change" severity error;
        assert(AN0 = '0') report "When address 001, value of AN0 should not change" severity error;
        assert(AN1 = '0') report "When address 001, value of AN1 should not change" severity error;
        assert(AN2 = '0') report "When address 001, value of AN2 should not change" severity error;
        assert(AN3 = '0') report "When address 001, value of AN3 should not change" severity error;

        A <= "010";
        wait for 1 ns;
        assert(ITEXT = '1') report "When address 010, value of ITEXT should not change" severity error;
        assert(MIX = '1') report "When address 010, value of MIX should not change" severity error;
        assert(PG2 = '1') report "When address 010, value of PG2 should take the value of D" severity error;
        assert(HIRES = '0') report "When address 010, value of HIRES should not change" severity error;
        assert(AN0 = '0') report "When address 010, value of AN0 should not change" severity error;
        assert(AN1 = '0') report "When address 010, value of AN1 should not change" severity error;
        assert(AN2 = '0') report "When address 010, value of AN2 should not change" severity error;
        assert(AN3 = '0') report "When address 010, value of AN3 should not change" severity error;

        A <= "011";
        wait for 1 ns;
        assert(ITEXT = '1') report "When address 011, value of ITEXT should not change" severity error;
        assert(MIX = '1') report "When address 011, value of MIX should not change" severity error;
        assert(PG2 = '1') report "When address 011, value of PG2 should not change" severity error;
        assert(HIRES = '1') report "When address 011, value of HIRES should take the value of D" severity error;
        assert(AN0 = '0') report "When address 011, value of AN0 should not change" severity error;
        assert(AN1 = '0') report "When address 011, value of AN1 should not change" severity error;
        assert(AN2 = '0') report "When address 011, value of AN2 should not change" severity error;
        assert(AN3 = '0') report "When address 011, value of AN3 should not change" severity error;

        A <= "100";
        wait for 1 ns;
        assert(ITEXT = '1') report "When address 100, value of ITEXT should not change" severity error;
        assert(MIX = '1') report "When address 100, value of MIX should not change" severity error;
        assert(PG2 = '1') report "When address 100, value of PG2 should not change" severity error;
        assert(HIRES = '1') report "When address 100, value of HIRES should not change" severity error;
        assert(AN0 = '1') report "When address 100, value of AN0 should take the value of D" severity error;
        assert(AN1 = '0') report "When address 100, value of AN1 should not change" severity error;
        assert(AN2 = '0') report "When address 100, value of AN2 should not change" severity error;
        assert(AN3 = '0') report "When address 100, value of AN3 should not change" severity error;

        A <= "101";
        wait for 1 ns;
        assert(ITEXT = '1') report "When address 101, value of ITEXT should not change" severity error;
        assert(MIX = '1') report "When address 101, value of MIX should not change" severity error;
        assert(PG2 = '1') report "When address 101, value of PG2 should not change" severity error;
        assert(HIRES = '1') report "When address 101, value of HIRES should not change" severity error;
        assert(AN0 = '1') report "When address 101, value of AN0 should not change" severity error;
        assert(AN1 = '1') report "When address 101, value of AN1 should take the value of D" severity error;
        assert(AN2 = '0') report "When address 101, value of AN2 should not change" severity error;
        assert(AN3 = '0') report "When address 101, value of AN3 should not change" severity error;

        A <= "110";
        wait for 1 ns;
        assert(ITEXT = '1') report "When address 110, value of ITEXT should not change" severity error;
        assert(MIX = '1') report "When address 110, value of MIX should not change" severity error;
        assert(PG2 = '1') report "When address 110, value of PG2 should not change" severity error;
        assert(HIRES = '1') report "When address 110, value of HIRES should not change" severity error;
        assert(AN0 = '1') report "When address 110, value of AN0 should not change" severity error;
        assert(AN1 = '1') report "When address 110, value of AN1 should not change" severity error;
        assert(AN2 = '1') report "When address 110, value of AN2 should take the value of D" severity error;
        assert(AN3 = '0') report "When address 110, value of AN3 should not change" severity error;

        A <= "111";
        wait for 1 ns;
        assert(ITEXT = '1') report "When address 111, value of ITEXT should not change" severity error;
        assert(MIX = '1') report "When address 111, value of MIX should not change" severity error;
        assert(PG2 = '1') report "When address 111, value of PG2 should not change" severity error;
        assert(HIRES = '1') report "When address 111, value of HIRES should not change" severity error;
        assert(AN0 = '1') report "When address 111, value of AN0 should not change" severity error;
        assert(AN1 = '1') report "When address 111, value of AN1 should not change" severity error;
        assert(AN2 = '1') report "When address 111, value of AN2 should not change" severity error;
        assert(AN3 = '1') report "When address 111, value of AN3 should take the value of D" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end SOFT_SWITCHES_C05X_TEST;
