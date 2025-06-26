library IEEE;
use IEEE.std_logic_1164.all;

entity IOU_MD7_TB is
    -- empty
end IOU_MD7_TB;

architecture TESTBENCH of IOU_MD7_TB is
    component IOU_MD7 is
        port (
            Q3       : in std_logic;
            PHI_0    : in std_logic;
            PRAS_N   : in std_logic;
            KEYLE    : in std_logic;
            POC_N    : in std_logic;
            CLRKEY_N : in std_logic;
            RC00X_N  : in std_logic;
            RC01X_N  : in std_logic;
            LA       : in std_logic_vector(3 downto 0);
            AKD      : in std_logic;
            VBL_N    : in std_logic;
            ITEXT    : in std_logic;
            MIX      : in std_logic;
            PG2      : in std_logic;
            HIRES    : in std_logic;
            PAYMAR   : in std_logic;
            S_80COL  : in std_logic;

            MD7_ENABLE_N : out std_logic;
            MD7          : out std_logic
        );
    end component;

    signal Q3           : std_logic;
    signal PHI_0        : std_logic;
    signal PRAS_N       : std_logic;
    signal KEYLE        : std_logic;
    signal POC_N        : std_logic;
    signal CLRKEY_N     : std_logic;
    signal RC00X_N      : std_logic;
    signal RC01X_N      : std_logic;
    signal LA           : std_logic_vector(3 downto 0);
    signal AKD          : std_logic;
    signal VBL_N        : std_logic;
    signal ITEXT        : std_logic;
    signal MIX          : std_logic;
    signal PG2          : std_logic;
    signal HIRES        : std_logic;
    signal PAYMAR       : std_logic;
    signal S_80COL      : std_logic;
    signal MD7_ENABLE_N : std_logic;
    signal MD7          : std_logic;

begin
    dut : IOU_MD7 port map(
        Q3           => Q3,
        PHI_0        => PHI_0,
        PRAS_N       => PRAS_N,
        KEYLE        => KEYLE,
        POC_N        => POC_N,
        CLRKEY_N     => CLRKEY_N,
        RC00X_N      => RC00X_N,
        RC01X_N      => RC01X_N,
        LA           => LA,
        AKD          => AKD,
        VBL_N        => VBL_N,
        ITEXT        => ITEXT,
        MIX          => MIX,
        PG2          => PG2,
        HIRES        => HIRES,
        PAYMAR       => PAYMAR,
        S_80COL      => S_80COL,
        MD7_ENABLE_N => MD7_ENABLE_N,
        MD7          => MD7
    );

    process begin

        -- MD7_ENABLE_N -----------------------------------
        -- Init
        PHI_0   <= '0';
        PRAS_N  <= '0';
        wait for 1 ns;

        -- Phase part of enabling
        Q3      <= '1';
        PHI_0   <= '1';
        PRAS_N  <= '1';
        RC00X_N <= '0';
        RC01X_N <= '1';
        LA      <= "0000";
        wait for 1 ns;
        assert(MD7_ENABLE_N = '1') report "expect MD7_ENABLE_N to be HIGH" severity error;

        Q3      <= '1';
        PHI_0   <= '1';
        PRAS_N  <= '0';
        RC00X_N <= '0';
        RC01X_N <= '1';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '1') report "expect MD7_ENABLE_N to be HIGH" severity error;

        Q3      <= '0';
        PHI_0   <= '1';
        PRAS_N  <= '0';
        RC00X_N <= '0';
        RC01X_N <= '1';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;

        Q3      <= '0';
        PHI_0   <= '1';
        PRAS_N  <= '1';
        RC00X_N <= '0';
        RC01X_N <= '1';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;

        Q3      <= '1';
        PHI_0   <= '0';
        PRAS_N  <= '1';
        RC00X_N <= '0';
        RC01X_N <= '1';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;

        Q3      <= '1';
        PHI_0   <= '0';
        PRAS_N  <= '0';
        RC00X_N <= '0';
        RC01X_N <= '1';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '1') report "expect MD7_ENABLE_N to be HIGH" severity error;

        Q3      <= '0';
        PHI_0   <= '0';
        PRAS_N  <= '0';
        RC00X_N <= '0';
        RC01X_N <= '1';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '1') report "expect MD7_ENABLE_N to be HIGH" severity error;

        Q3      <= '0';
        PHI_0   <= '0';
        PRAS_N  <= '1';
        RC00X_N <= '0';
        RC01X_N <= '1';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '1') report "expect MD7_ENABLE_N to be HIGH" severity error;
        -- In correct part of phase, but soft switches not addressed
        Q3     <= '0';
        PHI_0  <= '1';
        PRAS_N <= '1';

        RC00X_N <= '1';
        RC01X_N <= '1';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '1') report "expect MD7_ENABLE_N to be HIGH" severity error;

        RC00X_N <= '1';
        RC01X_N <= '0';
        LA      <= "0101"; -- C015
        wait for 1 ns;
        assert(MD7_ENABLE_N = '1') report "expect MD7_ENABLE_N to be HIGH" severity error;

        RC00X_N <= '1';
        RC01X_N <= '0';
        LA      <= "0000"; -- C010
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;

        -- Soft switches addressed
        RC00X_N <= '0';
        RC01X_N <= '1';
        LA      <= "0000";
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;

        RC00X_N <= '1';
        RC01X_N <= '0';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;

        RC00X_N <= '1';
        RC01X_N <= '0';
        LA      <= "1111";
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;

        -- KEY --------------------------------------------
        RC00X_N <= '0';
        RC01X_N <= '1';
        LA      <= "0000";

        KEYLE    <= '0';
        CLRKEY_N <= '1';
        POC_N    <= '0';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;
        assert(MD7 = '0') report "KEY should be LOW during power-on" severity error;

        POC_N <= '1';

        KEYLE <= '1';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;
        assert(MD7 = '1') report "KEY should be HIGH" severity error;

        KEYLE <= '0';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;
        assert(MD7 = '1') report "KEY should not change" severity error;

        CLRKEY_N <= '0';
        KEYLE    <= '0';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;
        assert(MD7 = '0') report "KEY should have been cleared" severity error;

        RC00X_N <= '1';
        RC01X_N <= '0';
        AKD     <= '0';
        VBL_N   <= '0';
        ITEXT   <= '0';
        MIX     <= '0';
        PG2     <= '0';
        HIRES   <= '0';
        PAYMAR  <= '0';
        S_80COL <= '0';

        -- C010
        LA  <= x"0";
        AKD <= '1';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;
        assert(MD7 = '1') report "MD7 should be HIGH" severity error;

        -- C019
        LA    <= x"9";
        AKD   <= '0';
        VBL_N <= '1';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;
        assert(MD7 = '1') report "MD7 should be HIGH" severity error;

        -- C01A
        LA    <= x"A";
        VBL_N <= '0';
        ITEXT <= '1';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;
        assert(MD7 = '1') report "MD7 should be HIGH" severity error;

        -- C01B
        LA    <= x"B";
        ITEXT <= '0';
        MIX   <= '1';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;
        assert(MD7 = '1') report "MD7 should be HIGH" severity error;

        -- C01C
        LA  <= x"C";
        MIX <= '0';
        PG2 <= '1';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;
        assert(MD7 = '1') report "MD7 should be HIGH" severity error;

        -- C01D
        LA    <= x"D";
        PG2   <= '0';
        HIRES <= '1';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;
        assert(MD7 = '1') report "MD7 should be HIGH" severity error;

        -- C01E
        LA     <= x"E";
        HIRES  <= '0';
        PAYMAR <= '1';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;
        assert(MD7 = '1') report "MD7 should be HIGH" severity error;

        -- C01F
        LA      <= x"F";
        PAYMAR  <= '0';
        S_80COL <= '1';
        wait for 1 ns;
        assert(MD7_ENABLE_N = '0') report "expect MD7_ENABLE_N to be LOW" severity error;
        assert(MD7 = '1') report "MD7 should be HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
