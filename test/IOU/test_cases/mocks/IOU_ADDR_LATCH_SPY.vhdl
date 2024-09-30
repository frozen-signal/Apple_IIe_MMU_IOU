library IEEE;
use IEEE.std_logic_1164.all;
use work.IOU_TESTBENCH_PACKAGE.all;

entity IOU_ADDR_LATCH_SPY is
    port (
        P_PHI_2 : in std_logic;
        RA0, RA1, RA2, RA3,
        RA4, RA5, RA6 : in std_logic;

        LA0, LA1, LA2, LA3,
        LA4, LA5, LA7 : out std_logic
    );
end IOU_ADDR_LATCH_SPY;

architecture SPY of IOU_ADDR_LATCH_SPY is
    component IOU_ADDR_LATCH is
        port (
            P_PHI_2 : in std_logic;
            RA0, RA1, RA2, RA3,
            RA4, RA5, RA6 : in std_logic;

            LA0, LA1, LA2, LA3,
            LA4, LA5, LA7 : out std_logic
        );
    end component;

    signal LA0_INT, LA1_INT, LA2_INT, LA3_INT, LA4_INT, LA5_INT, LA7_INT : std_logic;
begin
    U_IOU_ADDR_LATCH : IOU_ADDR_LATCH port map(
        P_PHI_2 => P_PHI_2,
        RA0     => RA0,
        RA1     => RA1,
        RA2     => RA2,
        RA3     => RA3,
        RA4     => RA4,
        RA5     => RA5,
        RA6     => RA6,
        LA0     => LA0_INT,
        LA1     => LA1_INT,
        LA2     => LA2_INT,
        LA3     => LA3_INT,
        LA4     => LA4_INT,
        LA5     => LA5_INT,
        LA7     => LA7_INT
    );

    TB_LA0 <= LA0_INT;
    TB_LA1 <= LA1_INT;
    TB_LA2 <= LA2_INT;
    TB_LA3 <= LA3_INT;
    TB_LA4 <= LA4_INT;
    TB_LA5 <= LA5_INT;
    TB_LA7 <= LA7_INT;

    LA0 <= LA0_INT;
    LA1 <= LA1_INT;
    LA2 <= LA2_INT;
    LA3 <= LA3_INT;
    LA4 <= LA4_INT;
    LA5 <= LA5_INT;
    LA7 <= LA7_INT;

end SPY;
