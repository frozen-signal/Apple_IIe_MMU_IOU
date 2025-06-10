--------------------------------------------------------------------------------
-- File: SOFT_SWITCHES_C00X.vhdl
-- Description: The $C00X soft switches.
-- Author: frozen-signal
-- Project: Apple_IIe_MMU_IOU
-- Project location: https://github.com/frozen-signal/Apple_IIe_MMU_IOU/
--
-- This work is licensed under the Creative Commons CC0 1.0 Universal license.
-- To view a copy of this license, visit:
-- https://github.com/frozen-signal/Apple_IIe_MMU_IOU/blob/master/LICENSE
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

-- Note: Both the IOU and MMU react the exact same way to the C00X soft-switches; these two components
-- must always change the soft-switches together and should always have the same values.
entity SOFT_SWITCHES_C00X is
    port (
        D           : in std_logic;
        SWITCH_ADDR : in std_logic_vector(2 downto 0);
        C00X_N      : in std_logic;
        R_W_N       : in std_logic;
        RESET_N     : in std_logic;
        PHI_0       : in std_logic;

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
    signal ENABLE_N : std_logic;
    signal Q5_VALUE : std_logic;
begin
    -- IOU_2 @B-1:J7
    ENABLE_N <= R_W_N or C00X_N;

    -- A difference with the schematics is that we use the rising edge of PHI_0 (both for the MMU and the IOU) to change the soft-switch
    --   instead of a D-Latch with PHI_1 part of the enable (PHI_1 because it's an active-low enable).
    process (RESET_N, ENABLE_N, D,SWITCH_ADDR) begin
        if (RESET_N = '0') then
            EN80VID  <= '0';
            FLG1     <= '0';
            FLG2     <= '0';
            PENIO_N  <= '0';
            ALTSTKZP <= '0';
            Q5_VALUE <= '0';
            S_80COL  <= '0';
            PAYMAR   <= '0';
        elsif (ENABLE_N = '0' and rising_edge(PHI_0)) then
            case (SWITCH_ADDR) is
                when "000"  => EN80VID  <= D;  -- Also called 80STORE,  RESET: WC000, SET: WC001, READ: RC018
                when "001"  => FLG1     <= D;  -- Also called RAMRD     RESET: WC002, SET: WC003, READ: RC013
                when "010"  => FLG2     <= D;  -- Also called RAMWRT    RESET: WC004, SET: WC005, READ: RC014
                when "011"  => PENIO_N  <= D;  -- Also called INTCXROM  RESET: WC006, SET: WC007, READ: RC015
                when "100"  => ALTSTKZP <= D;  -- Also called ALTZP     RESET: WC008, SET: WC009, READ: RC016
                when "101"  => Q5_VALUE <= D;  -- Also called SLOTC3ROM RESET: WC00A, SET: WC00B, READ: RC017
                when "110"  => S_80COL  <= D;  --                       RESET: WC00C, SET: WC00D, READ: RC01F
                when "111"  => PAYMAR   <= D;  -- Also called ALTCHRSET RESET: WC00E, SET: WC00F, READ: RC01E (Probably refers to the "Paymar Chip", a popular lowercase adapter for the original Apple II and II+ computers)
                when others => null;
            end case;
        end if;
    end process;

    INTC300_N <= Q5_VALUE;
    INTC300   <= not Q5_VALUE;

end RTL;
