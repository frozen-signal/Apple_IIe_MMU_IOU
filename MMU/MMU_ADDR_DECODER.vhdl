library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_ADDR_DECODER is
    port (
        A     : in std_logic_vector(15 downto 0);
        PHI_0 : in std_logic;

        CXXX_FXXX : out std_logic;
        FXXX_N    : out std_logic;
        EXXX_N    : out std_logic;
        DXXX_N    : out std_logic;
        CXXX      : out std_logic;
        C8_FXX    : out std_logic;
        C8_FXX_N  : out std_logic;
        C0_7XX_N  : out std_logic;
        E_FXXX_N  : out std_logic;
        D_FXXX    : out std_logic;

        -- There is also an address decoder in the IOU. The addresses decoded by
        -- the MMU are prefixed by 'M'. So, MC00X_N is C00X_N, but decoded by the MMU.
        -- The main difference is that the IOU uses the latched address and the MMU uses
        -- the address bus directly.
        MC0XX_N : out std_logic;
        MC3XX   : out std_logic;
        MC00X_N : out std_logic;
        MC01X_N : out std_logic;
        MC04X_N : out std_logic;
        MC05X_N : out std_logic;
        MC06X_N : out std_logic;
        MC07X_N : out std_logic;
        MCFFF_N : out std_logic;

        PHI_0_7XX   : out std_logic;
        PHI_0_1XX_N : out std_logic;
        S_01XX_N    : out std_logic
    );
end MMU_ADDR_DECODER;

architecture RTL of MMU_ADDR_DECODER is
    -- S5 stands for Soft 5, a 'soft' 5v. Comes from the Apple II.
    constant S5 : std_logic := '1'; -- Pull-up resistor see MMU_1 @B-4:A4-15

    component LS138 is
        port (
            A, B, C                        : in std_logic;
            G1, G2A_N, G2B_N               : in std_logic;
            Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7 : out std_logic
        );
    end component;

    signal CXXX_FXXX_INT, EXXX_N_INT, E_FXXX_N_INT, FXXX_N_INT, DXXX_N_INT   : std_logic;
    signal CXXX_INT, MC0XX_N_INT, C8_FXX_INT, PHI_0_7XX_INT, PHI_0_1XX_N_INT : std_logic;
begin
    -- MMU1 @B-4:F4(LS156)
    CXXX_FXXX_INT <= A(15) and A(14);
    FXXX_N_INT    <= not (CXXX_FXXX_INT and A(13) and A(12));
    EXXX_N_INT    <= not (CXXX_FXXX_INT and A(13) and not A(12));
    DXXX_N_INT    <= not (CXXX_FXXX_INT and not A(13) and A(12));
    CXXX_INT      <= CXXX_FXXX_INT and not A(13) and not A(12);
    C8_FXX_INT    <= CXXX_INT and A(11);
    C8_FXX_N      <= not C8_FXX_INT;
    C0_7XX_N      <= not (CXXX_INT and not A(11));

    -- MMU1 @B-34:D4-11 & F3-11
    E_FXXX_N_INT <= FXXX_N_INT and EXXX_N_INT;    -- There seems to be a typo in the schematics: It's labeled E-FXX' but should be E_FXXX'
    D_FXXX       <= E_FXXX_N_INT nand DXXX_N_INT; -- There seems to be a typo in the schematics: It's labeled D-FXXX' but should be D-FXXX (see also MMU2 @C-2:D3-9)

    -- MMU1 @C-3:J4
    MC0XX_N_INT <= (not CXXX_INT) or A(11) or (A(10) or A(9) or A(8));
    MC3XX       <= not((not CXXX_INT) or A(11) or (A(10) or (not A(9)) or (not A(8))));

    -- MMU1 @C-3:J5
    MMU_1_J5 : LS138 port map(
        A     => A(4),
        B     => A(5),
        C     => A(6),
        G1    => S5,
        G2A_N => A(7),
        G2B_N => MC0XX_N_INT,
        Y0    => MC00X_N,
        Y1    => MC01X_N,
        Y2    => open,
        Y3    => open,
        Y4    => MC04X_N,
        Y5    => MC05X_N, -- DIFFERENT THAN IN THE EMULATOR SCHEMATICS; Used for the soft switches HIRES (C056/7) and PG2 (C054/5). See the ASIC schematics.
        Y6    => MC06X_N,
        Y7    => MC07X_N
    );

    -- MMU2 @C-4:A2-9
    MCFFF_N <= not (C8_FXX_INT and PHI_0 -- There seems to be a typo in the schematics: Should be C8-FXX instead of C8-FXXX
        and A(10) and A(9) and A(8) and A(7) and A(6)
        and A(5) and A(4) and A(3) and A(2) and A(1) and A(0));

    -- MMU_2 @D-2
    PHI_0_7XX_INT   <= not (A(15) or A(14) or A(13) or A(12) or A(11));
    PHI_0_1XX_N_INT <= PHI_0_7XX_INT nand (A(10) nor A(9)); -- There seems to be a typo in the schematics: It's labeled PHI_0_1XX but should be PHI_0_1XX_N (see also MMU2 @C-2:S3-1)
    S_01XX_N        <= (not A(8) or PHI_0_1XX_N_INT);

    CXXX_FXXX   <= CXXX_FXXX_INT;
    EXXX_N      <= EXXX_N_INT;
    E_FXXX_N    <= E_FXXX_N_INT;
    FXXX_N      <= FXXX_N_INT;
    DXXX_N      <= DXXX_N_INT;
    CXXX        <= CXXX_INT;
    MC0XX_N     <= MC0XX_N_INT;
    C8_FXX      <= C8_FXX_INT;
    PHI_0_7XX   <= PHI_0_7XX_INT;
    PHI_0_1XX_N <= PHI_0_1XX_N_INT;
end RTL;
