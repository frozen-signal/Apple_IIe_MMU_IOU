# The ROM and RAM

## Overview

The MMU generates several signals that control the access to the C-D ROM, E-F ROM, the motherboard RAM, and the AUX Card RAM.

## R_W_N_245 and CASEN_N

### Description

These two signals are related to the data bus. R_W_N_245 controls the direction of the bidirectional peripheral data bus driver (a LS245), and CASEN_N prevent CAS_N from falling during PHASE_0 when the motherboard RAM is not read or written.

### R_W_N_245, PCASEN_N and OCASEN_N
<a align="center" href="/Schematics/MMU_1.jpg">
    <img src="/resources/PCASEN_N__R_W_N_245.png" style="width: 720px"/>
</a>
<p><i>MMU_1, @D-3 to D-1</i></p>
Hand-written notes on the schematics above:<br/>
<br/>
Below PCASEN_N:
<pre>
Turns off HIGH - CXXX
                 INH
                 Read ROM
                 Write to Lang. Card W/WR PROT SET
</pre>
<br/>
Below OCASEN_N:
<pre>
R.C020-C0FF  Access = '1"
  C000-C01F  Access = '0'
  C800       "      = '0'
</pre>
<br/>
Below R_W_N_245:
<pre>
if not(DMA) then Rd*CXXXOUT*INTIO_N
</pre>
<br/>

> **Note:** In the transistor-level schematics, OCASEN is forced LOW on MPON. Here that means OCASEN_N is forced HIGH on MPON_N.


PCASEN_N is used in the generation of EN80_N and OCASEN_N, and OCASEN_N is used to generate CASEN_N.

### CASEN_N
<a align="center" href="/Schematics/MMU_1.jpg">
    <img src="/resources/CASEN_N.png" style="width: 320px"/>
</a>
<p><i>MMU_1, @B-1</i></p>

The bonding option `64K` in this repository is a constant HIGH, therefore CASEN_N is the same as OCASEN_N. When HIGH, CASEN_N (CAS ENable) prevent CAS_N from falling during PHASE_0 when the motherboard RAM is not read or written.

## ROMEN1_N and ROMEN2_N
<a align="center" href="/Schematics/MMU_2.jpg">
    <img src="/resources/ROMEN_N.png" style="width: 720px"/>
</a>
<p><i>MMU_2, @D-4 and D-3</i></p>

ROMEN1_N and ROMEN2_N remains HIGH unless the MMU determines that the address on the bus targets one of the two ROM chip. When that happens, the MMU drives LOW the corresponding ROMEN_N signal. See "Understanding the Apple IIe" by Jim Sather p.5-28 and p.6-2. Note in the above schematics ROMEN1_N has INH hand-drawn and ROMEN2_N has no link to INH. In "Understanding the Apple IIe" by Jim Sather p.5-30 point 9, and in the transistor-level schematics, these two signals can be seen to be gated by INH.

## SELMB_N and EN80_N
### SELMB_N
<a align="center" href="/Schematics/MMU_2.jpg">
    <img src="/resources/SELMB_N_LOGIC.png" style="width: 720px"/>
</a>
<p><i>MMU_2, @C-3 to B-1</i></p>

Hand-written notes next to SELMB_N:<br/>
<pre>
When HIGH turns off CAS
     LOW            SELMB
</pre>
<br/>
This signal indicates whether the motherboard RAM (SELMB_N LOW) or the AUX RAM (SELMB_N HIGH) is used
The generation of SELMB_N is very complex in the logic-level schematics (and possibly incorrect). The transistor-level schematics, on the other hand, is much simpler. This repository uses this latter version.
<a align="center" href="/Schematics/MMU_ASIC.jpg">
    <img src="/resources/SELMB_N_TRANSISTOR.png" style="width: 720px"/>
</a>

SELMB_N is generated through a 'wired-or' chain.
| Location<br/>in schematic | Description |
| --- | --- |
| A | The transistor will conduct FLG2 (also called RAMWRT) if it's a write operation. It switches between motherboard RAM (FLG2 = '0') and AUX RAM (FLG2 = '1') |
| B | The transistor will conduct FLG1 (also called RAMRD) if it's a read operation. It switches between motherboard RAM (FLG1 = '0') and AUX RAM (FLG1 = '1') |
| C | The transistor will conduct /PG2 when accessing primary display range ($0400-$07FF) while EN80VID is set. PG2 switches between motherboard RAM (PG2 = '0') and AUX RAM (PG2 = '1') |
| D | The transistor will conduct /PG2 when accessing HIRES display range ($2000-$3FFF) while EN80VID and HIRES are set. PG2 switches between motherboard RAM (PG2 = '0') and AUX RAM (PG2 = '1') |
| E | A LOW at the output of this NAND gate signify that the address is in the range $D000-$FFFF. |
| F | The transistor will conduct ALTSTKZP when the address is in the range $D000-$FFFF. ALTSTKZP switches the $0000-$01FF and the $D000-$FFFF range between motherboard RAM (ALTSTKZP = '0') and AUX RAM (ALTSTKZP = '1') |
| G | The transistor will conduct ALTSTKZP when the address is in the range $0000-$01FF. ALTSTKZP switches the $0000-$01FF and the $D000-$FFFF range between motherboard RAM (ALTSTKZP = '0') and AUX RAM (ALTSTKZP = '1') |
| H & I | The transistor will only conduct when none of the C-D-F-G conditions are met. This essentially selects between the A-B part of the circuit, or the C-D-F-G part. |

### EN80_N
<a align="center" href="/Schematics/MMU_2.jpg">
    <img src="/resources/EN80_N.png" style="width: 520px"/>
</a>
<p><i>MMU_2, @C-1</i></p>

For a description of EN80_N, see "Understanding the Apple IIe" by Jim Sather p.5-3 section "RAM CONNECTIONS IN THE APPLE IIe".

