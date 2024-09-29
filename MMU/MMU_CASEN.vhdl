--------------------------------------------------------------------------------
-- File: MMU_CASEN.vhdl
-- Description: Handling of the CASEN_N signal that indicates if the motherboard
--              RAM is enabled.
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
use ieee.numeric_std.all;

entity MMU_CASEN is
    port (
        RDROM   : in std_logic;
        CXXX    : in std_logic;
        D_FXXX  : in std_logic;
        R_W_N   : in std_logic;
        WRPROT  : in std_logic;
        INH     : in std_logic;
        SELMB_N : in std_logic;
        PHI_0   : in std_logic;
        MPON_N  : in std_logic;

        PCASEN_N : out std_logic;
        OCASEN_N : out std_logic;
        CASEN_N  : out std_logic
    );
end MMU_CASEN;

architecture RTL of MMU_CASEN is
    signal D2_6, B5_8                 : std_logic;
    signal PCASEN_N_INT, OCASEN_N_INT : std_logic;
begin
    -- MMU_1 @D-2:C4-6
    D2_6         <= not (RDROM and D_FXXX and R_W_N);
    B5_8         <= not (WRPROT and D_FXXX and (not R_W_N));
    PCASEN_N_INT <= (D2_6 nand B5_8) or CXXX;

    -- MMU_1 @D-1:E2-3
    -- Not in the emulator schematics: In the ASIC, OCASEN is forced LOW on MPON. Here that means OCASEN_N is forced HIGH on MPON_N
    OCASEN_N_INT <= (PCASEN_N_INT or SELMB_N) or INH or (not MPON_N);

    -- MMU_1 @B-1:L2-8
    CASEN_N <= OCASEN_N_INT; -- In the schematics, CASEN_N is: OCASEN_N and (PHI_0 or 64K), but 64K is constant (HIGH)

    PCASEN_N <= PCASEN_N_INT;
    OCASEN_N <= OCASEN_N_INT;
end RTL;
