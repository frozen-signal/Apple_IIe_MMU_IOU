library IEEE;
library work;
use work.all;

configuration IOU_TB_RESET_N_POWER_ON of IOU_TEST_RESET_N_POWER_ON_ENTITY is
    for IOU_TB_RESET_N_POWER_ON
        for c_iou : IOU
            use entity work.IOU(RTL);
            for RTL
                for U_VIDEO_SCANNER : VIDEO_SCANNER
                    use entity VIDEO_SCANNER_SPY(SPY);
                end for;
            end for;
        end for;
    end for;
end IOU_TB_RESET_N_POWER_ON;

library IEEE;
library work;
use IEEE.std_logic_1164.all;
use work.TEST_UTILS.all;
use work.IOU_TESTBENCH_PACKAGE.all;
use work.all;

entity IOU_TEST_RESET_N_POWER_ON_ENTITY is
    -- empty
end IOU_TEST_RESET_N_POWER_ON_ENTITY;

architecture IOU_TB_RESET_N_POWER_ON of IOU_TEST_RESET_N_POWER_ON_ENTITY is

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

    signal CLK_14M : std_logic := '0';
    signal PHI_0   : std_logic := '1';
    signal Q3      : std_logic := '1';
    signal PRAS_N  : std_logic;

    signal FINISHED : std_logic := '0';

    signal R_W_N, C0XX_N, VID6, VID7, A6, IKSTRB, IAKD, PIN_RESET_N,
        ORA6, ORA5, ORA4, ORA3, ORA2, ORA1, ORA0, ORA7, H0, SEGA, SEGB, SEGC, LGR_TXT_N,
        MD7, SPKR, CASSO, AN0, AN1, AN2, AN3, S_80COL_N, RA9_N, RA10_N, CLRGAT_N, SYNC_N, WNDW_N : std_logic;

    signal HAS_RESET_N_REMAINED_LOW : std_logic := '1';
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

        wait until rising_edge(PHI_0);

        if PIN_RESET_N /= '0' then
            HAS_RESET_N_REMAINED_LOW <= '0';
        end if;

        wait until rising_edge(TB_TC);
        wait for 1 ns;

        assert(HAS_RESET_N_REMAINED_LOW = '1') report "RESET_N should have remained LOW" severity error;

        wait until rising_edge(PHI_0);
        wait for 1 ns;

        assert(PIN_RESET_N = 'Z') report "RESET_N should be High-Z" severity error;

        FINISHED <= '1';
        assert false report "Test done." severity note;
        wait;

    end process;
end IOU_TB_RESET_N_POWER_ON;
