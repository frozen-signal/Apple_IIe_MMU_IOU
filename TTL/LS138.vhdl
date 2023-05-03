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
