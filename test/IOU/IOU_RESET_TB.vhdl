library IEEE;
use IEEE.std_logic_1164.all;

entity IOU_RESET_TB is
    -- empty
end IOU_RESET_TB;

architecture IOU_RESET_TEST of IOU_RESET_TB is
    component IOU_RESET is
        port (
            PHI_1 : in std_logic;
            TC    : in std_logic;
            POC_N : in std_logic;

            FORCE_RESET_N_LOW : out std_logic
        );
    end component;

    signal PHI_1             : std_logic;
    signal TC                : std_logic;
    signal FORCE_RESET_N_LOW : std_logic;
    signal POC_N               : std_logic;

begin
    dut : IOU_RESET port map(
        PHI_1             => PHI_1,
        TC                => TC,
        POC_N               => POC_N,
        FORCE_RESET_N_LOW => FORCE_RESET_N_LOW
    );

    process begin
        TC <= '0';
        POC_N <= '0';
        wait for 490 ns;
        assert(FORCE_RESET_N_LOW = '1') report "expect FORCE_RESET_N_LOW HIGH" severity error;

        -- FORCE_RESET_N_LOW should remain high until PHI_1 and TC are HIGH
        POC_N <= '0';
        PHI_1 <= '0';
        TC    <= '1';
        wait for 490 ns;
        assert(FORCE_RESET_N_LOW = '1') report "expect FORCE_RESET_N_LOW HIGH" severity error;

        -- FORCE_RESET_N_LOW should drop LOW when PHI_1 and TC becomes HIGH
        POC_N <= '1';
        PHI_1 <= '1';
        wait for 490 ns;
        assert(FORCE_RESET_N_LOW = '0') report "expect FORCE_RESET_N_LOW LOW" severity error;

        -- FORCE_RESET_N_LOW should remain LOW thereafter
        PHI_1 <= '0';
        wait for 490 ns;
        PHI_1 <= '1';
        wait for 490 ns;
        assert(FORCE_RESET_N_LOW = '0') report "expect FORCE_RESET_N_LOW LOW" severity error;

        assert false report "Test done." severity note;
        wait;

    end process;
end IOU_RESET_TEST;
