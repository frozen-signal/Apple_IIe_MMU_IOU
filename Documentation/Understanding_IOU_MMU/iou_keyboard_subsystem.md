# The Keyboard Sybsystem

## Overview
The keyboard subsystem's task is to generate the value of the KEY soft switch (read access to $C000 - $C00F). This soft switch indicates whether a key as been pressed since the last time it has been reset. The keyboard subsystem also handles the auto-repeat feature that will set KEY at a frequency of 15 hertz while a key is pressed. The logic-gates schematics seem a bit complex, but it's relatively easy to understand when each piece is examined separately:

*** FIXME image
<a align="center" href="/Schematics/IOU_2.jpg">
    <img src="/resources/KEYBOARD_GATE_SCH.png" style="width: 820px"/>
</a>
<p><i>IOU_2, @D-1</i></p>

## KSTRB and AKD

Two input pins on the IOU indicates the state of keypresses on the keyboard:
 - IKSTRB is an input that momentarily goes HIGH when an actual key is pressed.
 - IAKD is an input that goes HIGH when an actual key is pressed and remains HIGH for as long as a key remains pressed

These two signals, IKSTRB and IAKD, are delayed by two P_PHI_2 cycles, and these two delayed signals are called KSTRB and AKD. See "Understanding the Apple IIe" by Jim Sather, page 7-3 paragraph 4

<a align="center" href="/Schematics/IOU_2.jpg">
    <img src="/resources/IOU_IDelay.png" style="width: 240px"/>
</a>
<p><i>IOU_2, @C-3</i></p>


## δKSTRB_N and STRBLE

δKSTRB_N is KSTRB delayed by one PHI_0 cycle. The red part in the schematics (FIXME) acts as an edge detector and STRBLE_N will be LOW for one PHI_0 cycle when KSTRB transitions from LOW to HIGH:

<img src="/resources/STRBLE_Trace.png" style="width: 320px"/>

## AKSTB

FIXME AKSTB is the Autorepeat Key STroBe

<img src="/resources/AKSTB_Trace.png" style="width: 320px"/>

### CTC¼S

## KEYLE


## CLRKEY_N and KEY