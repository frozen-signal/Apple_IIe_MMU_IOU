library IEEE;
use IEEE.std_logic_1164.all;

entity IOU_KEYBOARD is
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
        CLR_DELAY_N       : out std_logic; -- This signal is P8-8 in the schematics
        SET_DELAY         : out std_logic; -- This signal is N8-4 in the schematics
        AUTOREPEAT_DELAY  : out std_logic; -- This signal is N9-7 in the schematics
        AUTOREPEAT_ACTIVE : out std_logic; -- This is P7-12 in the schematics
        CLRKEY_N          : out std_logic;
        KEYLE             : out std_logic
    );
end IOU_KEYBOARD;

architecture RTL of IOU_KEYBOARD is
    signal M8_3     : std_logic;
    signal STRBLE   : std_logic;
    signal AKD_N    : std_logic;
    signal N8_4     : std_logic;
    signal N9_SHIFT : std_logic_vector(2 downto 0);
    signal N9_7     : std_logic;

    signal AKSTB_INT, D_KSTRB_N_INT, STRBLE_N_INT, CLR_DELAY_N_INT, SET_DELAY_INT : std_logic;
    signal AUTOREPEAT_DELAY_INT, AUTOREPEAT_ACTIVE_INT                            : std_logic;
begin
    -- IOU_1 @C-3:M8
    process (PHI_0)
    begin
        if (rising_edge(PHI_0)) then
            M8_3          <= not PAKST;
            D_KSTRB_N_INT <= not KSTRB;
        end if;
    end process;
    AKSTB_INT <= PAKST and M8_3; -- AKSTB is the Autorepeat Key STroBe

    -- IOU_2 @D-2, D-1, C-2, C-1
    STRBLE_N_INT <= KSTRB nand D_KSTRB_N_INT; -- STRBLE_N will be LOW when KSTRB transitions from LOW to HIGH.
    STRBLE       <= not STRBLE_N_INT;
    AKD_N        <= not AKD;

    -- IOU_2 @D-3:M3-6
    CLRKEY_N <= (RC01X_N or LA0 or LA1 or LA2 or LA3) and (R_W_N or C01X_N);

    -- IOU_2 @D-4:N8
    process (AKD_N, STRBLE)
    begin
        if (AKD_N = '1') then
            SET_DELAY_INT <= '0';
        elsif (STRBLE = '1') then
            SET_DELAY_INT <= '1';
        end if;
    end process;

    -- IOU_2 @D-1:N9
    -- The flip-flops used in the schematics is implemented here as a 3-bit shift register
    CLR_DELAY_N_INT <= AKD and STRBLE_N_INT;
    process (CTC14S, CLR_DELAY_N_INT)
    begin
        if (CLR_DELAY_N_INT = '0') then
            N9_SHIFT <= "000";
        elsif (rising_edge(CTC14S)) then
            N9_SHIFT(2 downto 1) <= N9_SHIFT(1 downto 0);
            N9_SHIFT(0)          <= SET_DELAY_INT;
        end if;
    end process;
    AUTOREPEAT_DELAY_INT <= N9_SHIFT(2);

    -- IOU_2 @D-4:P7
    process (STRBLE, AKD_N, AUTOREPEAT_DELAY_INT)
    begin
        if ((AKD_N or STRBLE) = '1') then
            AUTOREPEAT_ACTIVE_INT <= '0';
        elsif (AUTOREPEAT_DELAY_INT = '1') then
            AUTOREPEAT_ACTIVE_INT <= '1';
        end if;
    end process;
    KEYLE <= (AKSTB_INT and AUTOREPEAT_ACTIVE_INT) or STRBLE;

    AKSTB             <= AKSTB_INT;
    STRBLE_N          <= STRBLE_N_INT;
    D_KSTRB_N         <= D_KSTRB_N_INT;
    CLR_DELAY_N       <= CLR_DELAY_N_INT;
    SET_DELAY         <= SET_DELAY_INT;
    AUTOREPEAT_DELAY  <= AUTOREPEAT_DELAY_INT;
    AUTOREPEAT_ACTIVE <= AUTOREPEAT_ACTIVE_INT;
end RTL;
