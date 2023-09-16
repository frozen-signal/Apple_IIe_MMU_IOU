library IEEE;
use IEEE.std_logic_1164.all;
use work.IOU_TESTBENCH_PACKAGE.all;

entity VIDEO_ADDR_MUX_SPY is
    port (
        PHI_1          : in std_logic;
        Q3             : in std_logic;
        PG2_N          : in std_logic;
        EN80VID        : in std_logic;
        HIRESEN_N      : in std_logic;
        VA, VB, VC     : in std_logic;
        RAS_N          : in std_logic;
        V0, V1, V2     : in std_logic;
        H0, H1, H2     : in std_logic;
        E0, E1, E2, E3 : in std_logic;

        RA_ENABLE_N        : out std_logic;
        RA0, RA1, RA2, RA3,
        RA4, RA5, RA6, RA7 : out std_logic
    );
end VIDEO_ADDR_MUX_SPY;

architecture SPY of VIDEO_ADDR_MUX_SPY is
    component VIDEO_ADDR_MUX is
        port (
            PHI_1          : in std_logic;
            Q3             : in std_logic;
            PG2_N          : in std_logic;
            EN80VID        : in std_logic;
            HIRESEN_N      : in std_logic;
            VA, VB, VC     : in std_logic;
            RAS_N          : in std_logic;
            V0, V1, V2     : in std_logic;
            H0, H1, H2     : in std_logic;
            E0, E1, E2, E3 : in std_logic;

            RA_ENABLE_N        : out std_logic;
            RA0, RA1, RA2, RA3,
            RA4, RA5, RA6, RA7 : out std_logic
        );
    end component;

    signal RA0_INT, RA1_INT, RA2_INT, RA3_INT, RA4_INT, RA5_INT, RA6_INT, RA7_INT : std_logic;
    signal RA_ENABLE_N_INT                                                        : std_logic;
begin
    U_VIDEO_ADDR_MUX : VIDEO_ADDR_MUX port map(
        PHI_1       => PHI_1,
        Q3          => Q3,
        PG2_N       => PG2_N,
        EN80VID     => EN80VID,
        HIRESEN_N   => HIRESEN_N,
        VA          => VA,
        VB          => VB,
        VC          => VC,
        RAS_N       => RAS_N,
        V0          => V0,
        V1          => V1,
        V2          => V2,
        H0          => H0,
        H1          => H1,
        H2          => H2,
        E0          => E0,
        E1          => E1,
        E2          => E2,
        E3          => E3,
        RA_ENABLE_N => RA_ENABLE_N_INT,
        RA0         => RA0_INT,
        RA1         => RA1_INT,
        RA2         => RA2_INT,
        RA3         => RA3_INT,
        RA4         => RA4_INT,
        RA5         => RA5_INT,
        RA6         => RA6_INT,
        RA7         => RA7_INT
    );

    TB_RA_ENABLE_N <= RA_ENABLE_N_INT;
    TB_MUX_RA0     <= RA0_INT;
    TB_MUX_RA1     <= RA1_INT;
    TB_MUX_RA2     <= RA2_INT;
    TB_MUX_RA3     <= RA3_INT;
    TB_MUX_RA4     <= RA4_INT;
    TB_MUX_RA5     <= RA5_INT;
    TB_MUX_RA6     <= RA6_INT;
    TB_MUX_RA7     <= RA7_INT;

    RA_ENABLE_N <= RA_ENABLE_N_INT;
    RA0         <= RA0_INT;
    RA1         <= RA1_INT;
    RA2         <= RA2_INT;
    RA3         <= RA3_INT;
    RA4         <= RA4_INT;
    RA5         <= RA5_INT;
    RA6         <= RA6_INT;
    RA7         <= RA7_INT;

end SPY;
