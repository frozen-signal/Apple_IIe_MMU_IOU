--------------------------------------------------------------------------------
-- File: LATTICE_iCE40/DELAY_OSCILLATOR.vhdl
-- Description: An entity that generates the DELAY_CLK signal through the iCE40's SB_HFOSC IP. To be used with Lattice devices that supports the SB_HFOSC primitive.
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

-- NOTE: This implementation of DELAY_OSCILLATOR should only be used with Lattice devices that supports the SB_HFOSC primitive.
entity DELAY_OSCILLATOR is
    port (
        DELAY_CLK : out std_logic
    );
end DELAY_OSCILLATOR;

architecture RTL of DELAY_OSCILLATOR is
    component SB_HFOSC
    generic (CLKHF_DIV : string := "0b00");
    port (
            CLKHFEN : in std_logic ;
            CLKHFPU : in std_logic;
            CLKHF : out std_logic
        );
    end component;
begin
    U_SB_HFOSC : SB_HFOSC
    generic map (CLKHF_DIV => "0b00")
    port map (
        CLKHFEN  => '1',
        CLKHFPU  => '1',
        CLKHF    => DELAY_CLK
    );
end RTL;
