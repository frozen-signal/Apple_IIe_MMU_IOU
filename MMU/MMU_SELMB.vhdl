library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_SELMB is
    port (
        S_00_1XX    : in std_logic;  -- HIGH when the ADDRESS at the MMU's input is between $0000 - $01FF ($0[0-1]XX)
        S_04_7XX    : in std_logic;  -- HIGH when the ADDRESS at the MMU's input is between $0400 - $07FF ($0[4-7]XX)
        S_2_3XXX    : in std_logic;  -- HIGH when the ADDRESS at the MMU's input is between $2000 - $3FFF ($[2-3]XXX)
        D_FXXX      : in std_logic;
        HIRES       : in std_logic;
        EN80VID     : in std_logic;
        PG2         : in std_logic;
        FLG1        : in std_logic;
        FLG2        : in std_logic;
        R_W_N       : in std_logic;
        ALTSTKZP    : in std_logic;

        SELMB_N : out std_logic
    );
end MMU_SELMB;

architecture RTL of MMU_SELMB is
begin
    process (S_00_1XX, S_04_7XX, S_2_3XXX, D_FXXX, EN80VID,
             HIRES, R_W_N, PG2, ALTSTKZP, FLG1, FLG2)
    begin
        if (S_04_7XX = '1' and EN80VID = '1')
          or (S_2_3XXX = '1' and HIRES = '1' and EN80VID = '1') then
            -- When accessing primary display range ($0400-$07FF) while EN80VID is set
            -- or
            -- When accessing HIRES display range ($2000-$3FFF) while EN80VID and HIRES are set,
            -- PG2 switches between motherboard RAM (PG2 = '0') and AUX RAM (PG2 = '1')
            SELMB_N <= PG2;
        elsif D_FXXX = '1' or S_00_1XX = '1' then
            -- ALTSTKZP switches the $0000-$01FF and the $D000-$FFFF range between
            -- motherboard RAM (ALTSTKZP = '0') and AUX RAM (ALTSTKZP = '1')
            SELMB_N <= ALTSTKZP;

        -- Note: It's important that the following two tests are done after the 'address-based' checks above.
        --       (See "Understanding the Apple IIe" by Jim Sather, p.5-25, paragraph beginning with "RAMRD and RAMWRT...")
        elsif R_W_N = '1' then
            -- If it's a read operation, FLG1 (also called RAMRD) switches between
            -- motherboard RAM (FLG1 = '0') and AUX RAM (FLG1 = '1')
            SELMB_N <= FLG1;
        else
            -- If it's a write operation, FLG2 (also called RAMWRT) switches between
            -- motherboard RAM (FLG2 = '0') and AUX RAM (FLG2 = '1')
            SELMB_N <= FLG2;
        end if;
    end process;

end RTL;
