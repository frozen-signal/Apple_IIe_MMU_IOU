library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_RA_TB is
    -- empty
end MMU_RA_TB;
architecture MMU_RA_TEST of MMU_RA_TB is
    component MMU_RA is
        port (
            A         : in std_logic_vector(15 downto 0);
            PRAS_N    : in std_logic;
            RAS_N     : in std_logic;
            P_PHI_0   : in std_logic;
            Q3_PRAS_N : in std_logic;
            DXXX_N    : in std_logic;
            BANK1     : in std_logic;

            RA       : out std_logic_vector(7 downto 0);
            RA_ENABLE_N : out std_logic
        );
    end component;

    signal A         : std_logic_vector(15 downto 0);
    signal PRAS_N    : std_logic;
    signal P_PHI_0   : std_logic;
    signal Q3_PRAS_N : std_logic;
    signal DXXX_N    : std_logic;
    signal BANK1     : std_logic;
    signal RA        : std_logic_vector(7 downto 0);
    signal RA_ENABLE_N  : std_logic;

begin
    dut : MMU_RA port map(
        A         => A,
        PRAS_N    => PRAS_N,
        RAS_N     => PRAS_N, -- We don't test the ROW hold time; we simply use PRAS_N without the delay
        P_PHI_0   => P_PHI_0,
        Q3_PRAS_N => Q3_PRAS_N,
        DXXX_N    => DXXX_N,
        BANK1     => BANK1,
        RA        => RA,
        RA_ENABLE_N  => RA_ENABLE_N
    );

    process begin
        P_PHI_0   <= '1';
        Q3_PRAS_N <= '1';
        wait for 1 ns;
        assert(RA_ENABLE_N = '0') report "When P_PHI_0 and Q3_PRAS_N are HIGH; expect ENABLE LOW" severity error;

        P_PHI_0   <= '0';
        Q3_PRAS_N <= '1';
        wait for 1 ns;
        assert(RA_ENABLE_N = '1') report "When P_PHI_0 is LOW and Q3_PRAS_N is HIGH; expect ENABLE HIGH" severity error;

        P_PHI_0   <= '1';
        Q3_PRAS_N <= '0';
        wait for 1 ns;
        assert(RA_ENABLE_N = '1') report "When P_PHI_0 is HIGH and Q3_PRAS_N is LOW; expect ENABLE HIGH" severity error;

        P_PHI_0   <= '0';
        Q3_PRAS_N <= '0';
        wait for 1 ns;
        assert(RA_ENABLE_N = '1') report "When P_PHI_0 and Q3_PRAS_N LOW; expect ENABLE HIGH" severity error;

        A     <= "XXXXXXX00X000000";
        PRAS_N <= '1';
        wait for 1 ns;
        assert(RA = "00000000") report "When PRAS_N HIGH; expect B branch of the LS257 to be selected" severity error;

        A      <= "010X000XX1XXXXXX";
        PRAS_N  <= '0';
        DXXX_N <= '0';
        BANK1  <= '0';
        A(12)  <= '0';
        wait for 1 ns;
        assert(RA = "01000010") report "When PRAS_N LOW; expect A branch of the LS257 to be selected" severity error;

        A      <= "XXXXXXXXXXXXXXXX";
        PRAS_N  <= '0';
        DXXX_N <= '1';
        BANK1  <= '0';
        A(12)  <= '0';
        wait for 1 ns;
        assert(RA(4) = '0') report "When DXXX_N HIGH, BANK1 and A(12) LOW; expect MA12 LOW" severity error;

        A      <= "XXXXXXXXXXXXXXXX";
        PRAS_N  <= '0';
        DXXX_N <= '0';
        BANK1  <= '1';
        A(12)  <= '0';
        wait for 1 ns;
        assert(RA(4) = '1') report "When DXXX_N LOW, BANK1 HIGH, and A(12) LOW; expect MA12 HIGH" severity error;

        A      <= "XXXXXXXXXXXXXXXX";
        PRAS_N  <= '0';
        DXXX_N <= '0';
        BANK1  <= '0';
        A(12)  <= '1';
        wait for 1 ns;
        assert(RA(4) = '1') report "When DXXX_N, BANK1 LOW, and A(12) HIGH; expect MA12 HIGH" severity error;

        A      <= x"D123";
        BANK1  <= '0';
        DXXX_N <= '0';
        PRAS_N  <= '1';
        wait for 1 ns;
        assert(RA(0) = A(0)) report "expect RA(0) equals A(0)" severity error;
        assert(RA(1) = A(1)) report "expect RA(1) equals A(1)" severity error;
        assert(RA(2) = A(2)) report "expect RA(2) equals A(2)" severity error;
        assert(RA(3) = A(3)) report "expect RA(3) equals A(3)" severity error;
        assert(RA(4) = A(4)) report "expect RA(4) equals A(4)" severity error;
        assert(RA(5) = A(5)) report "expect RA(5) equals A(5)" severity error;
        assert(RA(6) = A(7)) report "expect RA(6) equals A(7)" severity error;
        assert(RA(7) = A(8)) report "expect RA(7) equals A(8)" severity error;

        A      <= x"D123";
        BANK1  <= '0';
        DXXX_N <= '0';
        PRAS_N  <= '0';
        wait for 1 ns;
        assert(RA(0) = A(9)) report "expect RA(0) equals A(9)" severity error;
        assert(RA(1) = A(6)) report "expect RA(1) equals A(6)" severity error;
        assert(RA(2) = A(10)) report "expect RA(2) equals A(10)" severity error;
        assert(RA(3) = A(11)) report "expect RA(3) equals A(11)" severity error;
        assert(RA(4) = (((not DXXX_N) nand BANK1) and A(12))) report "expect RA(4) equals (((not DXXX_N) nand BANK1) and A(12))" severity error;
        assert(RA(5) = A(13)) report "expect RA(5) equals A(13)" severity error;
        assert(RA(6) = A(14)) report "expect RA(6) equals A(14)" severity error;
        assert(RA(7) = A(15)) report "expect RA(7) equals A(15)" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end MMU_RA_TEST;
