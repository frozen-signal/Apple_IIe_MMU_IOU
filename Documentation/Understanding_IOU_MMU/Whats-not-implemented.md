# What was are the schematics

These schematics were obtained by Henry S. Courbis, founder of ReActiveMicro, at KansasFest 2016. They seem to be the logic schematics for an emulator that combines both the IOU and the MMU. The exact purpose of this emulator is unknown, but it's possible that it was to develop what would become the Apple //c. The transistor level schematic seem to be closer to the actual MMU, but it is unknown exactly how similar it is to the official MMU.

# What was not implemented

Only features related to the Apple IIe were implemented. These are the bonding options used in this implementation:
| Bonding<br/>Option | Value |
| --- | --- |
| 64K | HIGH |
| VLC | LOW |
| INVIO' | LOW |
| DIANA | HIGH |

In red, the part of the schematics that were not implemented:
## IOU 1
Everything was implemented in IOU_1

## IOU 2
<img src="/resources/NotImplemented_IOU_2.jpg" style="width: 1920px"/>

## MMU 1
<img src="/resources/NotImplemented_MMU_1.jpg" style="width: 1920px"/>

## IOU 2
<img src="/resources/NotImplemented_MMU_2.jpg" style="width: 1920px"/>