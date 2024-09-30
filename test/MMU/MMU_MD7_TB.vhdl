library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_MD7_TB is
    -- empty
end MMU_MD7_TB;
architecture TESTBENCH of MMU_MD7_TB is
    component MMU_MD7 is
        port (
            RC01X_N   : in std_logic;
            A         : in std_logic_vector(3 downto 0);
            PHI_0     : in std_logic;
            Q3        : in std_logic;
            PRAS_N    : in std_logic;
            BANK2     : in std_logic;
            RDRAM     : in std_logic;
            FLG1      : in std_logic;
            FLG2      : in std_logic;
            PENIO_N   : in std_logic;
            ALTSTKZP  : in std_logic;
            INTC300_N : in std_logic;
            EN80VID   : in std_logic;

            MD7      : out std_logic;
            ENABLE_N : out std_logic
        );
    end component;

    signal RC01X_N   : std_logic;
    signal A         : std_logic_vector(3 downto 0);
    signal PHI_0     : std_logic;
    signal Q3        : std_logic;
    signal PRAS_N    : std_logic;
    signal BANK2     : std_logic;
    signal RDRAM     : std_logic;
    signal FLG1      : std_logic;
    signal FLG2      : std_logic;
    signal PENIO_N   : std_logic;
    signal ALTSTKZP  : std_logic;
    signal INTC300_N : std_logic;
    signal EN80VID   : std_logic;

    signal MD7      : std_logic;
    signal ENABLE_N : std_logic;

    signal TEST_STEP : std_logic_vector(7 downto 0);
begin
    dut : MMU_MD7 port map(
        RC01X_N   => RC01X_N,
        A         => A,
        PHI_0     => PHI_0,
        Q3        => Q3,
        PRAS_N    => PRAS_N,
        BANK2     => BANK2,
        RDRAM     => RDRAM,
        FLG1      => FLG1,
        FLG2      => FLG2,
        PENIO_N   => PENIO_N,
        ALTSTKZP  => ALTSTKZP,
        INTC300_N => INTC300_N,
        EN80VID   => EN80VID,
        MD7       => MD7,
        ENABLE_N  => ENABLE_N
    );

    process begin
        PHI_0 <= '1';

        TEST_STEP <= x"01";
        A       <= "0001";
        RC01X_N <= '1';
        wait for 1 ns;
        assert(ENABLE_N = '1') report "When address not in the C01X range; expect ENABLE_N HIGH" severity error;

        TEST_STEP <= x"02";
        A       <= "0000";
        RC01X_N <= '0';
        wait for 1 ns;
        assert(ENABLE_N = '1') report "When address is C010; expect ENABLE_N HIGH" severity error;

        TEST_STEP <= x"03";
        A     <= "0001";
        BANK2 <= '1';
        wait for 1 ns;
        assert(ENABLE_N = '0') report "When address is C011; expect ENABLED LOW" severity error;
        assert(MD7 = '1') report "When address is C011; expect BANK2 assigned to MD7 " severity error;
        BANK2 <= 'U';

        TEST_STEP <= x"04";
        A     <= "0010";
        RDRAM <= '1';
        wait for 1 ns;
        assert(ENABLE_N = '0') report "When address is C012; expect ENABLED LOW" severity error;
        assert(MD7 = '1') report "When address is C012; expect RDRAM assigned to MD7 " severity error;
        RDRAM <= 'U';

        TEST_STEP <= x"05";
        A    <= "0011";
        FLG1 <= '1';
        wait for 1 ns;
        assert(ENABLE_N = '0') report "When address is C013; expect ENABLED LOW" severity error;
        assert(MD7 = '1') report "When address is C013; expect FLG1 assigned to MD7 " severity error;
        FLG1 <= 'U';

        TEST_STEP <= x"06";
        A    <= "0100";
        FLG2 <= '1';
        wait for 1 ns;
        assert(ENABLE_N = '0') report "When address is C014; expect ENABLED LOW" severity error;
        assert(MD7 = '1') report "When address is C014; expect FLG2 assigned to MD7 " severity error;
        FLG2 <= 'U';

        TEST_STEP <= x"07";
        A       <= "0101";
        PENIO_N <= '1';
        wait for 1 ns;
        assert(ENABLE_N = '0') report "When address is C015; expect ENABLED LOW" severity error;
        assert(MD7 = '1') report "When address is C015; expect PENIO_N assigned to MD7 " severity error;
        PENIO_N <= 'U';

        TEST_STEP <= x"08";
        A        <= "0110";
        ALTSTKZP <= '1';
        wait for 1 ns;
        assert(ENABLE_N = '0') report "When address is C016; expect ENABLED LOW" severity error;
        assert(MD7 = '1') report "When address is C016; expect ALTSTKZP assigned to MD7 " severity error;
        ALTSTKZP <= 'U';

        TEST_STEP <= x"09";
        A         <= "0111";
        INTC300_N <= '1';
        wait for 1 ns;
        assert(ENABLE_N = '0') report "When address is C017; expect ENABLED LOW" severity error;
        assert(MD7 = '1') report "When address is C017; expect INTC300_N assigned to MD7 " severity error;
        INTC300_N <= 'U';

        TEST_STEP <= x"0A";
        A       <= "1000";
        EN80VID <= '1';
        wait for 1 ns;
        assert(ENABLE_N = '0') report "When address is C018; expect ENABLED LOW" severity error;
        assert(MD7 = '1') report "When address is C018; expect EN80VID assigned to MD7 " severity error;
        EN80VID <= 'U';


        TEST_STEP <= x"0B";
        A <= "1001";
        wait for 1 ns;
        assert(ENABLE_N = '1') report "When address is C019; expect ENABLE_N HIGH" severity error;

        TEST_STEP <= x"0C";
        A <= "1010";
        wait for 1 ns;
        assert(ENABLE_N = '1') report "When address is C01A; expect ENABLE_N HIGH" severity error;

        TEST_STEP <= x"0D";
        A <= "1011";
        wait for 1 ns;
        assert(ENABLE_N = '1') report "When address is C01B; expect ENABLE_N HIGH" severity error;

        TEST_STEP <= x"0E";
        A <= "1100";
        wait for 1 ns;
        assert(ENABLE_N = '1') report "When address is C01C; expect ENABLE_N HIGH" severity error;

        TEST_STEP <= x"0F";
        A <= "1101";
        wait for 1 ns;
        assert(ENABLE_N = '1') report "When address is C01D; expect ENABLE_N HIGH" severity error;

        TEST_STEP <= x"10";
        A <= "1110";
        wait for 1 ns;
        assert(ENABLE_N = '1') report "When address is C01E; expect ENABLE_N HIGH" severity error;

        TEST_STEP <= x"11";
        A <= "1111";
        wait for 1 ns;
        assert(ENABLE_N = '1') report "When address is C01F; expect ENABLE_N HIGH" severity error;

        TEST_STEP <= x"12";
        PHI_0  <= '0';
        Q3     <= '1';
        PRAS_N <= '1';
        A      <= "0001";
        wait for 1 ns;
        assert(ENABLE_N = '0') report "When address is C011 and Q3, PRAS_N HIGH and PHASE 1; expect ENABLE_N LOW" severity error;

        TEST_STEP <= x"13";
        PHI_0  <= '0';
        Q3     <= '0';
        PRAS_N <= '1';
        A      <= "0001";
        wait for 1 ns;
        assert(ENABLE_N = '1') report "When address is C011 and Q3 LOW, PRAS_N HIGH  and PHASE 1; expect ENABLE_N HIGH" severity error;

        TEST_STEP <= x"14";
        PHI_0  <= '0';
        Q3     <= '1';
        PRAS_N <= '0';
        A      <= "0001";
        wait for 1 ns;
        assert(ENABLE_N = '1') report "When address is C011 and Q3 HIGH, PRAS_N LOW  and PHASE 1; expect ENABLE_N HIGH" severity error;

        TEST_STEP <= x"15";
        PHI_0   <= '1';
        Q3      <= '1';
        PRAS_N  <= '1';
        RC01X_N <= '1';
        A       <= "0001";
        wait for 1 ns;
        assert(ENABLE_N = '1') report "When address is C011 and address is not C01X; expect ENABLE_N HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
