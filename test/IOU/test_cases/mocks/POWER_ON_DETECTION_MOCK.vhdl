library IEEE;
use IEEE.std_logic_1164.all;
use work.IOU_TESTBENCH_PACKAGE.all;

entity POWER_ON_DETECTION_MOCK is
    port (
        PHI_0 : in std_logic;
        POC_N : out std_logic
    );
end POWER_ON_DETECTION_MOCK;

architecture MOCK of POWER_ON_DETECTION_MOCK is
begin
    POC_N <= TB_FORCE_POC_N;
end MOCK;
