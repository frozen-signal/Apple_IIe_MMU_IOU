library IEEE;
use IEEE.std_logic_1164.all;
use work.IOU_TESTBENCH_PACKAGE.all;

entity VIDEO_ADDR_LATCH_SPY is
    port (
        P_PHI_2 : in std_logic;
        RA0, RA1, RA2, RA3,
        RA4, RA5, RA6 : in std_logic;

        LA0, LA1, LA2, LA3,
        LA4, LA5, LA7 : out std_logic
    );
end VIDEO_ADDR_LATCH_SPY;

architecture SPY of VIDEO_ADDR_LATCH_SPY is
    component VIDEO_ADDR_LATCH is
        port (
            P_PHI_2 : in std_logic;
            RA0, RA1, RA2, RA3,
            RA4, RA5, RA6 : in std_logic;

            LA0, LA1, LA2, LA3,
            LA4, LA5, LA7 : out std_logic
        );
    end component;

begin
    U_VIDEO_ADDR_LATCH : VIDEO_ADDR_LATCH port map(
        P_PHI_2 => P_PHI_2,
        RA0     => RA0,
        RA1     => RA1,
        RA2     => RA2,
        RA3     => RA3,
        RA4     => RA4,
        RA5     => RA5,
        RA6     => RA6,
        LA0     => LA0,
        LA1     => LA1,
        LA2     => LA2,
        LA3     => LA3,
        LA4     => LA4,
        LA5     => LA5,
        LA7     => LA7
    );

    TB_LA0 <= LA0;
    TB_LA1 <= LA1;
    TB_LA2 <= LA2;
    TB_LA3 <= LA3;
    TB_LA4 <= LA4;
    TB_LA5 <= LA5;
    TB_LA7 <= LA7;

end SPY;
