library IEEE;
use IEEE.std_logic_1164.all;

entity IOU_TIMINGS is
    port (
        PHI_0   : in std_logic;
        P_PHI_0 : in std_logic;
        PRAS_N  : in std_logic;
        TC14S   : in std_logic;

        P_PHI_2 : out std_logic;  -- Probaly means Phase-shifted PHI_2
        PHI_1   : out std_logic;
        CTC14S  : out std_logic
    );
end IOU_TIMINGS;

architecture RTL of IOU_TIMINGS is
    signal P_PHI_2_INT : std_logic;
begin
    -- IOU_1 @C-3:P9-6
    P_PHI_2_INT <= P_PHI_0 and PRAS_N;

    -- IOU_1 @A-3:R8-8
    PHI_1 <= not PHI_0;

    -- MMU_2 @C-4:F2-9
    process (P_PHI_2_INT)
    begin
        if (rising_edge(P_PHI_2_INT)) then
            CTC14S <= TC14S;
        end if;
    end process;

    P_PHI_2 <= P_PHI_2_INT;
end RTL;
