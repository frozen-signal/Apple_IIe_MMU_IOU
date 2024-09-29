--------------------------------------------------------------------------------
-- File: LS138.vhdl
-- Description: Implementation of a 74LS138 3-Line To 8-Line Decoders/Demultiplexers
--              Note: only features used by this project has been implemented.
-- Author: frozen-signal
-- Project: Apple_IIe_MMU_IOU
-- Project location: https://github.com/frozen-signal/Apple_IIe_MMU_IOU/
--
-- This work is licensed under the Creative Commons CC0 1.0 Universal license.
-- To view a copy of this license, visit:
-- https://github.com/frozen-signal/Apple_IIe_MMU_IOU/blob/master/LICENSE
--------------------------------------------------------------------------------

-- LS138
library IEEE;
use IEEE.std_logic_1164.all;

entity LS138 is
    port (
        A, B, C          : in std_logic;
        G1, G2A_N, G2B_N : in std_logic;
        Y0, Y1, Y2, Y3,
        Y4, Y5, Y6, Y7 : out std_logic
    );
end LS138;

architecture RTL of LS138 is
    signal G_N                 : std_logic;
    signal NOT_A, NOT_B, NOT_C : std_logic;
begin
    G_N <= (not G1) or G2A_N or G2B_N;

    NOT_A <= not A;
    NOT_B <= not B;
    NOT_C <= not C;

    Y0 <= G_N or (C or B or A);
    Y1 <= G_N or (C or B or NOT_A);
    Y2 <= G_N or (C or NOT_B or A);
    Y3 <= G_N or (C or NOT_B or NOT_A);
    Y4 <= G_N or (NOT_C or B or A);
    Y5 <= G_N or (NOT_C or B or NOT_A);
    Y6 <= G_N or (NOT_C or NOT_B or A);
    Y7 <= G_N or (NOT_C or NOT_B or NOT_A);
end RTL;
