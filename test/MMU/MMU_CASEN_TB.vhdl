library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_CASEN_TB is
    -- empty
end MMU_CASEN_TB;
architecture TESTBENCH of MMU_CASEN_TB is
    component MMU_CASEN is
        port (
            RDROM   : in std_logic;
            CXXX    : in std_logic;
            D_FXXX  : in std_logic;
            R_W_N   : in std_logic;
            WRPROT  : in std_logic;
            INH     : in std_logic;
            SELMB_N : in std_logic;
            PHI_0   : in std_logic;
            MPON_N  : in std_logic;

            PCASEN_N : out std_logic;
            OCASEN_N : out std_logic;
            CASEN_N  : out std_logic
        );

    end component;

    signal RDROM   : std_logic;
    signal CXXX    : std_logic;
    signal D_FXXX  : std_logic;
    signal R_W_N   : std_logic;
    signal WRPROT  : std_logic;
    signal INH     : std_logic;
    signal SELMB_N : std_logic;
    signal PHI_0   : std_logic;
    signal MPON_N  : std_logic;

    signal PCASEN_N : std_logic;
    signal OCASEN_N : std_logic;
    signal CASEN_N  : std_logic;

begin
    dut : MMU_CASEN port map(
        RDROM    => RDROM,
        CXXX     => CXXX,
        D_FXXX   => D_FXXX,
        R_W_N    => R_W_N,
        WRPROT   => WRPROT,
        INH      => INH,
        SELMB_N  => SELMB_N,
        PHI_0    => PHI_0,
        MPON_N   => MPON_N,
        PCASEN_N => PCASEN_N,
        OCASEN_N => OCASEN_N,
        CASEN_N  => CASEN_N
    );

    process begin
        MPON_N <= '1';
        PHI_0  <= '1';

        -- PCASEN_N -------------------------------------------------------
        CXXX <= '1';
        wait for 1 ns;
        assert(PCASEN_N = '1') report "When CXXX is HIGH; expect PCASEN_N HIGH" severity error;

        CXXX   <= '0';
        RDROM  <= '0';
        D_FXXX <= '0';
        R_W_N  <= '0';
        WRPROT <= '0';
        wait for 1 ns;
        assert(PCASEN_N = '0') report "When all LOW; expect PCASEN_N LOW" severity error;

        CXXX   <= '0';
        RDROM  <= '1';
        D_FXXX <= '1';
        R_W_N  <= '1';
        WRPROT <= '0';
        wait for 1 ns;
        assert(PCASEN_N = '1') report "When RDROM, D_FXXX, R_W_N HIGH, WRPROT LOW; expect PCASEN_N HIGH" severity error;

        CXXX   <= '0';
        RDROM  <= '1';
        D_FXXX <= '1';
        R_W_N  <= '0';
        WRPROT <= '0';
        wait for 1 ns;
        assert(PCASEN_N = '0') report "When RDROM, D_FXXX HIGH, R_W_N and WRPROT LOW; expect PCASEN_N LOW" severity error;

        CXXX   <= '0';
        RDROM  <= '1';
        D_FXXX <= '0';
        R_W_N  <= '1';
        WRPROT <= '0';
        wait for 1 ns;
        assert(PCASEN_N = '0') report "When RDROM, R_W_N HIGH, D_FXXX and WRPROT LOW; expect PCASEN_N LOW" severity error;

        CXXX   <= '0';
        RDROM  <= '0';
        D_FXXX <= '1';
        R_W_N  <= '1';
        WRPROT <= '0';
        wait for 1 ns;
        assert(PCASEN_N = '0') report "When D_FXXX, R_W_N HIGH, RDROM and WRPROT LOW; expect PCASEN_N LOW" severity error;

        CXXX   <= '0';
        RDROM  <= '0';
        D_FXXX <= '1';
        R_W_N  <= '1';
        WRPROT <= '1';
        wait for 1 ns;
        assert(PCASEN_N = '0') report "When WRPROT, D_FXXX, R_W_N HIGH, and RDROM LOW; expect PCASEN_N LOW" severity error;

        CXXX   <= '0';
        RDROM  <= '0';
        D_FXXX <= '1';
        R_W_N  <= '0';
        WRPROT <= '1';
        wait for 1 ns;
        assert(PCASEN_N = '1') report "When WRPROT, D_FXXX HIGH, R_W_N and RDROM LOW; expect PCASEN_N HIGH" severity error;

        CXXX   <= '0';
        RDROM  <= '0';
        D_FXXX <= '0';
        R_W_N  <= '0';
        WRPROT <= '1';
        wait for 1 ns;
        assert(PCASEN_N = '0') report "When WRPROT HIGH, D_FXXX, R_W_N and RDROM LOW; expect PCASEN_N LOW" severity error;

        -- OCASEN_N -------------------------------------------------------
        CXXX   <= '0';
        RDROM  <= '0';
        D_FXXX <= '1';
        R_W_N  <= '0';
        WRPROT <= '1';
        wait for 1 ns;
        assert(OCASEN_N = '1') report "When PCASEN_N HIGH; expect OCASEN_N HIGH" severity error;

        CXXX    <= '0';
        RDROM   <= '0';
        D_FXXX  <= '0';
        R_W_N   <= '0';
        WRPROT  <= '1';
        SELMB_N <= '1';
        wait for 1 ns;
        assert(OCASEN_N = '1') report "When PCASEN_N LOW, SELMB_N HIGH; expect OCASEN_N HIGH" severity error;

        CXXX    <= '0';
        RDROM   <= '0';
        D_FXXX  <= '0';
        R_W_N   <= '0';
        WRPROT  <= '1';
        SELMB_N <= '0';
        INH     <= '1';
        wait for 1 ns;
        assert(OCASEN_N = '1') report "When PCASEN_N, SELMB_N LOW, INH HIGH; expect OCASEN_N HIGH" severity error;

        CXXX    <= '0';
        RDROM   <= '0';
        D_FXXX  <= '0';
        R_W_N   <= '0';
        WRPROT  <= '1';
        SELMB_N <= '0';
        INH     <= '0';
        wait for 1 ns;
        assert(OCASEN_N = '0') report "When PCASEN_N, SELMB_N, INH LOW; expect OCASEN_N LOW" severity error;

        -- CASEN_N --------------------------------------------------------
        CXXX   <= '0';
        RDROM  <= '0';
        D_FXXX <= '1';
        R_W_N  <= '0';
        WRPROT <= '1';
        wait for 1 ns;
        assert(OCASEN_N = '1') report "Precondition; expect OCASEN_N HIGH" severity error;

        MPON_N  <= '0';
        CXXX    <= '0';
        RDROM   <= '0';
        D_FXXX  <= '0';
        R_W_N   <= '0';
        WRPROT  <= '1';
        SELMB_N <= '0';
        INH     <= '0';
        wait for 1 ns;
        assert(OCASEN_N = '1') report "When MPON_N LOW; expect OCASEN_N HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
