# The Display Address Generation

## Overview

The correspondance of a pixel's coordinates on the screen to it's location in RAM is not trivial on the Apple IIe. The exact reasons why it's done this way are probably lost to history, but we can speculate that the two main reasons were to waste as little memory as possible, and use the video system for the required dynamic RAM refresh.<br />
<br />
The address depends on two things: the [Video Scanner](video-scanner.md)'s outputs and the graphics mode. The address generation is split in two phases: the ROW address, then the COLUMN address.

## Generation of &Sigma;3-0

FIXME schematics image

The computation of &Sigma;3-0 in the schematics is unnecessarily complex, probably due to them being constrained to logic gates only. It is also possibly incorrect. Instead, it is better to use the computation described in "Understanding the Apple IIe" by Jim Sather, P.5-9:
 <pre>
     0   0   0   1
   /H5 /H5  H4  H3
 +  V4  V3  V4  V3
 -----------------
    &Sigma;3  &Sigma;2  &Sigma;1  &Sigma;0
</pre>

## Compute the graphics mode dependant values
### 1. Compute VID_PG2_N
<a align="center" href="/Schematics/IOU_1.jpg">
    <img src="/resources/vidpg2.png" style="width: 480px"/>
</a>
<p align="center"><i>IOU_2, @C-4:E2</i></p>

### 2. Compute HIRESEN_N
<a align="center" href="/Schematics/IOU_1.jpg">
    <img src="/resources/HIRESEN_N.png" style="width: 480px"/>
</a>
<p align="center"><i>IOU_2, @C-4:E3</i></p>

### 3. Compute Z values

#### When HIRESEN_N = 0

| Z | Value |
| --- | --- |
| ZA | VA |
| ZB | VB |
| ZC | VC |
| ZD | VID_PG2_N |

#### When HIRESEN_N = 1

| Z | Value |
| --- | --- |
| ZA | VID_PG2_N |
| ZB | NOT(VID_PG2_N) |
| ZC | 0 |
| ZD | 0 |

#### In all cases
<a align="center" href="/Schematics/IOU_1.jpg">
    <img src="/resources/ZE.png" style="width: 480px"/>
</a>
<p align="center"><i>IOU_2, @A-4:L9</i></p>

## Generation of the multiplexed addresses

### Timing of ROW and COLUMN address

The IOU drives the RAM address bus from the rising edge of /RAS in the preceding PHI_0 phase up to the falling edge of Q3. The ROW address is placed on the bus until some hold time past the falling edge of /RAS, then the COLUMN address is placed on the bus up to some hold time past Q3. It operates the same way as the MMU, see [DRAM Hold Time](../../CUSTOM/DRAM_HOLD_TIME/readme.md).

### Computation of ROW address
<img src="/resources/IOU_ROW.png" style="width: 480px"/>

### Computation of COLUMN address
<img src="/resources/IOU_column.png" style="width: 480px"/>
