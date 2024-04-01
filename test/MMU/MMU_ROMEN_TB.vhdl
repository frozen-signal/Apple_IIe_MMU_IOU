library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_ROMEN_TB is
    -- empty
end MMU_ROMEN_TB;
architecture MMU_ROMEN_TEST of MMU_ROMEN_TB is
    component MMU_ROMEN is
        port (
            DELAYED_PHI_0 : in std_logic;
            INTC8ACC      : in std_logic;
            INTC3ACC_N    : in std_logic;
            CXXX          : in std_logic;
            DXXX_N        : in std_logic;
            E_FXXX_N      : in std_logic;
            INH           : in std_logic;
            RDROM         : in std_logic;
            CENROM1       : in std_logic;
            R_W_N         : in std_logic;

            ROMEN2_N : out std_logic;
            ROMEN1_N : out std_logic
        );
    end component;

    signal DELAYED_PHI_0      : std_logic;
    signal INTC8ACC   : std_logic;
    signal INTC3ACC_N : std_logic;
    signal CXXX       : std_logic;
    signal DXXX_N     : std_logic;
    signal E_FXXX_N   : std_logic;
    signal INH        : std_logic;
    signal RDROM      : std_logic;
    signal CENROM1    : std_logic;
    signal R_W_N      : std_logic;
    signal ROMEN2_N   : std_logic;
    signal ROMEN1_N   : std_logic;

begin
    dut : MMU_ROMEN port map(
        DELAYED_PHI_0 => DELAYED_PHI_0,
        INTC8ACC      => INTC8ACC,
        INTC3ACC_N    => INTC3ACC_N,
        CXXX          => CXXX,
        DXXX_N        => DXXX_N,
        E_FXXX_N      => E_FXXX_N,
        INH           => INH,
        RDROM         => RDROM,
        CENROM1       => CENROM1,
        R_W_N         => R_W_N,
        ROMEN2_N      => ROMEN2_N,
        ROMEN1_N      => ROMEN1_N
    );

    process begin
        -- ROMEN2 ---------------------------------------------------------
        INH      <= '0';
        RDROM    <= '0';
        R_W_N    <= '0';
        DELAYED_PHI_0 <= '0';
        E_FXXX_N <= '0';
        wait for 1 ns;
        assert(ROMEN2_N = '1') report "expect ROMEN2 HIGH" severity error;

        RDROM    <= '1';
        R_W_N    <= '1';
        DELAYED_PHI_0 <= '1';
        E_FXXX_N <= '0';
        wait for 1 ns;
        assert(ROMEN2_N = '0') report "expect ROMEN2 LOW" severity error;

        RDROM    <= '0';
        R_W_N    <= '1';
        DELAYED_PHI_0 <= '1';
        E_FXXX_N <= '0';
        wait for 1 ns;
        assert(ROMEN2_N = '1') report "expect ROMEN2 HIGH" severity error;

        RDROM    <= '0';
        R_W_N    <= '1';
        DELAYED_PHI_0 <= '1';
        E_FXXX_N <= '1';
        wait for 1 ns;
        assert(ROMEN2_N = '1') report "expect ROMEN2 HIGH" severity error;

        RDROM    <= '0';
        R_W_N    <= '1';
        DELAYED_PHI_0 <= '1';
        E_FXXX_N <= '1';
        wait for 1 ns;
        assert(ROMEN2_N = '1') report "expect ROMEN2 HIGH" severity error;

        INH      <= '1';
        RDROM    <= '1';
        R_W_N    <= '1';
        DELAYED_PHI_0 <= '1';
        E_FXXX_N <= '0';
        wait for 1 ns;
        assert(ROMEN2_N = '1') report "expect ROMEN2 HIGH" severity error;

        -- ROMEN1 ---------------------------------------------------------
        INH        <= '0';
        CENROM1    <= '0';
        CXXX       <= '1';
        DELAYED_PHI_0 <= '1';
        RDROM      <= '0';
        R_W_N      <= '0';
        DXXX_N     <= '1';
        INTC8ACC   <= '0';
        INTC3ACC_N <= '1';
        wait for 1 ns;
        assert(ROMEN1_N = '1') report "expect ROMEN1 HIGH" severity error;

        INH        <= '0';
        CENROM1    <= '1';
        CXXX       <= '1';
        DELAYED_PHI_0 <= '1';
        RDROM      <= '0';
        R_W_N      <= '0';
        DXXX_N     <= '1';
        INTC8ACC   <= '1';
        INTC3ACC_N <= '0';
        wait for 1 ns;
        assert(ROMEN1_N = '0') report "expect ROMEN1 LOW" severity error;

        INH        <= '0';
        CENROM1    <= '0';
        CXXX       <= '1';
        DELAYED_PHI_0 <= '1';
        RDROM      <= '0';
        R_W_N      <= '0';
        DXXX_N     <= '1';
        INTC8ACC   <= '1';
        INTC3ACC_N <= '0';
        wait for 1 ns;
        assert(ROMEN1_N = '0') report "expect ROMEN1 LOW" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end MMU_ROMEN_TEST;
