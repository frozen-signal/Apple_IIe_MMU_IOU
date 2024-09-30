library IEEE;
use IEEE.std_logic_1164.all;

entity LATCH_9334_TB is
    -- empty
end LATCH_9334_TB;

architecture TESTBENCH of LATCH_9334_TB is
    component LATCH_9334 is
        port (
            C_N : in std_logic;
            E_N : in std_logic;

            D          : in std_logic;
            ADDR : in std_logic_vector(2 downto 0);

            Q0, Q1, Q2, Q3,
            Q4, Q5, Q6, Q7 : out std_logic
        );
    end component;

    signal C_N : std_logic;
    signal E_N : std_logic;

    signal D          : std_logic;
    signal ADDR : std_logic_vector(2 downto 0);

    signal Q0, Q1, Q2, Q3,
    Q4, Q5, Q6, Q7 : std_logic;

begin
    dut : LATCH_9334 port map(
        C_N => C_N,
        E_N => E_N,
        D   => D,
        ADDR  => ADDR,
        Q0  => Q0,
        Q1  => Q1,
        Q2  => Q2,
        Q3  => Q3,
        Q4  => Q4,
        Q5  => Q5,
        Q6  => Q6,
        Q7  => Q7
    );

    process begin
        -- MEMORY

        C_N <= '0';
        wait for 1 ns;
        assert(Q0 = '0') report "When C_N is LOW; expect Q0 cleared" severity error;
        assert(Q1 = '0') report "When C_N is LOW; expect Q1 cleared" severity error;
        assert(Q2 = '0') report "When C_N is LOW; expect Q2 cleared" severity error;
        assert(Q3 = '0') report "When C_N is LOW; expect Q3 cleared" severity error;
        assert(Q4 = '0') report "When C_N is LOW; expect Q4 cleared" severity error;
        assert(Q5 = '0') report "When C_N is LOW; expect Q5 cleared" severity error;
        assert(Q6 = '0') report "When C_N is LOW; expect Q6 cleared" severity error;
        assert(Q7 = '0') report "When C_N is LOW; expect Q7 cleared" severity error;

        C_N <= '1';
        E_N <= '0';
        ADDR <= "000";
        D   <= '1';
        wait for 1 ns;
        assert(Q0 = '1') report "Storing 1 at 000; expect Q0 HIGH" severity error;
        assert(Q1 = '0') report "Storing 1 at 000; expect Q1 PREVIOUS" severity error;
        assert(Q2 = '0') report "Storing 1 at 000; expect Q2 PREVIOUS" severity error;
        assert(Q3 = '0') report "Storing 1 at 000; expect Q3 PREVIOUS" severity error;
        assert(Q4 = '0') report "Storing 1 at 000; expect Q4 PREVIOUS" severity error;
        assert(Q5 = '0') report "Storing 1 at 000; expect Q5 PREVIOUS" severity error;
        assert(Q6 = '0') report "Storing 1 at 000; expect Q6 PREVIOUS" severity error;
        assert(Q7 = '0') report "Storing 1 at 000; expect Q7 PREVIOUS" severity error;

        ADDR <= "001";
        D  <= '1';
        wait for 1 ns;
        assert(Q0 = '1') report "Storing 1 at 001; expect Q0 PREVIOUS" severity error;
        assert(Q1 = '1') report "Storing 1 at 001; expect Q1 HIGH" severity error;
        assert(Q2 = '0') report "Storing 1 at 001; expect Q2 PREVIOUS" severity error;
        assert(Q3 = '0') report "Storing 1 at 001; expect Q3 PREVIOUS" severity error;
        assert(Q4 = '0') report "Storing 1 at 001; expect Q4 PREVIOUS" severity error;
        assert(Q5 = '0') report "Storing 1 at 001; expect Q5 PREVIOUS" severity error;
        assert(Q6 = '0') report "Storing 1 at 001; expect Q6 PREVIOUS" severity error;
        assert(Q7 = '0') report "Storing 1 at 001; expect Q7 PREVIOUS" severity error;

        ADDR <= "010";
        D  <= '1';
        wait for 1 ns;
        assert(Q0 = '1') report "Storing 1 at 010; expect Q0 PREVIOUS" severity error;
        assert(Q1 = '1') report "Storing 1 at 010; expect Q1 PREVIOUS" severity error;
        assert(Q2 = '1') report "Storing 1 at 010; expect Q2 HIGH" severity error;
        assert(Q3 = '0') report "Storing 1 at 010; expect Q3 PREVIOUS" severity error;
        assert(Q4 = '0') report "Storing 1 at 010; expect Q4 PREVIOUS" severity error;
        assert(Q5 = '0') report "Storing 1 at 010; expect Q5 PREVIOUS" severity error;
        assert(Q6 = '0') report "Storing 1 at 010; expect Q6 PREVIOUS" severity error;
        assert(Q7 = '0') report "Storing 1 at 010; expect Q7 PREVIOUS" severity error;

        ADDR <= "011";
        D  <= '1';
        wait for 1 ns;
        assert(Q0 = '1') report "Storing 1 at 011; expect Q0 PREVIOUS" severity error;
        assert(Q1 = '1') report "Storing 1 at 011; expect Q1 PREVIOUS" severity error;
        assert(Q2 = '1') report "Storing 1 at 011; expect Q2 PREVIOUS" severity error;
        assert(Q3 = '1') report "Storing 1 at 011; expect Q3 HIGH" severity error;
        assert(Q4 = '0') report "Storing 1 at 011; expect Q4 PREVIOUS" severity error;
        assert(Q5 = '0') report "Storing 1 at 011; expect Q5 PREVIOUS" severity error;
        assert(Q6 = '0') report "Storing 1 at 011; expect Q6 PREVIOUS" severity error;
        assert(Q7 = '0') report "Storing 1 at 011; expect Q7 PREVIOUS" severity error;

        ADDR <= "100";
        D  <= '1';
        wait for 1 ns;
        assert(Q0 = '1') report "Storing 1 at 100; expect Q0 PREVIOUS" severity error;
        assert(Q1 = '1') report "Storing 1 at 100; expect Q1 PREVIOUS" severity error;
        assert(Q2 = '1') report "Storing 1 at 100; expect Q2 PREVIOUS" severity error;
        assert(Q3 = '1') report "Storing 1 at 100; expect Q3 PREVIOUS" severity error;
        assert(Q4 = '1') report "Storing 1 at 100; expect Q4 HIGH" severity error;
        assert(Q5 = '0') report "Storing 1 at 100; expect Q5 PREVIOUS" severity error;
        assert(Q6 = '0') report "Storing 1 at 100; expect Q6 PREVIOUS" severity error;
        assert(Q7 = '0') report "Storing 1 at 100; expect Q7 PREVIOUS" severity error;

        ADDR <= "101";
        D  <= '1';
        wait for 1 ns;
        assert(Q0 = '1') report "Storing 1 at 101; expect Q0 PREVIOUS" severity error;
        assert(Q1 = '1') report "Storing 1 at 101; expect Q1 PREVIOUS" severity error;
        assert(Q2 = '1') report "Storing 1 at 101; expect Q2 PREVIOUS" severity error;
        assert(Q3 = '1') report "Storing 1 at 101; expect Q3 PREVIOUS" severity error;
        assert(Q4 = '1') report "Storing 1 at 101; expect Q4 PREVIOUS" severity error;
        assert(Q5 = '1') report "Storing 1 at 101; expect Q5 HIGH" severity error;
        assert(Q6 = '0') report "Storing 1 at 101; expect Q6 PREVIOUS" severity error;
        assert(Q7 = '0') report "Storing 1 at 101; expect Q7 PREVIOUS" severity error;

        ADDR <= "110";
        D  <= '1';
        wait for 1 ns;
        assert(Q0 = '1') report "Storing 1 at 110; expect Q0 PREVIOUS" severity error;
        assert(Q1 = '1') report "Storing 1 at 110; expect Q1 PREVIOUS" severity error;
        assert(Q2 = '1') report "Storing 1 at 110; expect Q2 PREVIOUS" severity error;
        assert(Q3 = '1') report "Storing 1 at 110; expect Q3 PREVIOUS" severity error;
        assert(Q4 = '1') report "Storing 1 at 110; expect Q4 PREVIOUS" severity error;
        assert(Q5 = '1') report "Storing 1 at 110; expect Q5 PREVIOUS" severity error;
        assert(Q6 = '1') report "Storing 1 at 110; expect Q6 HIGH" severity error;
        assert(Q7 = '0') report "Storing 1 at 110; expect Q7 PREVIOUS" severity error;

        ADDR <= "111";
        D  <= '1';
        wait for 1 ns;
        assert(Q0 = '1') report "Storing 1 at 111; expect Q0 PREVIOUS" severity error;
        assert(Q1 = '1') report "Storing 1 at 111; expect Q1 PREVIOUS" severity error;
        assert(Q2 = '1') report "Storing 1 at 111; expect Q2 PREVIOUS" severity error;
        assert(Q3 = '1') report "Storing 1 at 111; expect Q3 PREVIOUS" severity error;
        assert(Q4 = '1') report "Storing 1 at 111; expect Q4 PREVIOUS" severity error;
        assert(Q5 = '1') report "Storing 1 at 111; expect Q5 PREVIOUS" severity error;
        assert(Q6 = '1') report "Storing 1 at 111; expect Q6 PREVIOUS" severity error;
        assert(Q7 = '1') report "Storing 1 at 111; expect Q7 HIGH" severity error;

        E_N <= '1';
        ADDR <= "111";
        D   <= '0';
        wait for 1 ns;
        assert(Q0 = '1') report "Memory mode; expect Q0 PREVIOUS" severity error;
        assert(Q1 = '1') report "Memory mode; expect Q1 PREVIOUS" severity error;
        assert(Q2 = '1') report "Memory mode; expect Q2 PREVIOUS" severity error;
        assert(Q3 = '1') report "Memory mode; expect Q3 PREVIOUS" severity error;
        assert(Q4 = '1') report "Memory mode; expect Q4 PREVIOUS" severity error;
        assert(Q5 = '1') report "Memory mode; expect Q5 PREVIOUS" severity error;
        assert(Q6 = '1') report "Memory mode; expect Q6 PREVIOUS" severity error;
        assert(Q7 = '1') report "Memory mode; expect Q7 PREVIOUS" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
