library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_ADDR_DECODER_TB is
    -- empty
end MMU_ADDR_DECODER_TB;

architecture TESTBENCH of MMU_ADDR_DECODER_TB is
    component MMU_ADDR_DECODER is
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

            MC0XX_N : out std_logic;
            MC3XX   : out std_logic;
            MC00X_N : out std_logic;
            MC01X_N : out std_logic;
            MC04X_N : out std_logic;
            MC05X_N : out std_logic;
            MC06X_N : out std_logic;
            MC07X_N : out std_logic;
            MCFFF_N : out std_logic;

            S_00_1XX    : out std_logic;
            S_04_7XX    : out std_logic;
            S_2_3XXX    : out std_logic;
            S_01XX_N    : out std_logic
        );
    end component;

    signal A : std_logic_vector(15 downto 0);
    signal PHI_0, CXXX_FXXX, FXXX_N, EXXX_N, DXXX_N, CXXX, C8_FXX, C8_FXX_N, C0_7XX_N,
    E_FXXX_N, D_FXXX, MC0XX_N, MC3XX, MC00X_N, MC01X_N, MC04X_N, MC05X_N, MC06X_N, MC07X_N, MCFFF_N,
    S_00_1XX, S_04_7XX, S_2_3XXX, S_01XX_N : std_logic;

begin
    dut : MMU_ADDR_DECODER port map(
        A           => A,
        PHI_0       => PHI_0,
        CXXX_FXXX   => CXXX_FXXX,
        FXXX_N      => FXXX_N,
        EXXX_N      => EXXX_N,
        DXXX_N      => DXXX_N,
        CXXX        => CXXX,
        C8_FXX      => C8_FXX,
        C8_FXX_N    => C8_FXX_N,
        C0_7XX_N    => C0_7XX_N,
        E_FXXX_N    => E_FXXX_N,
        D_FXXX      => D_FXXX,
        MC0XX_N     => MC0XX_N,
        MC3XX       => MC3XX,
        MC00X_N     => MC00X_N,
        MC01X_N     => MC01X_N,
        MC04X_N     => MC04X_N,
        MC05X_N     => MC05X_N,
        MC06X_N     => MC06X_N,
        MC07X_N     => MC07X_N,
        MCFFF_N     => MCFFF_N,
        S_00_1XX    => S_00_1XX,
        S_04_7XX    => S_04_7XX,
        S_2_3XXX    => S_2_3XXX,
        S_01XX_N    => S_01XX_N
    );

    process begin
        PHI_0 <= 'X';

        A <= x"7FFF";
        wait for 1 ns;
        assert(CXXX_FXXX = '0') report "When A is not in CXXX-FXXX range expect CXXX_FXXX LOW" severity error;
        assert(FXXX_N = '1') report "When A is not in CXXX-FXXX range expect FXXX_N HIGH" severity error;
        assert(EXXX_N = '1') report "When A is not in CXXX-FXXX range expect EXXX_N HIGH" severity error;
        assert(DXXX_N = '1') report "When A is not in CXXX-FXXX range expect DXXX_N HIGH" severity error;
        assert(CXXX = '0') report "When A is not in CXXX-FXXX range expect CXXX LOW" severity error;
        assert(C8_FXX = '0') report "When A is not in CXXX-FXXX range expect C8_FXX LOW" severity error;
        assert(C8_FXX_N = '1') report "When A is not in CXXX-FXXX range expect C8_FXX_N HIGH" severity error;
        assert(C0_7XX_N = '1') report "When A is not in CXXX-FXXX range expect C0_7XX_N HIGH" severity error;
        assert(E_FXXX_N = '1') report "When A is not in CXXX-FXXX range expect E_FXXX_N HIGH" severity error;
        assert(D_FXXX = '0') report "When A is not in CXXX-FXXX range expect D_FXXX LOW" severity error;
        assert(MC0XX_N = '1') report "When A is not in CXXX-FXXX range expect MC0XX_N HIGH" severity error;
        assert(MC3XX = '0') report "When A is not in CXXX-FXXX range expect MC3XX LOW" severity error;
        assert(MC00X_N = '1') report "When A is not in CXXX-FXXX range expect MC00X_N HIGH" severity error;
        assert(MC01X_N = '1') report "When A is not in CXXX-FXXX range expect MC01X_N HIGH" severity error;
        assert(MC04X_N = '1') report "When A is not in CXXX-FXXX range expect MC04X_N HIGH" severity error;
        assert(MC05X_N = '1') report "When A is not in CXXX-FXXX range expect MC05X_N HIGH" severity error;
        assert(MC06X_N = '1') report "When A is not in CXXX-FXXX range expect MC06X_N HIGH" severity error;
        assert(MC07X_N = '1') report "When A is not in CXXX-FXXX range expect MC07X_N HIGH" severity error;
        assert(MCFFF_N = '1') report "When A is not in CXXX-FXXX range expect MCFFF_N HIGH" severity error;
        assert(S_01XX_N = '1') report "When A is not in 01XX range expect 01XX_N HIGH" severity error;

        A <= x"F000";
        wait for 1 ns;
        assert(CXXX_FXXX = '1') report "When A is F000 expect CXXX_FXXX HIGH" severity error;
        assert(FXXX_N = '0') report "When A is F000 expect FXXX_N LOW" severity error;
        assert(EXXX_N = '1') report "When A is F000 expect EXXX_N HIGH" severity error;
        assert(DXXX_N = '1') report "When A is F000 expect DXXX_N HIGH" severity error;
        assert(CXXX = '0') report "When A is F000 expect CXXX LOW" severity error;
        assert(C8_FXX = '0') report "When A is F000 expect C8_FXX LOW" severity error;
        assert(C8_FXX_N = '1') report "When A is F000 expect C8_FXX_N HIGH" severity error;
        assert(C0_7XX_N = '1') report "When A is F000 expect C0_7XX_N HIGH" severity error;
        assert(E_FXXX_N = '0') report "When A is F000 expect E_FXXX_N LOW" severity error;
        assert(D_FXXX = '1') report "When A is F000 expect D_FXXX HIGH" severity error;
        assert(MC0XX_N = '1') report "When A is F000 expect MC0XX_N HIGH" severity error;
        assert(MC3XX = '0') report "When A is F000 expect MC3XX LOW" severity error;
        assert(MC00X_N = '1') report "When A is F000 expect MC00X_N HIGH" severity error;
        assert(MC01X_N = '1') report "When A is F000 expect MC01X_N HIGH" severity error;
        assert(MC04X_N = '1') report "When A is F000 expect MC04X_N HIGH" severity error;
        assert(MC05X_N = '1') report "When A is F000 expect MC05X_N HIGH" severity error;
        assert(MC06X_N = '1') report "When A is F000 expect MC06X_N HIGH" severity error;
        assert(MC07X_N = '1') report "When A is F000 expect MC07X_N HIGH" severity error;
        assert(MCFFF_N = '1') report "When A is F000 expect MCFFF_N HIGH" severity error;
        A <= x"E000";
        wait for 1 ns;
        assert(CXXX_FXXX = '1') report "When A is E000 expect CXXX_FXXX HIGH" severity error;
        assert(FXXX_N = '1') report "When A is E000 expect FXXX_N HIGH" severity error;
        assert(EXXX_N = '0') report "When A is E000 expect EXXX_N LOW" severity error;
        assert(DXXX_N = '1') report "When A is E000 expect DXXX_N HIGH" severity error;
        assert(CXXX = '0') report "When A is E000 expect CXXX LOW" severity error;
        assert(C8_FXX = '0') report "When A is E000 expect C8_FXX LOW" severity error;
        assert(C8_FXX_N = '1') report "When A is E000 expect C8_FXX_N HIGH" severity error;
        assert(C0_7XX_N = '1') report "When A is E000 expect C0_7XX_N HIGH" severity error;
        assert(E_FXXX_N = '0') report "When A is E000 expect E_FXXX_N LOW" severity error;
        assert(D_FXXX = '1') report "When A is E000 expect D_FXXX HIGH" severity error;
        assert(MC0XX_N = '1') report "When A is E000 expect MC0XX_N HIGH" severity error;
        assert(MC3XX = '0') report "When A is E000 expect MC3XX LOW" severity error;
        assert(MC00X_N = '1') report "When A is E000 expect MC00X_N HIGH" severity error;
        assert(MC01X_N = '1') report "When A is E000 expect MC01X_N HIGH" severity error;
        assert(MC04X_N = '1') report "When A is E000 expect MC04X_N HIGH" severity error;
        assert(MC05X_N = '1') report "When A is E000 expect MC05X_N HIGH" severity error;
        assert(MC06X_N = '1') report "When A is E000 expect MC06X_N HIGH" severity error;
        assert(MC07X_N = '1') report "When A is E000 expect MC07X_N HIGH" severity error;
        assert(MCFFF_N = '1') report "When A is E000 expect MCFFF_N HIGH" severity error;

        A <= x"D000";
        wait for 1 ns;
        assert(CXXX_FXXX = '1') report "When A is D000 expect CXXX_FXXX HIGH" severity error;
        assert(FXXX_N = '1') report "When A is D000 expect FXXX_N HIGH" severity error;
        assert(EXXX_N = '1') report "When A is D000 expect EXXX_N HIGH" severity error;
        assert(DXXX_N = '0') report "When A is D000 expect DXXX_N LOW" severity error;
        assert(CXXX = '0') report "When A is D000 expect CXXX LOW" severity error;
        assert(C8_FXX = '0') report "When A is D000 expect C8_FXX LOW" severity error;
        assert(C8_FXX_N = '1') report "When A is D000 expect C8_FXX_N HIGH" severity error;
        assert(C0_7XX_N = '1') report "When A is D000 expect C0_7XX_N HIGH" severity error;
        assert(E_FXXX_N = '1') report "When A is D000 expect E_FXXX_N HIGH" severity error;
        assert(D_FXXX = '1') report "When A is D000 expect D_FXXX HIGH" severity error;
        assert(MC0XX_N = '1') report "When A is D000 expect MC0XX_N HIGH" severity error;
        assert(MC3XX = '0') report "When A is D000 expect MC3XX LOW" severity error;
        assert(MC00X_N = '1') report "When A is D000 expect MC00X_N HIGH" severity error;
        assert(MC01X_N = '1') report "When A is D000 expect MC01X_N HIGH" severity error;
        assert(MC04X_N = '1') report "When A is D000 expect MC04X_N HIGH" severity error;
        assert(MC05X_N = '1') report "When A is D000 expect MC05X_N HIGH" severity error;
        assert(MC06X_N = '1') report "When A is D000 expect MC06X_N HIGH" severity error;
        assert(MC07X_N = '1') report "When A is D000 expect MC07X_N HIGH" severity error;
        assert(MCFFF_N = '1') report "When A is D000 expect MCFFF_N HIGH" severity error;

        A <= x"C000";
        wait for 1 ns;
        assert(CXXX_FXXX = '1') report "When A is C000 expect CXXX_FXXX HIGH" severity error;
        assert(FXXX_N = '1') report "When A is C000 expect FXXX_N HIGH" severity error;
        assert(EXXX_N = '1') report "When A is C000 expect EXXX_N HIGH" severity error;
        assert(DXXX_N = '1') report "When A is C000 expect DXXX_N HIGH" severity error;
        assert(CXXX = '1') report "When A is C000 expect CXXX LOW" severity error;
        assert(C8_FXX = '0') report "When A is C000 expect C8_FXX LOW" severity error;
        assert(C8_FXX_N = '1') report "When A is C000 expect C8_FXX_N HIGH" severity error;
        assert(C0_7XX_N = '0') report "When A is C000 expect C0_7XX_N LOW" severity error;
        assert(E_FXXX_N = '1') report "When A is C000 expect E_FXXX_N HIGH" severity error;
        assert(D_FXXX = '0') report "When A is C000 expect D_FXXX LOW" severity error;
        assert(MC0XX_N = '0') report "When A is C000 expect MC0XX_N LOW" severity error;
        assert(MC3XX = '0') report "When A is C000 expect MC3XX LOW" severity error;
        assert(MC00X_N = '0') report "When A is C000 expect MC00X_N LOW" severity error;
        assert(MC01X_N = '1') report "When A is C000 expect MC01X_N HIGH" severity error;
        assert(MC04X_N = '1') report "When A is C000 expect MC04X_N HIGH" severity error;
        assert(MC05X_N = '1') report "When A is C000 expect MC05X_N HIGH" severity error;
        assert(MC06X_N = '1') report "When A is C000 expect MC06X_N HIGH" severity error;
        assert(MC07X_N = '1') report "When A is C000 expect MC07X_N HIGH" severity error;
        assert(MCFFF_N = '1') report "When A is C000 expect MCFFF_N HIGH" severity error;

        A <= x"C010";
        wait for 1 ns;
        assert(C8_FXX = '0') report "When A is C010 expect C8_FXX LOW" severity error;
        assert(C8_FXX_N = '1') report "When A is C010 expect C8_FXX_N HIGH" severity error;
        assert(C0_7XX_N = '0') report "When A is C010 expect C0_7XX_N LOW" severity error;
        assert(MC0XX_N = '0') report "When A is C010 expect MC0XX_N LOW" severity error;
        assert(MC3XX = '0') report "When A is C010 expect MC3XX LOW" severity error;
        assert(MC00X_N = '1') report "When A is C010 expect MC00X_N HIGH" severity error;
        assert(MC01X_N = '0') report "When A is C010 expect MC01X_N LOW" severity error;
        assert(MC04X_N = '1') report "When A is C010 expect MC04X_N HIGH" severity error;
        assert(MC05X_N = '1') report "When A is C010 expect MC05X_N HIGH" severity error;
        assert(MC06X_N = '1') report "When A is C010 expect MC06X_N HIGH" severity error;
        assert(MC07X_N = '1') report "When A is C010 expect MC07X_N HIGH" severity error;
        assert(MCFFF_N = '1') report "When A is C010 expect MCFFF_N HIGH" severity error;

        A <= x"C040";
        wait for 1 ns;
        assert(C8_FXX = '0') report "When A is C040 expect C8_FXX LOW" severity error;
        assert(C8_FXX_N = '1') report "When A is C040 expect C8_FXX_N HIGH" severity error;
        assert(C0_7XX_N = '0') report "When A is C040 expect C0_7XX_N LOW" severity error;
        assert(MC0XX_N = '0') report "When A is C040 expect MC0XX_N LOW" severity error;
        assert(MC3XX = '0') report "When A is C040 expect MC3XX LOW" severity error;
        assert(MC00X_N = '1') report "When A is C040 expect MC00X_N HIGH" severity error;
        assert(MC01X_N = '1') report "When A is C040 expect MC01X_N HIGH" severity error;
        assert(MC04X_N = '0') report "When A is C040 expect MC04X_N LOW" severity error;
        assert(MC05X_N = '1') report "When A is C040 expect MC05X_N HIGH" severity error;
        assert(MC06X_N = '1') report "When A is C040 expect MC06X_N HIGH" severity error;
        assert(MC07X_N = '1') report "When A is C040 expect MC07X_N HIGH" severity error;
        assert(MCFFF_N = '1') report "When A is C040 expect MCFFF_N HIGH" severity error;

        A <= x"C050";
        wait for 1 ns;
        assert(C8_FXX = '0') report "When A is C040 expect C8_FXX LOW" severity error;
        assert(C8_FXX_N = '1') report "When A is C040 expect C8_FXX_N HIGH" severity error;
        assert(C0_7XX_N = '0') report "When A is C040 expect C0_7XX_N LOW" severity error;
        assert(MC0XX_N = '0') report "When A is C040 expect MC0XX_N LOW" severity error;
        assert(MC3XX = '0') report "When A is C040 expect MC3XX LOW" severity error;
        assert(MC00X_N = '1') report "When A is C040 expect MC00X_N HIGH" severity error;
        assert(MC01X_N = '1') report "When A is C040 expect MC01X_N HIGH" severity error;
        assert(MC04X_N = '1') report "When A is C040 expect MC04X_N HIGH" severity error;
        assert(MC05X_N = '0') report "When A is C040 expect MC05X_N LOW" severity error;
        assert(MC06X_N = '1') report "When A is C040 expect MC06X_N HIGH" severity error;
        assert(MC07X_N = '1') report "When A is C040 expect MC07X_N HIGH" severity error;
        assert(MCFFF_N = '1') report "When A is C040 expect MCFFF_N HIGH" severity error;

        A <= x"C060";
        wait for 1 ns;
        assert(C8_FXX = '0') report "When A is C060 expect C8_FXX LOW" severity error;
        assert(C8_FXX_N = '1') report "When A is C060 expect C8_FXX_N HIGH" severity error;
        assert(C0_7XX_N = '0') report "When A is C060 expect C0_7XX_N LOW" severity error;
        assert(MC0XX_N = '0') report "When A is C060 expect MC0XX_N LOW" severity error;
        assert(MC3XX = '0') report "When A is C060 expect MC3XX LOW" severity error;
        assert(MC00X_N = '1') report "When A is C060 expect MC00X_N HIGH" severity error;
        assert(MC01X_N = '1') report "When A is C060 expect MC01X_N HIGH" severity error;
        assert(MC04X_N = '1') report "When A is C060 expect MC04X_N HIGH" severity error;
        assert(MC05X_N = '1') report "When A is C060 expect MC05X_N HIGH" severity error;
        assert(MC06X_N = '0') report "When A is C060 expect MC06X_N LOW" severity error;
        assert(MC07X_N = '1') report "When A is C060 expect MC07X_N HIGH" severity error;
        assert(MCFFF_N = '1') report "When A is C060 expect MCFFF_N HIGH" severity error;

        A <= x"C070";
        wait for 1 ns;
        assert(C8_FXX = '0') report "When A is C070 expect C8_FXX LOW" severity error;
        assert(C8_FXX_N = '1') report "When A is C070 expect C8_FXX_N HIGH" severity error;
        assert(C0_7XX_N = '0') report "When A is C070 expect C0_7XX_N LOW" severity error;
        assert(MC0XX_N = '0') report "When A is C070 expect MC0XX_N LOW" severity error;
        assert(MC3XX = '0') report "When A is C070 expect MC3XX LOW" severity error;
        assert(MC00X_N = '1') report "When A is C070 expect MC00X_N HIGH" severity error;
        assert(MC01X_N = '1') report "When A is C070 expect MC01X_N HIGH" severity error;
        assert(MC04X_N = '1') report "When A is C070 expect MC04X_N HIGH" severity error;
        assert(MC05X_N = '1') report "When A is C070 expect MC05X_N HIGH" severity error;
        assert(MC06X_N = '1') report "When A is C070 expect MC06X_N HIGH" severity error;
        assert(MC07X_N = '0') report "When A is C070 expect MC07X_N LOW" severity error;
        assert(MCFFF_N = '1') report "When A is C070 expect MCFFF_N HIGH" severity error;

        A <= x"C300";
        wait for 1 ns;
        assert(C8_FXX = '0') report "When A is C300 expect C8_FXX LOW" severity error;
        assert(C8_FXX_N = '1') report "When A is C300 expect C8_FXX_N HIGH" severity error;
        assert(C0_7XX_N = '0') report "When A is C300 expect C0_7XX_N LOW" severity error;
        assert(MC0XX_N = '1') report "When A is C300 expect MC0XX_N HIGH" severity error;
        assert(MC3XX = '1') report "When A is C300 expect MC3XX HIGH" severity error;
        assert(MC00X_N = '1') report "When A is C300 expect MC00X_N HIGH" severity error;
        assert(MC01X_N = '1') report "When A is C300 expect MC01X_N HIGH" severity error;
        assert(MC04X_N = '1') report "When A is C300 expect MC04X_N HIGH" severity error;
        assert(MC05X_N = '1') report "When A is C300 expect MC05X_N HIGH" severity error;
        assert(MC06X_N = '1') report "When A is C300 expect MC06X_N HIGH" severity error;
        assert(MC07X_N = '1') report "When A is C300 expect MC07X_N HIGH" severity error;
        assert(MCFFF_N = '1') report "When A is C300 expect MCFFF_N HIGH" severity error;

        PHI_0 <= '1';
        A     <= x"CFFF";
        wait for 1 ns;
        assert(C8_FXX = '1') report "When A is CFFF expect C8_FXX HIGH" severity error;
        assert(C8_FXX_N = '0') report "When A is CFFF expect C8_FXX_N LOW" severity error;
        assert(C0_7XX_N = '1') report "When A is CFFF expect C0_7XX_N  LOW" severity error;
        assert(MC0XX_N = '1') report "When A is CFFF expect MC0XX_N HIGH" severity error;
        assert(MC3XX = '0') report "When A is CFFF expect MC3XX LOW" severity error;
        assert(MC00X_N = '1') report "When A is CFFF expect MC00X_N HIGH" severity error;
        assert(MC01X_N = '1') report "When A is CFFF expect MC01X_N HIGH" severity error;
        assert(MC04X_N = '1') report "When A is CFFF expect MC04X_N HIGH" severity error;
        assert(MC05X_N = '1') report "When A is CFFF expect MC05X_N HIGH" severity error;
        assert(MC06X_N = '1') report "When A is CFFF expect MC06X_N HIGH" severity error;
        assert(MC07X_N = '1') report "When A is CFFF expect MC07X_N HIGH" severity error;
        assert(MCFFF_N = '0') report "When A is CFFF expect MCFFF_N LOW" severity error;


        A <= x"0000";
        wait for 1 ns;
        assert(S_00_1XX = '1') report "When A is in 0000-01FF range expect S_00_1XX HIGH" severity error;
        assert(S_04_7XX = '0') report "When A is not in 0400-07FF range expect S_04_7XX LOW" severity error;
        assert(S_2_3XXX = '0') report "When A is not in 2000-3FFF range expect S_2_3XXX LOW" severity error;
        assert(S_01XX_N = '1') report "When A is not in 01XX range expect S_01XX_N HIGH" severity error;

        A <= x"01FF";
        wait for 1 ns;
        assert(S_00_1XX = '1') report "When A is in 0000-01FF range expect S_00_1XX HIGH" severity error;
        assert(S_04_7XX = '0') report "When A is not in 0400-07FF range expect S_04_7XX LOW" severity error;
        assert(S_2_3XXX = '0') report "When A is not in 2000-3FFF range expect S_2_3XXX LOW" severity error;
        assert(S_01XX_N = '0') report "When A is in 01XX range expect S_01XX_N LOW" severity error;

        A <= x"0200";
        wait for 1 ns;
        assert(S_00_1XX = '0') report "When A is not in 0000-01FF range expect S_00_1XX LOW" severity error;
        assert(S_04_7XX = '0') report "When A is not in 0400-07FF range expect S_04_7XX LOW" severity error;
        assert(S_2_3XXX = '0') report "When A is not in 2000-3FFF range expect S_2_3XXX LOW" severity error;
        assert(S_01XX_N = '1') report "When A is not in 01XX range expect S_01XX_N HIGH" severity error;

        A <= x"0400";
        wait for 1 ns;
        assert(S_00_1XX = '0') report "When A is not in 0000-01FF range expect S_00_1XX LOW" severity error;
        assert(S_04_7XX = '1') report "When A is in 0400-07FF range expect S_04_7XX HIGH" severity error;
        assert(S_2_3XXX = '0') report "When A is not in 2000-3FFF range expect S_2_3XXX LOW" severity error;
        assert(S_01XX_N = '1') report "When A is not in 01XX range expect S_01XX_N HIGH" severity error;

        A <= x"07FF";
        wait for 1 ns;
        assert(S_00_1XX = '0') report "When A is not in 0000-01FF range expect S_00_1XX LOW" severity error;
        assert(S_04_7XX = '1') report "When A is in 0400-07FF range expect S_04_7XX HIGH" severity error;
        assert(S_2_3XXX = '0') report "When A is not in 2000-3FFF range expect S_2_3XXX LOW" severity error;
        assert(S_01XX_N = '1') report "When A is not in 01XX range expect S_01XX_N HIGH" severity error;

        A <= x"2000";
        wait for 1 ns;
        assert(S_00_1XX = '0') report "When A is not in 0000-01FF range expect S_00_1XX LOW" severity error;
        assert(S_04_7XX = '0') report "When A is not in 0400-07FF range expect S_04_7XX LOW" severity error;
        assert(S_2_3XXX = '1') report "When A is in 2000-3FFF range expect S_2_3XXX HIGH" severity error;
        assert(S_01XX_N = '1') report "When A is not in 01XX range expect S_01XX_N HIGH" severity error;

        A <= x"3FFF";
        wait for 1 ns;
        assert(S_00_1XX = '0') report "When A is not in 0000-01FF range expect S_00_1XX LOW" severity error;
        assert(S_04_7XX = '0') report "When A is not in 0400-07FF range expect S_04_7XX LOW" severity error;
        assert(S_2_3XXX = '1') report "When A is in 2000-3FFF range expect S_2_3XXX HIGH" severity error;
        assert(S_01XX_N = '1') report "When A is not in 01XX range expect S_01XX_N HIGH" severity error;

        A <= x"4FFF";
        wait for 1 ns;
        assert(S_00_1XX = '0') report "When A is not in 0000-01FF range expect S_00_1XX LOW" severity error;
        assert(S_04_7XX = '0') report "When A is not in 0400-07FF range expect S_04_7XX LOW" severity error;
        assert(S_2_3XXX = '0') report "When A is not in 2000-3FFF range expect S_2_3XXX LOW" severity error;
        assert(S_01XX_N = '1') report "When A is not in 01XX range expect S_01XX_N HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end TESTBENCH;
