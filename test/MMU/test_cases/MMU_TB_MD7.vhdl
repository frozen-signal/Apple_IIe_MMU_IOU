library IEEE;
library work;
use IEEE.std_logic_1164.all;
use work.TEST_UTILS.all;

entity MMU_TB_MD7 is
    -- empty
end MMU_TB_MD7;

architecture MMU_TEST_MD7 of MMU_TB_MD7 is
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

        -- C00X SOFT SWITCHES -------------------------------------------------------------------------------------
        -- EN80VID --------------------------------------------------------
        TEST_STEP <= x"00";
        R_W_N     <= '1';
        A         <= x"C018";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '0') report "expect EN80VID LOW" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- Set EN80VID
        TEST_STEP <= x"01";
        R_W_N     <= '0';
        A         <= x"C001";
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C018";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '1') report "expect EN80VID HIGH" severity error;

        -- Reset EN80VID
        TEST_STEP <= x"02";
        R_W_N     <= '0';
        A         <= x"C000";
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C018";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '0') report "expect EN80VID LOW" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- FLG1 -----------------------------------------------------------
        TEST_STEP <= x"03";
        R_W_N     <= '1';
        A         <= x"C013";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '0') report "expect FLG1 LOW" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- Set FLG1
        TEST_STEP <= x"04";
        R_W_N     <= '0';
        A         <= x"C003";
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C013";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '1') report "expect FLG1 HIGH" severity error;

        -- Reset FLG1
        TEST_STEP <= x"05";
        R_W_N     <= '0';
        A         <= x"C002";
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C013";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '0') report "expect FLG1 LOW" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- FLG2 -----------------------------------------------------------
        TEST_STEP <= x"06";
        R_W_N     <= '1';
        A         <= x"C014";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '0') report "expect FLG2 LOW" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- Set FLG2
        TEST_STEP <= x"07";
        R_W_N     <= '0';
        A         <= x"C005";
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C014";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '1') report "expect FLG2 HIGH" severity error;

        -- Reset FLG2
        TEST_STEP <= x"08";
        R_W_N     <= '0';
        A         <= x"C004";
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C014";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '0') report "expect FLG2 LOW" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- PENIO_N ---------------------------------------------------------
        TEST_STEP <= x"09";
        R_W_N     <= '1';
        A         <= x"C015";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '0') report "expect PENIO_N LOW" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- Set PENIO_N
        TEST_STEP <= x"0A";
        R_W_N     <= '0';
        A         <= x"C007";
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C015";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '1') report "expect PENIO_N HIGH" severity error;

        -- Reset PENIO_N
        TEST_STEP <= x"0B";
        R_W_N     <= '0';
        A         <= x"C006";
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C015";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '0') report "expect PENIO_N LOW" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- ALTSTKZP -------------------------------------------------------
        TEST_STEP <= x"0C";
        R_W_N     <= '1';
        A         <= x"C016";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '0') report "expect ALTSTKZP LOW" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- Set ALTSTKZP
        TEST_STEP <= x"0D";
        R_W_N     <= '0';
        A         <= x"C009";
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C016";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '1') report "expect ALTSTKZP HIGH" severity error;

        -- Reset ALTSTKZP
        TEST_STEP <= x"0E";
        R_W_N     <= '0';
        A         <= x"C008";
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C016";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '0') report "expect ALTSTKZP LOW" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- INTC300_N ------------------------------------------------------
        TEST_STEP <= x"0F";
        R_W_N     <= '1';
        A         <= x"C017";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '0') report "expect INTC300_N LOW" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- Set INTC300_N
        TEST_STEP <= x"10";
        R_W_N     <= '0';
        A         <= x"C00B";
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C017";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '1') report "expect INTC300_N HIGH" severity error;

        -- Reset INTC300_N
        TEST_STEP <= x"11";
        R_W_N     <= '0';
        A         <= x"C00A";
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C017";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '0') report "expect INTC300_N LOW" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- C05X SOFT SWITCHES -------------------------------------------------------------------------------------
        -- We can't directly probe the C05X soft switches. We can check their value via CASEN_N

        -- HIRES and PG2 are SET ------------------------------------------
        TEST_STEP <= x"12";
        R_W_N     <= '0';
        A         <= x"C057"; -- SET HIRES
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C055"; -- SET PG2
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C001"; -- SET EN80VID
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"2000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- HIRES is SET, PG2 is RESET -------------------------------------
        TEST_STEP <= x"13";
        R_W_N     <= '0';
        A         <= x"C057"; -- SET HIRES
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C054"; -- RESET PG2
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C001"; -- SET EN80VID
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"2000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- HIRES is RESET, PG2 is SET -------------------------------------
        TEST_STEP <= x"14";
        R_W_N     <= '0';
        A         <= x"C056"; -- RESET HIRES
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C055"; -- SET PG2
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C001"; -- SET EN80VID
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"2000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- C08X SOFT SWITCHES -------------------------------------------------------------------------------------
        -- BANK1/BANK2 ----------------------------------------------------
        TEST_STEP <= x"15";
        R_W_N     <= '1';
        A         <= x"C011";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '1') report "expect BANK2 SELECTED" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- Set BANK1
        TEST_STEP <= x"16";
        R_W_N     <= '1';
        A         <= x"C088";
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C011";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '0') report "expect BANK1 SELECTED" severity error;

        -- Set BANK2
        TEST_STEP <= x"17";
        R_W_N     <= '1';
        A         <= x"C080";
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C011";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '1') report "expect BANK2 SELECTED" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- RDRAM/RDROM ----------------------------------------------------
        TEST_STEP <= x"18";
        R_W_N     <= '1';
        A         <= x"C012";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '0') report "expect RDROM SELECTED" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- Set RDRAM
        TEST_STEP <= x"19";
        R_W_N     <= '1';
        A         <= x"C080";
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C012";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '1') report "expect RDRAM SELECTED" severity error;

        -- Set RDROM
        TEST_STEP <= x"1A";
        R_W_N     <= '1';
        A         <= x"C081";
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C012";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '0') report "expect RDROM SELECTED" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- WRPROT ---------------------------------------------------------
        TEST_STEP <= x"1B";
        R_W_N     <= '0';
        A         <= x"C057"; -- SET HIRES
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C054"; -- RESET PG2
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C001"; -- SET EN80VID
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C081"; -- To set WRPROT, first read any odd address in C08X range...
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C080"; -- ...then read even address in C08X range.
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        R_W_N <= '0';
        A     <= x"D000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;

        -- RESET WRPROT: read odd address in C08X range.
        R_W_N <= '1';
        A     <= x"C081";
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        R_W_N <= '0';
        A     <= x"D000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- MD7 ENABLING -------------------------------------------------------------------------------------------
        -- When the MPU reads the state of an MMU soft switch, the MD7 enable gate appears to be PHASE0 + PHASE0' • Q3 • RAS'
        -- which is PHASE 0 and the first 14M period of the following PHASE 1.
        R_W_N <= '1';
        A     <= x"C081"; -- reset HRAMRD
        wait until falling_edge(PHI_0);

        TEST_STEP <= x"1C";
        A         <= x"C012"; -- Read soft switch HRAMRD
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(MD7 = '0') report "expect MD7 LOW (PHI_0 phase)" severity error;

        TEST_STEP <= x"1D";
        wait until falling_edge(PHI_0);
        assert(MD7 = '0') report "expect MD7 LOW (PHI_1 * Q3 * PRAS_N phase)" severity error;

        TEST_STEP <= x"1E";
        wait until falling_edge(CLK_14M);
        wait until rising_edge(CLK_14M);
        wait until falling_edge(CLK_14M);
        assert(MD7 = 'Z') report "expect MD7 Z (PHI_1 phase)" severity error;

        FINISHED <= '1';
        assert false report "Test done." severity note;
        wait;

    end process;
end MMU_TEST_MD7;
