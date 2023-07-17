library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity VIDEO_SCANNER is
    port (
        POC_N   : in std_logic;
        NTSC    : in std_logic;
        P_PHI_2 : in std_logic;

        HPE_N                  : out std_logic;
        V5, V4, V3, V2, V1, V0 : out std_logic;
        VC, VB, VA             : out std_logic;
        H5, H4, H3, H2, H1, H0 : out std_logic;
        PAKST                  : out std_logic;
        TC                     : out std_logic;
        TC14S                  : out std_logic;
        FLASH                  : out std_logic
    );
end VIDEO_SCANNER;

-- The VIDEO_SCANNER is the LS161 column on IOU_1, from A-4 to D-4. The rest of the MMU / IOU generally
-- tries to keep close to the emulator schematics, but this is an exception. The implementation below is
-- more efficient and simpler than 6x LS161s chained with a ripple carry overflow.
architecture RTL of VIDEO_SCANNER is
    signal counters : unsigned(23 downto 0); -- It's safe if we don't initialize counters: at power-up POC_N is LOW
                                             --    and will initialize the signal.

    signal HPE_N_INT, VA_INT, TC_INT : std_logic;
begin
    process (P_PHI_2, POC_N)
    begin
        if (POC_N = '0') then
            counters <= "111111110000000000000000";
        elsif (rising_edge(P_PHI_2)) then
            if (HPE_N_INT = '0') then
                counters(6 downto 0) <= "1000000";
                counters(7)          <= VA_INT;
            else
                counters <= counters + 1;
            end if;

            if (TC_INT = '1') then
                counters(8)  <= NTSC;
                counters(9)  <= '0';
                counters(10) <= '1';
                counters(11) <= NTSC;
                counters(12) <= NTSC;
                counters(13) <= '1';
                counters(14) <= '1';
                counters(15) <= '0';
            end if;
        end if;

    end process;

    H0        <= counters(0);
    H1        <= counters(1);
    H2        <= counters(2);
    H3        <= counters(3);
    H4        <= counters(4);
    H5        <= counters(5);
    HPE_N_INT <= counters(6);
    VA_INT    <= counters(7);
    VB        <= counters(8);
    VC        <= counters(9);
    V0        <= counters(10);
    V1        <= counters(11);
    V2        <= counters(12);
    V3        <= counters(13);
    V4        <= counters(14);
    V5        <= counters(15);
    PAKST     <= counters(17);
    FLASH     <= counters(20);

    TC_INT <= '1' when POC_N = '1' and counters(15 downto 0) = "1111111111111111" else '0';
    TC14S  <= '1' when POC_N = '1' and counters(19 downto 0) = "11111111111111111111" else '0';

    HPE_N <= HPE_N_INT;
    VA    <= VA_INT;
    TC    <= TC_INT;
end RTL;
