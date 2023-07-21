library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity VIDEO_GENERATOR is
    port (
        P_PHI_1    : in std_logic;
        H3, H4, H5 : in std_logic;
        V3, V4     : in std_logic;
        VID6, VID7 : in std_logic;
        LGR_TXT_N  : in std_logic;
        PAYMAR     : in std_logic;
        FLASH      : in std_logic;
        PCLRGAT    : in std_logic;
        PSYNC_N    : in std_logic;

        E0, E1, E2, E3 : out std_logic;
        CLRGAT_N       : out std_logic;
        SYNC_N         : out std_logic;
        RA9_N          : out std_logic;
        RA10_N         : out std_logic
    );
end VIDEO_GENERATOR;

architecture RTL of VIDEO_GENERATOR is
    signal K8_6   : std_logic;
    signal K8_8   : std_logic;
    signal L9_13  : std_logic;
    signal K8_3   : std_logic;
    signal H8_8   : std_logic;
    signal N7_8   : std_logic;
    signal VID6_N : std_logic;
    signal L6_6   : std_logic;
    signal H5_N   : std_logic;
    signal H3_N   : std_logic;
    signal SUMS   : unsigned(3 downto 0);
begin
    H3_N <= not H3;
    H5_N <= not H5;

    -- The schematics seems to have some problems with the computation of Σ0, Σ1, Σ2, and Σ3
    -- Instead we use here what is described in "Understanding the Apple IIe" by Jim Sather, P.5-9:
    --                      1
    --    H5'   H5'   H4   H3
    --  + V4    V3    V4   V3
    --    -------------------
    --    Σ3    Σ2    Σ1   Σ0
    --
    -- In the schematics, the location of these elements are:
    --   * almost all of IOU_1 @D-2
    --   * Σ0: IOU_1 @C-2:J8-8
    --   * Σ1: IOU_1 @C-2:J8-6
    --   * Σ2: IOU_1 @D-1:H8-11
    --   * Σ3: IOU_1 @D-1:H8-6

    SUMS <= ("0001" + (H5_N & H5_N & H4 & H3) + (V4 & V3 & V4 & V3));
    E0   <= SUMS(0); -- SUM-A3
    E1   <= SUMS(1); -- SUM-A4
    E2   <= SUMS(2); -- SUM-A5
    E3   <= SUMS(3); -- SUM-A6

    -- IOU_2 @D-4:L9-1
    VID6_N <= not VID6;
    L6_6   <= not (LGR_TXT_N or PAYMAR or VID7);
    RA9_N  <= VID6_N nor L6_6;

    -- IOU_2 @D-4:L8-3
    RA10_N <= (not (VID6_N or PAYMAR or (FLASH or LGR_TXT_N))) or VID7;

    -- IOU_1 @B-2:R7-1
    process (P_PHI_1, PCLRGAT)
    begin
        if (P_PHI_1 = '1') then
            CLRGAT_N <= not PCLRGAT;
        end if;
    end process;

    -- IOU_1 @B-2:R7-15
    process (P_PHI_1, PSYNC_N)
    begin
        if (P_PHI_1 = '1') then
            SYNC_N <= PSYNC_N;
        end if;
    end process;

end RTL;
