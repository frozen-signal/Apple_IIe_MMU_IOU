library IEEE;
use IEEE.std_logic_1164.all;

entity LS138_TB is
    -- empty
end LS138_TB;

architecture TESTBENCH of LS138_TB is
    component LS138 is
        port (
            A, B, C          : in std_logic;
            G1, G2A_N, G2B_N : in std_logic;
            Y0, Y1, Y2, Y3,
            Y4, Y5, Y6, Y7 : out std_logic
        );
    end component;

    signal A, B, C                        : std_logic;
    signal G1, G2A_N, G2B_N               : std_logic;
    signal Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7 : std_logic;

begin
    dut : LS138 port map(
        A     => A,
        B     => B,
        C     => C,
        G1    => G1,
        G2A_N => G2A_N,
        G2B_N => G2B_N,
        Y0    => Y0,
        Y1    => Y1,
        Y2    => Y2,
        Y3    => Y3,
        Y4    => Y4,
        Y5    => Y5,
        Y6    => Y6,
        Y7    => Y7
    );

    process begin
        A     <= 'X';
        B     <= 'X';
        C     <= 'X';
        G1    <= '0';
        G2A_N <= '0';
        G2B_N <= '0';
        wait for 1 ns;
        assert(Y0 = '1') report "expect Y0 HIGH" severity error;
        assert(Y1 = '1') report "expect Y1 HIGH" severity error;
        assert(Y2 = '1') report "expect Y2 HIGH" severity error;
        assert(Y3 = '1') report "expect Y3 HIGH" severity error;
        assert(Y4 = '1') report "expect Y4 HIGH" severity error;
        assert(Y5 = '1') report "expect Y5 HIGH" severity error;
        assert(Y6 = '1') report "expect Y6 HIGH" severity error;
        assert(Y7 = '1') report "expect Y7 HIGH" severity error;

        A     <= 'X';
        B     <= 'X';
        C     <= 'X';
        G1    <= '1';
        G2A_N <= '1';
        G2B_N <= '0';
        wait for 1 ns;
        assert(Y0 = '1') report "expect Y0 HIGH" severity error;
        assert(Y1 = '1') report "expect Y1 HIGH" severity error;
        assert(Y2 = '1') report "expect Y2 HIGH" severity error;
        assert(Y3 = '1') report "expect Y3 HIGH" severity error;
        assert(Y4 = '1') report "expect Y4 HIGH" severity error;
        assert(Y5 = '1') report "expect Y5 HIGH" severity error;
        assert(Y6 = '1') report "expect Y6 HIGH" severity error;
        assert(Y7 = '1') report "expect Y7 HIGH" severity error;

        A     <= 'X';
        B     <= 'X';
        C     <= 'X';
        G1    <= '1';
        G2A_N <= '0';
        G2B_N <= '1';
        wait for 1 ns;
        assert(Y0 = '1') report "expect Y0 HIGH" severity error;
        assert(Y1 = '1') report "expect Y1 HIGH" severity error;
        assert(Y2 = '1') report "expect Y2 HIGH" severity error;
        assert(Y3 = '1') report "expect Y3 HIGH" severity error;
        assert(Y4 = '1') report "expect Y4 HIGH" severity error;
        assert(Y5 = '1') report "expect Y5 HIGH" severity error;
        assert(Y6 = '1') report "expect Y6 HIGH" severity error;
        assert(Y7 = '1') report "expect Y7 HIGH" severity error;

        A     <= '0';
        B     <= '0';
        C     <= '0';
        G1    <= '1';
        G2A_N <= '0';
        G2B_N <= '0';
        wait for 1 ns;
        assert(Y0 = '0') report "Fail 000 for Y0" severity error;
        assert(Y1 = '1') report "Fail 000 for Y1" severity error;
        assert(Y2 = '1') report "Fail 000 for Y2" severity error;
        assert(Y3 = '1') report "Fail 000 for Y3" severity error;
        assert(Y4 = '1') report "Fail 000 for Y4" severity error;
        assert(Y5 = '1') report "Fail 000 for Y5" severity error;
        assert(Y6 = '1') report "Fail 000 for Y6" severity error;
        assert(Y7 = '1') report "Fail 000 for Y7" severity error;

        A     <= '1';
        B     <= '0';
        C     <= '0';
        G1    <= '1';
        G2A_N <= '0';
        G2B_N <= '0';
        wait for 1 ns;
        assert(Y0 = '1') report "Fail 001 for Y0" severity error;
        assert(Y1 = '0') report "Fail 001 for Y1" severity error;
        assert(Y2 = '1') report "Fail 001 for Y2" severity error;
        assert(Y3 = '1') report "Fail 001 for Y3" severity error;
        assert(Y4 = '1') report "Fail 001 for Y4" severity error;
        assert(Y5 = '1') report "Fail 001 for Y5" severity error;
        assert(Y6 = '1') report "Fail 001 for Y6" severity error;
        assert(Y7 = '1') report "Fail 001 for Y7" severity error;

        A     <= '0';
        B     <= '1';
        C     <= '0';
        G1    <= '1';
        G2A_N <= '0';
        G2B_N <= '0';
        wait for 1 ns;
        assert(Y0 = '1') report "Fail 010 for Y0" severity error;
        assert(Y1 = '1') report "Fail 010 for Y1" severity error;
        assert(Y2 = '0') report "Fail 010 for Y2" severity error;
        assert(Y3 = '1') report "Fail 010 for Y3" severity error;
        assert(Y4 = '1') report "Fail 010 for Y4" severity error;
        assert(Y5 = '1') report "Fail 010 for Y5" severity error;
        assert(Y6 = '1') report "Fail 010 for Y6" severity error;
        assert(Y7 = '1') report "Fail 010 for Y7" severity error;

        A     <= '1';
        B     <= '1';
        C     <= '0';
        G1    <= '1';
        G2A_N <= '0';
        G2B_N <= '0';
        wait for 1 ns;
        assert(Y0 = '1') report "Fail 011 for Y0" severity error;
        assert(Y1 = '1') report "Fail 011 for Y1" severity error;
        assert(Y2 = '1') report "Fail 011 for Y2" severity error;
        assert(Y3 = '0') report "Fail 011 for Y3" severity error;
        assert(Y4 = '1') report "Fail 011 for Y4" severity error;
        assert(Y5 = '1') report "Fail 011 for Y5" severity error;
        assert(Y6 = '1') report "Fail 011 for Y6" severity error;
        assert(Y7 = '1') report "Fail 011 for Y7" severity error;

        A     <= '0';
        B     <= '0';
        C     <= '1';
        G1    <= '1';
        G2A_N <= '0';
        G2B_N <= '0';
        wait for 1 ns;
        assert(Y0 = '1') report "Fail 100 for Y0" severity error;
        assert(Y1 = '1') report "Fail 100 for Y1" severity error;
        assert(Y2 = '1') report "Fail 100 for Y2" severity error;
        assert(Y3 = '1') report "Fail 100 for Y3" severity error;
        assert(Y4 = '0') report "Fail 100 for Y4" severity error;
        assert(Y5 = '1') report "Fail 100 for Y5" severity error;
        assert(Y6 = '1') report "Fail 100 for Y6" severity error;
        assert(Y7 = '1') report "Fail 100 for Y7" severity error;

        A     <= '1';
        B     <= '0';
        C     <= '1';
        G1    <= '1';
        G2A_N <= '0';
        G2B_N <= '0';
        wait for 1 ns;
        assert(Y0 = '1') report "Fail 101 for Y0" severity error;
        assert(Y1 = '1') report "Fail 101 for Y1" severity error;
        assert(Y2 = '1') report "Fail 101 for Y2" severity error;
        assert(Y3 = '1') report "Fail 101 for Y3" severity error;
        assert(Y4 = '1') report "Fail 101 for Y4" severity error;
        assert(Y5 = '0') report "Fail 101 for Y5" severity error;
        assert(Y6 = '1') report "Fail 101 for Y6" severity error;
        assert(Y7 = '1') report "Fail 101 for Y7" severity error;

        A     <= '0';
        B     <= '1';
        C     <= '1';
        G1    <= '1';
        G2A_N <= '0';
        G2B_N <= '0';
        wait for 1 ns;
        assert(Y0 = '1') report "Fail 110 for Y0" severity error;
        assert(Y1 = '1') report "Fail 110 for Y1" severity error;
        assert(Y2 = '1') report "Fail 110 for Y2" severity error;
        assert(Y3 = '1') report "Fail 110 for Y3" severity error;
        assert(Y4 = '1') report "Fail 110 for Y4" severity error;
        assert(Y5 = '1') report "Fail 110 for Y5" severity error;
        assert(Y6 = '0') report "Fail 110 for Y6" severity error;
        assert(Y7 = '1') report "Fail 110 for Y7" severity error;

        A     <= '1';
        B     <= '1';
        C     <= '1';
        G1    <= '1';
        G2A_N <= '0';
        G2B_N <= '0';
        wait for 1 ns;
        assert(Y0 = '1') report "Fail 111 for Y0" severity error;
        assert(Y1 = '1') report "Fail 111 for Y1" severity error;
        assert(Y2 = '1') report "Fail 111 for Y2" severity error;
        assert(Y3 = '1') report "Fail 111 for Y3" severity error;
        assert(Y4 = '1') report "Fail 111 for Y4" severity error;
        assert(Y5 = '1') report "Fail 111 for Y5" severity error;
        assert(Y6 = '1') report "Fail 111 for Y6" severity error;
        assert(Y7 = '0') report "Fail 111 for Y7" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
