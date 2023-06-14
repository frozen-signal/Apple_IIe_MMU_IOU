library IEEE;
use IEEE.std_logic_1164.all;

entity IOU_DEVICES is
    port (
        POC_N  : in std_logic;
        C02X_N : in std_logic;
        C03X_N : in std_logic;

        SPKR  : out std_logic;
        CASSO : out std_logic
    );
end IOU_DEVICES;

architecture RTL of IOU_DEVICES is
    signal CURRENT_SPKR  : std_logic := '0';
    signal CURRENT_CASSO : std_logic := '0';
begin
    -- IOU_1 @C-2:A5
    -- The speaker (and the cassette which is essentially the same from the IOU's perspective):
    -- On the Apple II series, a program produces sound by 'toggling' the HIGH/LOW state of the speaker in order to tense or relax the diaphragm.
    -- But the program never knows the actual HIGH/LOW state of the speaker; it can only tell the IOU to toggle it's value. So, when C03X is accessed,
    -- the value of the flip-flop is inverted. In the schematics, the signal CPKR_N is probably a typo and should be SPKR_N; the output Q' (A5-6)
    -- is tied to D (A6-2) in the schematics of the Apple II/II+'s board.

    process (POC_N, C03X_N)
    begin
        if (POC_N = '1') then
            CURRENT_SPKR <= '0';
        elsif (rising_edge(C03X_N)) then
            CURRENT_SPKR <= not CURRENT_SPKR;
        end if;
    end process;
    SPKR <= CURRENT_SPKR;

    process (POC_N, C02X_N)
    begin
        if (POC_N = '1') then
            CURRENT_CASSO <= '0';
        elsif (rising_edge(C02X_N)) then
            CURRENT_CASSO <= not CURRENT_CASSO;
        end if;
    end process;
    CASSO <= CURRENT_CASSO;

end RTL;
