library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- NOTE: Not thoroughly tested
-- NOTE: This implementation of RAS_HOLD_TIME can only be used with Lattice devices that support the SB_HFOSC primitive.
entity RAS_HOLD_TIME is
    port (
        PRAS_N : in std_logic;

        RAS_N : out std_logic
    );
end RAS_HOLD_TIME;

architecture RTL of RAS_HOLD_TIME is
    constant NUM_CLK_TICKS : positive := 1;

	component SB_HFOSC
        generic (
            CLKHF_DIV : string := "0b00"
        );
        port (
            CLKHFEN: in std_logic;
            CLKHFPU: in std_logic;
            CLKHF: out std_logic
        );
	end component;

    signal CLK : std_logic;
    signal SHIFT_REGISTER : unsigned(NUM_CLK_TICKS downto 0);
begin
    u_sb_hfosc : SB_HFOSC
    generic map (
        CLKHF_DIV => "0b00"
    )
    port map (
        CLKHFEN  => '1',
        CLKHFPU  => '1',
        CLKHF    => CLK
   );

    process(CLK)
    begin
        if rising_edge(CLK) then
            RAS_N <= SHIFT_REGISTER(SHIFT_REGISTER'high);
            SHIFT_REGISTER <= shift_left(SHIFT_REGISTER, 1);
            SHIFT_REGISTER(SHIFT_REGISTER'low) <= PRAS_N;
        end if;
    end process;

end RTL;
