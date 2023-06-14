library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity IOU_RESET is
    port (
        PHI_1 : in std_logic;
        TC    : in std_logic;

        -- The IOU will force RESET_N low during power-on;
        -- otherwise RESET_N is driven by the value from the input of the RESET_N pin.
        FORCE_RESET_N_LOW : out std_logic; -- This will be HIGH when the IOU should force RESET_N LOW.
        POC               : out std_logic
    );
end IOU_RESET;

architecture RTL of IOU_RESET is
    -- When the computer is powered on, the RESET_N is forced LOW for a certain time. This is what seems to be described on MMU_1:
    --
    -- The circuits at B-3:A3-2 and the 555 timer at B-2:B3 will hold POC HIGH for about .3s.
    -- POC is connected to the S leg of the RS latch at B-4:S5. While HIGH, POC will force RESET_N LOW.
    -- When POC finally drops LOW, the VIDEO_SCANNER (See IOU_1 @A-4 to C-4) is no longer kept in a CLR state and, eventually F9 will overflow.
    -- When that happens, TC will be HIGH and at the next PHI_1, the 2N3904 at A3 will disconnect RESET_N from the ground.
    -- RESET_N will then be HIGH, pulled-up by the pull-up resistor at MMU_1 @B-2:A4-4
    --
    -- However, hooking an oscilloscope on the RESET_N pin of the IOU shows that RESET_N is kept LOW for 35ms when the
    -- computer is powered on. Since the initial VIDEO_SCANNER full cycle takes ~32.6ms, that means that the 555 timer equivalent
    -- in the IOU have a delay of only ~2.4ms.
    -- (See "Understanding the Apple IIe" by Jim Sather, p3-17 first complete paragraph of the second column)
    --
    -- So here, we keep POC HIGH for 2.4 ms with a counter hooked on PHI_1 and use a rollover to know when the delay has been reached.
    -- Since the phase duration is not constant (1 out of every 65 cycles is a 'long phase') we use the average phase duration (979.9268644ns)
    -- to convert 2.4ms to a number of PHI_1 cycles (2449 cycles).
    signal COUNT          : unsigned(11 downto 0) := "011001101111"; -- 4096 - 2449 = 1647. We count from 1647 to 4096
    signal INT_POC        : std_logic             := '1';
    signal PWR_ON_ONGOING : std_logic             := '1';
begin
    process (PHI_1)
    begin
        if (INT_POC = '1' and rising_edge(PHI_1)) then
            COUNT <= COUNT + 1;
        end if;

        if (COUNT = "000000000000") then
            INT_POC <= '0';
        end if;
    end process;

    process (INT_POC, TC, PHI_1)
    begin
        if (PWR_ON_ONGOING = '1' and INT_POC = '0' and TC = '1' and PHI_1 = '1') then
            PWR_ON_ONGOING <= '0';
        end if;
    end process;

    POC <= INT_POC;
    FORCE_RESET_N_LOW <= PWR_ON_ONGOING;
end RTL;
