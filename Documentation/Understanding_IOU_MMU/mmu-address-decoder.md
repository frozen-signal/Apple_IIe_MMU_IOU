# Address decoding inside the MMU

## Overview

Almost every feature of the MMU depends on the address on the Address Bus. The role of the Address Decoder in the MMU is to identify which address blocks are being used in order to enable the correct subsystems or to set the correct soft switch. See See "Understanding the Apple IIe" by Jim Sather, from the paragraph "Memory Management" on page 5-20 up to almost the end of the chapter.

## The Address Decode
<a align="center" href="/Schematics/MMU_1.jpg">
    <img src="/resources/mmu-address-decode.png" style="width: 820px"/>
</a>
<p><i>MMU_1, @B-4:F4, @C-3:J4, J5, D4, and F3</i></p>

> **Note 1:** Since the emulator combines the IOU and the MMU, the addresses decoded in the CXXX range that are used by the MMU are prefixed with a 'M'.
> **Note 2:** S5 stands for Soft 5, a 'soft' 5v. Comes from the Apple II.

The decoding is straightforward, however there are some things to note.
| Component | Pin | Note |
| --- | --- | --- |
| D4 | 11 | There seems to be a typo in the schematics: It's labeled /E-FXX but should be /E_FXXX |
| F3 | 11 | There seems to be a typo in the schematics: It's labeled /D-FXXX (active low) but should be D-FXXX (active high) |
| J5 | 10 | /MC05X should be present;  Used for the soft switches HIRES (C056/7) and PG2 (C054/5). See the ASIC schematics. |

## Φ0/1XX and Φ0/7XX

<a align="center" href="/Schematics/MMU_2.jpg">
    <img src="/resources/mmu-address-decode-2.png" style="width: 400px"/>
</a>
<p><i>MMU_2, @D-2</i></p>

These signals are only used in the computation of /SELMB (See MMU_2 @B-1). These are not used in this implementation because the computation of /SELMB in the logical gate schematics may contain an error. Instead, this implementation uses the computation from the transistor-level schematics which are both correct and much simpler. See ** FIXME **


