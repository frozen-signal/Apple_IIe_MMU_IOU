library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_RA is
    port (
        A         : in std_logic_vector(15 downto 0);
        PRAS_N    : in std_logic;
        P_PHI_0   : in std_logic;
        Q3_PRAS_N : in std_logic;
        DXXX_N    : in std_logic;
        BANK1     : in std_logic;

        RA       : out std_logic_vector(7 downto 0);
        ENABLE_N : out std_logic
    );
end MMU_RA;

architecture RTL of MMU_RA is
    signal MA12 : std_logic;
begin
    -- MMU_2 @C-4:H4-6
    MA12 <= ((not DXXX_N) and BANK1) xor A(12);

    -- MMU_1 @C-4:E3-8
    ENABLE_N <= P_PHI_0 nand Q3_PRAS_N;

    -- MMU_1 @ @C-4:E5
    RA(0) <= A(0) when PRAS_N = '1' else A(9);
    RA(1) <= A(1) when PRAS_N = '1' else A(6);
    RA(2) <= A(2) when PRAS_N = '1' else A(10);
    RA(3) <= A(3) when PRAS_N = '1' else A(11);

    -- MMU_1 @ @C-4:D5
    RA(4) <= A(4) when PRAS_N = '1' else MA12;
    RA(5) <= A(5) when PRAS_N = '1' else A(13);
    RA(6) <= A(7) when PRAS_N = '1' else A(14); -- We consider 64K to be always HIGH
    RA(7) <= A(8) when PRAS_N = '1' else A(15);
end RTL;
