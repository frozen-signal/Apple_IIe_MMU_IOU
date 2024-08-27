# IOU Timing Signals

## Overview

The IOU generates several signals that helps in generating the TV Video Signal. FIXME

## Phase Signals

### P_PHI_0, P_PHI_1, P_PHI_2

*** FIXME P_PHI_0_1_2_Trace.png

#### Generation of P_PHI_0 and P_PHI_1
*** FIXME: P_PHI_0_1

The value of PHI_0 is latched when both PRAS_N and Q3 are LOW. The end effect is that P_PHI_0 has the same shape as PHI_0, but rises 3 14M clocks cycles before PHI_0. As for P_PHI_1, it is the inverse of P_PHI_0.

#### Uses of P_PHI_0 and P_PHI_1

P_PHI_0 is only used in the generation of P_PHI_2. In schematics, P_PHI_1 is used in the IOU RA Mux (IOU_1 @D3:K8) as the output enable signal. It is not used in this implementation: Since the code for the RA Mux is shared between the IOU and the MMU, we generate the output enable directly in that component.

#### Generation of P_PHI_2

FIXME: P_PHI_2

P_PHI_2 follows PRAS_N, but skip the HIGH when PRAS_N rises during PHASE 0.

#### Uses of P_PHI_2

P_PHI_2 is used in the Keyboard Subsystem (See FIXME) and the IOU Address Latch (See FIXME)

## Video Signals

### LGR_TXT_N, CLRGAT_N -> text / color mode

### SEGA, SEGB, SEGC

These three signals are inputs of the Video ROM in the Apple IIe. For a detailled explanation of these signals, see "Understanding the Apple IIe" by Jim Sather, P.8-12.


### WNDW_N, BL_N, HBL_N

### V1_N_V5_N, V2_V2_N, PSYNC_N, SYNC_N

### RA9_N, RA10_N


FIXME: P_PHI_0, P_PHI_1