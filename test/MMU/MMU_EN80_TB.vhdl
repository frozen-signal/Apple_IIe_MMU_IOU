library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_EN80_TB is
    -- empty
end MMU_EN80_TB;

architecture TESTBENCH of MMU_EN80_TB is
    component MMU_EN80 is
        port (
            SELMB_N  : in std_logic;
            INH_N    : in std_logic;
            PHI_0    : in std_logic;
            PCASEN_N : in std_logic;
            MPON_N   : in std_logic;

            EN80_N : out std_logic
        );
    end component;

    signal SELMB_N  : std_logic;
    signal INH_N    : std_logic;
    signal PHI_0    : std_logic;
    signal PCASEN_N : std_logic;
    signal MPON_N   : std_logic;
    signal EN80_N   : std_logic;

begin
    dut : MMU_EN80 port map(
        SELMB_N  => SELMB_N,
        INH_N    => INH_N,
        PHI_0    => PHI_0,
        PCASEN_N => PCASEN_N,
        MPON_N => MPON_N,
        EN80_N   => EN80_N
    );

    process begin
        MPON_N <= '1';

        PHI_0 <= '0';
        wait for 1 ns;
        assert(EN80_N = '1') report "When PHI_0 LOW; expect EN80_N HIGH" severity error;

        PHI_0    <= '1';
        INH_N    <= '0';
        SELMB_N  <= '1';
        PCASEN_N <= '0';
        wait for 1 ns;
        assert(EN80_N = '1') report "When INH_N LOW and L3-10 HIGH; expect EN80_N HIGH" severity error;

        PHI_0    <= '1';
        INH_N    <= '1';
        SELMB_N  <= '1';
        PCASEN_N <= '0';
        wait for 1 ns;
        assert(EN80_N = '0') report "When INH_N, SELMB_N HIGH and PCASEN_N LOW; expect EN80_N LOW" severity error;

        MPON_N   <= '0';
        wait for 1 ns;
        assert(EN80_N = '1') report "When MPON_N is LOW, ; expect EN80_N HIGH" severity error;

        MPON_N   <= '1';
        PHI_0    <= '1';
        INH_N    <= '1';
        SELMB_N  <= '0';
        PCASEN_N <= '1';
        wait for 1 ns;
        assert(EN80_N = '1') report "When INH_N, PCASEN_N HIGH and SELMB_N LOW; expect EN80_N HIGH" severity error;

        PHI_0    <= '1';
        INH_N    <= '1';
        SELMB_N  <= '1';
        PCASEN_N <= '1';
        wait for 1 ns;
        assert(EN80_N = '1') report "When INH_N, PCASEN_N HIGH and SELMB_N LOW; expect EN80_N HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
