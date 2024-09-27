# The ROM and RAM

## Overview

The MMU generates several signals that control the access to the C-D ROM, E-F ROM, the motherboard RAM, and the AUX Card RAM.

## CASEN_N and R_W_N_245
### PCASEN_N, OCASEN_N, and R_W_N_245
<a align="center" href="/Schematics/MMU_1.jpg">
    <img src="/resources/PCASEN_N__R_W_N_245.png" style="width: 720px"/>
</a>
<p><i>MMU_1, @D-3 to D-1</i></p>
Hand-written notes on the schematics above:<br/>
<br/>
Below PCASEN_N:
```
Turns off HIGH - CXXX
                 INH
                 Read ROM
                 Write to Lang. Card W/WR PROT SET
```
<br/>
Below OCASEN_N:
```
R.C020-C0FF  Access = '1"
  C000-C01F  Access = '0'
  C800       "      = '0'
```
<br/>
Below R_W_N_245:
```
if not(DMA) then Rd*CXXXOUT*INTIO_N
```
<br/>
> **Note:** In the transistor-level schematics, OCASEN is forced LOW on MPON. Here that means OCASEN_N is forced HIGH on MPON_N.

### CASEN_N
<a align="center" href="/Schematics/MMU_1.jpg">
    <img src="/resources/CASEN_N.png" style="width: 320px"/>
</a>
<p><i>MMU_1, @B-1</i></p>

The bonding option `64K` in this repository is a constant HIGH, therefore CASEN_N is the same as OCASEN_N.

## ROMEN1_N and ROMEN2_N
<a align="center" href="/Schematics/MMU_2.jpg">
    <img src="/resources/ROMEN_N.png" style="width: 720px"/>
</a>
<p><i>MMU_2, @D-4 and D-3</i></p>

ROMEN1_N and ROMEN2_N remains HIGH unless the MMU determines that the address on the bus targets one of the two ROM chip. When that happens, the MMU drives LOW the corresponding ROMEN_N signal. See "Understanding the Apple IIe" by Jim Sather p.5-28 and p.6-2. Note in the above schematics ROMEN1_N has INH hand-drawn and ROMEN2_N has no link to INH. In "Understanding the Apple IIe" by Jim Sather p.5-30 point 9, and in the transistor-level schematics, these two signals can be seen to be gated by INH.

## SELMB_N and EN80_N
<a align="center" href="/Schematics/MMU_2.jpg">
    <img src="/resources/SELMB_N_LOGIC.png" style="width: 720px"/>
</a>
<p><i>MMU_2, @C-3 to B-1</i></p>

Hand-written notes next to SELMB_N:<br/>
```
When HIGH turns off CAS
     LOW            SELMB
```
<br/>
The generation of SELMB_N is very complex in the logic-level schematics (and possibly incorrect). The transistor-level schematics, on the other hand, is much simpler. This repository uses this latter version.
<a align="center" href="/Schematics/MMU_ASIC.jpg">
    <img src="/resources/SELMB_N_TRANSISTOR.png" style="width: 720px"/>
</a>