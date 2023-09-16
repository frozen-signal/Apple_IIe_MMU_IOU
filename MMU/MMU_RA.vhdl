library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_RA is
    port (
        A      : in std_logic_vector(15 downto 0);
        RAS_N  : in std_logic;
        PHI_0  : in std_logic;
        Q3     : in std_logic;
        DXXX_N : in std_logic;
        BANK1  : in std_logic;

        RA          : out std_logic_vector(7 downto 0);
        RA_ENABLE_N : out std_logic
    );
end MMU_RA;

architecture RTL of MMU_RA is
    component RA_MUX is
        port (
            PHI     : in std_logic;
            RAS_N   : in std_logic;
            Q3      : in std_logic;
            ROW_RA0, ROW_RA1, ROW_RA2, ROW_RA3,
            ROW_RA4, ROW_RA5, ROW_RA6, ROW_RA7 : in std_logic;
            COL_RA0, COL_RA1, COL_RA2, COL_RA3,
            COL_RA4, COL_RA5, COL_RA6, COL_RA7 : in std_logic;

            RA_ENABLE_N : out std_logic;
            RA0, RA1, RA2, RA3,
            RA4, RA5, RA6, RA7 : out std_logic
        );
    end component;

    signal MA12 : std_logic;
begin
    -- MMU_2 @C-4:H4-6
    MA12 <= ((not DXXX_N) and BANK1) xor A(12);
    IOU_RA_MUX : RA_MUX port map(
        PHI   => PHI_0,
        RAS_N => RAS_N,
        Q3    => Q3,

        -- MMU_1 @ @C-4:E5 and D5
        ROW_RA0 => A(0),
        ROW_RA1 => A(1),
        ROW_RA2 => A(2),
        ROW_RA3 => A(3),
        ROW_RA4 => A(4),
        ROW_RA5 => A(5),
        ROW_RA6 => A(7),
        ROW_RA7 => A(8),
        COL_RA0 => A(9),
        COL_RA1 => A(6),
        COL_RA2 => A(10),
        COL_RA3 => A(11),
        COL_RA4 => MA12,
        COL_RA5 => A(13),
        COL_RA6 => A(14), -- We consider 64K to be always HIGH
        COL_RA7 => A(15),

        RA_ENABLE_N => RA_ENABLE_N,
        RA0         => RA(0),
        RA1         => RA(1),
        RA2         => RA(2),
        RA3         => RA(3),
        RA4         => RA(4),
        RA5         => RA(5),
        RA6         => RA(6),
        RA7         => RA(7)
    );
end RTL;
