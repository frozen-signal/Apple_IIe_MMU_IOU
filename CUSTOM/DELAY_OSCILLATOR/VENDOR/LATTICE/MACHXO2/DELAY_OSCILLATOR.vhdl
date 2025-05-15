--------------------------------------------------------------------------------
-- File: VENDOR\LATTICE\MACHXO3D\DELAY_OSCILLATOR.vhdl
-- Description: An entity that generates the DELAY_CLK signal through the MACHXO2's OSCH IP.
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

LIBRARY machxo2;
USE machxo2.all;

-- NOTE: This implementation of DELAY_OSCILLATOR should only be used with Lattice's MACHXO2.
entity DELAY_OSCILLATOR is
    port (
        DELAY_CLK : out std_logic
    );
end DELAY_OSCILLATOR;

architecture RTL of DELAY_OSCILLATOR is
    constant OSCI_FREQ : string := "133.00";

    component OSCH
        generic (NOM_FREQ: string := OSCI_FREQ);
        port (
            STDBY    : in std_logic;
            OSC      : out std_logic;
            SEDSTDBY : out std_logic
        );
    end component;

    attribute NOM_FREQ : string;
    attribute NOM_FREQ of U_OSCH : label is OSCI_FREQ;
begin
    U_OSCH: OSCH
    generic map (NOM_FREQ => OSCI_FREQ)
    port map (
        STDBY    => '0',
        OSC      => DELAY_CLK,
        SEDSTDBY => open
    );
end RTL;
