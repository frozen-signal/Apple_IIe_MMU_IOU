library IEEE;
use IEEE.std_logic_1164.all;

entity SOFT_SWITCHES_C05X is
    port (
        D           : in std_logic;
        SWITCH_ADDR : in std_logic_vector(2 downto 0);
        C05X_N      : in std_logic;
        RESET_N     : in std_logic;

        ITEXT : out std_logic;
        MIX   : out std_logic;
        PG2   : out std_logic;
        HIRES : out std_logic;
        AN0   : out std_logic;
        AN1   : out std_logic;
        AN2   : out std_logic;
        AN3   : out std_logic
    );
end SOFT_SWITCHES_C05X;

architecture RTL of SOFT_SWITCHES_C05X is
begin
    -- The book "Understanding the Apple IIe" by Jim Sather says that ITEXT and MIX are not changed by RESET_N going LOW. This is further supported
    -- by the fact that the schematics of Apple IIe's predecessor has the CLR pin of the 74LS259 tied to +5v
    -- (see page 207, component F4 of figure C-12 of "The Apple II Circuit Description" by W. Gayler).

    -- ITEXT     RESET: WC050, SET: WC051, READ: C01A
    -- MIX       RESET: WC052, SET: WC053, READ: C01B
    -- PG2       RESET: WC054, SET: WC055, READ: C01C
    -- HIRES     RESET: WC056, SET: WC057, READ: C01D
    -- AN0       RESET: WC058, SET: WC059
    -- AN1       RESET: WC05A, SET: WC05B
    -- AN2       RESET: WC05C, SET: WC05D
    -- AN3       RESET: WC05E, SET: WC05F

    -- IOU_1 @A-2:F7
    process (RESET_N, C05X_N, D, SWITCH_ADDR) begin
        if RESET_N = '0' then
            -- CLEAR all excpet ITEXT and MIX
            PG2 <= '0';
            HIRES <= '0';
            AN0 <= '0';
            AN1 <= '0';
            AN2 <= '0';
            AN3 <= '0';
        elsif C05X_N = '0' then
            case (SWITCH_ADDR) is
                when "000"  => ITEXT <= D;
                when "001"  => MIX <= D;
                when "010"  => PG2 <= D;
                when "011"  => HIRES <= D;
                when "100"  => AN0 <= D;
                when "101"  => AN1 <= D;
                when "110"  => AN2 <= D;
                when "111"  => AN3 <= D;
                when others => null;
            end case;
        end if;
    end process;

end RTL;
