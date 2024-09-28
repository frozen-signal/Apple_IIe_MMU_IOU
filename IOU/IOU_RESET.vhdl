--------------------------------------------------------------------------------
-- File: IOU_RESET.vhdl
-- Description: Handling of the RESET on the IOU.
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

-- When the computer is powered on, the RESET_N is forced LOW for a certain time. This is what is described on MMU_1:
--
-- POC is connected to the S leg of the RS latch at B-4:S5. While HIGH, POC (we'll use POC_N here) will force RESET_N LOW.
-- When POC finally drops LOW, the VIDEO_SCANNER (See IOU_1 @A-4 to C-4) is no longer kept in a CLR state and, eventually F9 will overflow.
-- When that happens, TC will be HIGH and at the next PHI_1, the 2N3904 at A3 will disconnect RESET_N from the ground.
-- RESET_N will then be HIGH, pulled-up by the pull-up resistor at MMU_1 @B-2:A4-4
entity IOU_RESET is
    port (
        PHI_1 : in std_logic;
        TC    : in std_logic;
        POC_N : in std_logic;

        -- The IOU will force RESET_N low during power-on;
        -- otherwise RESET_N is driven by the value from the input of the RESET_N pin.
        FORCE_RESET_N_LOW : out std_logic -- This will be HIGH when the IOU should force RESET_N LOW.
    );
end IOU_RESET;

architecture RTL of IOU_RESET is
    signal PWR_ON_FINISHED : std_logic;
begin
    process (POC_N, TC, PHI_1)
    begin
        if (POC_N = '0') then
            PWR_ON_FINISHED <= '0';
        elsif (TC = '1' and PHI_1 = '1') then
            PWR_ON_FINISHED <= '1';
        end if;
    end process;

    FORCE_RESET_N_LOW <= not PWR_ON_FINISHED;
end RTL;
