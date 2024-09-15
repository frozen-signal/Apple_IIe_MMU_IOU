# Address decoding inside the MMU

## Overview

Almost every feature of the MMU depends on the address on the Address Bus. The role of the Address Decoder in the MMU is to identify which address blocks are being used in order to enable the correct subsystems or to set the correct soft switch. See See "Understanding the Apple IIe" by Jim Sather, from the paragraph "Memory Management" on page 5-20 up to almost the end of the chapter.

## The Address Decode
<a align="center" href="/Schematics/MMU_1.jpg">
    <img src="/resources/mmu-address-decode.png" style="width: 820px"/>
</a>
<p><i>MMU_1, @B-4:F4, @C-3:J4, J5, D4, and F3</i></p>

<a align="center" href="/Schematics/MMU_2.jpg">
    <img src="/resources/mmu-address-decode-2.png" style="width: 400px"/>
</a>
<p><i>MMU_2, @D-2</i></p>

