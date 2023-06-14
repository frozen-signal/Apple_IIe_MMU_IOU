library IEEE;
use IEEE.std_logic_1164.all;

entity IOU_ADDR_DECODER is
    port (
        C0XX_N : in std_logic;
        LA7    : in std_logic;
        LA4    : in std_logic;
        LA5    : in std_logic;
        A6     : in std_logic;
        Q3     : in std_logic;

        C00X_N : out std_logic;
        C01X_N : out std_logic;
        C02X_N : out std_logic;
        C03X_N : out std_logic;
        C04X_N : out std_logic;
        C05X_N : out std_logic;
        C07X_N : out std_logic
    );
end IOU_ADDR_DECODER;

architecture RTL of IOU_ADDR_DECODER is

    component LS138 is
        port (
            A, B, C                        : in std_logic;
            G1, G2A_N, G2B_N               : in std_logic;
            Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7 : out std_logic
        );
    end component;

    signal LA7_N : std_logic;
begin
    -- A discrepency between "Understanding the Apple IIe" by Jim Sather and the emulator schematic is that Jim Sather writes that MD7 is
    -- enabled the last three 14M periods of PHASE 0 and the first 14M period of the following PHASE 1.
    -- According to the emulator schematics, C01X_N is forced HIGH on Q3 HIGH (see LS138 below). And Soft Switches are not enabled when
    -- RC001X_N is HIGH.

    -- IOU_1 @D-3:H6
    LA7_N <= not LA7;
    IOU_1_H6 : LS138 port map(
        A     => LA4,
        B     => LA5,
        C     => A6,
        G1    => LA7_N,
        G2A_N => C0XX_N,
        G2B_N => Q3,
        Y0    => C00X_N,
        Y1    => C01X_N,
        Y2    => C02X_N,
        Y3    => C03X_N,
        Y4    => C04X_N,
        Y5    => C05X_N,
        Y6    => open,
        Y7    => C07X_N
    );
end RTL;
