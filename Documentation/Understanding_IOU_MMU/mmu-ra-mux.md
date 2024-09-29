# The Generation of the multiplexed addresses in the MMU

## Overview

The MMU drives the RAM address bus from the rising edge of /RAS in the preceding PHI_1 phase up to the falling edge of Q3. The ROW address is placed on the bus until some hold time past the falling edge of /RAS, then the COLUMN address is placed on the bus up to some hold time past Q3. It operates the same way as the IOU, see [DRAM Hold Time](../../CUSTOM/DRAM_HOLD_TIME/readme.md).

### Computation of ROW address
<img src="/resources/MMU_ROW.png" style="width: 480px"/>

> **Note:** A6 is not in the ROW address but in the COL address.

### Computation of COLUMN address
<img src="/resources/MMU_column.png" style="width: 480px"/>
<img src="/resources/MA12.png" style="width: 480px"/>

> **Note:** A6 is in the COL address.

### In the schematics
<a align="center" href="/Schematics/MMU_1.jpg">
    <img src="/resources/MMU_RA_GEN.png" style="width: 320px"/>
</a>
<p><i>MMU_1, @C-4 and D-4:D5 and E5</i></p>

Two LS257s are used to generate the RA data. They drive the RA bus when pin 15 is LOW, that is from the rising edge of /RAS in the preceding PHI_1 phase up to the falling edge of Q3. Note that the CAS Hold Time is added implicitely as the TTL is slow enough not to require any additional delay circuit. See "Understanding the Apple IIe" by Jim Sather, P.5-6

> **Note:** A6 is in the COL address and the pin 11 of D5 is connected to A14 in this implementation because only the circuits with the bonding option 64K HIGH has been implemented (The MMU do not support 16K RAM chips; only 64K chips).
