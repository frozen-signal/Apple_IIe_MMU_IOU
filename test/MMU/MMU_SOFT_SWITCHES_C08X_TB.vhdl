library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_SOFT_SWITCHES_C08X_TB is
    -- empty
end MMU_SOFT_SWITCHES_C08X_TB;

architecture MMU_SOFT_SWITCHES_C08X_TEST of MMU_SOFT_SWITCHES_C08X_TB is
    component MMU_SOFT_SWITCHES_C08X is
        port (
            MPON_N     : in std_logic;
            A0, A1, A3 : in std_logic;
            DEV0_N     : in std_logic;
            R_W_N      : in std_logic;
            IN_FST_ACC : in std_logic;
            IN_WREN    : in std_logic;

            BANK1, BANK2     : out std_logic;
            RDRAM, RDROM     : out std_logic;
            OUT_FST_ACC      : out std_logic;
            WRPROT, OUT_WREN : out std_logic
        );
    end component;

    signal MPON_N, A0, A1, A3, DEV0_N, R_W_N, IN_FST_ACC, IN_WREN, BANK1, BANK2, RDRAM, RDROM, OUT_FST_ACC, WRPROT, OUT_WREN : std_logic;
    signal TEST_STEP : std_logic_vector(7 downto 0);
begin
    dut : MMU_SOFT_SWITCHES_C08X port map(
        MPON_N      => MPON_N,
        A0          => A0,
        A1          => A1,
        A3          => A3,
        DEV0_N      => DEV0_N,
        R_W_N       => R_W_N,
        IN_FST_ACC  => IN_FST_ACC,
        IN_WREN     => IN_WREN,
        BANK1       => BANK1,
        BANK2       => BANK2,
        RDRAM       => RDRAM,
        RDROM       => RDROM,
        OUT_FST_ACC => OUT_FST_ACC,
        WRPROT      => WRPROT,
        OUT_WREN    => OUT_WREN
    );

    process begin
        TEST_STEP  <= x"00";
        A0         <= 'X';
        A1         <= 'X';
        A3         <= 'X';
        DEV0_N     <= '0';
        R_W_N      <= 'X';
        IN_FST_ACC <= 'X';
        IN_WREN    <= 'X';
        wait for 1 ns;

        TEST_STEP <= x"01";
        MPON_N    <= '0';
        wait for 1 ns;
        assert(BANK1 = '0') report "expect BANK1 LOW" severity error;
        assert(BANK2 = '1') report "expect BANK2 HIGH" severity error;
        assert(RDRAM = '0') report "expect RDRAM LOW" severity error;
        assert(RDROM = '1') report "expect RDROM HIGH" severity error;
        assert(OUT_FST_ACC = '0') report "expect OUT_FST_ACC LOW" severity error;
        assert(WRPROT = '0') report "expect WRPROT LOW" severity error;
        assert(OUT_WREN = '1') report "expect OUT_WREN HIGH" severity error;

        -- Change D without DEV0_N change; should not change Q/Q'
        TEST_STEP  <= x"02";
        MPON_N     <= '1';
        A3         <= '1';
        A0         <= '1';
        A1         <= '1';
        R_W_N      <= '1';
        IN_FST_ACC <= '0';
        IN_WREN    <= '0';
        wait for 1 ns;
        assert(BANK1 = '0') report "expect BANK1 LOW" severity error;
        assert(BANK2 = '1') report "expect BANK2 HIGH" severity error;
        assert(RDRAM = '0') report "expect RDRAM LOW" severity error;
        assert(RDROM = '1') report "expect RDROM HIGH" severity error;
        assert(OUT_FST_ACC = '0') report "expect OUT_FST_ACC LOW" severity error;
        assert(WRPROT = '0') report "expect WRPROT LOW" severity error;
        assert(OUT_WREN = '1') report "expect OUT_WREN HIGH" severity error;

        DEV0_N <= '1';
        wait for 1 ns;

        -- On CLK raising edge; should change Q/Q'
        TEST_STEP <= x"03";
        DEV0_N    <= '0';
        wait for 1 ns;
        assert(BANK1 = '1') report "expect BANK1 HIGH" severity error;
        assert(BANK2 = '0') report "expect BANK2 LOW" severity error;
        assert(RDRAM = '1') report "expect RDRAM HIGH" severity error;
        assert(RDROM = '0') report "expect RDROM LOW" severity error;
        assert(OUT_FST_ACC = '1') report "expect OUT_FST_ACC HIGH" severity error;
        assert(WRPROT = '1') report "expect WRPROT HIGH" severity error;
        assert(OUT_WREN = '0') report "expect OUT_WREN LOW" severity error;

        DEV0_N <= '1';
        wait for 1 ns;

        -- Access to C088-C08F; should activate BANK1
        TEST_STEP <= x"04";
        A3        <= '1';
        wait for 1 ns;
        DEV0_N <= '1';
        wait for 1 ns;
        assert(BANK1 = '1') report "Access to C088-C08F; should set BANK1" severity error;
        assert(BANK2 = '0') report "Access to C088-C08F; should reset BANK2" severity error;

        DEV0_N <= '1';
        wait for 1 ns;

        -- Access to C080-C087; should activate BANK1
        TEST_STEP <= x"05";
        A3        <= '0';
        wait for 1 ns;
        DEV0_N <= '0';
        wait for 1 ns;
        assert(BANK1 = '0') report "Access to C080-C087; should reset BANK1" severity error;
        assert(BANK2 = '1') report "Access to C080-C087; should set BANK2" severity error;

        DEV0_N <= '1';
        wait for 1 ns;

        -- Access to C080; should activate RDRAM
        TEST_STEP <= x"06";
        A0        <= '0';
        A1        <= '0';
        wait for 1 ns;
        DEV0_N <= '0';
        wait for 1 ns;
        wait for 1 ns;
        assert(RDRAM = '1') report "Access to C080; should set RDRAM" severity error;
        assert(RDROM = '0') report "Access to C080; should reset RDROM" severity error;

        DEV0_N <= '1';
        wait for 1 ns;

        -- Access to C081; should activate RDROM
        TEST_STEP <= x"07";
        A0        <= '1';
        A1        <= '0';
        wait for 1 ns;
        DEV0_N <= '0';
        wait for 1 ns;
        assert(RDRAM = '0') report "Access to C081; should reset RDRAM" severity error;
        assert(RDROM = '1') report "Access to C081; should set RDROM" severity error;

        DEV0_N <= '1';
        wait for 1 ns;

        -- Access to C082; should activate RDROM
        TEST_STEP <= x"08";
        A0        <= '0';
        A1        <= '1';
        wait for 1 ns;
        DEV0_N <= '0';
        wait for 1 ns;
        assert(RDRAM = '0') report "Access to C082; should set RDRAM" severity error;
        assert(RDROM = '1') report "Access to C082; should reset RDROM" severity error;

        DEV0_N <= '1';
        wait for 1 ns;

        -- Access to C083; should activate RDRAM
        TEST_STEP <= x"09";
        A0        <= '1';
        A1        <= '1';
        wait for 1 ns;
        DEV0_N <= '0';
        wait for 1 ns;
        assert(RDRAM = '1') report "Access to C083; should reset RDRAM" severity error;
        assert(RDROM = '0') report "Access to C083; should set RDROM" severity error;

        DEV0_N <= '1';
        wait for 1 ns;

        -- Read even address; should reset FST_ACC
        TEST_STEP <= x"0A";
        A0        <= '0';
        wait for 1 ns;
        DEV0_N <= '0';
        wait for 1 ns;
        assert(OUT_FST_ACC = '0') report "Read even address; should reset OUT_FST_ACC" severity error;

        DEV0_N <= '1';
        wait for 1 ns;

        -- Read odd address; should set FST_ACC
        TEST_STEP <= x"0B";
        A0        <= '1';
        wait for 1 ns;
        DEV0_N <= '0';
        wait for 1 ns;
        assert(OUT_FST_ACC = '1') report "Read even address; should set OUT_FST_ACC" severity error;

        DEV0_N <= '1';
        wait for 1 ns;

        -- Read odd address and FST_ACC set; should reset WRPROT, set WREN
        TEST_STEP  <= x"0C";
        A0         <= '1';
        R_W_N      <= '1';
        IN_FST_ACC <= '1';
        wait for 1 ns;
        DEV0_N <= '0';
        wait for 1 ns;
        assert(WRPROT = '0') report "Read odd address and FST_ACC set; should reset WRPROT" severity error;
        assert(OUT_WREN = '1') report "Read odd address and FST_ACC set; should set OUT_WREN" severity error;

        DEV0_N <= '1';
        wait for 1 ns;

        -- Write odd address and FST_ACC set, WREN not set; should set WRPROT, reset WREN
        TEST_STEP  <= x"0D";
        A0         <= '1';
        R_W_N      <= '0';
        IN_FST_ACC <= '1';
        IN_WREN    <= '0';
        wait for 1 ns;
        DEV0_N <= '0';
        wait for 1 ns;
        assert(WRPROT = '1') report "Write odd address and FST_ACC set; should set WRPROT" severity error;
        assert(OUT_WREN = '0') report "Write odd address and FST_ACC set; should reset OUT_WREN" severity error;

        DEV0_N <= '1';
        wait for 1 ns;

        -- Read even address and FST_ACC set, WREN not set; should set WRPROT, reset WREN
        TEST_STEP  <= x"0E";
        A0         <= '0';
        R_W_N      <= '1';
        IN_FST_ACC <= '1';
        IN_WREN    <= '0';
        wait for 1 ns;
        DEV0_N <= '0';
        wait for 1 ns;
        assert(WRPROT = '1') report "Read even address and FST_ACC set; should set WRPROT" severity error;
        assert(OUT_WREN = '0') report "Read even address and FST_ACC set; should reset OUT_WREN" severity error;

        DEV0_N <= '1';
        wait for 1 ns;

        -- Read odd address and FST_ACC not set, WREN not set; should set WRPROT, reset WREN
        TEST_STEP  <= x"0F";
        A0         <= '1';
        R_W_N      <= '1';
        IN_FST_ACC <= '0';
        IN_WREN    <= '0';
        wait for 1 ns;
        DEV0_N <= '0';
        wait for 1 ns;
        assert(WRPROT = '1') report "Read odd address and FST_ACC not set, WREN not set; should set WRPROT" severity error;
        assert(OUT_WREN = '0') report "Read odd address and FST_ACC not set, WREN not set; should reset OUT_WREN" severity error;

        DEV0_N <= '1';
        wait for 1 ns;

        -- Write odd address, WREN set; should reset WRPROT, set WREN
        TEST_STEP <= x"10";
        A0        <= '1';
        R_W_N     <= '0';
        IN_WREN   <= '1';
        wait for 1 ns;
        DEV0_N <= '0';
        wait for 1 ns;
        assert(WRPROT = '0') report "Write odd address, WREN set; should reset WRPROT" severity error;
        assert(OUT_WREN = '1') report "Write odd address, WREN set; should set OUT_WREN" severity error;

        DEV0_N <= '1';
        wait for 1 ns;

        assert false report "Test done." severity note;
        wait;

    end process;
end MMU_SOFT_SWITCHES_C08X_TEST;
