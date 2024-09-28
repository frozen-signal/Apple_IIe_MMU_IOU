# The Soft Switches of the MMU

## Overview

The MMU is in charge of a few soft switches. Some are exclusive to the MMU, while others are mirrored between the IOU and the MMU. In the MMU, they control all aspects of memory access. They can be divided in three groups; those controlled by an address in the C00X range, those controlled by an address in the C05X range, and those controlled by an address in the C08X range.


## Soft Switches in the C00X range

<a align="center" href="/Schematics/IOU_2.jpg">
    <img src="/resources/IOU_C00X_SoftSwitches.png" style="width: 280px"/>
</a>
<p><i>IOU_2, @B-1:J7</i></p>

> **Note:** The logic-gates schematics contains the design for an emulator which combines the IOU and the MMU, this is why the MMU C00X soft-switches are shown on the IOU pages.

Not all of soft switches above are managed by the MMU:

| Signal | Also Called |  |
| --- | --- | --- |
| EN80VID | 80STORE | Mirrored by **both** the IOU and the MMU |
| FLG1 | RAMRD | Managed by the MMU |
| FLG2 | RAMWRT | Managed by the MMU |
| PENIO_N | INTCXROM | Managed by the MMU |
| ALTSTKZP | ALTZP | Managed by the MMU |
| INTC300_N | SLOTC3ROM | Managed by the MMU |
| 80COL |  | **NOT** managed by the MMU |
| PAYMAR | ALTCHRSET | **NOT** managed by the MMU |


In the MMU, signals A3-A1 (instead of LA3-LA1) indicates which soft switch is being addressed, and A0 (instead of LA0) indicates whether the soft switch will be RESET (LOW) or SET (HIGH); effectively the soft switch will take the value of A0. Also, in order to change the soft switch, a *write* access must be done to the C00X address. Finally, all the soft switches that are in the C00X range are set to LOW upon RESET. Note that the MMU do not have a RESET pin. Instead it monitors a triple Page 1 access followed by a 0xFFFC on the address bus. This means that it is possible to create a situation where only the MMU will reset the value of EN80VID.

## Soft Switches in the C05X range

<a align="center" href="/Schematics/IOU_1.jpg">
    <img src="/resources/IOU_C05X_SoftSwitches.png" style="width: 160px"/>
</a>
<p><i>IOU_1, @A-2:F7</i></p>

> **Note:** The logic-gates schematics contains the design for an emulator which combines the IOU and the MMU, this is why the MMU C05X soft-switches are shown on the IOU pages.

Similar to the EN80VID soft switch above, the PG2 and HIRES soft switches of C05X are mirrored between the IOU and the MMU:

| Signal |   |
| --- | --- |
| ITEXT | **NOT** managed by the MMU |
| MIX | **NOT** managed by the MMU |
| PG2 | Mirrored by **both** the IOU and the MMU |
| HIRES | Mirrored by **both** the IOU and the MMU |
| AN0 | **NOT** managed by the MMU |
| AN1 | **NOT** managed by the MMU |
| AN2 | **NOT** managed by the MMU |
| AN3 | **NOT** managed by the MMU |

Just like the C00X soft switches, signals A3-A1 are used instead of LA3-LA1 and they indicates which soft switch is being addressed. Also similar to the C00X switches, A0 is used instead of LA0, and it indicates whether the soft switch will be RESET (LOW) or SET (HIGH); effectively the soft switch will take the value of A0. But unlike the C00X soft switches, any access to C05X, read or write, will change the soft switch.<br/>
All C05X soft switches in the MMU are set LOW upon RESET.

> **Note:** The MMU do not have a RESET pin. Instead it monitors a triple Page 1 access followed by a 0xFFFC on the address bus. This means that it is possible to create a situation where only the MMU will reset the value of PG2 and HIRES.


## Soft Switches in the C08X range

<a align="center" href="/Schematics/MMU_1.jpg">
    <img src="/resources/MMU_C08X_SoftSwitches.png" style="width: 160px"/>
</a>
<p><i>MMU_1, @C-1:E4</i></p>

DEV0_N is LOW when $C08X is on the address bus. And the trio FST_ACC, WRPROT, and WREN are a bit special, see "Understanding the Apple IIe" by Jim Sather p.5-23

| Signal | Also Called |
| --- | --- |
| BANK1 |  |
| BANK2 |  |
| RDRAM | HRAMRD |
| FST_ACC | PRE-WRITE |
| WRPROT | HRAMWRT' |
| WREN |  |
