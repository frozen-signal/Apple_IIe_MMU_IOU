library IEEE;
use IEEE.std_logic_1164.all;
use work.IOU_TESTBENCH_PACKAGE.all;

entity IOU_KEYBOARD_SPY is
    port (
        PHI_0              : in std_logic;
        PAKST              : in std_logic;
        KSTRB              : in std_logic;
        AKD                : in std_logic;
        POC_N              : in std_logic;
        CTC14S             : in std_logic;
        LA0, LA1, LA2, LA3 : in std_logic;
        R_W_N              : in std_logic;
        C01X_N             : in std_logic;
        RC01X_N            : in std_logic;

        AKSTB             : out std_logic;
        D_KSTRB_N         : out std_logic;
        STRBLE_N          : out std_logic;
        CLR_DELAY_N       : out std_logic;
        SET_DELAY         : out std_logic;
        AUTOREPEAT_DELAY  : out std_logic;
        AUTOREPEAT_ACTIVE : out std_logic;
        CLRKEY_N          : out std_logic;
        KEYLE             : out std_logic
    );
end IOU_KEYBOARD_SPY;

architecture SPY of IOU_KEYBOARD_SPY is
    component IOU_KEYBOARD is
        port (
            PHI_0              : in std_logic;
            PAKST              : in std_logic;
            KSTRB              : in std_logic;
            AKD                : in std_logic;
            POC_N              : in std_logic;
            CTC14S             : in std_logic;
            LA0, LA1, LA2, LA3 : in std_logic;
            R_W_N              : in std_logic;
            C01X_N             : in std_logic;
            RC01X_N            : in std_logic;

            AKSTB             : out std_logic;
            D_KSTRB_N         : out std_logic;
            STRBLE_N          : out std_logic;
            CLR_DELAY_N       : out std_logic;
            SET_DELAY         : out std_logic;
            AUTOREPEAT_DELAY  : out std_logic;
            AUTOREPEAT_ACTIVE : out std_logic;
            CLRKEY_N          : out std_logic;
            KEYLE             : out std_logic
        );
    end component;

    signal KEYLE_INT : std_logic;

begin
    U_IOU_KEYBOARD : IOU_KEYBOARD port map(
        PHI_0 => PHI_0,
        PAKST => PAKST,
        KSTRB => KSTRB,
        AKD => AKD,
        POC_N => POC_N,
        CTC14S => CTC14S,
        LA0 => LA0,
        LA1 => LA1,
        LA2 => LA2,
        LA3 => LA3,
        R_W_N => R_W_N,
        C01X_N => C01X_N,
        RC01X_N => RC01X_N,
        AKSTB => AKSTB,
        D_KSTRB_N => D_KSTRB_N,
        STRBLE_N => STRBLE_N,
        CLR_DELAY_N => CLR_DELAY_N,
        SET_DELAY => SET_DELAY,
        AUTOREPEAT_DELAY => AUTOREPEAT_DELAY,
        AUTOREPEAT_ACTIVE => AUTOREPEAT_ACTIVE,
        CLRKEY_N => CLRKEY_N,
        KEYLE => KEYLE_INT
    );

    TB_KEYLE <= KEYLE_INT;
    KEYLE    <= KEYLE_INT;
end SPY;
