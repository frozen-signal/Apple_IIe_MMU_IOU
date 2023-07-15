library IEEE;
use IEEE.std_logic_1164.all;

entity POWER_ON_DETECTION_TB is
    -- empty
end POWER_ON_DETECTION_TB;

architecture POWER_ON_DETECTION_TEST of POWER_ON_DETECTION_TB is
    component POWER_ON_DETECTION is
        port (
            PHI_0 : in std_logic;

            POC_N  : out std_logic
        );
    end component;

    signal PHI_0             : std_logic;
    signal POC_N               : std_logic;

begin
    dut : POWER_ON_DETECTION port map(
        PHI_0             => PHI_0,
        POC_N               => POC_N
    );

    process begin
        -- POC_N should remain HIGH for the duration of the 555-timer imitation delay
        for i in 0 to 2449 loop
            PHI_0 <= '1';
            wait for 490 ns;
            assert(POC_N = '0') report "expect POC_N LOW" severity error;
            PHI_0 <= '0';
            wait for 490 ns;
        end loop;

        PHI_0 <= '1';
        wait for 490 ns;

        -- POC should go HIGH after the delay
        assert(POC_N = '1') report "expect POC_N HIGH" severity error;

        PHI_0 <= '0';
        wait for 490 ns;
        PHI_0 <= '1';
        wait for 490 ns;

        assert false report "Test done." severity note;
        wait;

    end process;
end POWER_ON_DETECTION_TEST;
