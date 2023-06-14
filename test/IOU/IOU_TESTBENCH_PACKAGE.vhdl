library IEEE;
use IEEE.std_logic_1164.all;

package IOU_TESTBENCH_PACKAGE is
       signal TB_LA0, TB_LA1, TB_LA2, TB_LA3, TB_LA4, TB_LA5, TB_LA7 : std_logic;
       signal TB_MUX_RA0, TB_MUX_RA1, TB_MUX_RA2, TB_MUX_RA3,
       TB_MUX_RA4, TB_MUX_RA5, TB_MUX_RA6, TB_MUX_RA7                                     : std_logic;
       signal TB_RA_ENABLE_N                                                              : std_logic;
       signal TB_C00X_N, TB_C01X_N, TB_C02X_N, TB_C03X_N, TB_C04X_N, TB_C05X_N, TB_C07X_N : std_logic;

       signal TB_FORCE_RESET : std_logic;
end package IOU_TESTBENCH_PACKAGE;
