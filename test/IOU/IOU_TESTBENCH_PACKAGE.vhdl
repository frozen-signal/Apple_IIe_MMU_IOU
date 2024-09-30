library IEEE;
use IEEE.std_logic_1164.all;

package IOU_TESTBENCH_PACKAGE is
       signal TB_LA0, TB_LA1, TB_LA2, TB_LA3, TB_LA4, TB_LA5, TB_LA7 : std_logic;

       signal TB_MUX_RA0, TB_MUX_RA1, TB_MUX_RA2, TB_MUX_RA3,
              TB_MUX_RA4, TB_MUX_RA5, TB_MUX_RA6, TB_MUX_RA7                              : std_logic;
       signal TB_RA_ENABLE_N, TB_HBL, TB_VBL_N                                            : std_logic;
       signal TB_C00X_N, TB_C01X_N, TB_C02X_N, TB_C03X_N, TB_C04X_N, TB_C05X_N, TB_C07X_N : std_logic;

       signal TB_FORCE_RESET       : std_logic; -- used by the mock
       signal TB_FORCE_POC_N       : std_logic;
       signal TB_FORCE_RESET_N_LOW : std_logic; -- used by the spy

       signal TB_TC                                              : std_logic;
       signal TB_V5, TB_V4, TB_V3, TB_V2, TB_V1, TB_V0           : std_logic;
       signal TB_VC, TB_VB, TB_VA                                : std_logic;
       signal TB_HPE_N, TB_H5, TB_H4, TB_H3, TB_H2, TB_H1, TB_H0 : std_logic;

       signal TB_KEYLE : std_logic;

end package IOU_TESTBENCH_PACKAGE;
