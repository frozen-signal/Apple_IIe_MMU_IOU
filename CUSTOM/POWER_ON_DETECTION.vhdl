library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- When the computer is powered on, the POC signal is used to detect the power-on event.
--
-- This is what is described on MMU_1:
-- The circuits at B-3:A3-2 and the 555 timer at B-2:B3 are a power-on detection circuit. That
-- circuit will hold POC HIGH for about 300ms, then drive POC LOW. When that happens other circuits will
-- be allowed to initialize (See IOU_RESET). During that time, RESET_N is held LOW.
--
-- There is a discrepency with the observed timing though. Hooking an oscilloscope on the RESET_N pin of
-- the IOU shows that RESET_N is kept LOW for 35ms when the computer is powered on (without the disk controller).
-- Since the initial VIDEO_SCANNER full cycle (initialization) takes ~32.6ms, that means that
-- the 555 timer equivalent in the IOU have a delay of only ~2.4ms.
-- (See "Understanding the Apple IIe" by Jim Sather, p3-17 first complete paragraph of the second column)
--
-- So here, we use directly POC_N and keep it LOW for 2.4 ms with a counter hooked on PHI_0. Since the
-- phase duration is not constant (1 out of every 65 cycles is a 'long phase') we use the average
-- phase duration (979.9268644ns) to convert 2.4ms to a number of PHI_0 cycles (2449 cycles).
--
-- There is still a problem, however.
--
-- We need a way to detect the power-on event. Unfortunately, there is no consistent way
-- to do that in VHDL only. Signal initialization won't work:
--
--     "Initial signal values are useful for simulation, but not for synthesis. For synthesis,
--      any initial or default value assigned to a signal is ignored by an IEEE 1076.6 compliant
--      synthesizer. This is because the synthesizer cannot assume that the target hardware has
--      the capability to be powered up with its signals in the specified states. Note that there
--      are some synthesizers that attempt to synthesize initial values (with varying degrees
--      of success). However, for a design description to be IEEE Std1076.6 compliant, initial
--      values must not be assigned to signals or variables."
--                       (From "VHDL for Engineers" (p. 87, about ":=" operator) by Kenneth L. Short)
--
-- This component assumes that, when powered-on, the CPLD/FPGA will set all flip-flops and other
-- memory elements to '0' and uses this fact to infer a power-on event. If it's not the case with
-- your hardware, you will have to come up with a way to reliably detect a power-on and write a
-- power-on detection component with this specification:
--
-- On power-on, the signal POC_N should be held LOW for 2.4ms and then driven HIGH. It shoult then
-- remain HIGH as long as the device has power.

entity POWER_ON_DETECTION is
    port (
        PHI_0 : in std_logic;

        POC_N : out std_logic := '0' -- Initialization only used by tests to
                                     --    mock requirement that the device should
                                     --    initialize all memory elements to '0'
    );
end POWER_ON_DETECTION;

architecture RTL of POWER_ON_DETECTION is
    constant COUNT_2_4_MS : unsigned(11 downto 0) := x"991"; -- 2449 in hex

    signal COUNT : unsigned(11 downto 0) := (others => '0'); -- Initialization only used by tests to
                                                             --    mock requirement that the device should
                                                             --    initialize all memory elements to '0'
begin
    process (PHI_0)
    begin
        if (rising_edge(PHI_0)) then
            if (COUNT < COUNT_2_4_MS) then
                COUNT      <= COUNT + 1;
                POC_N      <= '0';
            else
                POC_N <= '1';
            end if;
        end if;
    end process;

end RTL;
