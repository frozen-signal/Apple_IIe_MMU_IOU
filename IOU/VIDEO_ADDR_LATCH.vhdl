library IEEE;
use IEEE.std_logic_1164.all;

entity VIDEO_ADDR_LATCH is
    port (
        P_PHI_2 : in std_logic;
        RA0, RA1, RA2, RA3,
        RA4, RA5, RA6 : in std_logic;

        LA0, LA1, LA2, LA3,
        LA4, LA5, LA7 : out std_logic
    );
end VIDEO_ADDR_LATCH;

architecture RTL of VIDEO_ADDR_LATCH is
begin
    -- IOU_1 @C-3:F5
    process (P_PHI_2, RA0, RA1, RA2, RA3, RA4, RA5, RA6)
    begin
        if (P_PHI_2 = '1') then
            LA0 <= RA0;
            LA1 <= RA1;
            LA2 <= RA2;
            LA3 <= RA3;
            LA4 <= RA4;
            LA5 <= RA5;
            LA7 <= RA6; -- Note: this is not a mistake; There is no LA6 and LA7 is latched from RA6.
        end if;
    end process;
end RTL;
