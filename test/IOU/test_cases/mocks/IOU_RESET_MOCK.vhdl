library IEEE;
use IEEE.std_logic_1164.all;
use work.IOU_TESTBENCH_PACKAGE.all;

entity IOU_RESET_MOCK is
    port (
        PHI_1 : in std_logic;
        TC    : in std_logic;
        POC_N : in std_logic;

        FORCE_RESET_N_LOW : out std_logic
    );
end IOU_RESET_MOCK;

architecture MOCK of IOU_RESET_MOCK is
begin
    FORCE_RESET_N_LOW <= TB_FORCE_RESET;
end MOCK;
