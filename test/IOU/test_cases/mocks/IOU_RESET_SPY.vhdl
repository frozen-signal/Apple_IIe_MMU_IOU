library IEEE;
use IEEE.std_logic_1164.all;
use work.IOU_TESTBENCH_PACKAGE.all;

entity IOU_RESET_SPY is
    port (
        PHI_1 : in std_logic;
        TC    : in std_logic;
        POC_N : in std_logic;

        FORCE_RESET_N_LOW : out std_logic
    );
end IOU_RESET_SPY;

architecture SPY of IOU_RESET_SPY is
    component IOU_RESET is
        port (
            PHI_1 : in std_logic;
            TC    : in std_logic;
            POC_N : in std_logic;

            FORCE_RESET_N_LOW : out std_logic
        );
    end component;

    signal FORCE_RESET_N_LOW_INT : std_logic;
begin
    U_IOU_RESET : IOU_RESET port map(
        PHI_1             => PHI_1,
        TC                => TC,
        POC_N             => POC_N,
        FORCE_RESET_N_LOW => FORCE_RESET_N_LOW_INT
    );

    TB_FORCE_RESET_N_LOW <= FORCE_RESET_N_LOW_INT;
    FORCE_RESET_N_LOW    <= FORCE_RESET_N_LOW_INT;
end SPY;
