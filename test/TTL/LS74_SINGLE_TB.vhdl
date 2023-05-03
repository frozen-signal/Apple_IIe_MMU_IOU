library IEEE;
use IEEE.std_logic_1164.all;

entity LS74_SINGLE_TB is
    -- empty
end LS74_SINGLE_TB;

architecture LS74_SINGLE_TEST of LS74_SINGLE_TB is
    component LS74_SINGLE is
        port (
            PRE_N : in std_logic;
            CLR_N : in std_logic;
            CLK   : in std_logic;
            D     : in std_logic;
            Q     : out std_logic
        );
    end component;

    signal PRE_N : std_logic;
    signal CLR_N : std_logic;
    signal CLK   : std_logic;
    signal D     : std_logic;
    signal Q     : std_logic;

begin
    dut : LS74_SINGLE port map(
        PRE_N => PRE_N,
        CLR_N => CLR_N,
        CLK   => CLK,
        D     => D,
        Q     => Q
    );

    process begin
        CLK <= '1';

        PRE_N <= '0';
        CLK   <= 'X';
        D     <= 'X';
        wait for 1 ns;
        assert(Q = '1') report "When PRE_N is LOW; expect Q HIGH" severity error;

        PRE_N <= '1';
        CLR_N <= '0';
        CLK   <= 'X';
        D     <= 'X';
        wait for 1 ns;
        assert(Q = '0') report "When CLR_N is LOW; expect Q LOW" severity error;

        CLK   <= '0';
        PRE_N <= '1';
        CLR_N <= '1';
        D     <= '1';
        wait for 1 ns;
        assert(Q = '0') report "When PRE_N and CLR_N is HIGH, and not rising CLK; expect Q unchanged" severity error;

        CLK <= '1';
        wait for 1 ns;
        assert(Q = '1') report "When PRE_N and CLR_N is HIGH, and rising CLK; expect Q set to D" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end LS74_SINGLE_TEST;
