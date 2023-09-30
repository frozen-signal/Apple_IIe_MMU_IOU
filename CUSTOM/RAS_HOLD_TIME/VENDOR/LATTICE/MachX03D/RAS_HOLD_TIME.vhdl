library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

library machxo3d;
use machxo3d.all;

-- NOTE: Not thoroughly tested
-- NOTE: This implementation of RAS_HOLD_TIME can only be used with Lattice devices that support the OSCJ primitive.
entity RAS_HOLD_TIME is
    port (
        PRAS_N : in std_logic;

        RAS_N : out std_logic
    );
end RAS_HOLD_TIME;

architecture RTL of RAS_HOLD_TIME is
    constant OSC_FREQUENCY_MHZ : string := "88.67";
    constant NUM_CLK_TICKS : positive := 4;

	component OSCJ
        -- synthesis translate_off
        generic (
            NOM_FREQ: string := OSC_FREQUENCY_MHZ
        );
        -- synthesis translate_on

	    port (
            STDBY    : IN std_logic;

		    OSC      : OUT std_logic;
		    SEDSTDBY : OUT std_logic;
		    OSCESB   : OUT std_logic
        );
	end component;

	attribute NOM_FREQ : string;
	attribute NOM_FREQ of u_oscj : label is OSC_FREQUENCY_MHZ;

    signal CLK : std_logic;
    signal SHIFT_REGISTER : unsigned(NUM_CLK_TICKS downto 0);
begin
	u_oscj : OSCJ
        -- synthesis translate_off
        generic map (
            NOM_FREQ => OSC_FREQUENCY_MHZ
        )
        -- synthesis translate_on

	    port map (
            STDBY=> '0',
		    OSC => CLK,
		    SEDSTDBY => open,
		    OSCESB => open
	    );

    process(CLK)
    begin
        if rising_edge(CLK) then
            RAS_N <= SHIFT_REGISTER(SHIFT_REGISTER'high);
            SHIFT_REGISTER<= shift_left(SHIFT_REGISTER, 1);
            SHIFT_REGISTER(SHIFT_REGISTER'low) <= PRAS_N;
        end if;
    end process;

end RTL;
