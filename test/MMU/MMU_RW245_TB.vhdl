library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_RW245_TB is
    -- empty
end MMU_RW245_TB;
architecture TESTBENCH of MMU_RW245_TB is
    component MMU_RW245 is
        port (
            INTIO_N   : in std_logic;
            CXXXOUT_N : in std_logic;
            R_W_N     : in std_logic;
            DMA_N     : in std_logic;
            INH_N     : in std_logic;
            PHI_0     : in std_logic;

            R_W_N_245 : out std_logic
        );
    end component;

    signal INTIO_N   : std_logic;
    signal CXXXOUT_N : std_logic;
    signal R_W_N     : std_logic;
    signal DMA_N     : std_logic;
    signal INH_N     : std_logic;
    signal PHI_0     : std_logic;
    signal R_W_N_245 : std_logic;

begin
    dut : MMU_RW245 port map(
        INTIO_N   => INTIO_N,
        CXXXOUT_N => CXXXOUT_N,
        R_W_N     => R_W_N,
        DMA_N     => DMA_N,
        INH_N     => INH_N,
        PHI_0     => PHI_0,
        R_W_N_245 => R_W_N_245
    );

    process begin
        PHI_0 <= '0';
        wait for 1 ns;
        assert(R_W_N_245 = '0') report "When PHI_0 is LOW; expect R_W_N_245 LOW" severity error;

        PHI_0 <= '1';

        -- K3 branch tests
        INTIO_N   <= '0';
        CXXXOUT_N <= '0';
        R_W_N     <= '1';
        DMA_N     <= '1';
        INH_N     <= '1';
        wait for 1 ns;
        assert(R_W_N_245 = '0') report "expect R_W_N_245 LOW" severity error;

        -- P7 component
        INTIO_N   <= '1';
        CXXXOUT_N <= '0';
        R_W_N     <= '1';
        DMA_N     <= '1';
        INH_N     <= '1';
        wait for 1 ns;
        assert(R_W_N_245 = '1') report "expect R_W_N_245 HIGH" severity error;

        INTIO_N   <= '0';
        CXXXOUT_N <= '1';
        R_W_N     <= '1';
        DMA_N     <= '1';
        INH_N     <= '1';
        wait for 1 ns;
        assert(R_W_N_245 = '0') report "expect R_W_N_245 LOW" severity error;

        -- R/W'
        INTIO_N   <= '1';
        CXXXOUT_N <= '0';
        R_W_N     <= '0';
        DMA_N     <= '1';
        INH_N     <= '1';
        wait for 1 ns;
        assert(R_W_N_245 = '0') report "expect R_W_N_245 LOW" severity error;

        INTIO_N   <= '1';
        CXXXOUT_N <= '0';
        R_W_N     <= '1';
        DMA_N     <= '1';
        INH_N     <= '1';
        wait for 1 ns;
        assert(R_W_N_245 = '1') report "expect R_W_N_245 HIGH" severity error;

        -- DMA'
        INTIO_N   <= '1';
        CXXXOUT_N <= '0';
        R_W_N     <= '0';
        DMA_N     <= '0';
        INH_N     <= '1';
        wait for 1 ns;
        assert(R_W_N_245 = '1') report "expect R_W_N_245 HIGH" severity error;

        -- E2 component
        INTIO_N   <= '0';
        CXXXOUT_N <= '0';
        R_W_N     <= '1';
        DMA_N     <= '1';
        INH_N     <= '0';
        wait for 1 ns;
        assert(R_W_N_245 = '1') report "expect R_W_N_245 HIGH" severity error;
        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
