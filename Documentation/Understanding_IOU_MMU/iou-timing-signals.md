# IOU Timing Signals

## Overview

The IOU generates several signals that helps in generating the TV Video Signal. FIXME

## Phase Signals

### P_PHI_0, P_PHI_1, P_PHI_2

<img src="/resources/P_PHI_0_1_2_Trace.png" style="width: 1325px"/>

#### Generation of P_PHI_0 and P_PHI_1
<a align="center" href="/Schematics/IOU_1.jpg">
    <img src="/resources/P_PHI_0_1.png" style="width: 320px"/>
</a>
<p><i>IOU_1, @B-3:H5</i></p>

The value of PHI_0 is latched when both PRAS_N and Q3 are LOW. The end effect is that P_PHI_0 has the same shape as PHI_0, but rises 3 14M clocks cycles before PHI_0. As for P_PHI_1, it is the inverse of P_PHI_0.

#### Uses of P_PHI_0 and P_PHI_1

P_PHI_0 is only used in the generation of P_PHI_2. In schematics, P_PHI_1 is used in the IOU RA Mux (IOU_1 @D3:K8) as the output enable signal. It is not used in this implementation: Since the code for the RA Mux is shared between the IOU and the MMU, we generate the output enable directly in that component.

#### Generation of P_PHI_2

<a align="center" href="/Schematics/IOU_1.jpg">
    <img src="/resources/P_PHI_2.png" style="width: 230px"/>
</a>
<p><i>IOU_1, @C-3:B9</i></p>

P_PHI_2 follows PRAS_N, but skip the HIGH when PRAS_N rises during PHASE 0.

#### Uses of P_PHI_2

P_PHI_2 is used in the Keyboard Subsystem (See FIXME), in the generation of some video signals (See [Video Signals](#video-signals) below), and the IOU Address Latch (See FIXME).

## Video Signals

### LGR_TXT_N, PGR_TXT_N, CLRGAT_N

#### LGR_TXT_N and PGR_TXT_N

<a align="center" href="/Schematics/IOU_1.jpg">
    <img src="/resources/LGR_TXT_N.png" style="width: 520px"/>
</a>
<p><i>IOU_1, @B-2 and B-1</i></p>

This signal identifies if text characters should be displayed or not. See "Understanding the Apple IIe" by Jim Sather P.8-11. In the book, LGR_TXT_N is called GR+2, and PGR_TXT_N is called GR+1. <br/>
In this repository, LGR_TXT_N and PGR_TXT_N are clocked on PHI_0 instead of P_PHI_2. Below is an oscilloscope capture of LGR_TXT_N and PHI_0 using an official IOU. We can see that PHI_0 should be used.

<img src="/resources/LGR_TXT_N_SCOPE.png" style="width: 520px"/>
<p><i>LGR_TXT_N</i> is clocked on PHI_0</p>

### SEGA, SEGB, SEGC

These three signals are inputs of the Video ROM in the Apple IIe. When characters are displayed, these identifies which row of the character is currently rendered. For a detailled explanation of these signals, see "Understanding the Apple IIe" by Jim Sather, P.8-12.<br/>
Just like LGR_TXT_N, PHI_0 is used to clock these signals instead of P_PHI_2.

### HBL_N, VBL_N, BL_N, and WNDW_N

HBL_N is the Horizontal BLanking period, and VBL_N is the Vertical BLanking period. The value of these two signals define the visible part of the display:
<img src="/resources/HBL_N__VBL_N.png" style="width: 520px"/>
<p><i>HBL_N</i> and <i>VBL_N</i> values during display</p>

BL_N is similar; it is LOW whenever the Video Scanner is in a blanking area, and HIGH when in the displayed area. WNDW_N is the signal BL_N, but delayed one PHI_0 cycle as seen below:
<img src="/resources/WNDW_N_Timing_Trace.png" style="width: 840px"/>
<p><i>WNDW_N</i> is <i>BL_N</i> delayed by one PHI_0 cycle</p>


### V1_N_V5_N, V2_V2_N, PSYNC_N, SYNC_N

### RA9_N, RA10_N

