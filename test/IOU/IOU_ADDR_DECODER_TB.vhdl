library IEEE;
use IEEE.std_logic_1164.all;

entity IOU_ADDR_DECODER_TB is
    -- empty
end IOU_ADDR_DECODER_TB;

architecture IOU_ADDR_DECODER_TEST of IOU_ADDR_DECODER_TB is
    component IOU_ADDR_DECODER is
        port (
            C0XX_N : in std_logic;
            LA7    : in std_logic;
            LA4    : in std_logic;
            LA5    : in std_logic;
            A6     : in std_logic;
            Q3     : in std_logic;

            C00X_N : out std_logic;
            C01X_N : out std_logic;
            C02X_N : out std_logic;
            C03X_N : out std_logic;
            C04X_N : out std_logic;
            C05X_N : out std_logic;
            C07X_N : out std_logic
        );
    end component;

    signal C0XX_N : std_logic;
    signal LA7    : std_logic;
    signal LA4    : std_logic;
    signal LA5    : std_logic;
    signal A6     : std_logic;
    signal Q3     : std_logic;
    signal C00X_N : std_logic;
    signal C01X_N : std_logic;
    signal C02X_N : std_logic;
    signal C03X_N : std_logic;
    signal C04X_N : std_logic;
    signal C05X_N : std_logic;
    signal C07X_N : std_logic;

begin
    dut : IOU_ADDR_DECODER port map(
        C0XX_N => C0XX_N,
        LA7    => LA7,
        LA4    => LA4,
        LA5    => LA5,
        A6     => A6,
        Q3     => Q3,
        C00X_N => C00X_N,
        C01X_N => C01X_N,
        C02X_N => C02X_N,
        C03X_N => C03X_N,
        C04X_N => C04X_N,
        C05X_N => C05X_N,
        C07X_N => C07X_N
    );

    process
        variable ADDR : std_logic_vector(7 downto 0);
    begin
        C0XX_N <= '0';
        Q3     <= '0';

        ADDR := x"00";
        LA4 <= ADDR(4);
        LA5 <= ADDR(5);
        A6  <= ADDR(6);
        LA7 <= ADDR(7);
        wait for 1 ns;
        assert(C00X_N = '0') report "C00X_N should be LOW" severity error;
        assert(C01X_N = '1') report "C01X_N should be HIGH" severity error;
        assert(C02X_N = '1') report "C02X_N should be HIGH" severity error;
        assert(C03X_N = '1') report "C03X_N should be HIGH" severity error;
        assert(C04X_N = '1') report "C04X_N should be HIGH" severity error;
        assert(C05X_N = '1') report "C05X_N should be HIGH" severity error;
        assert(C07X_N = '1') report "C07X_N should be HIGH" severity error;

        ADDR := x"10";
        LA4 <= ADDR(4);
        LA5 <= ADDR(5);
        A6  <= ADDR(6);
        LA7 <= ADDR(7);
        wait for 1 ns;
        assert(C00X_N = '1') report "C00X_N should be HIGH" severity error;
        assert(C01X_N = '0') report "C01X_N should be LOW" severity error;
        assert(C02X_N = '1') report "C02X_N should be HIGH" severity error;
        assert(C03X_N = '1') report "C03X_N should be HIGH" severity error;
        assert(C04X_N = '1') report "C04X_N should be HIGH" severity error;
        assert(C05X_N = '1') report "C05X_N should be HIGH" severity error;
        assert(C07X_N = '1') report "C07X_N should be HIGH" severity error;

        ADDR := x"20";
        LA4 <= ADDR(4);
        LA5 <= ADDR(5);
        A6  <= ADDR(6);
        LA7 <= ADDR(7);
        wait for 1 ns;
        assert(C00X_N = '1') report "C00X_N should be HIGH" severity error;
        assert(C01X_N = '1') report "C01X_N should be HIGH" severity error;
        assert(C02X_N = '0') report "C02X_N should be LOW" severity error;
        assert(C03X_N = '1') report "C03X_N should be HIGH" severity error;
        assert(C04X_N = '1') report "C04X_N should be HIGH" severity error;
        assert(C05X_N = '1') report "C05X_N should be HIGH" severity error;
        assert(C07X_N = '1') report "C07X_N should be HIGH" severity error;

        ADDR := x"30";
        LA4 <= ADDR(4);
        LA5 <= ADDR(5);
        A6  <= ADDR(6);
        LA7 <= ADDR(7);
        wait for 1 ns;
        assert(C00X_N = '1') report "C00X_N should be HIGH" severity error;
        assert(C01X_N = '1') report "C01X_N should be HIGH" severity error;
        assert(C02X_N = '1') report "C02X_N should be HIGH" severity error;
        assert(C03X_N = '0') report "C03X_N should be LOW" severity error;
        assert(C04X_N = '1') report "C04X_N should be HIGH" severity error;
        assert(C05X_N = '1') report "C05X_N should be HIGH" severity error;
        assert(C07X_N = '1') report "C07X_N should be HIGH" severity error;

        ADDR := x"40";
        LA4 <= ADDR(4);
        LA5 <= ADDR(5);
        A6  <= ADDR(6);
        LA7 <= ADDR(7);
        wait for 1 ns;
        assert(C00X_N = '1') report "C00X_N should be HIGH" severity error;
        assert(C01X_N = '1') report "C01X_N should be HIGH" severity error;
        assert(C02X_N = '1') report "C02X_N should be HIGH" severity error;
        assert(C03X_N = '1') report "C03X_N should be HIGH" severity error;
        assert(C04X_N = '0') report "C04X_N should be LOW" severity error;
        assert(C05X_N = '1') report "C05X_N should be HIGH" severity error;
        assert(C07X_N = '1') report "C07X_N should be HIGH" severity error;

        ADDR := x"50";
        LA4 <= ADDR(4);
        LA5 <= ADDR(5);
        A6  <= ADDR(6);
        LA7 <= ADDR(7);
        wait for 1 ns;
        assert(C00X_N = '1') report "C00X_N should be HIGH" severity error;
        assert(C01X_N = '1') report "C01X_N should be HIGH" severity error;
        assert(C02X_N = '1') report "C02X_N should be HIGH" severity error;
        assert(C03X_N = '1') report "C03X_N should be HIGH" severity error;
        assert(C04X_N = '1') report "C04X_N should be HIGH" severity error;
        assert(C05X_N = '0') report "C05X_N should be LOW" severity error;
        assert(C07X_N = '1') report "C07X_N should be HIGH" severity error;

        ADDR := x"60";
        LA4 <= ADDR(4);
        LA5 <= ADDR(5);
        A6  <= ADDR(6);
        LA7 <= ADDR(7);
        wait for 1 ns;
        assert(C00X_N = '1') report "C00X_N should be HIGH" severity error;
        assert(C01X_N = '1') report "C01X_N should be HIGH" severity error;
        assert(C02X_N = '1') report "C02X_N should be HIGH" severity error;
        assert(C03X_N = '1') report "C03X_N should be HIGH" severity error;
        assert(C04X_N = '1') report "C04X_N should be HIGH" severity error;
        assert(C05X_N = '1') report "C05X_N should be HIGH" severity error;
        assert(C07X_N = '1') report "C07X_N should be HIGH" severity error;

        ADDR := x"70";
        LA4 <= ADDR(4);
        LA5 <= ADDR(5);
        A6  <= ADDR(6);
        LA7 <= ADDR(7);
        wait for 1 ns;
        assert(C00X_N = '1') report "C00X_N should be HIGH" severity error;
        assert(C01X_N = '1') report "C01X_N should be HIGH" severity error;
        assert(C02X_N = '1') report "C02X_N should be HIGH" severity error;
        assert(C03X_N = '1') report "C03X_N should be HIGH" severity error;
        assert(C04X_N = '1') report "C04X_N should be HIGH" severity error;
        assert(C05X_N = '1') report "C05X_N should be HIGH" severity error;
        assert(C07X_N = '0') report "C07X_N should be LOW" severity error;

        ADDR := x"80";
        LA4 <= ADDR(4);
        LA5 <= ADDR(5);
        A6  <= ADDR(6);
        LA7 <= ADDR(7);
        wait for 1 ns;
        assert(C00X_N = '1') report "C00X_N should be HIGH" severity error;
        assert(C01X_N = '1') report "C01X_N should be HIGH" severity error;
        assert(C02X_N = '1') report "C02X_N should be HIGH" severity error;
        assert(C03X_N = '1') report "C03X_N should be HIGH" severity error;
        assert(C04X_N = '1') report "C04X_N should be HIGH" severity error;
        assert(C05X_N = '1') report "C05X_N should be HIGH" severity error;
        assert(C07X_N = '1') report "C07X_N should be HIGH" severity error;

        Q3 <= '1';
        ADDR := x"00";
        LA4 <= ADDR(4);
        LA5 <= ADDR(5);
        A6  <= ADDR(6);
        LA7 <= ADDR(7);
        wait for 1 ns;
        assert(C00X_N = '1') report "C00X_N should be HIGH" severity error;
        assert(C01X_N = '1') report "C01X_N should be HIGH" severity error;
        assert(C02X_N = '1') report "C02X_N should be HIGH" severity error;
        assert(C03X_N = '1') report "C03X_N should be HIGH" severity error;
        assert(C04X_N = '1') report "C04X_N should be HIGH" severity error;
        assert(C05X_N = '1') report "C05X_N should be HIGH" severity error;
        assert(C07X_N = '1') report "C07X_N should be HIGH" severity error;

        Q3     <= '0';
        C0XX_N <= '1';
        ADDR := x"00";
        LA4 <= ADDR(4);
        LA5 <= ADDR(5);
        A6  <= ADDR(6);
        LA7 <= ADDR(7);
        wait for 1 ns;
        assert(C00X_N = '1') report "C00X_N should be HIGH" severity error;
        assert(C01X_N = '1') report "C01X_N should be HIGH" severity error;
        assert(C02X_N = '1') report "C02X_N should be HIGH" severity error;
        assert(C03X_N = '1') report "C03X_N should be HIGH" severity error;
        assert(C04X_N = '1') report "C04X_N should be HIGH" severity error;
        assert(C05X_N = '1') report "C05X_N should be HIGH" severity error;
        assert(C07X_N = '1') report "C07X_N should be HIGH" severity error;
        assert false report "Test done." severity note;
        wait;

    end process;
end IOU_ADDR_DECODER_TEST;
