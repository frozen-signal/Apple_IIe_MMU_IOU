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
    component LCELL
        port (
            A_IN : in std_logic;
            A_OUT : out std_logic
        );
    end component;

    signal PRAS_N_5NS, PRAS_N_10NS, PRAS_N_15NS, PRAS_N_20NS, PRAS_N_25NS : std_logic;
begin
    DELAY_5NS : LCELL port map(
        A_IN => PRAS_N,
        A_OUT => PRAS_N_5NS
    );
    DELAY_10NS : LCELL port map(
        A_IN => PRAS_N_5NS,
        A_OUT => PRAS_N_10NS
    );
    DELAY_15NS : LCELL port map(
        A_IN => PRAS_N_10NS,
        A_OUT => PRAS_N_15NS
    );
    DELAY_20NS : LCELL port map(
        A_IN => PRAS_N_15NS,
        A_OUT => PRAS_N_20NS
    );
    DELAY_25NS : LCELL port map(
        A_IN => PRAS_N_20NS,
        A_OUT => PRAS_N_25NS
    );

    RAS_N <= PRAS_N_25NS;
end RTL;
