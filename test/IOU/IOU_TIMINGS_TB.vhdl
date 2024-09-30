library IEEE;
use IEEE.std_logic_1164.all;

entity IOU_TIMINGS_TB is
    -- empty
end IOU_TIMINGS_TB;

architecture TESTBENCH of IOU_TIMINGS_TB is
    component IOU_TIMINGS is
        port (
            PHI_0   : in std_logic;
            P_PHI_0 : in std_logic;
            PRAS_N  : in std_logic;
            TC14S   : in std_logic;

            P_PHI_2 : out std_logic;
            PHI_1   : out std_logic;
            CTC14S  : out std_logic
        );
    end component;

    signal PHI_0   : std_logic;
    signal P_PHI_0 : std_logic;
    signal PRAS_N  : std_logic;
    signal TC14S   : std_logic;
    signal P_PHI_2 : std_logic;
    signal PHI_1   : std_logic;
    signal CTC14S  : std_logic;

begin
    dut : IOU_TIMINGS port map(
        PHI_0   => PHI_0,
        P_PHI_0 => P_PHI_0,
        PRAS_N  => PRAS_N,
        TC14S   => TC14S,
        P_PHI_2 => P_PHI_2,
        PHI_1   => PHI_1,
        CTC14S  => CTC14S
    );

    process begin

        TC14S   <= '1';
        P_PHI_0 <= '0';
        PRAS_N  <= '0';
        wait for 1 ns;
        assert(P_PHI_2 = '0') report "expect P_PHI_2 LOW" severity error;
        assert(CTC14S = 'U') report "expect CTC14S unchanged" severity error;

        P_PHI_0 <= '1';
        PRAS_N  <= '0';
        wait for 1 ns;
        assert(P_PHI_2 = '0') report "expect P_PHI_2 LOW" severity error;

        P_PHI_0 <= '0';
        PRAS_N  <= '1';
        wait for 1 ns;
        assert(P_PHI_2 = '0') report "expect P_PHI_2 LOW" severity error;

        P_PHI_0 <= '1';
        PRAS_N  <= '1';
        wait for 1 ns;
        assert(P_PHI_2 = '1') report "expect P_PHI_2 HIGH" severity error;
        assert(CTC14S = '1') report "expect CTC14S HIGH" severity error;

        P_PHI_0 <= '0';
        PRAS_N  <= '1';
        wait for 1 ns;

        TC14S   <= '0';
        P_PHI_0 <= '1';
        PRAS_N  <= '1';
        wait for 1 ns;
        assert(CTC14S = '0') report "expect CTC14S LOW" severity error;

        PHI_0 <= '0';
        wait for 1 ns;
        assert(PHI_1 = '1') report "expect PHI_1 HIGH" severity error;

        PHI_0 <= '1';
        wait for 1 ns;
        assert(PHI_1 = '0') report "expect PHI_1 LOW" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
