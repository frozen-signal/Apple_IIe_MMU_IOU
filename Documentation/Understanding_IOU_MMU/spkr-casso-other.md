# Misc circuits

## Speaker and Cassette

<a align="center" href="/Schematics/IOU_1.jpg">
    <img src="/resources/SPKR_CASSO.png" style="width: 320px"/>
</a>
<p><i>IOU_1, @C-2</i></p>

> **Note:** The schematic above contains an error; the label at pin 2 should be /SPKR.

The speaker and the cassette output works the same way inside the IOU. The inverted outputs of the flip-flop (pins 6 and 8) are connected to the inputs (pins 2 and 12). The end effect is that any access to C03X (in the case of the speaker) or C02X (in the case of the cassette output) will invert the flip-flop value. Finally, the outputs SPKR and CASSO are connected to output pins.<br/>
See "Understanding the Apple IIe" by Jim Sather, page 7-9.

## RAS_N Hold Time

<a align="center" href="/Schematics/IOU_1.jpg">
    <img src="/resources/RAS_HoldTime.png"/>
</a>
<p><i>IOU_1, @A-4</i></p>

This circuit has no logical effect; it introduces the required DRAM RAS Hold Time.<br/>
See "RAS Hold Time" in the section "ELECTRICAL CHARACTERISTICS AND RECOMMENDED AC OPERATING CONDITIONS" in an Apple IIe compatible DRAM datasheet (for example 4264's datasheet)
