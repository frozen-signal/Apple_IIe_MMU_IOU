library IEEE;
use IEEE.std_logic_1164.all;

entity VIDEO_GRAPHICS_TB is
    -- empty
end VIDEO_GRAPHICS_TB;

architecture VIDEO_GRAPHICS_TEST of VIDEO_GRAPHICS_TB is
    component VIDEO_GRAPHICS is
        port (
            PHI_0      : in std_logic;
            V2, V4     : in std_logic;
            VA, VB, VC : in std_logic;
            H0         : in std_logic;
            HIRESEN_N  : in std_logic;
            ITEXT      : in std_logic;
            MIX        : in std_logic;

            PGR_TXT_N        : out std_logic;
            SEGA, SEGB, SEGC : out std_logic;
            LGR_TXT_N        : out std_logic
        );
    end component;

    signal PHI_0      : std_logic;
    signal V2, V4     : std_logic;
    signal VA, VB, VC : std_logic;
    signal H0         : std_logic;
    signal HIRESEN_N  : std_logic;
    signal ITEXT      : std_logic;
    signal MIX        : std_logic;

    signal PGR_TXT_N        : std_logic;
    signal SEGA, SEGB, SEGC : std_logic;
    signal LGR_TXT_N        : std_logic;

begin
    dut : VIDEO_GRAPHICS port map(
        PHI_0     => PHI_0,
        V2        => V2,
        V4        => V4,
        VA        => VA,
        VB        => VB,
        VC        => VC,
        H0        => H0,
        HIRESEN_N => HIRESEN_N,
        ITEXT     => ITEXT,
        MIX       => MIX,
        PGR_TXT_N => PGR_TXT_N,
        SEGA      => SEGA,
        SEGB      => SEGB,
        SEGC      => SEGC,
        LGR_TXT_N => LGR_TXT_N
    );

    process begin
        -- PGR_TXT_N --------------------------------------
        MIX   <= '0';
        V2    <= '0';
        V4    <= '0';
        ITEXT <= '0';
        wait for 1 ns;
        assert(PGR_TXT_N = 'U') report "expect PGR_TXT_N unchanged" severity error;

        PHI_0 <= '0';
        wait for 1 ns;

        PHI_0   <= '1';
        MIX     <= '0';
        V2      <= '0';
        V4      <= '0';
        ITEXT   <= '0';
        wait for 1 ns;
        assert(PGR_TXT_N = '1') report "expect PGR_TXT_N HIGH" severity error;

        PHI_0   <= '0';
        wait for 1 ns;

        PHI_0   <= '1';
        MIX     <= '0';
        V2      <= '0';
        V4      <= '0';
        ITEXT   <= '1';
        wait for 1 ns;
        assert(PGR_TXT_N = '0') report "expect PGR_TXT_N LOW" severity error;

        PHI_0   <= '0';
        wait for 1 ns;

        PHI_0   <= '1';
        MIX     <= '0';
        V2      <= '1';
        V4      <= '1';
        ITEXT   <= '0';
        wait for 1 ns;
        assert(PGR_TXT_N = '1') report "expect PGR_TXT_N HIGH" severity error;

        PHI_0   <= '0';
        wait for 1 ns;

        PHI_0   <= '1';
        MIX     <= '1';
        V2      <= '0';
        V4      <= '1';
        ITEXT   <= '0';
        wait for 1 ns;
        assert(PGR_TXT_N = '1') report "expect PGR_TXT_N HIGH" severity error;

        PHI_0   <= '0';
        wait for 1 ns;

        PHI_0   <= '1';
        MIX     <= '1';
        V2      <= '1';
        V4      <= '0';
        ITEXT   <= '0';
        wait for 1 ns;
        assert(PGR_TXT_N = '1') report "expect PGR_TXT_N HIGH" severity error;

        PHI_0   <= '0';
        wait for 1 ns;

        PHI_0   <= '1';
        MIX     <= '1';
        V2      <= '1';
        V4      <= '1';
        ITEXT   <= '0';
        wait for 1 ns;
        assert(PGR_TXT_N = '0') report "expect PGR_TXT_N LOW" severity error;

        -- SEGA, SEGB, SEGC -------------------------------
        -- LGR_TXT_N --------------------------------------
        PHI_0   <= '0';
        wait for 1 ns;

        PHI_0     <= '1';
        H0        <= '0';
        VA        <= '0';
        HIRESEN_N <= '0';
        VB        <= '0';
        VC        <= '0';
        wait for 1 ns;
        assert(SEGA = '0') report "expect SEGA LOW" severity error;
        assert(SEGB = '0') report "expect SEGB LOW" severity error;
        assert(SEGC = '0') report "expect SEGC LOW" severity error;
        assert(LGR_TXT_N = '0') report "expect LGR_TXT_N LOW" severity error;

        PHI_0     <= '0';
        H0        <= '0';
        VA        <= '1';
        HIRESEN_N <= '0';
        VB        <= '1';
        VC        <= '1';
        wait for 1 ns;
        assert(SEGA = '0') report "expect SEGA unchanged" severity error;
        assert(SEGB = '0') report "expect SEGB unchanged" severity error;
        assert(SEGC = '0') report "expect SEGC unchanged" severity error;
        assert(LGR_TXT_N = '0') report "expect LGR_TXT_N unchanged" severity error;

        PHI_0     <= '1';
        H0        <= '0';
        VA        <= '1';
        HIRESEN_N <= '0';
        VB        <= '1';
        VC        <= '1';
        MIX       <= '0';
        V2        <= '0';
        V4        <= '0';
        ITEXT     <= '0'; -- PGR_TXT_N 1
        wait for 1 ns;
        assert(SEGA = '1') report "expect SEGA HIGH" severity error;
        assert(SEGB = '1') report "expect SEGB HIGH" severity error;
        assert(SEGC = '1') report "expect SEGC HIGH" severity error;
        assert(LGR_TXT_N = '0') report "expect LGR_TXT_N unchanged" severity error;

        PHI_0     <= '0';
        wait for 1 ns;

        PHI_0     <= '1';
        wait for 1 ns;
        assert(LGR_TXT_N = '1') report "expect LGR_TXT_N HIGH" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end VIDEO_GRAPHICS_TEST;
