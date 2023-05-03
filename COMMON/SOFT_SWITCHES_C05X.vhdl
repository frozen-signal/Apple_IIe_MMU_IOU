-- C05X range soft-switches located on IOU_1 @A-2:F7
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

    component LATCH_9334 is
        port (
            C_N : in std_logic;
            E_N : in std_logic;

            D          : in std_logic;
            A0, A1, A2 : in std_logic;

            Q0, Q1, Q2, Q3,
            Q4, Q5, Q6, Q7 : out std_logic
        );
    end component;
begin
    SOFT_SWITCHES_LATCH : LATCH_9334 port map(
        C_N => RESET_N,
        E_N => C05X_N,
        D   => D,
        A0  => SWITCH_ADDR(0),
        A1  => SWITCH_ADDR(1),
        A2  => SWITCH_ADDR(2),
        Q0  => ITEXT, 		-- RESET: WC050, SET: WC051, READ: C01A
        Q1  => MIX,   		-- RESET: WC052, SET: WC053, READ: C01B
        Q2  => PG2,   		-- RESET: WC054, SET: WC055, READ: C01C
        Q3  => HIRES, 		-- RESET: WC056, SET: WC057, READ: C01D
        Q4  => AN0,   		-- RESET: WC058, SET: WC059
        Q5  => AN1,   		-- RESET: WC05A, SET: WC05B
        Q6  => AN2,   		-- RESET: WC05C, SET: WC05D
        Q7  => AN3    		-- RESET: WC05E, SET: WC05F
    );

end RTL;
