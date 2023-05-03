library IEEE;
library work;
use IEEE.std_logic_1164.all;
use work.TEST_UTILS.all;

entity MMU_TB_RW245 is
    -- empty
end MMU_TB_RW245;

architecture MMU_TEST_RW245 of MMU_TB_RW245 is
    component HAL_TIMING_MOCK is
        port (
            CLK_14M  : out std_logic;
            PHI_0    : out std_logic;
            Q3       : out std_logic;
            RAS_N    : out std_logic;
            FINISHED : out std_logic
        );
    end component;

    component MMU is
        port (
            A      : in std_logic_vector(15 downto 0);
            PHI_0  : in std_logic;
            Q3     : in std_logic;
            PRAS_N : in std_logic;
            R_W_N  : in std_logic;
            INH_N  : in std_logic;
            DMA_N  : in std_logic;

            ORA       : out std_logic_vector(7 downto 0);
            EN80_N    : out std_logic;
            KBD_N     : out std_logic;
            ROMEN1_N  : out std_logic;
            ROMEN2_N  : out std_logic;
            MD7       : out std_logic;
            R_W_N_245 : out std_logic;
            CASEN_N   : out std_logic;
            CXXXOUT   : out std_logic
        );
    end component;

    signal CLK_14M : std_logic := '0';
    signal PHI_0   : std_logic := '1';
    signal Q3      : std_logic := '1';
    signal PRAS_N  : std_logic;

    signal FINISHED  : std_logic := '0';
    signal TEST_STEP : std_logic_vector(7 downto 0);

    signal A     : std_logic_vector(15 downto 0);
    signal R_W_N : std_logic;
    signal INH_N : std_logic;
    signal DMA_N : std_logic;

    signal ORA       : std_logic_vector(7 downto 0);
    signal EN80_N    : std_logic;
    signal KBD_N     : std_logic;
    signal ROMEN1_N  : std_logic;
    signal ROMEN2_N  : std_logic;
    signal MD7       : std_logic;
    signal R_W_N_245 : std_logic;
    signal CASEN_N   : std_logic;
    signal CXXXOUT   : std_logic;

begin
    hal_mock : HAL_TIMING_MOCK port map(
        CLK_14M  => CLK_14M,
        PHI_0    => PHI_0,
        Q3       => Q3,
        RAS_N    => PRAS_N,
        FINISHED => FINISHED
    );

    c_mmu : MMU port map(
        A      => A,
        PHI_0  => PHI_0,
        Q3     => Q3,
        PRAS_N => PRAS_N,
        R_W_N  => R_W_N,
        INH_N  => INH_N,
        DMA_N  => DMA_N,

        ORA       => ORA,
        EN80_N    => EN80_N,
        KBD_N     => KBD_N,
        ROMEN1_N  => ROMEN1_N,
        ROMEN2_N  => ROMEN2_N,
        MD7       => MD7,
        R_W_N_245 => R_W_N_245,
        CASEN_N   => CASEN_N,
        CXXXOUT   => CXXXOUT
    );

    process begin
        R_W_N <= '1';
        INH_N <= '1';
        DMA_N <= '1';

        resetMMU(PHI_0, A);

        -- TABLE 5.7 tests ----------------------------------------------------------------------------------------
        -- Line 1 ---------------------------------------------------------
        TEST_STEP <= x"00";
        A         <= x"0000";
        R_W_N     <= '0';
        DMA_N     <= '0';
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(R_W_N_245 = '1') report "expect R_W_N_245 HIGH" severity error;

        wait until falling_edge(PHI_0);

        -- Line 2 ---------------------------------------------------------
        TEST_STEP <= x"01";
        A         <= x"0000";
        R_W_N     <= '1';
        DMA_N     <= '1';
        INH_N     <= '0';
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(R_W_N_245 = '1') report "expect R_W_N_245 HIGH" severity error;

        wait until falling_edge(PHI_0);

        -- Line 3 ---------------------------------------------------------
        TEST_STEP <= x"02";
        INH_N     <= '1';
        A         <= x"C020";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(R_W_N_245 = '1') report "expect R_W_N_245 HIGH" severity error;

        wait until falling_edge(PHI_0);

        -- Line 4 ---------------------------------------------------------
        TEST_STEP <= x"03";
        R_W_N     <= '0';
        A         <= x"C006"; -- RESET PENIO_N
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C100";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(R_W_N_245 = '1') report "expect R_W_N_245 HIGH" severity error;

        -- Line 5 ---------------------------------------------------------
        TEST_STEP <= x"04";
        A         <= x"C400";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(R_W_N_245 = '1') report "expect R_W_N_245 HIGH" severity error;

        -- Line 6 ---------------------------------------------------------
        TEST_STEP <= x"05";
        R_W_N     <= '0';
        A         <= x"C006"; -- RESET PENIO_N
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C00B"; -- RESET INTC300 (SET INTC300_N)
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C300";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(R_W_N_245 = '1') report "expect R_W_N_245 HIGH" severity error;

        -- Line 7 ---------------------------------------------------------
        TEST_STEP <= x"06";
        R_W_N     <= '0';
        A         <= x"C006"; -- RESET PENIO_N
        wait until falling_edge(PHI_0);

        R_W_N <= '0';
        A     <= x"CFFF"; -- RESET INTC8EN (INTC8ROM)
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C800";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(R_W_N_245 = '1') report "expect R_W_N_245 HIGH" severity error;

        -- Anything else should expect LOW on R_W_N_245
        resetMMU(PHI_0, A);
        DMA_N <= '1';
        R_W_N <= '0';
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(R_W_N_245 = '0') report "expect R_W_N_245 LOW" severity error;

        FINISHED <= '1';
        assert false report "Test done." severity note;
        wait;

    end process;
end MMU_TEST_RW245;
