library IEEE;
use IEEE.std_logic_1164.all;

entity LS175_TB is
    -- empty
end LS175_TB;

architecture LS175_TEST of LS175_TB is
    component LS175 is
        port (
            CLR_N                  : in std_logic;
            CLK                    : in std_logic;
            D1, D2, D3, D4         : in std_logic;
            Q1, Q2, Q3, Q4         : out std_logic;
            Q1_N, Q2_N, Q3_N, Q4_N : out std_logic
        );
    end component;

    signal CLR_N                  : std_logic;
    signal CLK                    : std_logic;
    signal D1, D2, D3, D4         : std_logic;
    signal Q1, Q2, Q3, Q4         : std_logic;
    signal Q1_N, Q2_N, Q3_N, Q4_N : std_logic;

begin
    dut : LS175 port map(
        CLR_N => CLR_N,
        CLK   => CLK,
        D1    => D1,
        D2    => D2,
        D3    => D3,
        D4    => D4,
        Q1    => Q1,
        Q2    => Q2,
        Q3    => Q3,
        Q4    => Q4,
        Q1_N  => Q1_N,
        Q2_N  => Q2_N,
        Q3_N  => Q3_N,
        Q4_N  => Q4_N
    );

    process begin
        CLR_N <= '0';
        CLK   <= 'X';
        D1    <= 'X';
        D2    <= 'X';
        D3    <= 'X';
        D4    <= 'X';
        wait for 1 ns;
        assert(Q1 = '0') report "expect Q1 LOW" severity error;
        assert(Q2 = '0') report "expect Q2 LOW" severity error;
        assert(Q3 = '0') report "expect Q3 LOW" severity error;
        assert(Q4 = '0') report "expect Q4 LOW" severity error;
        assert(Q1_N = '1') report "expect Q1_N HIGH" severity error;
        assert(Q2_N = '1') report "expect Q2_N HIGH" severity error;
        assert(Q3_N = '1') report "expect Q3_N HIGH" severity error;
        assert(Q4_N = '1') report "expect Q4_N HIGH" severity error;

        CLR_N <= '1';
        CLK   <= '0';
        D1    <= '1';
        D2    <= '1';
        D3    <= '1';
        D4    <= '1';
        wait for 1 ns;
        CLK <= '1';
        wait for 1 ns;
        assert(Q1 = '1') report "expect Q1 HIGH" severity error;
        assert(Q2 = '1') report "expect Q2 HIGH" severity error;
        assert(Q3 = '1') report "expect Q3 HIGH" severity error;
        assert(Q4 = '1') report "expect Q4 HIGH" severity error;
        assert(Q1_N = '0') report "expect Q1_N LOW" severity error;
        assert(Q2_N = '0') report "expect Q2_N LOW" severity error;
        assert(Q3_N = '0') report "expect Q3_N LOW" severity error;
        assert(Q4_N = '0') report "expect Q4_N LOW" severity error;

        CLR_N <= '1';
        D1    <= '0';
        D2    <= '0';
        D3    <= '0';
        D4    <= '0';
        wait for 1 ns;
        CLK <= '0';
        wait for 1 ns;
        wait for 1 ns;
        assert(Q1 = '1') report "expect Q1 HIGH" severity error;
        assert(Q2 = '1') report "expect Q2 HIGH" severity error;
        assert(Q3 = '1') report "expect Q3 HIGH" severity error;
        assert(Q4 = '1') report "expect Q4 HIGH" severity error;
        assert(Q1_N = '0') report "expect Q1_N LOW" severity error;
        assert(Q2_N = '0') report "expect Q2_N LOW" severity error;
        assert(Q3_N = '0') report "expect Q3_N LOW" severity error;
        assert(Q4_N = '0') report "expect Q4_N LOW" severity error;

        CLK <= '1';
        wait for 1 ns;
        assert(Q1 = '0') report "expect Q1 LOW" severity error;
        assert(Q2 = '0') report "expect Q2 LOW" severity error;
        assert(Q3 = '0') report "expect Q3 LOW" severity error;
        assert(Q4 = '0') report "expect Q4 LOW" severity error;
        assert(Q1_N = '1') report "expect Q1_N HIGH" severity error;
        assert(Q2_N = '1') report "expect Q2_N HIGH" severity error;
        assert(Q3_N = '1') report "expect Q3_N HIGH" severity error;
        assert(Q4_N = '1') report "expect Q4_N HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end LS175_TEST;
