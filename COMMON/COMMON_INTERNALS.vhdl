library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity COMMON_INTERNALS is
    port (
        R_W_N  : in std_logic;
        C01X_N : in std_logic;
        PRAS_N : in std_logic;
        Q3     : in std_logic;
        PHI_0  : in std_logic;

        RC01X_N   : out std_logic;
        RAS_N     : out std_logic;
        P_PHI_0   : out std_logic;
        P_PHI_1   : out std_logic;
        Q3_PRAS_N : out std_logic
    );
end COMMON_INTERNALS;

architecture RTL of COMMON_INTERNALS is
begin
    -- IOU_2 @BC-1:R6-11
    -- NOTE:
    -- In the ASIC schematic, the signal PENIO (the 'F' output of the third component in the stack of DET.L on the left)
    -- is the inverse of PENIO_N of IOU_2 @B-1:J7-7. By comparing the ASIC vs IOU_2 @BC-1:R6-11, we can see that
    -- ENIO_N and PENIO_N are the same. Therefore, only PENIO_N has been kept.

    -- IOU_2 @D-3:M4-8
    RC01X_N <= (not R_W_N) or C01X_N;

    -- IOU_1 @A-4:J8-11
    RAS_N <= PRAS_N; -- It's PRAS_N xor '0' in the schematics (?)

    -- IOU_1 @D-3:K9-3
    Q3_PRAS_N <= Q3 or PRAS_N;

    -- IOU_1 @B-3:H5
    process (Q3_PRAS_N, PHI_0) begin
        if (Q3_PRAS_N = '0') then
            P_PHI_0 <= not PHI_0;
            P_PHI_1 <= PHI_0;
        end if;
    end process;

end RTL;
