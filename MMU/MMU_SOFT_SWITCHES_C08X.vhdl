-- MMU1 E4 (located at C-1)
library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_SOFT_SWITCHES_C08X is
    port (
        MPON_N     : in std_logic;
        A0, A1, A3 : in std_logic;  -- A3: C08
        DEV0_N     : in std_logic;  -- C08X
        R_W_N      : in std_logic;
        IN_FST_ACC : in std_logic;
        IN_WREN    : in std_logic;

        BANK1, BANK2     : out std_logic;  -- BANK1: C08(8-F), BANK2: C08(0-7)
        RDRAM, RDROM     : out std_logic;  -- RDRAM (also called HRAMRD): C08(0,3), RDROM: C08(1,2)
        OUT_FST_ACC      : out std_logic;  -- READ ODD (also called PRE-WRITE)
        WRPROT, OUT_WREN : out std_logic   -- WRPROT (also called HRAMWRT'): EVEN ACCESS, WREN: 2 ODD READS
    );
end MMU_SOFT_SWITCHES_C08X;

architecture RTL of MMU_SOFT_SWITCHES_C08X is
    component LS175 is
        port (
            CLR_N                  : in std_logic;
            CLK                    : in std_logic;
            D1, D2, D3, D4         : in std_logic;
            Q1, Q2, Q3, Q4         : out std_logic;
            Q1_N, Q2_N, Q3_N, Q4_N : out std_logic
        );
    end component;

    signal D2, D3, D4, CLK : std_logic;
begin
    D2 <= not (A0 xor A1);
    D3 <= A0 and R_W_N;
    D4 <= ((D3 and IN_FST_ACC) or IN_WREN) nand A0;

    -- Contrary to what is drawn in MMU_1 @C-1:E4-9, the CLK signal of the LS175 should be
    -- (inverted DEV0_N): DEV0_N goes LOW when C08X*PHI_0 is accessed. Since the LS175 stores
    -- D on the rising edge of CLK it's clear that DEV_0 is to be inverted. Confirmed by
    -- looking at the DET.T that handles RDROM in the ASIC schematic
    CLK <= not DEV0_N;

    process (CLK, MPON_N)
    begin
        if (MPON_N = '0') then
            BANK1       <= '0';
            RDRAM       <= '0';
            OUT_FST_ACC <= '0';
            WRPROT      <= '0';
            BANK2       <= '1';  -- BANK2 is always the inverse of BANK1
            RDROM       <= '1';  -- RDROM is always the inverse of RDRAM
            OUT_WREN    <= '1';  -- WREN is always the inverse of WRPROT
        elsif (rising_edge(CLK)) then
            BANK1       <= A3;        -- SET C088-C08F; Set BANK2 to RESET, READ C011
            RDRAM       <= D2;        -- SET C080, C083; Set RDROM to RESET. This is HRAMRD in its SET state. READ C012
            OUT_FST_ACC <= D3;        -- SET: READ odd address in the C08X range; RESET: In C08X range, read even addr or write
            WRPROT      <= D4;        -- Also called HRAMWRT'
            BANK2       <= not A3;    -- SET C080-C087; Set BANK1 to RESET
            RDROM       <= not D2;    -- SET C081, C082; Set RDRAM to RESET, This is HRAMRD in its RESET state
            OUT_WREN    <= not D4;    -- Also called PRE-WRITE
        end if;
    end process;

end RTL;
