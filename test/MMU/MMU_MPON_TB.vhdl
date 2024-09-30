library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_MPON_TB is
    -- empty
end MMU_MPON_TB;
architecture TESTBENCH of MMU_MPON_TB is
    component MMU_MPON is
        port (
            A        : in std_logic_vector(15 downto 0);
            S_01XX_N : in std_logic;
            PHI_0    : in std_logic;
            Q3       : in std_logic;

            MPON_N : out std_logic
        );
    end component;

    signal A                   : std_logic_vector(15 downto 0);
    signal S_01XX_N, PHI_0, Q3 : std_logic;

    signal MPON_N : std_logic;
begin
    dut : MMU_MPON port map(
        A        => A,
        S_01XX_N => S_01XX_N,
        PHI_0    => PHI_0,
        Q3       => Q3,
        MPON_N   => MPON_N
    );

    process begin
        -- Triple access to 01XX followed by an access to FFFC_N on PHI_0 and Q3; expect MPON_N LOW
        PHI_0    <= '0';
        A        <= x"0000";
        S_01XX_N <= '0';
        Q3       <= '0';
        wait for 1 ns;

        PHI_0 <= '1';
        wait for 1 ns;
        PHI_0 <= '0';
        wait for 1 ns;

        PHI_0 <= '1';
        wait for 1 ns;
        PHI_0 <= '0';
        wait for 1 ns;

        PHI_0 <= '1';
        wait for 1 ns;
        PHI_0 <= '0';
        wait for 1 ns;

        A        <= x"FFFC";
        S_01XX_N <= '1';
        wait for 1 ns;

        assert(MPON_N = '0') report "Triple access to 01XX followed by an access to FFFC_N on PHI_0 and Q3; expect MPON_N LOW" severity error;

        A        <= x"0000";
        S_01XX_N <= '1';
        PHI_0    <= '1';
        wait for 1 ns;
        PHI_0 <= '0';
        wait for 1 ns;

        -- A different access pattern; expect MPON_N HIGH
        PHI_0    <= '0';
        A        <= x"0000";
        S_01XX_N <= '1';
        wait for 1 ns;

        PHI_0 <= '1';
        wait for 1 ns;
        PHI_0 <= '0';
        wait for 1 ns;

        PHI_0 <= '1';
        wait for 1 ns;
        PHI_0 <= '0';
        wait for 1 ns;

        PHI_0 <= '1';
        wait for 1 ns;
        PHI_0 <= '0';
        wait for 1 ns;

        A        <= x"ABCD";
        S_01XX_N <= '1';
        wait for 1 ns;

        assert(MPON_N = '1') report "A different access pattern; expect MPON_N HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
