-- This is a package that contains procedures useful in the testbenches.
library IEEE;
use IEEE.std_logic_1164.all;

package TEST_UTILS is
    procedure resetMMU(
        signal PHI_0 : in std_logic;
        signal A     : out std_logic_vector(15 downto 0)
    );

end package TEST_UTILS;

package body TEST_UTILS is
    procedure resetMMU(
        signal PHI_0 : in std_logic;
        signal A     : out std_logic_vector(15 downto 0)
    ) is
    begin
        A <= x"0100";
        wait until rising_edge(PHI_0);
        wait until rising_edge(PHI_0);
        wait until rising_edge(PHI_0);

        A <= x"FFFC";
        wait until rising_edge(PHI_0);
    end resetMMU;
end package body TEST_UTILS;
