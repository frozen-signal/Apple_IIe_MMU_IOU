-- This is a package that contains procedures useful in the testbenches.
library IEEE;
use IEEE.std_logic_1164.all;

package TEST_UTILS is
    procedure resetMMU(
        signal PHI_0 : in std_logic;
        signal A     : out std_logic_vector(15 downto 0)
    );

    function to_hstring(slv : std_logic_vector) return string;

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

    function to_hstring(slv : std_logic_vector) return string is
        constant hexlen         : integer                                   := (slv'length + 3)/4;
        variable longslv        : std_logic_vector(slv'length + 3 downto 0) := (others => '0');
        variable hex            : string(1 to hexlen);
        variable fourbit        : std_logic_vector(3 downto 0);
    begin
        longslv(slv'length - 1 downto 0) := slv;
        for i in hexlen - 1 downto 0 loop
            fourbit := longslv(i * 4 + 3 downto i * 4);
            case fourbit is
                when "0000" => hex(hexlen - i) := '0';
                when "0001" => hex(hexlen - i) := '1';
                when "0010" => hex(hexlen - i) := '2';
                when "0011" => hex(hexlen - i) := '3';
                when "0100" => hex(hexlen - i) := '4';
                when "0101" => hex(hexlen - i) := '5';
                when "0110" => hex(hexlen - i) := '6';
                when "0111" => hex(hexlen - i) := '7';
                when "1000" => hex(hexlen - i) := '8';
                when "1001" => hex(hexlen - i) := '9';
                when "1010" => hex(hexlen - i) := 'A';
                when "1011" => hex(hexlen - i) := 'B';
                when "1100" => hex(hexlen - i) := 'C';
                when "1101" => hex(hexlen - i) := 'D';
                when "1110" => hex(hexlen - i) := 'E';
                when "1111" => hex(hexlen - i) := 'F';
                when "ZZZZ" => hex(hexlen - i) := 'Z';
                when "UUUU" => hex(hexlen - i) := 'U';
                when "XXXX" => hex(hexlen - i) := 'X';
                when others => hex(hexlen - i) := '?';
            end case;
        end loop;
        return hex;
    end function to_hstring;

end package body TEST_UTILS;
