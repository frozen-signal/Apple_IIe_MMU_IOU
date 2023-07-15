library IEEE;
use IEEE.std_logic_1164.all;

entity VIDEO_SCANNER_TB is
    -- empty
end VIDEO_SCANNER_TB;

architecture VIDEO_SCANNER_TEST of VIDEO_SCANNER_TB is
    component VIDEO_SCANNER is
        port (
            POC_N   : in std_logic;
            NTSC    : in std_logic;
            P_PHI_2 : in std_logic;

            HPE_N                  : out std_logic;
            V5, V4, V3, V2, V1, V0 : out std_logic;
            VC, VB, VA             : out std_logic;
            H5, H4, H3, H2, H1, H0 : out std_logic;
            PAKST                  : out std_logic;
            TC                     : out std_logic;
            TC14S                  : out std_logic;
            FLASH                  : out std_logic
        );
    end component;

    signal POC_N   : std_logic;
    signal NTSC    : std_logic;
    signal P_PHI_2 : std_logic;

    signal TC                     : std_logic;
    signal V5, V4, V3, V2, V1, V0 : std_logic;
    signal HPE_N                  : std_logic := '0';
    signal VC, VB, VA             : std_logic;
    signal H5, H4, H3, H2, H1, H0 : std_logic;
    signal PAKST                  : std_logic;
    signal TC14S                  : std_logic;
    signal FLASH                  : std_logic;

begin
    dut : VIDEO_SCANNER port map(
        POC_N   => POC_N,
        NTSC    => NTSC,
        P_PHI_2 => P_PHI_2,
        V5      => V5,
        V4      => V4,
        V3      => V3,
        V2      => V2,
        V1      => V1,
        V0      => V0,
        HPE_N   => HPE_N,
        TC      => TC,
        VC      => VC,
        VB      => VB,
        VA      => VA,
        H5      => H5,
        H4      => H4,
        H3      => H3,
        H2      => H2,
        H1      => H1,
        H0      => H0,
        PAKST   => PAKST,
        TC14S   => TC14S,
        FLASH   => FLASH
    );

    process
    begin
        -- When POC_N is low, the video scanner should clear its values (asynchronously)
        -- POC_N will be LOW when computer is turned on. This is the only time the video scanner is cleared. ----------
        P_PHI_2 <= '0';
        POC_N   <= '0';
        NTSC    <= '1';
        wait for 1 ns;
        assert(H0 = '0') report "H0 should be LOW" severity error;
        assert(H1 = '0') report "H1 should be LOW" severity error;
        assert(H2 = '0') report "H2 should be LOW" severity error;
        assert(H3 = '0') report "H3 should be LOW" severity error;
        assert(H4 = '0') report "H4 should be LOW" severity error;
        assert(H5 = '0') report "H5 should be LOW" severity error;
        assert(HPE_N = '0') report "HPE_N should be LOW" severity error;
        assert(VA = '0') report "VA should be LOW" severity error;
        assert(VB = '0') report "VB should be LOW" severity error;
        assert(VC = '0') report "VC should be LOW" severity error;
        assert(V0 = '0') report "V0 should be LOW" severity error;
        assert(V1 = '0') report "V1 should be LOW" severity error;
        assert(V2 = '0') report "V2 should be LOW" severity error;
        assert(V3 = '0') report "V3 should be LOW" severity error;
        assert(V4 = '0') report "V4 should be LOW" severity error;
        assert(V5 = '0') report "V5 should be LOW" severity error;
        assert(TC = '0') report "TC should be LOW" severity error;

        -- After POC_N goes HIGH, initial values are loaded.
        POC_N <= '1';
        wait for 489.9634322 ns;
        P_PHI_2 <= '1';
        wait for 489.9634322 ns;
        assert(H0 = '0') report "H0 should be LOW" severity error;
        assert(H1 = '0') report "H1 should be LOW" severity error;
        assert(H2 = '0') report "H2 should be LOW" severity error;
        assert(H3 = '0') report "H3 should be LOW" severity error;
        assert(H4 = '0') report "H4 should be LOW" severity error;
        assert(H5 = '0') report "H5 should be LOW" severity error;
        assert(HPE_N = '1') report "HPE_N should be HIGH" severity error;
        assert(VA = '0') report "VA should be LOW" severity error;
        -- POC_N HIGH should not cause E9 or F9 to load.
        assert(VB = '0') report "VB should be LOW" severity error;
        assert(VC = '0') report "VC should be LOW" severity error;
        assert(V0 = '0') report "V0 should be LOW" severity error;
        assert(V1 = '0') report "V1 should be LOW" severity error;
        assert(V2 = '0') report "V2 should be LOW" severity error;
        assert(V3 = '0') report "V3 should be LOW" severity error;
        assert(V4 = '0') report "V4 should be LOW" severity error;
        assert(V5 = '0') report "V5 should be LOW" severity error;
        assert(TC = '0') report "TC should be LOW" severity error;

        for i in 1 to 15 loop
            P_PHI_2 <= '0';
            wait for 489.9634322 ns;
            P_PHI_2 <= '1';
            wait for 489.9634322 ns;
        end loop;

        -- C9 should count to 15
        assert(H0 = '1') report "H0 should be HIGH" severity error;
        assert(H1 = '1') report "H1 should be HIGH" severity error;
        assert(H2 = '1') report "H2 should be HIGH" severity error;
        assert(H3 = '1') report "H3 should be HIGH" severity error;
        assert(H4 = '0') report "H4 should be LOW" severity error;
        assert(H5 = '0') report "H5 should be LOW" severity error;
        assert(HPE_N = '1') report "HPE_N should be HIGH" severity error;
        assert(VA = '0') report "VA should be LOW" severity error;
        assert(VB = '0') report "VB should be LOW" severity error;
        assert(VC = '0') report "VC should be LOW" severity error;
        assert(V0 = '0') report "V0 should be LOW" severity error;
        assert(V1 = '0') report "V1 should be LOW" severity error;
        assert(V2 = '0') report "V2 should be LOW" severity error;
        assert(V3 = '0') report "V3 should be LOW" severity error;
        assert(V4 = '0') report "V4 should be LOW" severity error;
        assert(V5 = '0') report "V5 should be LOW" severity error;
        assert(TC = '0') report "TC should be LOW" severity error;

        P_PHI_2 <= '0';
        wait for 489.9634322 ns;
        P_PHI_2 <= '1';
        wait for 489.9634322 ns;

        -- C9 should rollover and D9 increase 1
        assert(H0 = '0') report "H0 should be LOW" severity error;
        assert(H1 = '0') report "H1 should be LOW" severity error;
        assert(H2 = '0') report "H2 should be LOW" severity error;
        assert(H3 = '0') report "H3 should be LOW" severity error;
        assert(H4 = '1') report "H4 should be HIGH" severity error;
        assert(H5 = '0') report "H5 should be LOW" severity error;
        assert(HPE_N = '1') report "HPE_N should be HIGH" severity error;
        assert(VA = '0') report "VA should be LOW" severity error;
        assert(VB = '0') report "VB should be LOW" severity error;
        assert(VC = '0') report "VC should be LOW" severity error;
        assert(V0 = '0') report "V0 should be LOW" severity error;
        assert(V1 = '0') report "V1 should be LOW" severity error;
        assert(V2 = '0') report "V2 should be LOW" severity error;
        assert(V3 = '0') report "V3 should be LOW" severity error;
        assert(V4 = '0') report "V4 should be LOW" severity error;
        assert(V5 = '0') report "V5 should be LOW" severity error;
        assert(TC = '0') report "TC should be LOW" severity error;

        for i in 80 to 191 loop
            P_PHI_2 <= '0';
            wait for 489.9634322 ns;
            P_PHI_2 <= '1';
            wait for 489.9634322 ns;
        end loop;

        -- C9 and D9 should be at 128
        assert(H0 = '1') report "H0 should be HIGH" severity error;
        assert(H1 = '1') report "H1 should be HIGH" severity error;
        assert(H2 = '1') report "H2 should be HIGH" severity error;
        assert(H3 = '1') report "H3 should be HIGH" severity error;
        assert(H4 = '1') report "H4 should be HIGH" severity error;
        assert(H5 = '1') report "H5 should be HIGH" severity error;
        assert(HPE_N = '1') report "HPE_N should be HIGH" severity error;
        assert(VA = '1') report "VA should be HIGH" severity error;
        assert(VB = '0') report "VB should be LOW" severity error;
        assert(VC = '0') report "VC should be LOW" severity error;
        assert(V0 = '0') report "V0 should be LOW" severity error;
        assert(V1 = '0') report "V1 should be LOW" severity error;
        assert(V2 = '0') report "V2 should be LOW" severity error;
        assert(V3 = '0') report "V3 should be LOW" severity error;
        assert(V4 = '0') report "V4 should be LOW" severity error;
        assert(V5 = '0') report "V5 should be LOW" severity error;
        assert(TC = '0') report "TC should be LOW" severity error;

        -- 130: 128 steps + 2x loads
        for i in 1 to 130 loop
            P_PHI_2 <= '0';
            wait for 489.9634322 ns;
            P_PHI_2 <= '1';
            wait for 489.9634322 ns;
        end loop;

        -- Everything up to VB should be 1
        assert(H0 = '1') report "H0 should be HIGH" severity error;
        assert(H1 = '1') report "H1 should be HIGH" severity error;
        assert(H2 = '1') report "H2 should be HIGH" severity error;
        assert(H3 = '1') report "H3 should be HIGH" severity error;
        assert(H4 = '1') report "H4 should be HIGH" severity error;
        assert(H5 = '1') report "H5 should be HIGH" severity error;
        assert(HPE_N = '1') report "HPE_N should be HIGH" severity error;
        assert(VA = '1') report "VA should be HIGH" severity error;
        assert(VB = '1') report "VB should be HIGH" severity error;
        assert(VC = '0') report "VC should be LOW" severity error;
        assert(V0 = '0') report "V0 should be LOW" severity error;
        assert(V1 = '0') report "V1 should be LOW" severity error;
        assert(V2 = '0') report "V2 should be LOW" severity error;
        assert(V3 = '0') report "V3 should be LOW" severity error;
        assert(V4 = '0') report "V4 should be LOW" severity error;
        assert(V5 = '0') report "V5 should be LOW" severity error;
        assert(TC = '0') report "TC should be LOW" severity error;

        -- 260: 256 steps + 4x loads
        for i in 1 to 260 loop
            P_PHI_2 <= '0';
            wait for 489.9634322 ns;
            P_PHI_2 <= '1';
            wait for 489.9634322 ns;
        end loop;

        -- Everything up to VC should be 1
        assert(H0 = '1') report "H0 should be HIGH" severity error;
        assert(H1 = '1') report "H1 should be HIGH" severity error;
        assert(H2 = '1') report "H2 should be HIGH" severity error;
        assert(H3 = '1') report "H3 should be HIGH" severity error;
        assert(H4 = '1') report "H4 should be HIGH" severity error;
        assert(H5 = '1') report "H5 should be HIGH" severity error;
        assert(HPE_N = '1') report "HPE_N should be HIGH" severity error;
        assert(VA = '1') report "VA should be HIGH" severity error;
        assert(VB = '1') report "VB should be HIGH" severity error;
        assert(VC = '1') report "VC should be HIGH" severity error;
        assert(V0 = '0') report "V0 should be LOW" severity error;
        assert(V1 = '0') report "V1 should be LOW" severity error;
        assert(V2 = '0') report "V2 should be LOW" severity error;
        assert(V3 = '0') report "V3 should be LOW" severity error;
        assert(V4 = '0') report "V4 should be LOW" severity error;
        assert(V5 = '0') report "V5 should be LOW" severity error;
        assert(TC = '0') report "TC should be LOW" severity error;

        -- 520: 512 steps + 8x loads
        for i in 1 to 520 loop
            P_PHI_2 <= '0';
            wait for 489.9634322 ns;
            P_PHI_2 <= '1';
            wait for 489.9634322 ns;
        end loop;

        -- Everything up to V0 should be 1
        assert(H0 = '1') report "H0 should be HIGH" severity error;
        assert(H1 = '1') report "H1 should be HIGH" severity error;
        assert(H2 = '1') report "H2 should be HIGH" severity error;
        assert(H3 = '1') report "H3 should be HIGH" severity error;
        assert(H4 = '1') report "H4 should be HIGH" severity error;
        assert(H5 = '1') report "H5 should be HIGH" severity error;
        assert(HPE_N = '1') report "HPE_N should be HIGH" severity error;
        assert(VA = '1') report "VA should be HIGH" severity error;
        assert(VB = '1') report "VB should be HIGH" severity error;
        assert(VC = '1') report "VC should be HIGH" severity error;
        assert(V0 = '1') report "V0 should be HIGH" severity error;
        assert(V1 = '0') report "V1 should be LOW" severity error;
        assert(V2 = '0') report "V2 should be LOW" severity error;
        assert(V3 = '0') report "V3 should be LOW" severity error;
        assert(V4 = '0') report "V4 should be LOW" severity error;
        assert(V5 = '0') report "V5 should be LOW" severity error;
        assert(TC = '0') report "TC should be LOW" severity error;

        -- 1040: 1024 steps + 16x loads
        for i in 1 to 1040 loop
            P_PHI_2 <= '0';
            wait for 489.9634322 ns;
            P_PHI_2 <= '1';
            wait for 489.9634322 ns;
        end loop;

        -- Everything up to V1 should be 1
        assert(H0 = '1') report "H0 should be HIGH" severity error;
        assert(H1 = '1') report "H1 should be HIGH" severity error;
        assert(H2 = '1') report "H2 should be HIGH" severity error;
        assert(H3 = '1') report "H3 should be HIGH" severity error;
        assert(H4 = '1') report "H4 should be HIGH" severity error;
        assert(H5 = '1') report "H5 should be HIGH" severity error;
        assert(HPE_N = '1') report "HPE_N should be HIGH" severity error;
        assert(VA = '1') report "VA should be HIGH" severity error;
        assert(VB = '1') report "VB should be HIGH" severity error;
        assert(VC = '1') report "VC should be HIGH" severity error;
        assert(V0 = '1') report "V0 should be HIGH" severity error;
        assert(V1 = '1') report "V1 should be HIGH" severity error;
        assert(V2 = '0') report "V2 should be LOW" severity error;
        assert(V3 = '0') report "V3 should be LOW" severity error;
        assert(V4 = '0') report "V4 should be LOW" severity error;
        assert(V5 = '0') report "V5 should be LOW" severity error;
        assert(TC = '0') report "TC should be LOW" severity error;

        -- 2080: 2048 steps + 32x loads
        for i in 1 to 2080 loop
            P_PHI_2 <= '0';
            wait for 489.9634322 ns;
            P_PHI_2 <= '1';
            wait for 489.9634322 ns;
        end loop;

        -- Everything up to V2 should be 1
        assert(H0 = '1') report "H0 should be HIGH" severity error;
        assert(H1 = '1') report "H1 should be HIGH" severity error;
        assert(H2 = '1') report "H2 should be HIGH" severity error;
        assert(H3 = '1') report "H3 should be HIGH" severity error;
        assert(H4 = '1') report "H4 should be HIGH" severity error;
        assert(H5 = '1') report "H5 should be HIGH" severity error;
        assert(HPE_N = '1') report "HPE_N should be HIGH" severity error;
        assert(VA = '1') report "VA should be HIGH" severity error;
        assert(VB = '1') report "VB should be HIGH" severity error;
        assert(VC = '1') report "VC should be HIGH" severity error;
        assert(V0 = '1') report "V0 should be HIGH" severity error;
        assert(V1 = '1') report "V1 should be HIGH" severity error;
        assert(V2 = '1') report "V2 should be HIGH" severity error;
        assert(V3 = '0') report "V3 should be LOW" severity error;
        assert(V4 = '0') report "V4 should be LOW" severity error;
        assert(V5 = '0') report "V5 should be LOW" severity error;
        assert(TC = '0') report "TC should be LOW" severity error;

        -- 4160: 4096 steps + 64x loads
        for i in 1 to 4160 loop
            P_PHI_2 <= '0';
            wait for 489.9634322 ns;
            P_PHI_2 <= '1';
            wait for 489.9634322 ns;
        end loop;

        -- Everything up to V3 should be 1
        assert(H0 = '1') report "H0 should be HIGH" severity error;
        assert(H1 = '1') report "H1 should be HIGH" severity error;
        assert(H2 = '1') report "H2 should be HIGH" severity error;
        assert(H3 = '1') report "H3 should be HIGH" severity error;
        assert(H4 = '1') report "H4 should be HIGH" severity error;
        assert(H5 = '1') report "H5 should be HIGH" severity error;
        assert(HPE_N = '1') report "HPE_N should be HIGH" severity error;
        assert(VA = '1') report "VA should be HIGH" severity error;
        assert(VB = '1') report "VB should be HIGH" severity error;
        assert(VC = '1') report "VC should be HIGH" severity error;
        assert(V0 = '1') report "V0 should be HIGH" severity error;
        assert(V1 = '1') report "V1 should be HIGH" severity error;
        assert(V2 = '1') report "V2 should be HIGH" severity error;
        assert(V3 = '1') report "V3 should be HIGH" severity error;
        assert(V4 = '0') report "V4 should be LOW" severity error;
        assert(V5 = '0') report "V5 should be LOW" severity error;
        assert(TC = '0') report "TC should be LOW" severity error;

        -- 8320: 8192 steps + 128x loads
        for i in 1 to 8320 loop
            P_PHI_2 <= '0';
            wait for 489.9634322 ns;
            P_PHI_2 <= '1';
            wait for 489.9634322 ns;
        end loop;

        -- Everything up to V4 should be 1
        assert(H0 = '1') report "H0 should be HIGH" severity error;
        assert(H1 = '1') report "H1 should be HIGH" severity error;
        assert(H2 = '1') report "H2 should be HIGH" severity error;
        assert(H3 = '1') report "H3 should be HIGH" severity error;
        assert(H4 = '1') report "H4 should be HIGH" severity error;
        assert(H5 = '1') report "H5 should be HIGH" severity error;
        assert(HPE_N = '1') report "HPE_N should be HIGH" severity error;
        assert(VA = '1') report "VA should be HIGH" severity error;
        assert(VB = '1') report "VB should be HIGH" severity error;
        assert(VC = '1') report "VC should be HIGH" severity error;
        assert(V0 = '1') report "V0 should be HIGH" severity error;
        assert(V1 = '1') report "V1 should be HIGH" severity error;
        assert(V2 = '1') report "V2 should be HIGH" severity error;
        assert(V3 = '1') report "V3 should be HIGH" severity error;
        assert(V4 = '1') report "V4 should be HIGH" severity error;
        assert(V5 = '0') report "V5 should be LOW" severity error;
        assert(TC = '0') report "TC should be LOW" severity error;

        -- 16640: 16384 steps + 256x loads
        for i in 1 to 16640 loop
            P_PHI_2 <= '0';
            wait for 489.9634322 ns;
            P_PHI_2 <= '1';
            wait for 489.9634322 ns;
        end loop;

        -- Everything up to V5 should be 1, and TC should be 1
        assert(H0 = '1') report "H0 should be HIGH" severity error;
        assert(H1 = '1') report "H1 should be HIGH" severity error;
        assert(H2 = '1') report "H2 should be HIGH" severity error;
        assert(H3 = '1') report "H3 should be HIGH" severity error;
        assert(H4 = '1') report "H4 should be HIGH" severity error;
        assert(H5 = '1') report "H5 should be HIGH" severity error;
        assert(HPE_N = '1') report "HPE_N should be HIGH" severity error;
        assert(VA = '1') report "VA should be HIGH" severity error;
        assert(VB = '1') report "VB should be HIGH" severity error;
        assert(VC = '1') report "VC should be HIGH" severity error;
        assert(V0 = '1') report "V0 should be HIGH" severity error;
        assert(V1 = '1') report "V1 should be HIGH" severity error;
        assert(V2 = '1') report "V2 should be HIGH" severity error;
        assert(V3 = '1') report "V3 should be HIGH" severity error;
        assert(V4 = '1') report "V4 should be HIGH" severity error;
        assert(V5 = '1') report "V5 should be HIGH" severity error;
        assert(TC = '1') report "TC should be HIGH" severity error;
        P_PHI_2 <= '0';
        wait for 489.9634322 ns;
        P_PHI_2 <= '1';
        wait for 489.9634322 ns;

        -- Once the video scanner power-on cycle is completed, a complete video scanner cycle will be 17030 P_PHI_2 cycles (for NTSC).

        -- After a complete H0-V5 loop, C9 & D9 should rollover and E9 & F9 should load
        assert(H0 = '0') report "H0 should be LOW" severity error;
        assert(H1 = '0') report "H1 should be LOW" severity error;
        assert(H2 = '0') report "H2 should be LOW" severity error;
        assert(H3 = '0') report "H3 should be LOW" severity error;
        assert(H4 = '0') report "H4 should be LOW" severity error;
        assert(H5 = '0') report "H5 should be LOW" severity error;
        assert(HPE_N = '0') report "HPE_N should be LOW" severity error;
        assert(VA = '0') report "VA should be LOW" severity error;
        assert(VB = '1') report "VB should be HIGH" severity error;
        assert(VC = '0') report "VC should be LOW" severity error;
        assert(V0 = '1') report "V0 should be HIGH" severity error;
        assert(V1 = '1') report "V1 should be HIGH" severity error;
        assert(V2 = '1') report "V2 should be HIGH" severity error;
        assert(V3 = '1') report "V3 should be HIGH" severity error;
        assert(V4 = '1') report "V4 should be HIGH" severity error;
        assert(V5 = '0') report "V5 should be LOW" severity error;

        for i in 1 to 17029 loop
            P_PHI_2 <= '0';
            wait for 489.9634322 ns;
            P_PHI_2 <= '1';
            wait for 489.9634322 ns;
        end loop;

        assert(H0 = '1') report "H0 should be HIGH" severity error;
        assert(H1 = '1') report "H1 should be HIGH" severity error;
        assert(H2 = '1') report "H2 should be HIGH" severity error;
        assert(H3 = '1') report "H3 should be HIGH" severity error;
        assert(H4 = '1') report "H4 should be HIGH" severity error;
        assert(H5 = '1') report "H5 should be HIGH" severity error;
        assert(HPE_N = '1') report "HPE_N should be HIGH" severity error;
        assert(VA = '1') report "VA should be HIGH" severity error;
        assert(VB = '1') report "VB should be HIGH" severity error;
        assert(VC = '1') report "VC should be HIGH" severity error;
        assert(V0 = '1') report "V0 should be HIGH" severity error;
        assert(V1 = '1') report "V1 should be HIGH" severity error;
        assert(V2 = '1') report "V2 should be HIGH" severity error;
        assert(V3 = '1') report "V3 should be HIGH" severity error;
        assert(V4 = '1') report "V4 should be HIGH" severity error;
        assert(V5 = '1') report "V5 should be HIGH" severity error;
        assert(TC = '1') report "TC should be HIGH" severity error;

        for i in 1 to 17030 loop
            P_PHI_2 <= '0';
            wait for 489.9634322 ns;
            P_PHI_2 <= '1';
            wait for 489.9634322 ns;
        end loop;

        assert(PAKST = '0') report "PAKST should be LOW" severity error;

        P_PHI_2 <= '0';
        wait for 489.9634322 ns;
        P_PHI_2 <= '1';
        wait for 489.9634322 ns;

        assert(PAKST = '1') report "PAKST should be HIGH" severity error;

        for i in 1 to 34060 + 68120 + 136240 - 2 loop
            P_PHI_2 <= '0';
            wait for 489.9634322 ns;
            P_PHI_2 <= '1';
            wait for 489.9634322 ns;
        end loop;

        assert(TC14S = '0') report "TC14S should be LOW" severity error;

        P_PHI_2 <= '0';
        wait for 489.9634322 ns;
        P_PHI_2 <= '1';
        wait for 489.9634322 ns;

        assert(TC14S = '1') report "TC14S should be HIGH" severity error;
        assert(FLASH = '0') report "FLASH should be LOW" severity error;

        P_PHI_2 <= '0';
        wait for 489.9634322 ns;
        P_PHI_2 <= '1';
        wait for 489.9634322 ns;

        assert(FLASH = '1') report "FLASH should be HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end VIDEO_SCANNER_TEST;
