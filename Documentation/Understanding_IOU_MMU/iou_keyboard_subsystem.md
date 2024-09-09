# The Keyboard Sybsystem

## Overview
The keyboard subsystem's task is to generate the value of the KEY soft switch (read access to $C000 - $C00F). This soft switch indicates whether a key as been pressed since the last time it has been reset. The keyboard subsystem also handles the auto-repeat feature that will set KEY at a frequency of 15 hertz while a key is pressed (Note that KEY still need to be reset with $C010 between each auto-repeat cycle).

## Prerequisite Signals

### KSTRB and AKD

Two input pins on the IOU indicates the state of keypresses on the keyboard:
 - IKSTRB is an input that momentarily goes HIGH when an actual key is pressed.
 - IAKD is an input that goes HIGH when an actual key is pressed and remains HIGH for as long as a key remains pressed

These two signals, IKSTRB and IAKD, are delayed by two P_PHI_2 cycles, and these two delayed signals are called KSTRB and AKD.<br/>
See "Understanding the Apple IIe" by Jim Sather, page 7-3 paragraph 4

<a align="center" href="/Schematics/IOU_2.jpg">
    <img src="/resources/IOU_IDelay.png" style="width: 240px"/>
</a>
<p><i>IOU_2, @C-3</i></p>

### AKSTB, and δKSTRB_N

<a align="center" href="/Schematics/IOU_1.jpg">
    <img src="/resources/KeyboardStrobe.png" style="width: 240px"/>
</a>
<p><i>IOU_1, @C-3</i></p>

AKSTB is the Autorepeat Key STroBe. Components M8 and B2 above acts like a risind edge detector and makes AKSTB pulses high for one PHI_0 cycle when PAKST rises. This the ~15 characters per second 'clock' for the auto-repeat.

<img src="/resources/AKSTB_Trace.png" style="width: 820px"/>

δKSTRB_N is KSTRB delayed by one PHI_0 cycle. Used to generate STRBLE [See below](#STRBLE)

### CTC¼S

<a align="center" href="/Schematics/MMU_2.jpg">
    <img src="/resources/CTC14S.png" style="width: 240px"/>
</a>
<p><i>MMU_2, @C-3</i></p>

CTC¼S is generated from TC¼S (See [TC¼S](video-scanner.md#pakst-and-tcs)); TC¼S is delayed one P_PHI_2 cycle.

## Keyboard Signals

The logic-gates schematics seem a bit complex, but it's relatively easy to understand when each piece is examined separately:

<a align="center" href="/Schematics/IOU_2.jpg">
    <img src="/resources/KEYBOARD_GATE_SCH.png" style="width: 820px"/>
</a>
<p><i>IOU_2, @D-1</i></p>

### STRBLE (red part)

The red part in the schematics above acts as an edge detector and STRBLE_N will be LOW for one 14M cycle when KSTRB transitions from LOW to HIGH:

<img src="/resources/STRBLE_Trace.png" style="width: 820px"/>

The end effect is that STRBLE_N will pulse LOW (or HIGH in the case STRBLE) for 14M after a key is pressed.

### Clear Delay (purple part)

Clear Delay will reset the AutoRepeat Delay (The delay after a key is pressed and held down before the AutoRepeat activates, 534 ms to 801 ms) whenever it drops LOW. It happens when no key is pressed (AKD is LOW), or when a key is held down and another key is pressed (For example, holding down 'A' and pressing 'B' while 'A' is repeating will write a single 'B' and stop).

### Set Delay (yellow part)

The two NOR gates in yellow is a SR flip-flop, with its /Q (inverted stored value) output connected to the green N9 component. Its SET input is the inverted AKD (HIGH when no key is pressed), and its RESET input is STRBLE.

The end effect this behaviour:
 - If no key is pressed output N8-4 will be LOW (/Q is the inverse of the flip-flop value)
 - When a key is pressed STRBLE will pulse HIGH and reset the flip-flop and the output N8-4 will be HIGH.

### AutoRepeat Delay (green part)

The component N9 essentially acts as a 3-bit shifter, clocked by CTC¼S that delays the output of the yellow flip-flop.

The end effect at pin N9-7 (AutoRepeat Delay) will be:
 - Remains LOW as long as no key is pressed.
 - When a key is held down, the yellow flip-flip will push a HIGH in the green 3-bit shifter. This shifter will delay this HIGH for 534 ms to 801 ms (the auto-repeat delay), and the output a HIGH N9-7.

 > **Note:** When all keys are released, the LOW propagates with the same delay to N9-7. The immediate deactivation of the auto-repeat is done in the blue part below.

### AutoRepeat Active (blue part)

AutoRepeat Active is connected to the /Q output of the flip-flop which is the inverse of the value of the flip-flop. The RESET pin of the blue flip-flop is connected to the AutoRepeat Delay; this means that when AutoRepeat Delay is HIGH, P7-12 also will be HIGH. Two signals are connected to the SET pin: the inverse of AKD, and STRBLE. This means that P7-12 will be LOW whenever all keys are released or whenever a key is pressed.

The end effect at pin P7-12 (AutoRepeat Active) will be:
 - LOW when no key is pressed.
 - Forced LOW whenever a key is pressed.
 - When a key is pressed and held down, and after the AutoRepeat Delay has passed, will become HIGH.
 - If AutoRepeat Active is HIGH and another key is pressed, AutoRepeat Active will becomne LOW until another AutoRepeat Delay has passed (assuming no key is released).

### KEYLE (cyan part)

KEYLE will be:
 - Pulsed HIGH when a key is pressed.
 - Cycled at 15 hertz (the auto-repeat frequency) if AutoRepeat Active is HIGH

### CLRKEY_N

<a align="center" href="/Schematics/IOU_2.jpg">
    <img src="/resources/CLRKEY_N.png" style="width: 520px"/>
</a>
<p><i>IOU_2, @D-3</i></p>

CLRKEY_N is used to clear the KEY soft switch (See below). It will be LOW on an access to $C010 or a write access to $C01X.

### KEY
<a align="center" href="/Schematics/IOU_1.jpg">
    <img src="/resources/KEY.png" style="width: 320px"/>
</a>
<p><i>IOU_1, @A-3</i></p>

POC_N is a signal that becomes HIGH and remain HIGH once the power-on has completed. See [Power-On event and /RESET Pin](reset-and-power-on.md).
With this circuit, KEY is held LOW during power-on (POC_N LOW). It's set HIGH when KEYLE is HIGH (Pulsed HIGH when a key is pressed, and pulse at a 15 hertz frequency when a key is held down). And KEY is reset LOW when CLRKEY_N is used.<br />

See "Understanding the Apple IIe" by Jim Sather, page 2-16 paragraph "Keyboard Input"