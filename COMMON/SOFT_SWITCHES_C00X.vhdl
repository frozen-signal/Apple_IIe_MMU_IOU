-- C00X range soft-switches located on IOU_2 @B-1:J7
library IEEE;
use IEEE.std_logic_1164.all;

entity SOFT_SWITCHES_C00X is
    port (
        D           : in std_logic;
        SWITCH_ADDR : in std_logic_vector(2 downto 0);
        C00X_N      : in std_logic;
        R_W_N       : in std_logic;
        RESET_N     : in std_logic;
        -- These are not directly shown in the logic schematics. In the IOU, C00X_N is computed from Q3 and C0XX_N (IOU_1 @D-3:H6-15)
        -- And C0XX_N is an input pin of the IOU coming from the LS138 UB5 (board schematics, part 2, upper right) which is gated by PHI_1
        -- Instead of requiring that this component's C00X_N to be gated, we will do it here.
        PHI : in std_logic; -- This will be PHI_0 for the MMU and PHI_1 for the IOU

        EN80VID   : out std_logic;
        FLG1      : out std_logic;
        FLG2      : out std_logic;
        PENIO_N   : out std_logic;
        ALTSTKZP  : out std_logic;
        INTC300_N : out std_logic;
        INTC300   : out std_logic;
        S_80COL   : out std_logic;
        PAYMAR    : out std_logic
    );
end SOFT_SWITCHES_C00X;

architecture RTL of SOFT_SWITCHES_C00X is

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

    signal ENABLE_N : std_logic;
    signal Q5_VALUE : std_logic;
begin
    ENABLE_N <= R_W_N or C00X_N or (not PHI);

    SOFT_SWITCHES_LATCH : LATCH_9334 port map(
        C_N => RESET_N,
        E_N => ENABLE_N,
        D   => D,
        A0  => SWITCH_ADDR(0),
        A1  => SWITCH_ADDR(1),
        A2  => SWITCH_ADDR(2),
        Q0  => EN80VID,  -- Also called 80STORE,  RESET: WC000, SET: WC001, READ: RC018
        Q1  => FLG1,     -- Also called RAMRD     RESET: WC002, SET: WC003, READ: RC013
        Q2  => FLG2,     -- Also called RAMWRT    RESET: WC004, SET: WC005, READ: RC014
        Q3  => PENIO_N,  -- Also called INTCXROM  RESET: WC006, SET: WC007, READ: RC015
        Q4  => ALTSTKZP, -- Also called ALTZP     RESET: WC008, SET: WC009, READ: RC016
        Q5  => Q5_VALUE, -- Also called SLOTC3ROM RESET: WC00A, SET: WC00B, READ: RC017
        Q6  => S_80COL,  --                       RESET: WC00C, SET: WC00D, READ: RC01F
        Q7  => PAYMAR    -- Also called ALTCHRSET RESET: WC00E, SET: WC00F, READ: RC01E
    );

    INTC300_N <= Q5_VALUE;
    INTC300   <= not Q5_VALUE;

end RTL;
