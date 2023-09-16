library IEEE;
library work;
use work.all;

configuration IOU_TB_SCANNER_VERTICAL_EUROPEAN of IOU_TB_SCANNER_VERTICAL_EUROPEAN_ENTITY is
    for IOU_TB_SCANNER_VERTICAL_EUROPEAN
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
end IOU_TB_SCANNER_VERTICAL_EUROPEAN;

library IEEE;
library work;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.TEST_UTILS.all;
use work.IOU_TESTBENCH_PACKAGE.all;
use work.all;

entity IOU_TB_SCANNER_VERTICAL_EUROPEAN_ENTITY is
    -- empty
end IOU_TB_SCANNER_VERTICAL_EUROPEAN_ENTITY;

architecture IOU_TB_SCANNER_VERTICAL_EUROPEAN of IOU_TB_SCANNER_VERTICAL_EUROPEAN_ENTITY is

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
        generic(
            NTSC_CONSTANT : std_logic
        );
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

            PIN_RESET_N      : inout std_logic;
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

    procedure assertNextVValues(constant expected_value : in std_logic_vector(6 downto 0);
                                constant line_num       : string) is
        variable real_v : std_logic_vector(8 downto 0);
    begin
        wait until falling_edge(TB_RA_ENABLE_N);

        wait until rising_edge(TB_HPE_N);
        real_v := TB_V5 & TB_V4 & TB_V3 & TB_V2 & TB_V1 & TB_V0 & TB_VC & TB_VB & TB_VA;
        assert(real_v = (expected_value & "00"))
        report "Vertical (EUROPEAN) 543210CBA for line (X=00) " & line_num & " incorrect." severity error;

        wait until rising_edge(TB_HPE_N);
        real_v := TB_V5 & TB_V4 & TB_V3 & TB_V2 & TB_V1 & TB_V0 & TB_VC & TB_VB & TB_VA;
        assert(real_v = (expected_value & "01"))
        report "Vertical (EUROPEAN) 543210CBA for line (X=01) " & line_num & " incorrect." severity error;

        wait until rising_edge(TB_HPE_N);
        real_v := TB_V5 & TB_V4 & TB_V3 & TB_V2 & TB_V1 & TB_V0 & TB_VC & TB_VB & TB_VA;
        assert(real_v = (expected_value & "10"))
        report "Vertical (EUROPEAN) 543210CBA for line (X=10) " & line_num & " incorrect." severity error;

        wait until rising_edge(TB_HPE_N);
        real_v := TB_V5 & TB_V4 & TB_V3 & TB_V2 & TB_V1 & TB_V0 & TB_VC & TB_VB & TB_VA;
        assert(real_v = (expected_value & "11"))
        report "Vertical (EUROPEAN) 543210CBA for line (X=11) " & line_num & " incorrect." severity error;

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

    c_iou : IOU
    generic map (
        NTSC_CONSTANT => '0'
    )
    port map(
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
        wait until falling_edge(TB_TC);

        -- "Understanding the Apple IIe" by Jim Sather, P 3-15, "EUROPEAN VERTICAL SCANNING" table.
        assertNextVValues("0110010", "256-259");
        assertNextVValues("0110011", "260-263");
        assertNextVValues("0110100", "264-267");
        assertNextVValues("0110101", "268-271");
        assertNextVValues("0110110", "262-275");
        assertNextVValues("0110111", "266-279");
        assertNextVValues("0111000", "280-283");
        assertNextVValues("0111001", "284-287");
        assertNextVValues("0111010", "288-291");
        assertNextVValues("0111011", "292-295");
        assertNextVValues("0111100", "296-299");
        assertNextVValues("0111101", "300-303");
        assertNextVValues("0111110", "304-307");
        assertNextVValues("0111111", "308-311");
        assertNextVValues("1000000", "000-003");
        assertNextVValues("1000001", "004-007");
        assertNextVValues("1000010", "008-011");
        assertNextVValues("1000011", "012-015");
        assertNextVValues("1000100", "016-019");
        assertNextVValues("1000101", "020-023");
        assertNextVValues("1000110", "024-027");
        assertNextVValues("1000111", "028-031");
        assertNextVValues("1001000", "032-035");
        assertNextVValues("1001001", "036-039");
        assertNextVValues("1001010", "040-043");
        assertNextVValues("1001011", "044-047");
        assertNextVValues("1001100", "048-051");
        assertNextVValues("1001101", "052-055");
        assertNextVValues("1001110", "056-059");
        assertNextVValues("1001111", "060-063");
        assertNextVValues("1010000", "064-067");
        assertNextVValues("1010001", "068-071");
        assertNextVValues("1010010", "072-075");
        assertNextVValues("1010011", "076-079");
        assertNextVValues("1010100", "080-083");
        assertNextVValues("1010101", "084-087");
        assertNextVValues("1010110", "088-091");
        assertNextVValues("1010111", "092-095");
        assertNextVValues("1011000", "096-099");
        assertNextVValues("1011001", "100-103");
        assertNextVValues("1011010", "104-107");
        assertNextVValues("1011011", "108-111");
        assertNextVValues("1011100", "112-115");
        assertNextVValues("1011101", "116-119");
        assertNextVValues("1011110", "120-123");
        assertNextVValues("1011111", "124-127");
        assertNextVValues("1100000", "128-131");
        assertNextVValues("1100001", "132-135");
        assertNextVValues("1100010", "136-139");
        assertNextVValues("1100011", "140-143");
        assertNextVValues("1100100", "144-147");
        assertNextVValues("1100101", "148-151");
        assertNextVValues("1100110", "152-155");
        assertNextVValues("1100111", "156-159");
        assertNextVValues("1101000", "160-163");
        assertNextVValues("1101001", "164-167");
        assertNextVValues("1101010", "168-171");
        assertNextVValues("1101011", "172-175");
        assertNextVValues("1101100", "176-179");
        assertNextVValues("1101101", "180-183");
        assertNextVValues("1101110", "184-187");
        assertNextVValues("1101111", "188-191");
        assertNextVValues("1110000", "192-195");
        assertNextVValues("1110001", "196-199");
        assertNextVValues("1110010", "200-203");
        assertNextVValues("1110011", "204-207");
        assertNextVValues("1110100", "208-211");
        assertNextVValues("1110101", "212-215");
        assertNextVValues("1110110", "216-219");
        assertNextVValues("1110111", "220-223");
        assertNextVValues("1111000", "224-227");
        assertNextVValues("1111001", "228-231");
        assertNextVValues("1111010", "232-235");
        assertNextVValues("1111011", "236-239");
        assertNextVValues("1111100", "240-243");
        assertNextVValues("1111101", "244-247");
        assertNextVValues("1111110", "248-251");
        assertNextVValues("1111111", "252-255");

        FINISHED <= '1';
        assert false report "Test done." severity note;
        wait;

    end process;
end IOU_TB_SCANNER_VERTICAL_EUROPEAN;
