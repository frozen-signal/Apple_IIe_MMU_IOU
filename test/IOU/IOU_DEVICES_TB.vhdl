library IEEE;
use IEEE.std_logic_1164.all;

entity IOU_DEVICES_TB is
    -- empty
end IOU_DEVICES_TB;

architecture IOU_DEVICES_TEST of IOU_DEVICES_TB is
    component IOU_DEVICES is
        port (
            POC_N  : in std_logic;
            C02X_N : in std_logic;
            C03X_N : in std_logic;

            SPKR  : out std_logic;
            CASSO : out std_logic
        );
    end component;

    signal POC_N  : std_logic;
    signal C02X_N : std_logic;
    signal C03X_N : std_logic;
    signal SPKR   : std_logic;
    signal CASSO  : std_logic;

begin
    dut : IOU_DEVICES port map(
        POC_N  => POC_N,
        C02X_N => C02X_N,
        C03X_N => C03X_N,
        SPKR   => SPKR,
        CASSO  => CASSO
    );

    process begin
        -- Power On ---------------------------------------
        POC_N  <= '0';
        C02X_N <= '0';
        wait for 1 ns;
        C02X_N <= '1';
        wait for 1 ns;
        assert(CASSO = '0') report "CASSO should not change during power on" severity error;

        C03X_N <= '0';
        wait for 1 ns;
        C03X_N <= '1';
        wait for 1 ns;
        assert(SPKR = '0') report "SPKR should not change during power on" severity error;

        POC_N <= '1';

        -- Speaker ----------------------------------------
        C03X_N <= '0';
        wait for 1 ns;
        C03X_N <= '1';
        wait for 1 ns;
        assert(SPKR = '1') report "expect SPKR to be HIGH" severity error;

        C03X_N <= '0';
        wait for 1 ns;
        C03X_N <= '1';
        wait for 1 ns;
        assert(SPKR = '0') report "expect SPKR to be LOW" severity error;

        -- Cassette ---------------------------------------
        C02X_N <= '0';
        wait for 1 ns;
        C02X_N <= '1';
        wait for 1 ns;
        assert(CASSO = '1') report "expect CASSO to be HIGH" severity error;

        C02X_N <= '0';
        wait for 1 ns;
        C02X_N <= '1';
        wait for 1 ns;
        assert(CASSO = '0') report "expect CASSO to be LOW" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end IOU_DEVICES_TEST;
