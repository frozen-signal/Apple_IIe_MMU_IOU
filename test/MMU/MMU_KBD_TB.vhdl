library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_KBD_TB is
    -- empty
end MMU_KBD_TB;
architecture TESTBENCH of MMU_KBD_TB is
    component MMU_KBD is
        port (
            INTIO_N : in std_logic;
            R_W_N   : in std_logic;
            PHI_1   : in std_logic;

            KBD_N : out std_logic
        );
    end component;

    signal INTIO_N : std_logic;
    signal R_W_N   : std_logic;
    signal PHI_1   : std_logic;
    signal KBD_N   : std_logic;

begin
    dut : MMU_KBD port map(
        INTIO_N => INTIO_N,
        R_W_N   => R_W_N,
        PHI_1   => PHI_1,
        KBD_N   => KBD_N
    );

    process begin
        INTIO_N <= '0';
        R_W_N   <= '1';
        PHI_1   <= '0';
        wait for 1 ns;
        assert(KBD_N = '0') report "When INTIO_N, PHI_1 LOW, R_W_N HIGH; expect KBD_N LOW" severity error;

        INTIO_N <= '1';
        R_W_N   <= '1';
        PHI_1   <= '0';
        wait for 1 ns;
        assert(KBD_N = '1') report "When INTIO_N HIGH, PHI_1 LOW, R_W_N HIGH; expect KBD_N HIGH" severity error;

        INTIO_N <= '0';
        R_W_N   <= '0';
        PHI_1   <= '0';
        wait for 1 ns;
        assert(KBD_N = '1') report "When INTIO_N LOW, PHI_1 HIGH, R_W_N HIGH; expect KBD_N HIGH" severity error;

        INTIO_N <= '0';
        R_W_N   <= '1';
        PHI_1   <= '1';
        wait for 1 ns;
        assert(KBD_N = '1') report "When INTIO_N LOW, PHI_1 HIGH, R_W_N HIGH; expect KBD_N HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
