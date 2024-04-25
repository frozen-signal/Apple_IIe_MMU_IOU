library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- NOTE: This implementation of DRAM_HOLD_TIME can only be used with Altera devices that support the LCELL primitive.
entity DRAM_HOLD_TIME is
    port (
        PRAS_N : in std_logic;
        Q3     : in std_logic;

        RAS_N      : out std_logic;
        DELAYED_Q3 : out std_logic
    );
end DRAM_HOLD_TIME;

architecture RTL of DRAM_HOLD_TIME is
    constant NUM_LCELLS_RAS : positive := 14;
    constant NUM_LCELLS_Q3 : positive := 10;

    component LCELL
        port (
            A_IN : in std_logic;
            A_OUT : out std_logic
        );
    end component;

    signal PRAS_N_DELAY : std_logic_vector((NUM_LCELLS_RAS-1) downto 0);
    signal Q3_DELAY : std_logic_vector((NUM_LCELLS_Q3-1) downto 0);
begin
    -- PRAS_N DELAY -------------------
    INITIAL_RAS_DELAY : LCELL port map(
        A_IN => PRAS_N,
        A_OUT => PRAS_N_DELAY(0)
    );

    g_GENERATE_RAS_DELAY: for i in 0 to (NUM_LCELLS_RAS-2) generate
        DELAY : LCELL port map(
            A_IN => PRAS_N_DELAY(i),
            A_OUT => PRAS_N_DELAY(i+1)
        );
    end generate g_GENERATE_RAS_DELAY;

    RAS_N <= PRAS_N_DELAY(NUM_LCELLS_RAS-1);

    -- Q3 DELAY -----------------------
    INITIAL_Q3_DELAY : LCELL port map(
        A_IN => Q3,
        A_OUT => Q3_DELAY(0)
    );

    g_GENERATE_Q3_DELAY: for i in 0 to (NUM_LCELLS_Q3-2) generate
        DELAY : LCELL port map(
            A_IN => Q3_DELAY(i),
            A_OUT => Q3_DELAY(i+1)
        );
    end generate g_GENERATE_Q3_DELAY;

    DELAYED_Q3 <= Q3_DELAY(NUM_LCELLS_Q3-1);
end RTL;
