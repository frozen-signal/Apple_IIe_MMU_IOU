# The Soft Switches of the IOU

## Overview

The IOU is in charge of a few soft switches. Some are exclusive to the IOU, while others are mirrored between the IOU and the MMU. In the IOU, they control several aspects of the display and the annunciators. They can be divided in two groups; those controlled by an address in the C00X range, and those controlled by an address in the C05X range.

> **Note:** Latched addresses are used to manipulate and read the soft switches. See [<i>The Address Latch</i> in "Address decoding inside the IOU"](iou-address-decoder.md#the-address-latch)

## Soft Switches in the C00X range


<a align="center" href="/Schematics/IOU_2.jpg">
    <img src="/resources/IOU_C00X_SoftSwitches.png" style="width: 280px"/>
</a>
<p><i>IOU_2, @B-1:J7</i></p>

The first thing to note is that the logic-gates schematics contains the design for an emulator which combines the IOU and the MMU. Not all of soft switches above are managed by the IOU:

| Signal | Also Called |  |
| --- | --- | --- |
| EN80VID | 80STORE | Mirrored by **both** the IOU and the MMU |
| FLG1 | RAMRD | **NOT** managed by the IOU |
| FLG2 | RAMWRT | **NOT** managed by the IOU |
| PENIO_N | INTCXROM | **NOT** managed by the IOU |
| ALTSTKZP | ALTZP | **NOT** managed by the IOU |
| INTC300_N | SLOTC3ROM | **NOT** managed by the IOU |
| 80COL |  | Managed by the IOU |
| PAYMAR | ALTCHRSET | Managed by the IOU |

Signals LA3-LA1 indicates which soft switch is being addressed, and LA0 indicates whether the soft switch will be RESET (LOW) or SET (HIGH); effectively the soft switch will take the value of LA0. Also, in order to change the soft switch, a *write* access must be done to the C00X address. Finally, all the soft switches that are in the C00X range are set to LOW upon RESET.

> **Note:** The MMU do not have a RESET pin. Instead it monitors a triple Page 1 access followed by a 0xFFFC on the address bus. This means that it is possible to create a situation where only the MMU will reset the value of EN80VID.

## Soft Switches in the C05X range

<a align="center" href="/Schematics/IOU_1.jpg">
    <img src="/resources/IOU_C05X_SoftSwitches.png" style="width: 160px"/>
</a>
<p><i>IOU_1, @A-2:F7</i></p>

Similar to the EN80VID soft switch above, the PG2 and HIRES soft switches of C05X are mirrored between the IOU and the MMU:

| Signal |   |
| --- | --- |
| ITEXT | Managed by the IOU |
| MIX | Managed by the IOU |
| PG2 | Mirrored by **both** the IOU and the MMU |
| HIRES | Mirrored by **both** the IOU and the MMU |
| AN0 | Managed by the IOU |
| AN1 | Managed by the IOU |
| AN2 | Managed by the IOU |
| AN3 | Managed by the IOU |

Just like the C00X soft switches, signals LA3-LA1 indicates which soft switch is being addressed, and LA0 indicates whether the soft switch will be RESET (LOW) or SET (HIGH); effectively the soft switch will take the value of LA0. But unlike the C00X soft switches, any access to C05X, read or write, will change the soft switch.<br/>
<br/>
The logic-gates schematics contains an error in the above image: The soft switches ITEXT and MIX are unaffected by a reset. The fact that this is an error of the schematics is supported by "Understanding the Apple IIe" which says that ITEXT and MIX are not changed by RESET_N going LOW. And this is further supported by the fact that the schematics of Apple IIe's predecessor has the CLR pin of the 74LS259 tied to +5v (see page 207, component F4 of figure C-12 of "The Apple II Circuit Description" by W. Gayler). All others C05X soft switches are set LOW upon RESET however.

> **Note:** The MMU do not have a RESET pin. Instead it monitors a triple Page 1 access followed by a 0xFFFC on the address bus. This means that it is possible to create a situation where only the MMU will reset the value of PG2 and HIRES.

## Reading the IOU Soft Switches

<a align="center" href="/Schematics/IOU_2.jpg">
    <img src="/resources/IOU_MD7_SoftSwitches.png" style="width: 280px"/>
</a>
<p><i>IOU_2, @C-2 and D-2</i></p>

Again, the logic-gates schematics contains the design for an emulator which combines the IOU and the MMU. This means that the IOU will only drive MD7 when one of the soft switch in orange above is read.<br/>
<br/>
The B4 and H3 part of the circuit above will drive MD7 when a read access is made to C00X. MD7 will be the value of the signal KEY which is managed by the Keyboard Subsystem (See [The Keyboard Subsystem](iou_keyboard_subsystem.md))<br/>
<br/>
The L7 and M7 components will drive MD7 when a read access is made to C01X. The value of MD7 will depend on LA2-LA1-LA0:

| Address | Soft Switch |
| --- | --- |
| C010 | AKD |
| C019 | VBL_N |
| C01A | ITEXT |
| C01B | MIX |
| C01C | PG2 |
| C01D | HIRES |
| C01E | PAYMAR |
| C01F | 80COL |

Finally, the IOU will drive MD7 during last three 14M periods of PHASE 0 and the first 14M period of the following PHASE 1, when C00X or C019-C01F is read.

