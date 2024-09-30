-- Test case: RA0-RA7 ADDR Convertion
library IEEE;
library work;
use IEEE.std_logic_1164.all;
use work.TEST_UTILS.all;

entity MMU_TB_RA_ADDR is
    -- empty
end MMU_TB_RA_ADDR;

architecture TESTBENCH of MMU_TB_RA_ADDR is
    component HAL_TIMING_MOCK is
        port (
            FINISHED : in std_logic;

            CLK_14M  : inout std_logic;
            PHI_0    : out std_logic;
            Q3       : out std_logic;
            RAS_N    : out std_logic
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
        FINISHED => FINISHED,
        CLK_14M  => CLK_14M,
        PHI_0    => PHI_0,
        Q3       => Q3,
        RAS_N    => PRAS_N
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

        TEST_STEP <= x"00";
        A         <= x"C088"; -- Enable BANK 1
        wait until falling_edge(CLK_14M);
        assert(ORA = x"48") report "expect ORA 0x48" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(MD7 = 'Z') report "expect MD7 Z" severity error;
        assert(R_W_N_245 = '1') report "expect R_W_N_245 HIGH" severity error;
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;

        TEST_STEP <= x"01";
        wait until falling_edge(PRAS_N);
        wait until falling_edge(CLK_14M);
        assert(ORA = x"C0") report "expect ORA 0xC0" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(MD7 = 'Z') report "expect MD7 Z" severity error;
        assert(R_W_N_245 = '1') report "expect R_W_N_245 HIGH" severity error;
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;

        wait until falling_edge(PHI_0);

        TEST_STEP <= x"02";
        A         <= x"1234";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(ORA = x"34") report "expect ORA 0x34" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(MD7 = 'Z') report "expect MD7 Z" severity error;
        assert(R_W_N_245 = '0') report "expect R_W_N_245 LOW" severity error;
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;

        -- RAM addr 1234 with BANK 1 active should be converted to 1134
        TEST_STEP <= x"03";
        wait until falling_edge(PRAS_N);
        wait until falling_edge(CLK_14M);
        assert(ORA = x"11") report "expect ORA 0x11" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(MD7 = 'Z') report "expect MD7 Z" severity error;
        assert(R_W_N_245 = '0') report "expect R_W_N_245 LOW" severity error;
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;

        wait until falling_edge(PHI_0);

        TEST_STEP <= x"04";
        A         <= x"D123";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(ORA = x"A3") report "expect ORA 0xA3" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(MD7 = 'Z') report "expect MD7 Z" severity error;
        assert(R_W_N_245 = '0') report "expect R_W_N_245 LOW" severity error;
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;

        -- RAM addr D123 with BANK 1 active should be converted to
        TEST_STEP <= x"05";
        wait until falling_edge(PRAS_N);
        wait until falling_edge(CLK_14M);
        assert(ORA = x"C0") report "expect ORA 0xC0" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(MD7 = 'Z') report "expect MD7 Z" severity error;
        assert(R_W_N_245 = '0') report "expect R_W_N_245 LOW" severity error;
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;

        wait until falling_edge(PHI_0);

        TEST_STEP <= x"06";
        A         <= x"C087"; -- Enable BANK 2
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(ORA = x"47") report "expect ORA 0x47" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(MD7 = 'Z') report "expect MD7 Z" severity error;
        assert(R_W_N_245 = '1') report "expect R_W_N_245 HIGH" severity error;
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;

        TEST_STEP <= x"07";
        wait until falling_edge(PRAS_N);
        wait until falling_edge(CLK_14M);
        assert(ORA = x"C0") report "expect ORA 0xC0" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(MD7 = 'Z') report "expect MD7 Z" severity error;
        assert(R_W_N_245 = '1') report "expect R_W_N_245 HIGH" severity error;
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;

        wait until falling_edge(PHI_0);

        TEST_STEP <= x"08";
        A         <= x"1234";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(ORA = x"34") report "expect ORA 0x34" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(MD7 = 'Z') report "expect MD7 Z" severity error;
        assert(R_W_N_245 = '0') report "expect R_W_N_245 LOW" severity error;
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;

        -- RAM addr 1234 with BANK 1 active should be converted to 1134
        TEST_STEP <= x"09";
        wait until falling_edge(PRAS_N);
        wait until falling_edge(CLK_14M);
        assert(ORA = x"11") report "expect ORA 0x11" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(MD7 = 'Z') report "expect MD7 Z" severity error;
        assert(R_W_N_245 = '0') report "expect R_W_N_245 LOW" severity error;
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;

        wait until falling_edge(PHI_0);

        -- RAM addr D123 with BANK 1 active should be converted to D0A3
        TEST_STEP <= x"0A";
        A         <= x"D123";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(ORA = x"A3") report "expect ORA 0xA3" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(MD7 = 'Z') report "expect MD7 Z" severity error;
        assert(R_W_N_245 = '0') report "expect R_W_N_245 LOW" severity error;
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;

        TEST_STEP <= x"0B";
        wait until falling_edge(PRAS_N);
        wait until falling_edge(CLK_14M);
        assert(ORA = x"D0") report "expect ORA 0xD0" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(MD7 = 'Z') report "expect MD7 Z" severity error;
        assert(R_W_N_245 = '0') report "expect R_W_N_245 LOW" severity error;
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;

        FINISHED <= '1';
        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
