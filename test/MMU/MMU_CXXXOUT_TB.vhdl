library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_CXXXOUT_TB is
    -- empty
end MMU_CXXXOUT_TB;

architecture TESTBENCH of MMU_CXXXOUT_TB is
    component MMU_CXXXOUT is
        port (
            CENROM1    : in std_logic;
            INTC8ACC   : in std_logic;
            INTC3ACC_N : in std_logic;
            CXXX       : in std_logic;

            CXXXOUT_N : out std_logic
        );
    end component;

    signal CENROM1    : std_logic;
    signal INTC8ACC   : std_logic;
    signal INTC3ACC_N : std_logic;
    signal CXXX       : std_logic;
    signal CXXXOUT_N  : std_logic;

begin
    dut : MMU_CXXXOUT port map(
        CENROM1    => CENROM1,
        INTC8ACC   => INTC8ACC,
        INTC3ACC_N => INTC3ACC_N,
        CXXX       => CXXX,
        CXXXOUT_N  => CXXXOUT_N
    );

    process begin
        CENROM1    <= '0';
        INTC3ACC_N <= '1';
        CXXX       <= '1';
        INTC8ACC   <= '0';
        wait for 1 ns;
        assert(CXXXOUT_N = '0') report "When CENROM1 is LOW, INTC3ACC is HIGH, CXXX is HIGH, INTC8ACC is LOW; expect CXXXOUT_N LOW" severity error;

        CENROM1    <= '1';
        INTC3ACC_N <= '1';
        CXXX       <= '1';
        INTC8ACC   <= '0';
        wait for 1 ns;
        assert(CXXXOUT_N = '1') report "When CENROM1 is HIGH, INTC3ACC is HIGH, CXXX is HIGH, INTC8ACC is LOW; expect CXXXOUT_N HIGH" severity error;

        CENROM1    <= '0';
        INTC3ACC_N <= '0';
        CXXX       <= '1';
        INTC8ACC   <= '0';
        wait for 1 ns;
        assert(CXXXOUT_N = '1') report "When CENROM1 is LOW, INTC3ACC is LOW, CXXX is HIGH, INTC8ACC is LOW; expect CXXXOUT_N HIGH" severity error;

        CENROM1    <= '0';
        INTC3ACC_N <= '1';
        CXXX       <= '0';
        INTC8ACC   <= '0';
        wait for 1 ns;
        assert(CXXXOUT_N = '1') report "When CENROM1 is LOW, INTC3ACC is HIGH, CXXX is LOW, INTC8ACC is LOW; expect CXXXOUT_N HIGH" severity error;

        CENROM1    <= '0';
        INTC3ACC_N <= '1';
        CXXX       <= '1';
        INTC8ACC   <= '1';
        wait for 1 ns;
        assert(CXXXOUT_N = '1') report "When CENROM1 is LOW, INTC3ACC is HIGH, CXXX is HIGH, INTC8ACC is HIGH; expect CXXXOUT_N HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
