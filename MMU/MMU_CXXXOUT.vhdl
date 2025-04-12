--------------------------------------------------------------------------------
-- File: MMU_CXXXOUT.vhdl
-- Description: Handling of CXXXOUT which tell the IOU that a $CXXX address
--              has been referenced.
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

entity MMU_CXXXOUT is
    port (
        CENROM1    : in std_logic;
        INTC8ACC   : in std_logic;
        INTC3ACC_N : in std_logic;
        CXXX       : in std_logic;

        CXXXOUT_N : out std_logic
    );
end MMU_CXXXOUT;

architecture RTL of MMU_CXXXOUT is
begin
    -- FIXME: Should /ENIO be ignored or not?
    -- MMU_2 @C-2:C2-6
    CXXXOUT_N <= ((not CENROM1) and INTC3ACC_N) nand (CXXX and (not INTC8ACC));
end RTL;
