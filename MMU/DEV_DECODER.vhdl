library IEEE;
use IEEE.std_logic_1164.all;

entity DEV_DECODER is
    port (
        A       : in std_logic_vector(15 downto 0);
        PHI_1   : in std_logic;
        MC0XX_N : in std_logic;

        DEV0_N : out std_logic;
        DEV1_N : out std_logic;
        DEV2_N : out std_logic;
        DEV5_N : out std_logic;
        DEV6_N : out std_logic
    );
end DEV_DECODER;

architecture RTL of DEV_DECODER is

    component LS138 is
        port (
            A, B, C                        : in std_logic;
            G1, G2A_N, G2B_N               : in std_logic;
            Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7 : out std_logic
        );
    end component;
begin
    -- MMU1 @BC-3:P3
    MMU_1_P3 : LS138 port map(
        A     => A(4),
        B     => A(5),
        C     => A(6),
        G1    => A(7), -- XX8X
        G2A_N => MC0XX_N,
        G2B_N => PHI_1,
        Y0    => DEV0_N, -- C08X
        Y1    => DEV1_N, -- C09X
        Y2    => DEV2_N, -- C0AX
        Y3    => open,
        Y4    => open,
        Y5    => DEV5_N, -- C0DX
        Y6    => DEV6_N, -- C0EX
        Y7    => open
    );
end RTL;
