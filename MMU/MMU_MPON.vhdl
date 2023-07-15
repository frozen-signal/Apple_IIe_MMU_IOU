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

    signal FFFC_N                   : std_logic;
    signal M5_2, M5_7, DELTA_01XX_N : std_logic;
    signal P5_11, N4_11             : std_logic;
begin
    -- MMU_2 @B-4:H2-9
    FFFC_N <= '0' when A = FFFC else '1';

    -- MMU_2 @B-3:M5-2
    process (PHI_0)
    begin
        if (rising_edge(PHI_0)) then
            M5_2   <= S_01XX_N;
        end if;
    end process;

    -- MMU_2 @B-3:M5-7
    process (PHI_0)
    begin
        if (rising_edge(PHI_0)) then
            M5_7  <= M5_2;
        end if;
    end process;

    -- MMU_2 @B-3
    P5_11 <= M5_2 or M5_7;

    -- MMU_2 @B-3:M5-15
    process (PHI_0)
    begin
        if (rising_edge(PHI_0)) then
            DELTA_01XX_N  <= M5_7;
        end if;
    end process;

    N4_11 <= DELTA_01XX_N or P5_11;

    MPON_N <= Q3 or PHI_0 or FFFC_N or N4_11;
end RTL;
