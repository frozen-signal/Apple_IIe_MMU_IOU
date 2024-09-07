# The Soft Switches of the IOU

## Overview

The IOU is in charge of a few soft switches. Some are exclusive to the IOU, while others are mirrored between the IOU and the MMU. In the IOU, they control several aspects of the display and the annunciators. They can be divided in two groups; those controlled by an address in the C00X range, and those controlled by an address in the C05X range.

## Soft Switches in the C00X range

<img src="/resources/IOU_C00X_SoftSwitches.png" style="width: 280px"/>

The first thing to note is that the logic-gates Schematics are for an emulator which combines the IOU and the MMU. Not all soft switches above are managed by the IOU:

| Signal | Also Called |  |
| --- | --- | --- |
| EN80VID | 80STORE | Mirrored by both the IOU and the MMU |
| FLG1 | RAMRD | *NOT* managed by the IOU |
| FLG2 | RAMWRT | *NOT* managed by the IOU |
| PENIO_N | INTCXROM | *NOT* managed by the IOU |
| ALTSTKZP | ALTZP | *NOT* managed by the IOU |
| INTC300_N | SLOTC3ROM | *NOT* managed by the IOU |
| S_80COL |  | Managed by the IOU |
| PAYMAR | ALTCHRSET | Managed by the IOU |

Signals LA3-LA1 indicates which soft switch is being addressed, and LA0 indicates whether the soft switch will be RESET (LOW) or SET (HIGH); effectively the soft switch will take the value of LA0. Also, in order to change the soft switch, a *write* access must be done to the C00X address. Finally, all the soft switches that are in the C00X range are set to LOW upon RESET.

> **Note:** The MMU do not have a RESET pin. Instead it monitors a triple Page 1 access followed by a 0xFFFC on the address bus. This means that it is possible to create a situation where only the MMU will reset the value of EN80VID.

## Soft Switches in the C05X range

<img src="/resources/IOU_C05X_SoftSwitches.png" style="width: 160px"/>

** FIXME

## Reading the IOU Soft Switches

<img src="/resources/IOU_MD7_SoftSwitches.png" style="width: 280px"/>

** FIXME
