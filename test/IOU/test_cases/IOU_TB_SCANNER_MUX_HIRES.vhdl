library IEEE;
library work;
use work.all;

configuration IOU_TB_SCANNER_MUX_HIRES of IOU_TB_SCANNER_MUX_HIRES_ENTITY is
    for IOU_TB_SCANNER_MUX_HIRES
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
end IOU_TB_SCANNER_MUX_HIRES;

library IEEE;
library work;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.TEST_UTILS.all;
use work.IOU_TESTBENCH_PACKAGE.all;
use work.all;

entity IOU_TB_SCANNER_MUX_HIRES_ENTITY is
    -- empty
end IOU_TB_SCANNER_MUX_HIRES_ENTITY;

architecture IOU_TB_SCANNER_MUX_HIRES of IOU_TB_SCANNER_MUX_HIRES_ENTITY is

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

    procedure assertNextLine(constant line_num                                     : integer;
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
        expected_ora_display := expected_first_display_addr;
        expected_ora_hbl := expected_first_hbl_addr;

        -- 'Burn' the address when HPE_N is LOW
        wait until falling_edge(TB_RA_ENABLE_N);
        assert(TB_HPE_N = '0') report "Expected HPE_N to be LOW." severity error;

        -- Addresses during horizontal blanking
        for byte_num in 0 to 23 loop
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
                report "Incorrect address (horizontal blanking). Expected: " & to_hstring(expected_ora_hbl) & " Got: " & to_hstring(real_ora) & " at line "
                    & integer'image(line_num) & " byte index " & integer'image(byte_num) severity error;

            expected_ora_hbl := std_logic_vector(unsigned(expected_ora_hbl) + 1);
            if(expect_wrap = '1') then
                expected_ora_hbl(15 downto 7) := expected_first_display_addr(15 downto 7);
            end if;
        end loop;

        -- Addresses of displayed characters
        for byte_num in 0 to 39 loop
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
                report "Incorrect address (displayed). Expected: " & to_hstring(expected_ora_display) & " Got: " & to_hstring(real_ora) & " at line "
                    & integer'image(line_num) & " byte index " & integer'image(byte_num) severity error;

            expected_ora_display := std_logic_vector(unsigned(expected_ora_display) + 1);
            if(expect_wrap = '1') then
                expected_ora_display(15 downto 7) := expected_first_display_addr(15 downto 7);
            end if;
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


        -- SET HIRES (Write $C057)
        wait until falling_edge(PHI_0);
        ORA0 <= '1';
        ORA1 <= '1';
        ORA2 <= '1';
        ORA3 <= '0';
        ORA4 <= '1';
        ORA5 <= '0';
        ORA6 <= '0';
        ORA7 <= '0';
        R_W_N     <= '0';
        C0XX_N    <= '0';
        A6        <= '1';
        wait until rising_edge(PRAS_N);
        wait until rising_edge(PHI_0);
        C0XX_N <= '1';
        wait until falling_edge(Q3);
        ORA0 <= 'Z';
        ORA1 <= 'Z';
        ORA2 <= 'Z';
        ORA3 <= 'Z';
        ORA4 <= 'Z';
        ORA5 <= 'Z';
        ORA6 <= 'Z';
        ORA7 <= 'Z';

        wait until falling_edge(TB_TC);
        wait until rising_edge(TB_VBL_N);

        -- "Understanding the Apple IIe" by Jim Sather, P 5-15 to 5-18
        -- Screen top
        assertNextLine(0, x"2000", x"2068", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(1, x"2400", x"2468", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(2, x"2800", x"2868", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(3, x"2C00", x"2C68", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(4, x"3000", x"3068", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(5, x"3400", x"3468", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(6, x"3800", x"3868", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(7, x"3C00", x"3C68", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(8, x"2080", x"20E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(9, x"2480", x"24E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(10, x"2880", x"28E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(11, x"2C80", x"2CE8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(12, x"3080", x"30E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(13, x"3480", x"34E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(14, x"3880", x"38E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(15, x"3C80", x"3CE8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(16, x"2100", x"2168", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(17, x"2500", x"2568", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(18, x"2900", x"2968", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(19, x"2D00", x"2D68", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(20, x"3100", x"3168", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(21, x"3500", x"3568", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(22, x"3900", x"3968", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(23, x"3D00", x"3D68", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(24, x"2180", x"21E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(25, x"2580", x"25E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(26, x"2980", x"29E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(27, x"2D80", x"2DE8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(28, x"3180", x"31E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(29, x"3580", x"35E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(30, x"3980", x"39E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(31, x"3D80", x"3DE8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(32, x"2200", x"2268", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(33, x"2600", x"2668", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(34, x"2A00", x"2A68", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(35, x"2E00", x"2E68", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(36, x"3200", x"3268", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(37, x"3600", x"3668", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(38, x"3A00", x"3A68", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(39, x"3E00", x"3E68", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(40, x"2280", x"22E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(41, x"2680", x"26E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(42, x"2A80", x"2AE8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(43, x"2E80", x"2EE8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(44, x"3280", x"32E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(45, x"3680", x"36E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(46, x"3A80", x"3AE8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(47, x"3E80", x"3EE8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(48, x"2300", x"2368", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(49, x"2700", x"2768", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(50, x"2B00", x"2B68", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(51, x"2F00", x"2F68", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(52, x"3300", x"3368", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(53, x"3700", x"3768", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(54, x"3B00", x"3B68", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(55, x"3F00", x"3F68", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(56, x"2380", x"23E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(57, x"2780", x"27E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(58, x"2B80", x"2BE8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(59, x"2F80", x"2FE8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(60, x"3380", x"33E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(61, x"3780", x"37E8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(62, x"3B80", x"3BE8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(63, x"3F80", x"3FE8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        -- Screen middle
        assertNextLine(64, x"2028", x"2010", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(65, x"2428", x"2410", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(66, x"2828", x"2810", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(67, x"2C28", x"2C10", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(68, x"3028", x"3010", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(69, x"3428", x"3410", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(70, x"3828", x"3810", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(71, x"3C28", x"3C10", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(72, x"20A8", x"2090", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(73, x"24A8", x"2490", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(74, x"28A8", x"2890", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(75, x"2CA8", x"2C90", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(76, x"30A8", x"3090", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(77, x"34A8", x"3490", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(78, x"38A8", x"3890", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(79, x"3CA8", x"3C90", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(80, x"2128", x"2110", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(81, x"2528", x"2510", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(82, x"2928", x"2910", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(83, x"2D28", x"2D10", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(84, x"3128", x"3110", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(85, x"3528", x"3510", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(86, x"3928", x"3910", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(87, x"3D28", x"3D10", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(88, x"21A8", x"2190", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(89, x"25A8", x"2590", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(90, x"29A8", x"2990", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(91, x"2DA8", x"2D90", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(92, x"31A8", x"3190", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(93, x"35A8", x"3590", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(94, x"39A8", x"3990", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(95, x"3DA8", x"3D90", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(96, x"2228", x"2210", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(97, x"2628", x"2610", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(98, x"2A28", x"2A10", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(99, x"2E28", x"2E10", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(100, x"3228", x"3210", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(101, x"3628", x"3610", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(102, x"3A28", x"3A10", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(103, x"3E28", x"3E10", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(104, x"22A8", x"2290", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(105, x"26A8", x"2690", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(106, x"2AA8", x"2A90", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(107, x"2EA8", x"2E90", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(108, x"32A8", x"3290", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(109, x"36A8", x"3690", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(110, x"3AA8", x"3A90", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(111, x"3EA8", x"3E90", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(112, x"2328", x"2310", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(113, x"2728", x"2710", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(114, x"2B28", x"2B10", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(115, x"2F28", x"2F10", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(116, x"3328", x"3310", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(117, x"3728", x"3710", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(118, x"3B28", x"3B10", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(119, x"3F28", x"3F10", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(120, x"23A8", x"2390", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(121, x"27A8", x"2790", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(122, x"2BA8", x"2B90", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(123, x"2FA8", x"2F90", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(124, x"33A8", x"3390", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(125, x"37A8", x"3790", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(126, x"3BA8", x"3B90", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(127, x"3FA8", x"3F90", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        -- Screen bottom
        assertNextLine(128, x"2050", x"2038", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(129, x"2450", x"2438", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(130, x"2850", x"2838", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(131, x"2C50", x"2C38", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(132, x"3050", x"3038", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(133, x"3450", x"3438", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(134, x"3850", x"3838", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(135, x"3C50", x"3C38", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(136, x"20D0", x"20B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(137, x"24D0", x"24B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(138, x"28D0", x"28B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(139, x"2CD0", x"2CB8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(140, x"30D0", x"30B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(141, x"34D0", x"34B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(142, x"38D0", x"38B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(143, x"3CD0", x"3CB8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(144, x"2150", x"2138", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(145, x"2550", x"2538", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(146, x"2950", x"2938", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(147, x"2D50", x"2D38", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(148, x"3150", x"3138", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(149, x"3550", x"3538", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(150, x"3950", x"3938", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(151, x"3D50", x"3D38", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(152, x"21D0", x"21B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(153, x"25D0", x"25B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(154, x"29D0", x"29B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(155, x"2DD0", x"2DB8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(156, x"31D0", x"31B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(157, x"35D0", x"35B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(158, x"39D0", x"39B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(159, x"3DD0", x"3DB8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(160, x"2250", x"2238", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(161, x"2650", x"2638", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(162, x"2A50", x"2A38", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(163, x"2E50", x"2E38", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(164, x"3250", x"3238", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(165, x"3650", x"3638", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(166, x"3A50", x"3A38", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(167, x"3E50", x"3E38", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(168, x"22D0", x"22B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(169, x"26D0", x"26B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(170, x"2AD0", x"2AB8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(171, x"2ED0", x"2EB8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(172, x"32D0", x"32B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(173, x"36D0", x"36B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(174, x"3AD0", x"3AB8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(175, x"3ED0", x"3EB8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(176, x"2350", x"2338", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(177, x"2750", x"2738", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(178, x"2B50", x"2B38", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(179, x"2F50", x"2F38", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(180, x"3350", x"3338", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(181, x"3750", x"3738", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(182, x"3B50", x"3B38", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(183, x"3F50", x"3F38", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(184, x"23D0", x"23B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(185, x"27D0", x"27B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(186, x"2BD0", x"2BB8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(187, x"2FD0", x"2FB8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(188, x"33D0", x"33B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(189, x"37D0", x"37B8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(190, x"3BD0", x"3BB8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(191, x"3FD0", x"3FB8", '0', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        -- Vertical Blanking Period
        assertNextLine(192, x"2078", x"2060", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(193, x"2478", x"2460", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(194, x"2878", x"2860", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(195, x"2C78", x"2C60", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(196, x"3078", x"3060", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(197, x"3478", x"3460", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(198, x"3878", x"3860", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(199, x"3C78", x"3C60", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(200, x"20F8", x"20E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(201, x"24F8", x"24E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(202, x"28F8", x"28E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(203, x"2CF8", x"2CE0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(204, x"30F8", x"30E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(205, x"34F8", x"34E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(206, x"38F8", x"38E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(207, x"3CF8", x"3CE0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(208, x"2178", x"2160", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(209, x"2578", x"2560", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(210, x"2978", x"2960", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(211, x"2D78", x"2D60", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(212, x"3178", x"3160", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(213, x"3578", x"3560", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(214, x"3978", x"3960", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(215, x"3D78", x"3D60", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(216, x"21F8", x"21E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(217, x"25F8", x"25E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(218, x"29F8", x"29E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(219, x"2DF8", x"2DE0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(220, x"31F8", x"31E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(221, x"35F8", x"35E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(222, x"39F8", x"39E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(223, x"3DF8", x"3DE0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(224, x"2278", x"2260", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(225, x"2678", x"2660", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(226, x"2A78", x"2A60", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(227, x"2E78", x"2E60", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(228, x"3278", x"3260", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(229, x"3678", x"3660", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(230, x"3A78", x"3A60", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(231, x"3E78", x"3E60", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(232, x"22F8", x"22E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(233, x"26F8", x"26E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(234, x"2AF8", x"2AE0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(235, x"2EF8", x"2EE0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(236, x"32F8", x"32E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(237, x"36F8", x"36E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(238, x"3AF8", x"3AE0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(239, x"3EF8", x"3EE0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(240, x"2378", x"2360", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(241, x"2778", x"2760", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(242, x"2B78", x"2B60", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(243, x"2F78", x"2F60", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(244, x"3378", x"3360", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(245, x"3778", x"3760", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(246, x"3B78", x"3B60", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(247, x"3F78", x"3F60", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(248, x"23F8", x"23E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(249, x"27F8", x"27E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(250, x"2BF8", x"2BE0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(251, x"2FF8", x"2FE0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(252, x"33F8", x"33E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(253, x"37F8", x"37E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(254, x"3BF8", x"3BE0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(255, x"3FF8", x"3FE0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        assertNextLine(256, x"2BF8", x"2BE0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(257, x"2FF8", x"2FE0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(258, x"33F8", x"33E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(259, x"37F8", x"37E0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(260, x"3BF8", x"3BE0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);
        assertNextLine(261, x"3FF8", x"3FE0", '1', ORA7, ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, PRAS_N);

        FINISHED <= '1';
        assert false report "Test done." severity note;
        wait;

    end process;
end IOU_TB_SCANNER_MUX_HIRES;
