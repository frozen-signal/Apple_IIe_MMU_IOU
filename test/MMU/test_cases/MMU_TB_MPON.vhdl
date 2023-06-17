library IEEE;
library work;
use IEEE.std_logic_1164.all;
use work.TEST_UTILS.all;

entity MMU_TB_MPON is
    -- empty
end MMU_TB_MPON;

architecture MMU_TEST_MPON of MMU_TB_MPON is
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

    signal CLK_14M   : std_logic := '0';
    signal PHI_0     : std_logic := '1';
    signal Q3        : std_logic := '1';
    signal PRAS_N    : std_logic;
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

        -- Reset MMU ----------------------------------------------------------------------------------------------
        TEST_STEP <= x"00";
        A         <= x"0100";
        wait until rising_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until rising_edge(PHI_0);

        TEST_STEP <= x"01";
        A         <= x"FFFC";
        wait until rising_edge(PHI_0);

        -- After an MMU reset, the MPU will read all soft switches except BANK1 as zero. --------------------------
        TEST_STEP <= x"02";
        A         <= x"C011"; -- BANK 2
        wait until rising_edge(CLK_14M);
        assert(MD7 = '1') report "expect MD7 HIGH" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;

        wait until rising_edge(PHI_0);

        A <= x"C012"; -- RDRAM
        wait until rising_edge(CLK_14M);
        assert(MD7 = '0') report "expect MD7 LOW" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;

        wait until rising_edge(PHI_0);

        A <= x"C013"; -- FLG1
        wait until rising_edge(CLK_14M);
        assert(MD7 = '0') report "expect MD7 LOW" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;

        wait until rising_edge(PHI_0);

        A <= x"C014"; -- FLG2
        wait until rising_edge(CLK_14M);
        assert(MD7 = '0') report "expect MD7 LOW" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;

        wait until rising_edge(PHI_0);

        A <= x"C015"; -- ENIO_N
        wait until rising_edge(CLK_14M);
        assert(MD7 = '0') report "expect MD7 LOW" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;

        wait until rising_edge(PHI_0);

        A <= x"C016"; -- ALTSTKZP
        wait until rising_edge(CLK_14M);
        assert(MD7 = '0') report "expect MD7 LOW" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;

        wait until rising_edge(PHI_0);

        A <= x"C017"; -- INTC300_N
        wait until rising_edge(CLK_14M);
        assert(MD7 = '0') report "expect MD7 LOW" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;

        wait until rising_edge(PHI_0);

        A <= x"C018"; -- EN80VID
        wait until rising_edge(CLK_14M);
        assert(MD7 = '0') report "expect MD7 LOW" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;

        FINISHED <= '1';
        assert false report "Test done." severity note;
        wait;

    end process;
end MMU_TEST_MPON;
