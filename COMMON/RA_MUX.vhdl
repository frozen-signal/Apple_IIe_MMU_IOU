--------------------------------------------------------------------------------
-- File: RA_MUX.vhdl
-- Description: The logic common to the IOU and the MMU for the Mux of the RA signals.
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

entity RA_MUX is
    port (
        PHI     : in std_logic;  -- Should be PHI_0 in the case of the MMU, and PHI_1 in the case of the IOU
        PRAS_N  : in std_logic;
        Q3      : in std_logic;

        ROW_RA0, ROW_RA1, ROW_RA2, ROW_RA3,
        ROW_RA4, ROW_RA5, ROW_RA6, ROW_RA7 : in std_logic;
        COL_RA0, COL_RA1, COL_RA2, COL_RA3,
        COL_RA4, COL_RA5, COL_RA6, COL_RA7 : in std_logic;

        RA_ENABLE_N : out std_logic;
        RA0, RA1, RA2, RA3,
        RA4, RA5, RA6, RA7 : out std_logic
    );
end RA_MUX;

architecture RTL of RA_MUX is
    -- This is used to add the hold times required by the RAM used by the Apple II series.
    -- See https://github.com/frozen-signal/Apple_IIe_MMU_IOU/tree/master/CUSTOM/DRAM_HOLD_TIME
    component DRAM_HOLD_TIME is
        port (
            PRAS_N : in std_logic;
            Q3     : in std_logic;

            D_RAS_N : out std_logic;
            D_Q3    : out std_logic
        );
    end component;

    signal D_RAS_N, D_Q3  : std_logic;  -- Delayed version of the signals
    signal COMBINED_RAS_N : std_logic;  -- A RAS_N signal that falls with PRAS_N, but rises with the delayed D_RAS_N
begin
    U_DRAM_HOLD_TIME : DRAM_HOLD_TIME port map(
        PRAS_N  => PRAS_N,
        Q3      => Q3,
        D_RAS_N => D_RAS_N,
        D_Q3    => D_Q3
    );

    -- The RA bus is driven from the rising edge of RAS_N in the previous phase to the falling edge of Q3 in the current phase.
    -- Note: A process is used because PHI and Q3 changes at the same time, and Q3 has a slow rise time. The previous implementation:
    -- RA_ENABLE_N <= not ((Q3 and PHI) or ((not PHI) and (not Q3) and RAS_N));
    -- caused an issue with the hold time in DRAM_HOLD_TIME. See https://github.com/frozen-signal/Apple_IIe_MMU_IOU/issues/47
    -- So, the code below shield from the slow-rising Q3 and adds the hold time after the falling_edge of Q3.
    process (PHI, PRAS_N, Q3, D_Q3)
    begin
        if (PHI = '0' and Q3 = '0' and PRAS_N = '1') then
            RA_ENABLE_N <= '0';
        elsif (PHI = '1' and falling_edge(D_Q3)) then
            RA_ENABLE_N <= '1';
        end if;
    end process;

    -- The Apple IIe RAM reads ROW address on the falling edge of PRAS_N and requires to hold that address for
    -- a certain hold time. So we set the ROW before the falling edge of PRAS_N and hold it for as long as RAS_N is HIGH.
    COMBINED_RAS_N <= D_RAS_N or PRAS_N;
    RA0 <= ROW_RA0 when COMBINED_RAS_N = '1' else COL_RA0;
    RA1 <= ROW_RA1 when COMBINED_RAS_N = '1' else COL_RA1;
    RA2 <= ROW_RA2 when COMBINED_RAS_N = '1' else COL_RA2;
    RA3 <= ROW_RA3 when COMBINED_RAS_N = '1' else COL_RA3;
    RA4 <= ROW_RA4 when COMBINED_RAS_N = '1' else COL_RA4;
    RA5 <= ROW_RA5 when COMBINED_RAS_N = '1' else COL_RA5;
    RA6 <= ROW_RA6 when COMBINED_RAS_N = '1' else COL_RA6;
    RA7 <= ROW_RA7 when COMBINED_RAS_N = '1' else COL_RA7;

end RTL;
