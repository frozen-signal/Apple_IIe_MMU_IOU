--------------------------------------------------------------------------------
-- File: IOU_ADDR_LATCH.vhdl
-- Description: An entity that latches the address on the RA bus during PHASE 0
--              and stays unchanged during PHASE 1 (when the RA bus has the
--              display address)
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

-- FIXME: Should be renamed; these latched adresses are not related the video signals. IOU_ADDR_LATCH maybe?
entity IOU_ADDR_LATCH is
    port (
        P_PHI_2 : in std_logic;
        RA0, RA1, RA2, RA3,
        RA4, RA5, RA6 : in std_logic;

        LA0, LA1, LA2, LA3,
        LA4, LA5, LA7 : out std_logic
    );
end IOU_ADDR_LATCH;

architecture RTL of IOU_ADDR_LATCH is
begin
    -- IOU_1 @C-3:F5
    process (P_PHI_2, RA0, RA1, RA2, RA3, RA4, RA5, RA6)
    begin
        if (P_PHI_2 = '1') then
            LA0 <= RA0;
            LA1 <= RA1;
            LA2 <= RA2;
            LA3 <= RA3;
            LA4 <= RA4;
            LA5 <= RA5;
            LA7 <= RA6; -- Note: this is not a mistake; There is no LA6 and LA7 is latched from RA6. RA7-0 are driven by the MMU which sets A7 (from the CPU address bus) on the ORA6 line.
        end if;
    end process;
end RTL;
