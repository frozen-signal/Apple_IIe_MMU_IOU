library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_INTERNALS_TB is
    -- empty
end MMU_INTERNALS_TB;
architecture MMU_INTERNALS_TEST of MMU_INTERNALS_TB is
    component MMU_INTERNALS is
        port (
            C8_FXX  : in std_logic;
            MCFFF_N : in std_logic;
            PHI_1   : in std_logic;
            INTC300 : in std_logic;
            MC00X_N : in std_logic;
            MC01X_N : in std_logic;
            MC3XX   : in std_logic;
            MPON_N  : in std_logic;
            PENIO_N : in std_logic;
            MC0XX_N : in std_logic;

            INTC8EN    : out std_logic;
            INTC8ACC   : out std_logic;
            INTC3ACC_N : out std_logic;
            CENROM1    : out std_logic;
            INTIO_N    : out std_logic
        );

    end component;

    signal C8_FXX  : std_logic;
    signal MCFFF_N : std_logic;
    signal PHI_1   : std_logic;
    signal INTC300 : std_logic;
    signal MC00X_N : std_logic;
    signal MC01X_N : std_logic;
    signal MC3XX   : std_logic;
    signal MPON_N  : std_logic;
    signal PENIO_N : std_logic;
    signal MC0XX_N : std_logic;

    signal INTC8EN    : std_logic;
    signal INTC8ACC   : std_logic;
    signal INTC3ACC_N : std_logic;
    signal CENROM1    : std_logic;
    signal INTIO_N    : std_logic;

begin
    dut : MMU_INTERNALS port map(
        C8_FXX  => C8_FXX,
        MCFFF_N => MCFFF_N,
        PHI_1   => PHI_1,
        INTC300 => INTC300,
        MC00X_N => MC00X_N,
        MC01X_N => MC01X_N,
        MC3XX   => MC3XX,
        MPON_N  => MPON_N,
        PENIO_N => PENIO_N,
        MC0XX_N => MC0XX_N,

        INTC8EN    => INTC8EN,
        INTC8ACC   => INTC8ACC,
        INTC3ACC_N => INTC3ACC_N,
        CENROM1    => CENROM1,
        INTIO_N    => INTIO_N
    );

    process begin

        -- INTC3ACC_N -----------------------------------------------------
        INTC300 <= '0';
        MC3XX   <= '0';
        wait for 1 ns;
        assert(INTC3ACC_N = '1') report "When INTC300 and MC3XX LOW; expect INTC3ACC_N HIGH" severity error;

        INTC300 <= '1';
        MC3XX   <= '0';
        wait for 1 ns;
        assert(INTC3ACC_N = '1') report "When INTC300 LOW and MC3XX HIGH; expect INTC3ACC_N HIGH" severity error;

        INTC300 <= '0';
        MC3XX   <= '1';
        wait for 1 ns;
        assert(INTC3ACC_N = '1') report "When INTC300 HIGH and MC3XX LOW; expect INTC3ACC_N HIGH" severity error;

        INTC300 <= '1';
        MC3XX   <= '1';
        wait for 1 ns;
        assert(INTC3ACC_N = '0') report "When INTC300 and MC3XX HIGH; expect INTC3ACC_N LOW" severity error;

        -- INTC8EN --------------------------------------------------------
        MPON_N <= '0';
        wait for 1 ns;
        assert(INTC8EN = '0') report "On reset (MPON_N LOW); expect INTC8EN cleared" severity error;

        MPON_N  <= '1';
        MCFFF_N <= '1';
        PHI_1   <= '1';
        wait for 1 ns;
        assert(INTC8EN = '0') report "When PHI_1 is HIGH; expect INTC8EN unchanged" severity error;

        INTC300 <= '1';
        MC3XX   <= '1';
        PHI_1   <= '0';
        wait for 1 ns;
        assert(INTC3ACC_N = '0') report "Precondition: INTC3ACC_N should be LOW" severity error;
        assert(INTC8EN = '1') report "When PHI_1 and INTC3ACC_N LOW; expect INTC8EN preset" severity error;

        INTC300 <= '0';
        MC3XX   <= '1';
        MCFFF_N <= '0';
        wait for 1 ns;
        assert(INTC8EN = '0') report "When MCFFF_N LOW; expect INTC8EN cleared" severity error;

        -- INTC8ACC -------------------------------------------------------
        C8_FXX  <= '0';
        INTC300 <= '0';
        MC3XX   <= '1';
        MCFFF_N <= '0';
        wait for 1 ns;
        assert(INTC8EN = '0') report "Precondition: INTC8EN should be LOW" severity error;
        assert(INTC8ACC = '0') report "When C8_FXX and INTC8EN LOW; expect INTC8ACC LOW" severity error;

        C8_FXX <= '1';
        wait for 1 ns;
        assert(INTC8ACC = '0') report "When C8_FXX HIGH and INTC8EN LOW; expect INTC8ACC LOW" severity error;

        C8_FXX  <= '0';
        INTC300 <= '1';
        MC3XX   <= '1';
        PHI_1   <= '0';
        wait for 1 ns;
        assert(INTC8EN = '1') report "Precondition: INTC8EN should be HIGH" severity error;
        assert(INTC8ACC = '0') report "When C8_FXX LOW and INTC8EN HIGH; expect INTC8ACC LOW" severity error;

        C8_FXX <= '1';
        wait for 1 ns;
        assert(INTC8ACC = '1') report "When C8_FXX and INTC8EN HIGH; expect INTC8ACC HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

        -- CENROM1 --------------------------------------------------------
        MC0XX_N <= '0';
        PENIO_N <= '0';
        wait for 1 ns;
        assert(CENROM1 = '0') report "When MC0XX_N and PENIO_N LOW; expect CENROM1 LOW" severity error;

        MC0XX_N <= '1';
        PENIO_N <= '0';
        wait for 1 ns;
        assert(CENROM1 = '0') report "When MC0XX_N HIGH and PENIO_N LOW; expect CENROM1 LOW" severity error;

        MC0XX_N <= '0';
        PENIO_N <= '1';
        wait for 1 ns;
        assert(CENROM1 = '0') report "When MC0XX_N LOW and PENIO_N HIGH; expect CENROM1 LOW" severity error;

        MC0XX_N <= '1';
        PENIO_N <= '1';
        wait for 1 ns;
        assert(CENROM1 = '1') report "When MC0XX_N and PENIO_N HIGH; expect CENROM1 HIGH" severity error;

        -- INTIO_N ------------------------------------------------------------
        MC00X_N <= '0';
        MC01X_N <= '0';
        wait for 1 ns;
        assert(INTIO_N = '0') report "When MC00X_N and MC01X_N LOW; expect INTIO_N LOW" severity error;

        MC00X_N <= '1';
        MC01X_N <= '0';
        wait for 1 ns;
        assert(INTIO_N = '0') report "When MC00X_N HIGH and MC01X_N LOW; expect INTIO_N LOW" severity error;

        MC00X_N <= '0';
        MC01X_N <= '1';
        wait for 1 ns;
        assert(INTIO_N = '0') report "When MC00X_N LOW and MC01X_N HIGH; expect INTIO_N LOW" severity error;

        MC00X_N <= '1';
        MC01X_N <= '1';
        wait for 1 ns;
        assert(INTIO_N = '1') report "When MC00X_N and MC01X_N HIGH; expect INTIO_N HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end MMU_INTERNALS_TEST;
