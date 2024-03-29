library IEEE;
use IEEE.std_logic_1164.all;

entity RA_MUX is
    port (
        PHI     : in std_logic;  -- Should be PHI_0 in the case of the MMU, and PHI_1 in the case of the IOU
        RAS_N   : in std_logic;  -- The delayed PRAS_N signal. See comment below.
        Q3      : in std_logic;
        ROW_RA0, ROW_RA1, ROW_RA2, ROW_RA3,
        ROW_RA4, ROW_RA5, ROW_RA6, ROW_RA7 : in std_logic;
        COL_RA0, COL_RA1, COL_RA2, COL_RA3,
        COL_RA4, COL_RA5, COL_RA6, COL_RA7 : in std_logic;

        RA_ENABLE_N : out std_logic;
        RA0, RA1, RA2, RA3,
        RA4, RA5, RA6, RA7 : out std_logic
    );
end RA_MUX;

architecture RTL of RA_MUX is
begin
    RA_ENABLE_N <= not ((Q3 and PHI) or ((not PHI) and (not Q3) and RAS_N));

    -- The Apple IIe RAM reads ROW address on the falling edge of PRAS_N and requires to hold that address for
    -- a certain delay (~60ns). So we set the ROW before the falling edge of PRAS_N and hold it for as long as RAS_N is HIGH.
    RA0 <= ROW_RA0 when RAS_N = '1' else COL_RA0;
    RA1 <= ROW_RA1 when RAS_N = '1' else COL_RA1;
    RA2 <= ROW_RA2 when RAS_N = '1' else COL_RA2;
    RA3 <= ROW_RA3 when RAS_N = '1' else COL_RA3;
    RA4 <= ROW_RA4 when RAS_N = '1' else COL_RA4;
    RA5 <= ROW_RA5 when RAS_N = '1' else COL_RA5;
    RA6 <= ROW_RA6 when RAS_N = '1' else COL_RA6;
    RA7 <= ROW_RA7 when RAS_N = '1' else COL_RA7;

end RTL;
