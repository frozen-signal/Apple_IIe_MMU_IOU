library IEEE;
library work;
use IEEE.std_logic_1164.all;
use work.TEST_UTILS.all;

entity MMU_TB_RA_STATE is
    -- empty
end MMU_TB_RA_STATE;

architecture TESTBENCH of MMU_TB_RA_STATE is
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

    signal FINISHED : std_logic := '0';

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

        A <= x"1234";
        wait until falling_edge(CLK_14M);
        assert(ORA = x"34") report "expect ORA 0x34" severity error;

        wait until falling_edge(PRAS_N);
        wait until falling_edge(CLK_14M);
        assert(ORA = x"11") report "expect ORA 0x11" severity error;

        wait until falling_edge(Q3);
        wait until falling_edge(CLK_14M);
        assert(ORA = "ZZZZZZZZ") report "expect ORA ZZZZZZZZ" severity error;

        FINISHED <= '1';
        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
