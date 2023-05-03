library IEEE;
use IEEE.std_logic_1164.all;

entity DEV_DECODER_TB is
    -- empty
end DEV_DECODER_TB;
architecture DEV_DECODER_TEST of DEV_DECODER_TB is
    component DEV_DECODER is
        port (
            A       : in std_logic_vector(15 downto 0);
            PHI_1   : in std_logic;
            MC0XX_N : in std_logic;

            DEV0_N : out std_logic;
            DEV1_N : out std_logic;
            DEV2_N : out std_logic;
            DEV5_N : out std_logic;
            DEV6_N : out std_logic
        );
    end component;

    signal A : std_logic_vector(15 downto 0);
    signal PHI_1, MC0XX_N, DEV0_N, DEV1_N, DEV2_N, DEV5_N, DEV6_N : std_logic;

begin
    dut : DEV_DECODER port map(
        A       => A,
        PHI_1   => PHI_1,
        MC0XX_N => MC0XX_N,
        DEV0_N  => DEV0_N,
        DEV1_N  => DEV1_N,
        DEV2_N  => DEV2_N,
        DEV5_N  => DEV5_N,
        DEV6_N  => DEV6_N
    );

    process begin
        A(4)    <= 'X';
        A(5)    <= 'X';
        A(6)    <= 'X';
        A(7)    <= '0';
        MC0XX_N <= '0';
        PHI_1   <= '0';
        wait for 1 ns;
        assert(DEV0_N = '1') report "when A(7) LOW; expect DEV0_N HIGH" severity error;
        assert(DEV1_N = '1') report "when A(7) LOW; expect DEV1_N HIGH" severity error;
        assert(DEV2_N = '1') report "when A(7) LOW; expect DEV2_N HIGH" severity error;
        assert(DEV5_N = '1') report "when A(7) LOW; expect DEV5_N HIGH" severity error;
        assert(DEV6_N = '1') report "when A(7) LOW; expect DEV6_N HIGH" severity error;

        A(4)    <= 'X';
        A(5)    <= 'X';
        A(6)    <= 'X';
        A(7)    <= '1';
        MC0XX_N <= '1';
        PHI_1   <= '0';
        wait for 1 ns;
        assert(DEV0_N = '1') report "when PHI_1 LOW; expect DEV0_N HIGH" severity error;
        assert(DEV1_N = '1') report "when PHI_1 LOW; expect DEV1_N HIGH" severity error;
        assert(DEV2_N = '1') report "when PHI_1 LOW; expect DEV2_N HIGH" severity error;
        assert(DEV5_N = '1') report "when PHI_1 LOW; expect DEV5_N HIGH" severity error;
        assert(DEV6_N = '1') report "when PHI_1 LOW; expect DEV6_N HIGH" severity error;

        A(4)    <= 'X';
        A(5)    <= 'X';
        A(6)    <= 'X';
        A(7)    <= '1';
        MC0XX_N <= '0';
        PHI_1   <= '1';
        wait for 1 ns;
        assert(DEV0_N = '1') report "when MC0XX_N LOW; expect DEV0_N HIGH" severity error;
        assert(DEV1_N = '1') report "when MC0XX_N LOW; expect DEV1_N HIGH" severity error;
        assert(DEV2_N = '1') report "when MC0XX_N LOW; expect DEV2_N HIGH" severity error;
        assert(DEV5_N = '1') report "when MC0XX_N LOW; expect DEV5_N HIGH" severity error;
        assert(DEV6_N = '1') report "when MC0XX_N LOW; expect DEV6_N HIGH" severity error;

        A(4)    <= '0';
        A(5)    <= '0';
        A(6)    <= '0';
        A(7)    <= '1';
        MC0XX_N <= '0';
        PHI_1   <= '0';
        wait for 1 ns;
        assert(DEV0_N = '0') report "when A(6-5-4) = '000'; expect DEV0_N LOW" severity error;
        assert(DEV1_N = '1') report "when A(6-5-4) = '000'; expect DEV1_N HIGH" severity error;
        assert(DEV2_N = '1') report "when A(6-5-4) = '000'; expect DEV2_N HIGH" severity error;
        assert(DEV5_N = '1') report "when A(6-5-4) = '000'; expect DEV5_N HIGH" severity error;
        assert(DEV6_N = '1') report "when A(6-5-4) = '000'; expect DEV6_N HIGH" severity error;

        A(4)    <= '1';
        A(5)    <= '0';
        A(6)    <= '0';
        A(7)    <= '1';
        MC0XX_N <= '0';
        PHI_1   <= '0';
        wait for 1 ns;
        assert(DEV0_N = '1') report "when A(6-5-4) = '001'; expect DEV0_N HIGH" severity error;
        assert(DEV1_N = '0') report "when A(6-5-4) = '001'; expect DEV1_N LOW" severity error;
        assert(DEV2_N = '1') report "when A(6-5-4) = '001'; expect DEV2_N HIGH" severity error;
        assert(DEV5_N = '1') report "when A(6-5-4) = '001'; expect DEV5_N HIGH" severity error;
        assert(DEV6_N = '1') report "when A(6-5-4) = '001'; expect DEV6_N HIGH" severity error;

        A(4)    <= '0';
        A(5)    <= '1';
        A(6)    <= '0';
        A(7)    <= '1';
        MC0XX_N <= '0';
        PHI_1   <= '0';
        wait for 1 ns;
        assert(DEV0_N = '1') report "when A(6-5-4) = '010'; expect DEV0_N HIGH" severity error;
        assert(DEV1_N = '1') report "when A(6-5-4) = '010'; expect DEV1_N HIGH" severity error;
        assert(DEV2_N = '0') report "when A(6-5-4) = '010'; expect DEV2_N LOW" severity error;
        assert(DEV5_N = '1') report "when A(6-5-4) = '010'; expect DEV5_N HIGH" severity error;
        assert(DEV6_N = '1') report "when A(6-5-4) = '010'; expect DEV6_N HIGH" severity error;

        A(4)    <= '1';
        A(5)    <= '1';
        A(6)    <= '0';
        A(7)    <= '1';
        MC0XX_N <= '0';
        PHI_1   <= '0';
        wait for 1 ns;
        assert(DEV0_N = '1') report "when A(6-5-4) = '011'; expect DEV0_N HIGH" severity error;
        assert(DEV1_N = '1') report "when A(6-5-4) = '011'; expect DEV1_N HIGH" severity error;
        assert(DEV2_N = '1') report "when A(6-5-4) = '011'; expect DEV2_N HIGH" severity error;
        assert(DEV5_N = '1') report "when A(6-5-4) = '011'; expect DEV5_N HIGH" severity error;
        assert(DEV6_N = '1') report "when A(6-5-4) = '011'; expect DEV6_N HIGH" severity error;

        A(4)    <= '0';
        A(5)    <= '0';
        A(6)    <= '1';
        A(7)    <= '1';
        MC0XX_N <= '0';
        PHI_1   <= '0';
        wait for 1 ns;
        assert(DEV0_N = '1') report "when A(6-5-4) = '100'; expect DEV0_N HIGH" severity error;
        assert(DEV1_N = '1') report "when A(6-5-4) = '100'; expect DEV1_N HIGH" severity error;
        assert(DEV2_N = '1') report "when A(6-5-4) = '100'; expect DEV2_N HIGH" severity error;
        assert(DEV5_N = '1') report "when A(6-5-4) = '100'; expect DEV5_N HIGH" severity error;
        assert(DEV6_N = '1') report "when A(6-5-4) = '100'; expect DEV6_N HIGH" severity error;

        A(4)    <= '1';
        A(5)    <= '0';
        A(6)    <= '1';
        A(7)    <= '1';
        MC0XX_N <= '0';
        PHI_1   <= '0';
        wait for 1 ns;
        assert(DEV0_N = '1') report "when A(6-5-4) = '101'; expect DEV0_N HIGH" severity error;
        assert(DEV1_N = '1') report "when A(6-5-4) = '101'; expect DEV1_N HIGH" severity error;
        assert(DEV2_N = '1') report "when A(6-5-4) = '101'; expect DEV2_N HIGH" severity error;
        assert(DEV5_N = '0') report "when A(6-5-4) = '101'; expect DEV5_N LOW" severity error;
        assert(DEV6_N = '1') report "when A(6-5-4) = '101'; expect DEV6_N HIGH" severity error;

        A(4)    <= '0';
        A(5)    <= '1';
        A(6)    <= '1';
        A(7)    <= '1';
        MC0XX_N <= '0';
        PHI_1   <= '0';
        wait for 1 ns;
        assert(DEV0_N = '1') report "when A(6-5-4) = '110'; expect DEV0_N HIGH" severity error;
        assert(DEV1_N = '1') report "when A(6-5-4) = '110'; expect DEV1_N HIGH" severity error;
        assert(DEV2_N = '1') report "when A(6-5-4) = '110'; expect DEV2_N HIGH" severity error;
        assert(DEV5_N = '1') report "when A(6-5-4) = '110'; expect DEV5_N HIGH" severity error;
        assert(DEV6_N = '0') report "when A(6-5-4) = '110'; expect DEV6_N LOW" severity error;

        A(4)    <= '1';
        A(5)    <= '1';
        A(6)    <= '1';
        A(7)    <= '1';
        MC0XX_N <= '0';
        PHI_1   <= '0';
        wait for 1 ns;
        assert(DEV0_N = '1') report "when A(6-5-4) = '111'; expect DEV0_N HIGH" severity error;
        assert(DEV1_N = '1') report "when A(6-5-4) = '111'; expect DEV1_N HIGH" severity error;
        assert(DEV2_N = '1') report "when A(6-5-4) = '111'; expect DEV2_N HIGH" severity error;
        assert(DEV5_N = '1') report "when A(6-5-4) = '111'; expect DEV5_N HIGH" severity error;
        assert(DEV6_N = '1') report "when A(6-5-4) = '111'; expect DEV6_N HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end DEV_DECODER_TEST;
