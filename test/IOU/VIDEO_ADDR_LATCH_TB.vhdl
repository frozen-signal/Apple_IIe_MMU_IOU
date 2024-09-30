library IEEE;
use IEEE.std_logic_1164.all;

entity IOU_ADDR_LATCH_TB is
    -- empty
end IOU_ADDR_LATCH_TB;

architecture TESTBENCH of IOU_ADDR_LATCH_TB is
    component IOU_ADDR_LATCH is
        port (
            P_PHI_2 : in std_logic;
            RA0, RA1, RA2, RA3,
            RA4, RA5, RA6 : in std_logic;

            LA0, LA1, LA2, LA3,
            LA4, LA5, LA7 : out std_logic
        );
    end component;

    signal P_PHI_2 : std_logic;
    signal RA0, RA1, RA2, RA3,
    RA4, RA5, RA6 : std_logic;

    signal LA0, LA1, LA2, LA3,
    LA4, LA5, LA7 : std_logic;

begin
    dut : IOU_ADDR_LATCH port map(
        P_PHI_2 => P_PHI_2,
        RA0     => RA0,
        RA1     => RA1,
        RA2     => RA2,
        RA3     => RA3,
        RA4     => RA4,
        RA5     => RA5,
        RA6     => RA6,
        LA0     => LA0,
        LA1     => LA1,
        LA2     => LA2,
        LA3     => LA3,
        LA4     => LA4,
        LA5     => LA5,
        LA7     => LA7
    );

    process begin
        P_PHI_2 <= '1';
        RA0     <= '1';
        RA1     <= '1';
        RA2     <= '1';
        RA3     <= '1';
        RA4     <= '1';
        RA5     <= '1';
        RA6     <= '1';
        wait for 1 ns;
        assert(LA0 = '1') report "expect RA0 HIGH" severity error;
        assert(LA1 = '1') report "expect RA1 HIGH" severity error;
        assert(LA2 = '1') report "expect RA2 HIGH" severity error;
        assert(LA3 = '1') report "expect RA3 HIGH" severity error;
        assert(LA4 = '1') report "expect RA4 HIGH" severity error;
        assert(LA5 = '1') report "expect RA5 HIGH" severity error;
        assert(LA7 = '1') report "expect RA7 HIGH" severity error;

        P_PHI_2 <= '0';
        RA0     <= '0';
        RA1     <= '0';
        RA2     <= '0';
        RA3     <= '0';
        RA4     <= '0';
        RA5     <= '0';
        RA6     <= '0';
        wait for 1 ns;
        assert(LA0 = '1') report "expect RA0 HIGH" severity error;
        assert(LA1 = '1') report "expect RA1 HIGH" severity error;
        assert(LA2 = '1') report "expect RA2 HIGH" severity error;
        assert(LA3 = '1') report "expect RA3 HIGH" severity error;
        assert(LA4 = '1') report "expect RA4 HIGH" severity error;
        assert(LA5 = '1') report "expect RA5 HIGH" severity error;
        assert(LA7 = '1') report "expect RA7 HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
