library IEEE;
use IEEE.std_logic_1164.all;

entity LS174_SINGLE_TB is
    -- empty
end LS174_SINGLE_TB;

architecture LS174_SINGLE_TEST of LS174_SINGLE_TB is
    component LS174_SINGLE is
        port (
            CLR_N : in std_logic;
            CLK   : in std_logic;
            D     : in std_logic;
            Q     : out std_logic;
            Q_N   : out std_logic
        );
    end component;

    signal CLR_N : std_logic;
    signal CLK   : std_logic;
    signal D     : std_logic;
    signal Q     : std_logic;
    signal Q_N   : std_logic;

begin
    dut : LS174_SINGLE port map(
        CLR_N => CLR_N,
        CLK   => CLK,
        D     => D,
        Q     => Q,
        Q_N   => Q_N
    );

    process begin
        CLR_N <= '0';
        CLK   <= 'X';
        D     <= 'X';
        wait for 1 ns;
        assert(Q = '0') report "When CLR_N is LOW; expect Q cleared" severity error;
        assert(Q_N = '1') report "When CLR_N is LOW; expect Q_N cleared" severity error;

        CLR_N <= '1';
        CLK   <= '0';
        D     <= '1';
        wait for 1 ns;
        CLK <= '1';
        wait for 1 ns;
        assert(Q = '1') report "When CLK is rising and D is HIGH; expect Q HIGH" severity error;
        assert(Q_N = '0') report "When CLK is rising and D is HIGH; expect Q_N LOW" severity error;

        CLR_N <= '1';
        D     <= '0';
        wait for 1 ns;
        CLK <= '0';
        wait for 1 ns;
        wait for 1 ns;
        assert(Q = '1') report "When CLK is not rising and D is different than Q; expect Q unchanged" severity error;
        assert(Q_N = '0') report "When CLK not is rising and D is different than Q; expect Q_N unchanged" severity error;

        CLK <= '1';
        wait for 1 ns;
        assert(Q = '0') report "When CLK is rising and D is different than Q; expect Q equal to D" severity error;
        assert(Q_N = '1') report "When CLK is rising and D is different than Q; expect Q_N equal to not D" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end LS174_SINGLE_TEST;
