library IEEE;
use IEEE.std_logic_1164.all;

entity RA_MUX_TB is
    -- empty
end RA_MUX_TB;

architecture TESTBENCH of RA_MUX_TB is
    component RA_MUX is
        port (
            DELAY_CLK : in std_logic;
            PHI       : in std_logic;
            PRAS_N    : in std_logic;
            Q3        : in std_logic;
            ROW_RA0, ROW_RA1, ROW_RA2, ROW_RA3,
            ROW_RA4, ROW_RA5, ROW_RA6, ROW_RA7 : in std_logic;
            COL_RA0, COL_RA1, COL_RA2, COL_RA3,
            COL_RA4, COL_RA5, COL_RA6, COL_RA7 : in std_logic;

            RA_ENABLE_N : out std_logic;
            RA0, RA1, RA2, RA3,
            RA4, RA5, RA6, RA7 : out std_logic
        );
    end component;

    signal PHI, PRAS_N, Q3 : std_logic;
    signal ROW_RA0, ROW_RA1, ROW_RA2, ROW_RA3,
    ROW_RA4, ROW_RA5, ROW_RA6, ROW_RA7 : std_logic;
    signal COL_RA0, COL_RA1, COL_RA2, COL_RA3,
    COL_RA4, COL_RA5, COL_RA6, COL_RA7 : std_logic;

    signal RA_ENABLE_N : std_logic;
    signal RA0, RA1, RA2, RA3,
    RA4, RA5, RA6, RA7 : std_logic;
begin
    dut : RA_MUX port map(
        DELAY_CLK => '0',
        PHI       => PHI,
        PRAS_N    => PRAS_N,
        Q3        => Q3,

        ROW_RA0 => ROW_RA0,
        ROW_RA1 => ROW_RA1,
        ROW_RA2 => ROW_RA2,
        ROW_RA3 => ROW_RA3,
        ROW_RA4 => ROW_RA4,
        ROW_RA5 => ROW_RA5,
        ROW_RA6 => ROW_RA6,
        ROW_RA7 => ROW_RA7,
        COL_RA0 => COL_RA0,
        COL_RA1 => COL_RA1,
        COL_RA2 => COL_RA2,
        COL_RA3 => COL_RA3,
        COL_RA4 => COL_RA4,
        COL_RA5 => COL_RA5,
        COL_RA6 => COL_RA6,
        COL_RA7 => COL_RA7,

        RA_ENABLE_N => RA_ENABLE_N,
        RA0 => RA0,
        RA1 => RA1,
        RA2 => RA2,
        RA3 => RA3,
        RA4 => RA4,
        RA5 => RA5,
        RA6 => RA6,
        RA7 => RA7

    );

    process begin
        -- RA_ENABLE_N TESTS
        PHI <= '0';
        Q3 <= '0';
        PRAS_N <= '0';
        wait for 1 ns;
        assert(RA_ENABLE_N = '1') report "Expected RA_ENABLE_N HIGH" severity error;

        PHI <= '0';
        Q3 <= '0';
        PRAS_N <= '1';
        wait for 1 ns;
        assert(RA_ENABLE_N = '0') report "Expected RA_ENABLE_N LOW" severity error;

        PHI <= '1';
        Q3 <= '1';
        PRAS_N <= '1';
        wait for 1 ns;
        assert(RA_ENABLE_N = '0') report "Expected RA_ENABLE_N LOW" severity error;

        PHI <= '1';
        Q3 <= '1';
        PRAS_N <= '0';
        wait for 1 ns;
        assert(RA_ENABLE_N = '0') report "Expected RA_ENABLE_N LOW" severity error;

        PHI <= '1';
        Q3 <= '0';
        PRAS_N <= '0';
        wait for 1 ns;
        assert(RA_ENABLE_N = '1') report "Expected RA_ENABLE_N HIGH" severity error;

        PHI <= '1';
        Q3 <= '0';
        PRAS_N <= '1';
        wait for 1 ns;
        assert(RA_ENABLE_N = '1') report "Expected RA_ENABLE_N HIGH" severity error;

        PHI <= '1';
        Q3 <= '0';
        PRAS_N <= '1';
        wait for 1 ns;
        assert(RA_ENABLE_N = '1') report "Expected RA_ENABLE_N HIGH" severity error;

        PHI <= '0';
        Q3 <= '1';
        PRAS_N <= '1';
        wait for 1 ns;
        assert(RA_ENABLE_N = '1') report "Expected RA_ENABLE_N HIGH" severity error;

        PHI <= '0';
        Q3 <= '1';
        PRAS_N <= '0';
        wait for 1 ns;
        assert(RA_ENABLE_N = '1') report "Expected RA_ENABLE_N HIGH" severity error;

        PHI <= '0';
        Q3 <= '0';
        PRAS_N <= '0';
        wait for 1 ns;
        assert(RA_ENABLE_N = '1') report "Expected RA_ENABLE_N HIGH" severity error;

        -- ROW / COL TESTS
        ROW_RA0 <= '0';
        ROW_RA1 <= '1';
        ROW_RA2 <= '0';
        ROW_RA3 <= '1';
        ROW_RA4 <= '0';
        ROW_RA5 <= '1';
        ROW_RA6 <= '0';
        ROW_RA7 <= '1';
        COL_RA0 <= 'U';
        COL_RA1 <= 'U';
        COL_RA2 <= 'U';
        COL_RA3 <= 'U';
        COL_RA4 <= 'U';
        COL_RA5 <= 'U';
        COL_RA6 <= 'U';
        COL_RA7 <= 'U';

        PRAS_N <= '1';
        wait for 1 ns;
        assert(RA0 = '0') report "When PRAS_N is LOW and PRAS_N is HIGH, RA should be ROW addresses" severity error;
        assert(RA1 = '1') report "When PRAS_N is LOW and PRAS_N is HIGH, RA should be ROW addresses" severity error;
        assert(RA2 = '0') report "When PRAS_N is LOW and PRAS_N is HIGH, RA should be ROW addresses" severity error;
        assert(RA3 = '1') report "When PRAS_N is LOW and PRAS_N is HIGH, RA should be ROW addresses" severity error;
        assert(RA4 = '0') report "When PRAS_N is LOW and PRAS_N is HIGH, RA should be ROW addresses" severity error;
        assert(RA5 = '1') report "When PRAS_N is LOW and PRAS_N is HIGH, RA should be ROW addresses" severity error;
        assert(RA6 = '0') report "When PRAS_N is LOW and PRAS_N is HIGH, RA should be ROW addresses" severity error;
        assert(RA7 = '1') report "When PRAS_N is LOW and PRAS_N is HIGH, RA should be ROW addresses" severity error;

        ROW_RA0 <= 'U';
        ROW_RA1 <= 'U';
        ROW_RA2 <= 'U';
        ROW_RA3 <= 'U';
        ROW_RA4 <= 'U';
        ROW_RA5 <= 'U';
        ROW_RA6 <= 'U';
        ROW_RA7 <= 'U';
        COL_RA0 <= '0';
        COL_RA1 <= '1';
        COL_RA2 <= '0';
        COL_RA3 <= '1';
        COL_RA4 <= '0';
        COL_RA5 <= '1';
        COL_RA6 <= '0';
        COL_RA7 <= '1';

        PRAS_N <= '0';
        wait for 1 ns;
        assert(RA0 = '0') report "When PRAS_N is LOW, RA should be COL addresses" severity error;
        assert(RA1 = '1') report "When PRAS_N is LOW, RA should be COL addresses" severity error;
        assert(RA2 = '0') report "When PRAS_N is LOW, RA should be COL addresses" severity error;
        assert(RA3 = '1') report "When PRAS_N is LOW, RA should be COL addresses" severity error;
        assert(RA4 = '0') report "When PRAS_N is LOW, RA should be COL addresses" severity error;
        assert(RA5 = '1') report "When PRAS_N is LOW, RA should be COL addresses" severity error;
        assert(RA6 = '0') report "When PRAS_N is LOW, RA should be COL addresses" severity error;
        assert(RA7 = '1') report "When PRAS_N is LOW, RA should be COL addresses" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
