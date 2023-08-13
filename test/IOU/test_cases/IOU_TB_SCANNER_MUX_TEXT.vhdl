library IEEE;
library work;
use work.all;

configuration IOU_TB_SCANNER_MUX_TEXT of IOU_TB_SCANNER_MUX_TEXT_ENTITY is
    for IOU_TB_SCANNER_MUX_TEXT
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
end IOU_TB_SCANNER_MUX_TEXT;

library IEEE;
library work;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.TEST_UTILS.all;
use work.IOU_TESTBENCH_PACKAGE.all;
use work.all;

entity IOU_TB_SCANNER_MUX_TEXT_ENTITY is
    -- empty
end IOU_TB_SCANNER_MUX_TEXT_ENTITY;

architecture IOU_TB_SCANNER_MUX_TEXT of IOU_TB_SCANNER_MUX_TEXT_ENTITY is

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

    -- This procedure test a single horizontal line in text mode. An important thing to note is that the addresses wrap around their
    -- 128 byte segment. The first segment starts at $0400 for page 1, and the others following segments starts at $80 increments.
    -- So the second segment is at $0480, the third at $0500 and so on. Page 2 follows the same logic, but starts at $0800.
    -- The wrap around means that the address following $047F is not $0480, but $0400. In other words, when scanning a line the address(15 downto 7)
    -- remains the same for the totality of the line.
    --
    -- Also note that address ORA0-7 during ROW and COLUMN strobe are not in a 'naive' order; they are not ROW OAR7-0 for address low bits and COLUMN ORA7-0 for
    -- address high bits.
    procedure assertNextLine(constant txt_line_num                                 : integer;
                             constant expected_first_display_addr                  : in std_logic_vector(15 downto 0);
                             constant expected_first_hbl_addr                      : in std_logic_vector(15 downto 0);
                             constant expect_wrap                                  : in std_logic;
                             signal ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0 : in std_logic;
                             signal PRAS_N                                         : in std_logic) is
        variable row_real_ora : std_logic_vector(7 downto 0);
        variable col_real_ora : std_logic_vector(7 downto 0);
        variable real_ora : std_logic_vector(15 downto 0);
        variable expected_ora_display : std_logic_vector(15 downto 0);
        variable expected_ora_hbl : std_logic_vector(15 downto 0);
    begin
        for scan_line in 1 to 8 loop
            expected_ora_display := expected_first_display_addr;
            expected_ora_hbl := expected_first_hbl_addr;

            -- 'Burn' the address when HPE_N is LOW
            wait until falling_edge(TB_RA_ENABLE_N);
            assert(TB_HPE_N = '0') report "Expected HPE_N to be LOW." severity error;

            -- Addresses during horizontal blanking
            for chr_num in 0 to 23 loop
                wait until falling_edge(TB_RA_ENABLE_N);
                wait for 1 ns;

                row_real_ora(7 downto 0) := ORA7 & ORA6 & ORA5 & ORA4 & ORA3 & ORA2 & ORA1 & ORA0;

                wait until falling_edge(PRAS_N);
                wait for 1 ns;
                col_real_ora(7 downto 0) := ORA7 & ORA6 & ORA5 & ORA4 & ORA3 & ORA2 & ORA1 & ORA0;

                real_ora(15 downto 0) := col_real_ora(7 downto 2)   -- '0' & ZE downto ZA
                                       & col_real_ora(0)            -- V2
                                       & row_real_ora(7)            -- V1
                                       & row_real_ora(6)            -- V0
                                       & col_real_ora(1)            -- E3
                                       & row_real_ora(5 downto 0);  -- E2 downto E0 & H2 downto H0

                assert(TB_HBL = '1') report "Expected to be in horizontal blanking." severity error;
                assert(real_ora = expected_ora_hbl)
                    report "Incorrect address (horizontal blanking). Expected: " & to_hstring(expected_ora_hbl) & " Got: " & to_hstring(real_ora) & " at text line "
                        & integer'image(txt_line_num) & " scan line " & integer'image(scan_line) & " chr index " & integer'image(chr_num) severity error;

                expected_ora_hbl := std_logic_vector(unsigned(expected_ora_hbl) + 1);
                if(expect_wrap = '1') then
                    expected_ora_hbl(15 downto 7) := expected_first_display_addr(15 downto 7);
                end if;
            end loop;

            -- Addresses of displayed characters
            for chr_num in 0 to 39 loop
                wait until falling_edge(TB_RA_ENABLE_N);
                wait for 1 ns;

                row_real_ora(7 downto 0) := ORA7 & ORA6 & ORA5 & ORA4 & ORA3 & ORA2 & ORA1 & ORA0;

                wait until falling_edge(PRAS_N);
                wait for 1 ns;
                col_real_ora(7 downto 0) := ORA7 & ORA6 & ORA5 & ORA4 & ORA3 & ORA2 & ORA1 & ORA0;

                real_ora(15 downto 0) := col_real_ora(7 downto 2)   -- '0' & ZE downto ZA
                                       & col_real_ora(0)            -- V2
                                       & row_real_ora(7)            -- V1
                                       & row_real_ora(6)            -- V0
                                       & col_real_ora(1)            -- E3
                                       & row_real_ora(5 downto 0);  -- E2 downto E0 & H2 downto H0

                assert(TB_HBL = '0') report "Unexpected horizontal blanking during scanning." severity error;
                assert(real_ora = expected_ora_display)
                    report "Incorrect address (displayed). Expected: " & to_hstring(expected_ora_display) & " Got: " & to_hstring(real_ora) & " at text line "
                        & integer'image(txt_line_num) & " scan line " & integer'image(scan_line) & " chr index " & integer'image(chr_num) severity error;

                expected_ora_display := std_logic_vector(unsigned(expected_ora_display) + 1);
                if(expect_wrap = '1') then
                    expected_ora_display(15 downto 7) := expected_first_display_addr(15 downto 7);
                end if;
            end loop;
        end loop;
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
        wait until falling_edge(TB_TC);
        wait until rising_edge(TB_VBL_N);

        -- "Understanding the Apple IIe" by Jim Sather, P 5-12
        -- Screen top
        assertNextLine(0, x"0400", x"0468", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(1, x"0480", x"04E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(2, x"0500", x"0568", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(3, x"0580", x"05E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(4, x"0600", x"0668", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(5, x"0680", x"06E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(6, x"0700", x"0768", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(7, x"0780", x"07E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        -- Screen middle
        assertNextLine(8, x"0428", x"0410", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(9, x"04A8", x"0490", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(10, x"0528", x"0510", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(11, x"05A8", x"0590", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(12, x"0628", x"0610", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(13, x"06A8", x"0690", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(14, x"0728", x"0710", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(15, x"07A8", x"0790", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(16, x"0450", x"0438", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        -- Screen bottom
        assertNextLine(17, x"04D0", x"04B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(18, x"0550", x"0538", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(19, x"05D0", x"05B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(20, x"0650", x"0638", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(21, x"06D0", x"06B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(22, x"0750", x"0738", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(23, x"07D0", x"07B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        -- Vertical blanking
        assertNextLine(24, x"0478", x"0460", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(25, x"04F8", x"04E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(26, x"0578", x"0560", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(27, x"05F8", x"05E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(28, x"0678", x"0660", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(29, x"06F8", x"06E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(30, x"0778", x"0760", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(31, x"07F8", x"07E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        FINISHED <= '1';
        assert false report "Test done." severity note;
        wait;

    end process;
end IOU_TB_SCANNER_MUX_TEXT;
