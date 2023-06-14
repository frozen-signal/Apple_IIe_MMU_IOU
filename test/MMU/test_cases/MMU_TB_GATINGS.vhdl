-- Test case: See table 5.6 (p. 5-33) of "Understanding the Apple IIe" by Jim Sather
library IEEE;
library work;
use IEEE.std_logic_1164.all;
use work.TEST_UTILS.all;

entity MMU_TB_GATINGS is
    -- empty
end MMU_TB_GATINGS;

architecture MMU_TEST_GATINGS of MMU_TB_GATINGS is
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

        -- Point 2 of "Understanding the Apple IIe", page 5-29 ----------------------------------------------------
        -- "There appears to be a window during which the address bus is monitored for commands which determine
        -- soft switch states. If a soft switch command is held valid on the address bus for about 40 nanoseconds
        -- or more during the window, the affected soft switch will respond to the command."
        TEST_STEP <= x"00";
        A         <= "UUUUUUUUUUUUUUUU"; -- Make sure we don't access any address
        -- Get to the "window"
        wait until rising_edge(PHI_0);
        wait until falling_edge(Q3);
        wait until rising_edge(PRAS_N);
        -- Set a soft switch
        A     <= x"C009";
        R_W_N <= '0';
        wait until falling_edge(CLK_14M);
        A <= "UUUUUUUUUUUUUUUU"; -- Make again sure we don't access any address
        wait until rising_edge(PHI_0);

        -- Expect the soft switch to have been changed.
        R_W_N <= '1';
        A     <= x"C016"; -- Read ALTZP
        wait until rising_edge(CLK_14M);
        assert(MD7 = '1') report "expect MD7 HIGH" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- TABLE 5.6 tests ----------------------------------------------------------------------------------------
        -- $0000-$01FF, LINE 1
        TEST_STEP <= x"01";
        R_W_N     <= '0';
        A         <= x"C008"; -- RESET ALTZP
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"0000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $0000-$01FF, LINE 2 ------------------------------------------------------------------------------------
        TEST_STEP <= x"02";
        R_W_N     <= '0';
        A         <= x"C009"; -- SET ALTZP
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"0000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '0') report "expect EN80_N LOW" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- Line labeled TABLE A -----------------------------------------------------------------------------------
        TEST_STEP <= x"03";
        R_W_N     <= '0';
        A         <= x"C002"; -- SET RDROM
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        INH_N <= '1';
        A     <= x"0200";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $0200-$03FF, Line under the line labeled TABLE A -------------------------------------------------------
        TEST_STEP <= x"04";
        R_W_N     <= '0';
        A         <= x"C003"; -- SET FLG1
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        INH_N <= '1';
        A     <= x"0200";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '0') report "expect EN80_N LOW" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $0800-$1FFF --------------------------------------------------------------------------------------------
        TEST_STEP <= x"05";
        R_W_N     <= '0';
        A         <= x"C004"; -- RESET FLG2
        wait until falling_edge(PHI_0);

        R_W_N <= '0';
        A     <= x"0800";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $4000-$BFFF --------------------------------------------------------------------------------------------
        TEST_STEP <= x"06";
        R_W_N     <= '0';
        A         <= x"C005"; -- SET FLG2
        wait until falling_edge(PHI_0);

        R_W_N <= '0';
        A     <= x"4000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '0') report "expect EN80_N LOW" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $0400-$07FF --------------------------------------------------------------------------------------------
        TEST_STEP <= x"07";
        R_W_N     <= '0';
        A         <= x"C000"; -- RESET EN80VID
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"0400";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $0400-$07FF, line 2 ------------------------------------------------------------------------------------
        TEST_STEP <= x"08";
        R_W_N     <= '0';
        A         <= x"C001"; -- SET EN80VID
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C054"; -- RESET PG2
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"0400";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $0400-$07FF, line 3 ------------------------------------------------------------------------------------
        TEST_STEP <= x"09";
        R_W_N     <= '0';
        A         <= x"C001"; -- SET EN80VID
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C055"; -- SET PG2
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        INH_N <= '1';
        A     <= x"0400";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '0') report "expect EN80_N LOW" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $2000-$3FFF, line 1 ------------------------------------------------------------------------------------
        TEST_STEP <= x"0A";
        R_W_N     <= '0';
        A         <= x"C000"; -- RESET EN80VID
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"2000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $2000-$3FFF, line 2 ------------------------------------------------------------------------------------
        TEST_STEP <= x"0B";
        R_W_N     <= '0';
        A         <= x"C056"; -- RESET HIRES
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"2000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $2000-$3FFF, line 3 ------------------------------------------------------------------------------------
        TEST_STEP <= x"0C";
        R_W_N     <= '0';
        A         <= x"C001"; -- SET EN80VID
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C057"; -- RESET HIRES
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C054"; -- RESET PG2
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        INH_N <= '1';
        R_W_N <= '1';
        A     <= x"2000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $2000-$3FFF, line 4 ------------------------------------------------------------------------------------
        TEST_STEP <= x"0D";
        R_W_N     <= '0';
        A         <= x"C001"; -- SET EN80VID
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C057"; -- RESET HIRES
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C055"; -- SET PG2
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        INH_N <= '1';
        A     <= x"2000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '0') report "expect EN80_N LOW" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $C000-$C01F, line 1 ------------------------------------------------------------------------------------
        TEST_STEP <= x"0E";
        R_W_N     <= '1';
        A         <= x"C01F";
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;
        assert(KBD_N = '0') report "expect KBD_N LOW" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $C000-$C01F, line 2 ------------------------------------------------------------------------------------
        TEST_STEP <= x"0F";
        R_W_N     <= '0';
        A         <= x"C01F";
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $C020-$C0FF ---------------------------------------------------------------------------------------------
        TEST_STEP <= x"10";
        R_W_N     <= '1';
        A         <= x"C0FF";
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $C100-$C2FF ---------------------------------------------------------------------------------------------
        TEST_STEP <= x"11";
        R_W_N     <= '0';
        A         <= x"C006"; -- RESET PENIO_N
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C100";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $C400-$C7FF ---------------------------------------------------------------------------------------------
        TEST_STEP <= x"12";
        R_W_N     <= '0';
        A         <= x"C007"; -- SET PENIO_N
        wait until falling_edge(PHI_0);

        INH_N <= '1';
        R_W_N <= '1';
        A     <= x"C400";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '0') report "expect ROMEN1_N LOW" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $C300-$C3FF, line 1 -------------------------------------------------------------------------------------
        TEST_STEP <= x"13";
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
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $C300-$C3FF, line 2 -------------------------------------------------------------------------------------
        TEST_STEP <= x"14";
        R_W_N     <= '0';
        A         <= x"C007"; -- SET PENIO_N
        wait until falling_edge(PHI_0);

        INH_N <= '1';
        R_W_N <= '1';
        A     <= x"C300";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '0') report "expect ROMEN1_N LOW" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $C300-$C3FF, line 4 -------------------------------------------------------------------------------------
        TEST_STEP <= x"15";
        R_W_N     <= '0';
        A         <= x"C00A"; -- SET INTC300 (RESET INTC300_N)
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C300";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '0') report "expect ROMEN1_N LOW" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $C800-$CFFF, line 1 -------------------------------------------------------------------------------------
        TEST_STEP <= x"16";
        R_W_N     <= '0';
        A         <= x"C00B"; -- RESET INTC300 (SET INTC300_N)
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"CFFF"; -- RESET INTC8EN (INTC8ROM)
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"C800";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '1') report "expect CXXXOUT HIGH" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $C800-$CFFF, line 2 -------------------------------------------------------------------------------------
        TEST_STEP <= x"17";
        R_W_N     <= '0';
        A         <= x"C007"; -- SET PENIO_N
        wait until falling_edge(PHI_0);

        INH_N <= '1';
        R_W_N <= '1';
        A     <= x"C800";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '0') report "expect ROMEN1_N LOW" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $C800-$CFFF, line 3 -------------------------------------------------------------------------------------
        TEST_STEP <= x"17";
        R_W_N     <= '0';
        A         <= x"C300"; -- SET INTC8EN (INTC8ROM)
        wait until falling_edge(PHI_0);

        INH_N <= '1';
        R_W_N <= '1';
        A     <= x"C800";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '0') report "expect ROMEN1_N LOW" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $D000-$DFFF ---------------------------------------------------------------------------------------------
        TEST_STEP <= x"18";
        R_W_N     <= '1';
        A         <= x"C081"; -- SET RDROM (RESET HRAMRD)
        wait until falling_edge(PHI_0);

        INH_N <= '1';
        R_W_N <= '1';
        A     <= x"D000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '0') report "expect ROMEN1_N LOW" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $E000-$FFFF ---------------------------------------------------------------------------------------------
        TEST_STEP <= x"19";
        R_W_N     <= '1';
        A         <= x"C081"; -- SET RDROM (RESET HRAMRD)
        wait until falling_edge(PHI_0);

        INH_N <= '1';
        R_W_N <= '1';
        A     <= x"E000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '0') report "expect ROMEN2_N LOW" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $D000-$FFFF, line 1 ------------------------------------------------------------------------------------
        TEST_STEP <= x"1A";
        R_W_N     <= '1';
        A         <= x"C080"; -- SET RDRAM (SET HRAMRD)
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C008"; -- RESET ALTZP
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        INH_N <= '1';
        R_W_N <= '1';
        A     <= x"D000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $D000-$FFFF, line 2 ------------------------------------------------------------------------------------
        TEST_STEP <= x"1B";
        R_W_N     <= '1';
        A         <= x"C080"; -- SET RDRAM (SET HRAMRD)
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C009"; -- SET ALTZP
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        INH_N <= '1';
        R_W_N <= '1';
        A     <= x"D000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '0') report "expect EN80_N LOW" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $D000-$FFFF, line 3 ------------------------------------------------------------------------------------
        TEST_STEP <= x"1C";
        R_W_N     <= '1';
        A         <= x"C081"; -- SET WREN (SET PRE-WRITE)
        wait until falling_edge(PHI_0);
        R_W_N <= '1';
        A     <= x"C081"; -- RESET WRPROT (RESET HRAMWRT')
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C008"; -- RESET ALTZP
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        INH_N <= '1';
        R_W_N <= '0';
        A     <= x"D000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '0') report "expect CASEN_N LOW" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- $D000-$FFFF, line 4 ------------------------------------------------------------------------------------
        TEST_STEP <= x"1D";
        R_W_N     <= '1';
        A         <= x"C081"; -- SET WREN (SET PRE-WRITE)
        wait until falling_edge(PHI_0);
        R_W_N <= '1';
        A     <= x"C081"; -- RESET WRPROT (RESET HRAMWRT')
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);
        R_W_N <= '0';
        A     <= x"C009"; -- SET ALTZP
        wait until rising_edge(PHI_0);
        wait until falling_edge(PHI_0);

        INH_N <= '1';
        R_W_N <= '0';
        A     <= x"D000";
        wait until rising_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '0') report "expect EN80_N LOW" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        -- During PHASE 1 -----------------------------------------------------------------------------------------
        -- ROMEN1', R0MEN2', EN80', KBD', and MD IN/OUT' are all gated by PHASE 0. CASEN' is not
        -- gated by PHASE in the MMU, but it is gated by PHASE in the timing HAL.
        TEST_STEP <= x"1E";
        R_W_N     <= '0';
        A         <= x"C009"; -- SET ALTZP
        wait until falling_edge(PHI_0);

        R_W_N <= '1';
        A     <= x"0000";
        wait until falling_edge(PHI_0);
        wait until falling_edge(CLK_14M);
        assert(CASEN_N = '1') report "expect CASEN_N HIGH" severity error;
        assert(EN80_N = '1') report "expect EN80_N HIGH" severity error;
        assert(ROMEN1_N = '1') report "expect ROMEN1_N HIGH" severity error;
        assert(ROMEN2_N = '1') report "expect ROMEN2_N HIGH" severity error;
        assert(CXXXOUT = '0') report "expect CXXXOUT LOW" severity error;
        assert(KBD_N = '1') report "expect KBD_N HIGH" severity error;

        TEST_STEP <= "UUUUUUUU";
        resetMMU(PHI_0, A);

        FINISHED <= '1';
        assert false report "Test done." severity note;
        wait;

    end process;
end MMU_TEST_GATINGS;
