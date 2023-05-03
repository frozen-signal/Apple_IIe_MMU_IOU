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
    KBD_N <= INTIO_N or (not R_W_N) or PHI_1;
end RTL;
