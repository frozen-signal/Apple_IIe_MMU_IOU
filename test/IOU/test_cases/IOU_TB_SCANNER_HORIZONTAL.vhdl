library IEEE;
library work;
use work.all;

configuration IOU_TB_SCANNER_HORIZONTAL of IOU_TB_SCANNER_HORIZONTAL_ENTITY is
    for IOU_TB_SCANNER_HORIZONTAL
        for c_iou : IOU
            use entity work.IOU(RTL);
            for RTL
                for U_VIDEO_SCANNER : VIDEO_SCANNER
                    use entity VIDEO_SCANNER_SPY(SPY);
                end for;
                for U_VIDEO_ADDR_MUX : VIDEO_ADDR_MUX
                    use entity VIDEO_ADDR_MUX_SPY(SPY);
                end for;
                for U_POWER_ON_DETECTION : POWER_ON_DETECTION
                    use entity POWER_ON_DETECTION_MOCK(MOCK);
                end for;
                for U_IOU_INTERNALS : IOU_INTERNALS
                    use entity IOU_INTERNALS_SPY(SPY);
                end for;
                for U_IOU_RESET : IOU_RESET
                    use entity IOU_RESET_SPY(SPY);
                end for;
            end for;
        end for;
    end for;
end IOU_TB_SCANNER_HORIZONTAL;

library IEEE;
library work;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.TEST_UTILS.all;
use work.IOU_TESTBENCH_PACKAGE.all;
use work.all;

entity IOU_TB_SCANNER_HORIZONTAL_ENTITY is
    -- empty
end IOU_TB_SCANNER_HORIZONTAL_ENTITY;

architecture IOU_TB_SCANNER_HORIZONTAL of IOU_TB_SCANNER_HORIZONTAL_ENTITY is

    component HAL_TIMING_MOCK is
        port (
            FINISHED : in std_logic;

            CLK_14M : inout std_logic;
            PHI_0   : out std_logic;
            Q3      : out std_logic;
            RAS_N   : out std_logic
        );
    end component;

    component IOU is
        port (
            PHI_0      : in std_logic;
            Q3         : in std_logic;
            PRAS_N     : in std_logic;
            R_W_N      : in std_logic;
            C0XX_N     : in std_logic;
            VID6, VID7 : in std_logic;
            A6         : in std_logic;
            IKSTRB     : in std_logic;
            IAKD       : in std_logic;

            PIN_RESET_N : inout std_logic;
            ORA6, ORA5, ORA4, ORA3,
            ORA2, ORA1, ORA0 : inout std_logic;

            ORA7               : out std_logic;
            H0                 : out std_logic;
            SEGA, SEGB, SEGC   : out std_logic;
            LGR_TXT_N          : out std_logic;
            MD7                : out std_logic;
            SPKR               : out std_logic;
            CASSO              : out std_logic;
            AN0, AN1, AN2, AN3 : out std_logic;
            S_80COL_N          : out std_logic;
            RA9_N, RA10_N      : out std_logic;
            CLRGAT_N           : out std_logic;
            SYNC_N             : out std_logic;
            WNDW_N             : out std_logic
        );
    end component;

    procedure assertNextHValues(constant expected_value : in std_logic_vector(6 downto 0);
                                constant chr_num        : integer;
                                signal PHI_0            : in std_logic) is
    begin
        wait until falling_edge(PHI_0);
        wait for 1 ns;
        assert((TB_HPE_N & TB_H5 & TB_H4 & TB_H3 & TB_H2 & TB_H1 & TB_H0) = expected_value)
        report "Horizontal P543210 for CHR " & integer'image(chr_num) & " incorrect." severity error;
    end procedure;

signal CLK_14M : std_logic := '0';
signal PHI_0   : std_logic := '1';
signal Q3      : std_logic := '1';
signal PRAS_N  : std_logic;

signal FINISHED : std_logic := '0';

signal R_W_N, C0XX_N, VID6, VID7, A6, IKSTRB, IAKD, PIN_RESET_N,
ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, ORA7, H0, SEGA, SEGB, SEGC, LGR_TXT_N,
MD7, SPKR, CASSO, AN0, AN1, AN2, AN3, S_80COL_N, RA9_N, RA10_N, CLRGAT_N, SYNC_N, WNDW_N : std_logic;
begin
hal_mock : HAL_TIMING_MOCK port map(
    FINISHED => FINISHED,
    CLK_14M  => CLK_14M,
    PHI_0    => PHI_0,
    Q3       => Q3,
    RAS_N    => PRAS_N
);

c_iou : IOU port map(
    PHI_0       => PHI_0,
    Q3          => Q3,
    PRAS_N      => PRAS_N,
    R_W_N       => R_W_N,
    C0XX_N      => C0XX_N,
    VID6        => VID6,
    VID7        => VID7,
    A6          => A6,
    IKSTRB      => IKSTRB,
    IAKD        => IAKD,
    PIN_RESET_N => PIN_RESET_N,
    ORA6        => ORA6,
    ORA5        => ORA5,
    ORA4        => ORA4,
    ORA3        => ORA3,
    ORA2        => ORA2,
    ORA1        => ORA1,
    ORA0        => ORA0,
    ORA7        => ORA7,
    H0          => H0,
    SEGA        => SEGA,
    SEGB        => SEGB,
    SEGC        => SEGC,
    LGR_TXT_N   => LGR_TXT_N,
    MD7         => MD7,
    SPKR        => SPKR,
    CASSO       => CASSO,
    AN0         => AN0,
    AN1         => AN1,
    AN2         => AN2,
    AN3         => AN3,
    S_80COL_N   => S_80COL_N,
    RA9_N       => RA9_N,
    RA10_N      => RA10_N,
    CLRGAT_N    => CLRGAT_N,
    SYNC_N      => SYNC_N,
    WNDW_N      => WNDW_N
);

process begin
    TB_FORCE_POC_N <= '0';
    wait for 1 ns;
    TB_FORCE_POC_N <= '1';
    wait for 1 ns;

    wait until falling_edge(TB_FORCE_RESET_N_LOW);
    wait until rising_edge(TB_VBL_N);
    wait until falling_edge(TB_HBL);

    -- "Understanding the Apple IIe" by Jim Sather, P 3-15, "HORIZONTAL SCANNING" table.
    assertNextHValues("1011000", 0, PHI_0);
    assertNextHValues("1011001", 1, PHI_0);
    assertNextHValues("1011010", 2, PHI_0);
    assertNextHValues("1011011", 3, PHI_0);
    assertNextHValues("1011100", 4, PHI_0);
    assertNextHValues("1011101", 5, PHI_0);
    assertNextHValues("1011110", 6, PHI_0);
    assertNextHValues("1011111", 7, PHI_0);
    assertNextHValues("1100000", 8, PHI_0);
    assertNextHValues("1100001", 9, PHI_0);
    assertNextHValues("1100010", 10, PHI_0);
    assertNextHValues("1100011", 11, PHI_0);
    assertNextHValues("1100100", 12, PHI_0);
    assertNextHValues("1100101", 13, PHI_0);
    assertNextHValues("1100110", 14, PHI_0);
    assertNextHValues("1100111", 15, PHI_0);
    assertNextHValues("1101000", 16, PHI_0);
    assertNextHValues("1101001", 17, PHI_0);
    assertNextHValues("1101010", 18, PHI_0);
    assertNextHValues("1101011", 19, PHI_0);
    assertNextHValues("1101100", 20, PHI_0);
    assertNextHValues("1101101", 21, PHI_0);
    assertNextHValues("1101110", 22, PHI_0);
    assertNextHValues("1101111", 23, PHI_0);
    assertNextHValues("1110000", 24, PHI_0);
    assertNextHValues("1110001", 25, PHI_0);
    assertNextHValues("1110010", 26, PHI_0);
    assertNextHValues("1110011", 27, PHI_0);
    assertNextHValues("1110100", 28, PHI_0);
    assertNextHValues("1110101", 29, PHI_0);
    assertNextHValues("1110110", 30, PHI_0);
    assertNextHValues("1110111", 31, PHI_0);
    assertNextHValues("1111000", 32, PHI_0);
    assertNextHValues("1111001", 33, PHI_0);
    assertNextHValues("1111010", 34, PHI_0);
    assertNextHValues("1111011", 35, PHI_0);
    assertNextHValues("1111100", 36, PHI_0);
    assertNextHValues("1111101", 37, PHI_0);
    assertNextHValues("1111110", 38, PHI_0);
    assertNextHValues("1111111", 39, PHI_0);
    assertNextHValues("0000000", 40, PHI_0);
    assertNextHValues("1000000", 41, PHI_0);
    assertNextHValues("1000001", 42, PHI_0);
    assertNextHValues("1000010", 43, PHI_0);
    assertNextHValues("1000011", 44, PHI_0);
    assertNextHValues("1000100", 45, PHI_0);
    assertNextHValues("1000101", 46, PHI_0);
    assertNextHValues("1000110", 47, PHI_0);
    assertNextHValues("1000111", 48, PHI_0);
    assertNextHValues("1001000", 49, PHI_0);
    assertNextHValues("1001001", 50, PHI_0);
    assertNextHValues("1001010", 51, PHI_0);
    assertNextHValues("1001011", 52, PHI_0);
    assertNextHValues("1001100", 53, PHI_0);
    assertNextHValues("1001101", 54, PHI_0);
    assertNextHValues("1001110", 55, PHI_0);
    assertNextHValues("1001111", 56, PHI_0);
    assertNextHValues("1010000", 57, PHI_0);
    assertNextHValues("1010001", 58, PHI_0);
    assertNextHValues("1010010", 59, PHI_0);
    assertNextHValues("1010011", 60, PHI_0);
    assertNextHValues("1010100", 61, PHI_0);
    assertNextHValues("1010101", 62, PHI_0);
    assertNextHValues("1010110", 63, PHI_0);
    assertNextHValues("1010111", 64, PHI_0);

    FINISHED <= '1';
    assert false report "Test done." severity note;
    wait;

end process;
end IOU_TB_SCANNER_HORIZONTAL;
