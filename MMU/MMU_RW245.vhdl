library IEEE;
use IEEE.std_logic_1164.all;

entity MMU_RW245 is
    port (
        INTIO_N   : in std_logic;
        CXXXOUT_N : in std_logic;
        R_W_N     : in std_logic;
        DMA_N     : in std_logic;
        INH_N     : in std_logic;
        PHI_0     : in std_logic;

        R_W_N_245 : out std_logic
    );
end MMU_RW245;

architecture RTL of MMU_RW245 is
    signal P7_8, P9_11, L4_3, C4_11, L4_6, K3_3, E2_11 : std_logic;

    signal DMA    : std_logic;
    signal PRW245 : std_logic;
begin
    DMA <= not DMA_N;

    -- MMU_1 @D-1:H3-11
    P7_8   <= CXXXOUT_N nor (not INTIO_N);
    P9_11  <= R_W_N and P7_8;
    L4_3   <= P9_11 and DMA_N;
    C4_11  <= P7_8 or (not R_W_N);
    L4_6   <= C4_11 and (not DMA_N);
    K3_3   <= L4_3 or L4_6;
    E2_11  <= DMA or R_W_N;
    PRW245 <= K3_3 when INH_N = '1' else E2_11;

    -- MMU_1 @D-1:L4-8
    -- Handwritten notes:
    --    R.C020-C0FF  Access = '1"
    --    C000-C01F    Access = '0'
    --    C800         "      = '0'
    --    if not(DMA) then Rd*CXXXOUT*INTIO_N
    R_W_N_245 <= PHI_0 and PRW245;

end RTL;
