library IEEE;
use IEEE.std_logic_1164.all;

entity IOU_KEYBOARD_TB is
    -- empty
end IOU_KEYBOARD_TB;

architecture TESTBENCH of IOU_KEYBOARD_TB is
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

    signal PHI_0            : std_logic;
    signal PAKST              : std_logic;
    signal KSTRB              : std_logic;
    signal AKD                : std_logic;
    signal POC_N              : std_logic;
    signal CTC14S             : std_logic;
    signal LA0, LA1, LA2, LA3 : std_logic;
    signal R_W_N              : std_logic;
    signal C01X_N             : std_logic;
    signal RC01X_N            : std_logic;
    signal AKSTB              : std_logic;
    signal D_KSTRB_N          : std_logic;
    signal STRBLE_N           : std_logic;
    signal CLR_DELAY_N        : std_logic;
    signal SET_DELAY          : std_logic;
    signal AUTOREPEAT_DELAY   : std_logic;
    signal AUTOREPEAT_ACTIVE  : std_logic;
    signal CLRKEY_N           : std_logic;
    signal KEYLE              : std_logic;

begin
    dut : IOU_KEYBOARD port map(
        PHI_0             => PHI_0,
        PAKST             => PAKST,
        KSTRB             => KSTRB,
        AKD               => AKD,
        POC_N             => POC_N,
        CTC14S            => CTC14S,
        LA0               => LA0,
        LA1               => LA1,
        LA2               => LA2,
        LA3               => LA3,
        R_W_N             => R_W_N,
        C01X_N            => C01X_N,
        RC01X_N           => RC01X_N,
        AKSTB             => AKSTB,
        D_KSTRB_N         => D_KSTRB_N,
        STRBLE_N          => STRBLE_N,
        CLR_DELAY_N       => CLR_DELAY_N,
        SET_DELAY         => SET_DELAY,
        AUTOREPEAT_DELAY  => AUTOREPEAT_DELAY,
        AUTOREPEAT_ACTIVE => AUTOREPEAT_ACTIVE,
        CLRKEY_N          => CLRKEY_N,
        KEYLE             => KEYLE
    );

    process begin
        POC_N <= '1';

        -- AKSTB, D_KSTRB_N -----------------------
        PHI_0   <= '0';
        PAKST   <= '1';
        KSTRB   <= '0';
        wait for 1 ns;
        assert(AKSTB = 'U') report "expect AKSTB unchanged" severity error;
        assert(D_KSTRB_N = 'U') report "expect D_KSTRB_N unchanged" severity error;

        PAKST <= '0';
        wait for 1 ns;
        assert(AKSTB = '0') report "expect AKSTB LOW" severity error;
        assert(D_KSTRB_N = 'U') report "expect D_KSTRB_N unchanged" severity error;

        PHI_0 <= '1';
        wait for 1 ns;
        assert(AKSTB = '0') report "expect AKSTB LOW" severity error;
        assert(D_KSTRB_N = '1') report "expect D_KSTRB_N HIGH" severity error;

        PAKST <= '1';
        KSTRB <= '1';
        wait for 1 ns;
        assert(AKSTB = '1') report "expect AKSTB HIGH" severity error;
        assert(D_KSTRB_N = '1') report "expect D_KSTRB_N HIGH" severity error;

        PHI_0 <= '0';
        wait for 1 ns;

        PHI_0 <= '1';
        wait for 1 ns;
        assert(AKSTB = '0') report "expect AKSTB LOW" severity error;
        assert(D_KSTRB_N = '0') report "expect D_KSTRB_N LOW" severity error;

        -- STRBLE_N ---------------------------------------
        -- Preconditions
        assert(D_KSTRB_N = '0') report "PRECONDITION: D_KSTRB_N should be LOW" severity error;

        KSTRB <= '0';
        wait for 1 ns;
        assert(STRBLE_N = '1') report "expect STRBLE_N HIGH" severity error;

        KSTRB <= '1';
        wait for 1 ns;
        assert(STRBLE_N = '1') report "expect STRBLE_N HIGH" severity error;

        PHI_0 <= '0';
        wait for 1 ns;

        KSTRB   <= '0';
        PHI_0 <= '1';
        wait for 1 ns;
        assert(D_KSTRB_N = '1') report "PRECONDITION: D_KSTRB_N should be HIGH" severity error;
        assert(STRBLE_N = '1') report "expect STRBLE_N HIGH" severity error;

        KSTRB <= '1';
        wait for 1 ns;
        assert(STRBLE_N = '0') report "expect STRBLE_N LOW" severity error;

        -- CLRKEY_N ---------------------------------------
        RC01X_N <= '0';
        LA0     <= '0';
        LA1     <= '0';
        LA2     <= '0';
        LA3     <= '0';
        R_W_N   <= '1';
        C01X_N  <= '0';
        wait for 1 ns;
        assert(CLRKEY_N = '0') report "expect CLRKEY_N LOW" severity error;

        RC01X_N <= '1';
        LA0     <= '0';
        LA1     <= '0';
        LA2     <= '0';
        LA3     <= '0';
        R_W_N   <= '1';
        C01X_N  <= '1';
        wait for 1 ns;
        assert(CLRKEY_N = '1') report "expect CLRKEY_N HIGH" severity error;

        RC01X_N <= '0';
        LA0     <= '1';
        LA1     <= '0';
        LA2     <= '0';
        LA3     <= '0';
        R_W_N   <= '1';
        C01X_N  <= '0';
        wait for 1 ns;
        assert(CLRKEY_N = '1') report "expect CLRKEY_N HIGH" severity error;

        RC01X_N <= '0';
        LA0     <= '0';
        LA1     <= '1';
        LA2     <= '0';
        LA3     <= '0';
        R_W_N   <= '1';
        C01X_N  <= '0';
        wait for 1 ns;
        assert(CLRKEY_N = '1') report "expect CLRKEY_N HIGH" severity error;

        RC01X_N <= '0';
        LA0     <= '0';
        LA1     <= '0';
        LA2     <= '1';
        LA3     <= '0';
        R_W_N   <= '1';
        C01X_N  <= '0';
        wait for 1 ns;
        assert(CLRKEY_N = '1') report "expect CLRKEY_N HIGH" severity error;

        RC01X_N <= '0';
        LA0     <= '0';
        LA1     <= '0';
        LA2     <= '0';
        LA3     <= '1';
        R_W_N   <= '1';
        C01X_N  <= '0';
        wait for 1 ns;
        assert(CLRKEY_N = '1') report "expect CLRKEY_N HIGH" severity error;

        RC01X_N <= '1';
        LA0     <= '0';
        LA1     <= '0';
        LA2     <= '0';
        LA3     <= '1';
        R_W_N   <= '0';
        C01X_N  <= '0';
        wait for 1 ns;
        assert(CLRKEY_N = '0') report "expect CLRKEY_N LOW" severity error;

        -- SET_DELAY --------------------------------------
        -- Precondition
        assert(STRBLE_N = '0') report "PRECONDITION: STRBLE_N should be LOW" severity error; -- STRBLE HIGH

        AKD <= '1';
        wait for 1 ns;
        assert(SET_DELAY = '1') report "expect SET_DELAY HIGH" severity error;

        KSTRB <= '0';
        wait for 1 ns;
        assert(STRBLE_N = '1') report "PRECONDITION: STRBLE_N should be HIGH" severity error; -- STRBLE LOW
        assert(SET_DELAY = '1') report "expect SET_DELAY unchanged" severity error;

        AKD <= '0';
        wait for 1 ns;
        assert(SET_DELAY = '0') report "expect SET_DELAY LOW" severity error;

        -- CLR_DELAY_N --------------------------------------
        PHI_0 <= '0';
        wait for 1 ns;
        PHI_0 <= '1';
        KSTRB   <= '1';
        wait for 1 ns;
        PHI_0 <= '0';
        wait for 1 ns;
        KSTRB   <= '0';
        PHI_0 <= '1';
        wait for 1 ns;
        KSTRB <= '1';
        wait for 1 ns;
        assert(STRBLE_N = '0') report "PRECONDITION: STRBLE_N should be LOW" severity error;

        AKD <= '0';
        wait for 1 ns;
        assert(CLR_DELAY_N = '0') report "expect CLR_DELAY_N LOW" severity error;

        AKD <= '1';
        wait for 1 ns;
        assert(CLR_DELAY_N = '0') report "expect CLR_DELAY_N LOW" severity error;

        AKD   <= '0';
        KSTRB <= '1';
        wait for 1 ns;
        KSTRB <= '0';
        wait for 1 ns;
        assert(STRBLE_N = '1') report "PRECONDITION: STRBLE_N should be HIGH" severity error;
        assert(CLR_DELAY_N = '0') report "expect CLR_DELAY_N LOW" severity error;

        AKD <= '1';
        wait for 1 ns;
        assert(CLR_DELAY_N = '1') report "expect CLR_DELAY_N HIGH" severity error;

        -- AUTOREPEAT_DELAY -------------------------------
        -- A key is pressed
        AKD   <= '1';
        KSTRB <= '1';
        wait for 1 ns;
        assert(CLR_DELAY_N = '0') report "auto-repeat delay should have been cleared" severity error;
        assert(KEYLE = '1') report "A key should have been issued" severity error;
        KSTRB <= '0';
        wait for 1 ns;
        assert(STRBLE_N = '1') report "PRECONDITION: STRBLE_N should be HIGH" severity error;
        assert(KEYLE = '0') report "A single key should have been issued" severity error;

        -- Delay 1/3
        CTC14S <= '0';
        wait for 1 ns;
        CTC14S <= '1';
        wait for 1 ns;
        assert(SET_DELAY = '1') report "expect SET_DELAY to be HIGH" severity error;
        assert(AUTOREPEAT_DELAY = '0') report "expect AUTOREPEAT_DELAY LOW" severity error;

        -- Delay 2/3
        CTC14S <= '0';
        wait for 1 ns;
        CTC14S <= '1';
        wait for 1 ns;
        assert(SET_DELAY = '1') report "expect SET_DELAY to be HIGH" severity error;
        assert(AUTOREPEAT_DELAY = '0') report "expect AUTOREPEAT_DELAY LOW" severity error;
        assert(AUTOREPEAT_ACTIVE = '0') report "expect AUTOREPEAT_ACTIVE LOW" severity error;

        -- Delay 3/3: end of "Auto-repeat start delay"
        CTC14S <= '0';
        wait for 1 ns;
        CTC14S <= '1';
        wait for 1 ns;
        assert(SET_DELAY = '1') report "expect SET_DELAY to be HIGH" severity error;
        assert(AUTOREPEAT_DELAY = '1') report "expect AUTOREPEAT_DELAY HIGH" severity error;
        assert(AUTOREPEAT_ACTIVE = '1') report "expect AUTOREPEAT_ACTIVE HIGH" severity error;

        assert(STRBLE_N = '1') report "PRECONDITION: STRBLE_N should be HIGH" severity error;
        PAKST <= '0';
        wait for 1 ns;
        assert(AKSTB = '0') report "PRECONDITION: AKSTB should be LOW" severity error;
        assert(KEYLE = '0') report "When AKSTB is LOW we should be in the 'no key emitted' part of the auto-repeat cycle" severity error;

        PHI_0 <= '0';
        wait for 1 ns;
        PHI_0 <= '1';
        wait for 1 ns;
        PAKST <= '1';
        wait for 1 ns;
        assert(AKSTB = '1') report "PRECONDITION: AKSTB should be HIGH" severity error;
        assert(KEYLE = '1') report "When AKSTB is HIGH we should be in the 'key emitted' part of the auto-repeat cycle" severity error;

        AKD <= '0';
        wait for 1 ns;
        assert(AUTOREPEAT_ACTIVE = '0') report "Releasing the keypress should change AUTOREPEAT_ACTIVE to LOW" severity error;
        assert(KEYLE = '0') report "Releasing the keypress should change KEYLE to LOW" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
