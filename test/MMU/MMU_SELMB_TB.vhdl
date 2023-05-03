library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_SELMB_TB is
    -- empty
end MMU_SELMB_TB;
architecture MMU_SELMB_TEST of MMU_SELMB_TB is
    component MMU_SELMB is
        port (
            A15, A14,
            A13, A10    : in std_logic;
            HIRES       : in std_logic;
            PHI_0_7XX   : in std_logic;
            EN80VID     : in std_logic;
            PG2         : in std_logic;
            FLG1        : in std_logic;
            FLG2        : in std_logic;
            R_W_N       : in std_logic;
            ALTSTKZP    : in std_logic;
            D_FXXX      : in std_logic;
            PHI_0_1XX_N : in std_logic;

            SELMB_N : out std_logic
        );
    end component;

    signal A15, A14, A13, A10 : std_logic;
    signal HIRES              : std_logic;
    signal PHI_0_7XX          : std_logic;
    signal EN80VID            : std_logic;
    signal PG2                : std_logic;
    signal FLG1               : std_logic;
    signal FLG2               : std_logic;
    signal R_W_N              : std_logic;
    signal ALTSTKZP           : std_logic;
    signal D_FXXX             : std_logic;
    signal PHI_0_1XX_N        : std_logic;
    signal SELMB_N            : std_logic;

begin
    dut : MMU_SELMB port map(
        A15         => A15,
        A14         => A14,
        A13         => A13,
        A10         => A10,
        HIRES       => HIRES,
        PHI_0_7XX   => PHI_0_7XX,
        EN80VID     => EN80VID,
        PG2         => PG2,
        FLG1        => FLG1,
        FLG2        => FLG2,
        R_W_N       => R_W_N,
        ALTSTKZP    => ALTSTKZP,
        D_FXXX      => D_FXXX,
        PHI_0_1XX_N => PHI_0_1XX_N,
        SELMB_N     => SELMB_N
    );

    process begin
        A15         <= '0';
        A14         <= '0';
        A13         <= '0';
        A10         <= '0';
        HIRES       <= '0';
        PHI_0_7XX   <= '0';
        EN80VID     <= '0';
        PG2         <= '0';
        FLG1        <= '0';
        FLG2        <= '0';
        R_W_N       <= '0';
        ALTSTKZP    <= '0';
        D_FXXX      <= '0';
        PHI_0_1XX_N <= '0';
        wait for 1 ns;
        assert(SELMB_N = '0') report "expect SELMB_N LOW" severity error;

        ALTSTKZP <= '1';
        wait for 1 ns;
        assert(SELMB_N = '1') report "expect SELMB_N HIGH" severity error;

        ALTSTKZP    <= '0';
        PHI_0_1XX_N <= '1';
        wait for 1 ns;
        assert(SELMB_N = '0') report "expect SELMB_N LOW" severity error;

        FLG2 <= '1';
        wait for 1 ns;
        assert(SELMB_N = '1') report "expect SELMB_N HIGH" severity error;

        FLG1  <= '1';
        FLG2  <= '0';
        R_W_N <= '1';
        wait for 1 ns;
        assert(SELMB_N = '1') report "expect SELMB_N HIGH" severity error;

        FLG1      <= '0';
        FLG2      <= '0';
        R_W_N     <= '0';
        A10       <= '1';
        PHI_0_7XX <= '1';
        wait for 1 ns;
        assert(SELMB_N = '0') report "expect SELMB_N LOW" severity error;

        EN80VID <= '1';
        PG2     <= '1';
        wait for 1 ns;
        assert(SELMB_N = '1') report "expect SELMB_N HIGH" severity error;

        A10       <= '0';
        PHI_0_7XX <= '0';
        A15       <= '0';
        A13       <= '1';
        wait for 1 ns;
        assert(SELMB_N = '0') report "expect SELMB_N LOW" severity error;

        HIRES <= '1';
        wait for 1 ns;
        assert(SELMB_N = '1') report "expect SELMB_N HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end MMU_SELMB_TEST;
