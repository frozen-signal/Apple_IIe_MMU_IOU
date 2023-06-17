library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity MMU_MPON is
    port (
        A        : in std_logic_vector(15 downto 0);
        S_01XX_N : in std_logic;
        PHI_0    : in std_logic;
        Q3       : in std_logic;

        MPON_N : out std_logic
    );
end MMU_MPON;

architecture RTL of MMU_MPON is
    -- S5 stands for Soft 5, a 'soft' 5v. Comes from the Apple II.
    constant S5   : std_logic                     := '1'; -- Pull-up resistor see MMU_1 @B-4:A4-15
    constant FFFC : std_logic_vector(15 downto 0) := x"FFFC";

    component LS174_SINGLE is
        port (
            CLR_N : in std_logic;
            CLK   : in std_logic;
            D     : in std_logic;
            Q     : out std_logic;
            Q_N   : out std_logic
        );
    end component;

    signal FFFC_N                   : std_logic;
    signal M5_2, M5_7, DELTA_01XX_N : std_logic;
    signal P5_11, N4_11             : std_logic;
begin
    -- MMU2 @B-4 to B-2
    FFFC_N <= '0' when A = FFFC else '1';

    MMU1_LS174_1 : LS174_SINGLE port map(
        CLR_N => S5,
        CLK   => PHI_0,
        D     => S_01XX_N,
        Q     => M5_2,
        Q_N   => open
    );

    MMU1_LS174_2 : LS174_SINGLE port map(
        CLR_N => S5,
        CLK   => PHI_0,
        D     => M5_2,
        Q     => M5_7,
        Q_N   => open
    );

    P5_11 <= M5_2 or M5_7;

    MMU1_LS174_3 : LS174_SINGLE port map(
        CLR_N => S5,
        CLK   => PHI_0,
        D     => M5_7,
        Q     => DELTA_01XX_N,
        Q_N   => open
    );

    N4_11 <= DELTA_01XX_N or P5_11;

    MPON_N <= Q3 or PHI_0 or FFFC_N or N4_11;
end RTL;
