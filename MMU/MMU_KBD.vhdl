--------------------------------------------------------------------------------
-- File: MMU_KBD.vhdl
-- Description: Handling of the timing signal that help in the reading of the
--              keyboard keystrokes.
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

entity MMU_KBD is
    port (
        INTIO_N : in std_logic;
        R_W_N   : in std_logic;
        PHI_1   : in std_logic;

        KBD_N : out std_logic
    );
end MMU_KBD;

architecture RTL of MMU_KBD is
begin
    -- MMU_1 @D-2:N4-6
    KBD_N <= INTIO_N or (not R_W_N) or PHI_1;
end RTL;
