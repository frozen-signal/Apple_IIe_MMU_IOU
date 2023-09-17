library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- NOTE: This implementation of RAS_HOLD_TIME can only be used with Altera devices that support the LCELL primitive.
entity RAS_HOLD_TIME_ALTERA is
    port (
        PRAS_N : in std_logic;

        RAS_N : out std_logic
    );
end RAS_HOLD_TIME_ALTERA;

architecture RTL of RAS_HOLD_TIME_ALTERA is
    constant NUM_LCELLS : positive := 14;

    component LCELL
        port (
            A_IN : in std_logic;
            A_OUT : out std_logic
        );
    end component;

    signal PRAS_N_DELAY : std_logic_vector((NUM_LCELLS-1) downto 0);
begin
    INITIAL_DELAY : LCELL port map(
        A_IN => PRAS_N,
        A_OUT => PRAS_N_DELAY(0)
    );

    g_GENERATE_DELAY: for i in 0 to (NUM_LCELLS-2) generate
        DELAY : LCELL port map(
            A_IN => PRAS_N_DELAY(i),
            A_OUT => PRAS_N_DELAY(i+1)
        );
    end generate g_GENERATE_DELAY;

    RAS_N <= PRAS_N_DELAY(NUM_LCELLS-1);
end RTL;
