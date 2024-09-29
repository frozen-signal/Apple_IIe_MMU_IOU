# Miscellaneous MMU signals

## INTIO_N and KBD

<a align="center" href="/Schematics/MMU_1.jpg">
    <img src="/resources/INTIO_KBD.png" style="width: 320px"/>
</a>
<p><i>MMU_1, @D-3 to C-2</i></p>

### INTIO_N
INTIO_N will be LOW when the address on the bus is in the range $C000-$C01F.<br/>
> **Note:** In the emulator schematic, the output of J3-11 is labeled INTIO; it should be INTIO_N.

### KBD
Used in the transfert of the keystroke to MD6-MD0. See "Understanding the Apple IIe" by Jim Sather, page 2-16 paragraph "Keyboard Input"

## DEV0_N - DEV6_N

<a align="center" href="/Schematics/MMU_1.jpg">
    <img src="/resources/MMU_DEV.png" style="width: 320px"/>
</a>
<p><i>MMU_1, @C-3</i></p>

A few active-low signals that indicates that some specific addresses are on the bus:

| DEV | Address |
| --- | --- |
| DEV_0_N | $C08X |
| DEV_1_N | $C09X |
| DEV_2_N | $C0AX |
| DEV_5_N | $C0DX |
| DEV_6_N | $C0EX |

## CXXXOUT

<a align="center" href="/Schematics/MMU_2.jpg">
    <img src="/resources/CXXXOUT.png" style="width: 520px"/>
</a>
<p><i>MMU_2, @C-3</i></p>

Hand-written notes above CXXOUT_N:
<pre>
If INTC800ACC = '1'
If C0XX       = '0'
</pre>

<a align="center" href="/Schematics/MMU_1.jpg">
    <img src="/resources/CXXX_PIN.png" style="width: 320px"/>
</a>
<p><i>MMU_1, @B-3</i></p>

Active-high signal that indicate to the IOU that an address it handles is on the bus. Note that VLC is a bonding option that is a constant LOW in this repository. Therefore, pin 24 (marked CXXX / SELIO_N) is always the inverse of CXXXOUT_N.

## MPON_N

<a align="center" href="/Schematics/MMU_2.jpg">
    <img src="/resources/MPON_N.png" style="width: 720px"/>
</a>
<p><i>MMU_1, @B-4 to A-2</i></p>

The MMU do not have a RESET_N pin. Instead it must be clever and detect a RESET by monitoring for a triple Page 1 access followed by a 0xFFFC on the address bus.

## INTC8EN

<a align="center" href="/Schematics/MMU_2.jpg">
    <img src="/resources/MMU_INTC8EN_CTC14S.png" style="width: 520px"/>
</a>
<p><i>MMU_1, @C-4</i></p>

INTC8EN is a signal that is used in the computation of ROMEN1_N. See "Understanding the Apple IIe" by Jim Sather, p.5-28
