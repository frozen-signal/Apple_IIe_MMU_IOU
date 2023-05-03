library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_ROMEN is
    port (
        PHI_0      : in std_logic;
        INTC8ACC   : in std_logic;
        INTC3ACC_N : in std_logic;
        CXXX       : in std_logic;
        DXXX_N     : in std_logic;
        E_FXXX_N   : in std_logic;
        INH        : in std_logic;
        RDROM      : in std_logic;
        CENROM1    : in std_logic;
        R_W_N      : in std_logic;

        ROMEN2_N : out std_logic;
        ROMEN1_N : out std_logic
    );
end MMU_ROMEN;

architecture RTL of MMU_ROMEN is
    signal B5_6, L5_11, K2_12, D2_12 : std_logic;
begin
    -- MMU_2 @D-4:L5-8
    B5_6     <= not (RDROM and R_W_N and PHI_0);
    ROMEN2_N <= B5_6 or E_FXXX_N or INH; -- INH not present in the schematics, but present in the ASIC schematic

    -- MMU_2 @D-3:K2-6
    L5_11    <= B5_6 or DXXX_N;
    K2_12    <= not (CENROM1 and CXXX and PHI_0);
    D2_12    <= (INTC8ACC or (not INTC3ACC_N)) nand PHI_0;
    ROMEN1_N <= (K2_12 and L5_11 and D2_12) or INH; -- INH handwritten in the schematics
end RTL;
