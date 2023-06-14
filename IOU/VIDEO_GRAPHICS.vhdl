library IEEE;
use IEEE.std_logic_1164.all;

entity VIDEO_GRAPHICS is
    port (
        P_PHI_2    : in std_logic;
        V2, V4     : in std_logic;
        VA, VB, VC : in std_logic;
        H0         : in std_logic;
        HIRESEN_N  : in std_logic;
        ITEXT      : in std_logic;
        MIX        : in std_logic;

        PGR_TXT_N        : out std_logic;
        SEGA, SEGB, SEGC : out std_logic;
        LGR_TXT_N        : out std_logic
    );
end VIDEO_GRAPHICS;

architecture RTL of VIDEO_GRAPHICS is
begin
    -- IOU_1 @B-1:R5-12
    process (P_PHI_2)
    begin
        if (rising_edge(P_PHI_2)) then
            PGR_TXT_N <= (MIX and V2 and V4) nor ITEXT;
        end if;
    end process;

    -- IOU_1 @B-2:N6
    process (P_PHI_2)
    begin
        if (rising_edge(P_PHI_2)) then
            SEGA      <= VA when PGR_TXT_N = '0' else H0;
            SEGB      <= VB when PGR_TXT_N = '0' else HIRESEN_N;
            SEGC      <= VC;
            LGR_TXT_N <= (MIX and V2 and V4) nor ITEXT;
        end if;
    end process;

end RTL;
