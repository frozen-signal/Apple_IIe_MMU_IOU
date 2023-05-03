library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_CXXXOUT is
    port (
        CENROM1    : in std_logic;
        INTC8ACC   : in std_logic;
        INTC3ACC_N : in std_logic;
        CXXX       : in std_logic;

        CXXXOUT_N : out std_logic
    );
end MMU_CXXXOUT;

architecture RTL of MMU_CXXXOUT is
begin
    -- MMU_2 @C-2:C2-6
    CXXXOUT_N <= ((not CENROM1) and INTC3ACC_N) nand (CXXX and (not INTC8ACC));
end RTL;
