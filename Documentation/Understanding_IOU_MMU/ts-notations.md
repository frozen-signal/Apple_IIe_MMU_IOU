# Notations of the Transistor Level Schematics

To help readers who are unfamiliar with the notations in this schematics, we present them in this section.

## nMOS transistor

<img src="/resources/ts-nmos.png"/>

In the absence of any charge on the gate, the transistor will be in a non-conducting state and no current will flow from the drain to the source. If sufficient positive charge is placed on the gate, the transistor will be in a conducting state and current will flow from the drain to the source. <br/>
See "Introduction to VLSI Systems" by Mead and Conway, page 2.


## The Totem-Pole

<img src="/resources/ts-totem-pole.png"/>

The Totem-Pole is a circuit configuration where two transistors drives the output. One is connected to Vdd with its gate connected to the input "D", and the other is connected to ground with its gate connected to the inversed input "/D". The output thus will be the same as the input signal, but with higher drive strength. <br/>

## The Super Buffer

<img src="/resources/ts-superbuffer-handdrawn.png" style="width: 450px"/>
<img src="/resources/ts-superbuffer.png" style="width: 450px"/>

Super Buffers are circuits capable of driving higher loads, used in the transistor-level schematics on every output capable pin. <br/>
See "Introduction to VLSI Systems" by Mead and Conway, page 15.

# "DET" Constructs

## DET.A

<img src="/resources/ts-det-a.png" style="width: 220px"/>

Connected to the bonding options, this circuit acts as a buffer that provide higher current. For the sake of understanding this schematics, these can be read as a simple connection between "I" and "O".

## DET.B and DET.J

<img src="/resources/ts-det-b.png" style="width: 220px"/>
<img src="/resources/ts-det-j.png" style="width: 220px"/>

The value of input "I" is inverted in "F" (B variant) and is unchanged in "T".

## DET.L

<img src="/resources/ts-det-l.png" style="width: 720px"/>

The DET.L component is similar to a transparent latch and is used to store the soft switches (except the C08X ones, see DET.T below). <br/>
The green loop is the storage node. It has three inputs: itself, D (yellow) and the Reset signal (Red).<br/>
The Reset signal, when HIGH, forces the storage node LOW.<br/>
The two other inputs (itself and D) are connected in a "wired-OR" configuration by the green-blue transistor and the yellow-blue transistor. Since the gate of one transistor is the inverse of the other, the value of "D" will be selected (and stored) when S is HIGH (soft switch is changed), and the stored value will be maintained when S is LOW.<br/>
The output "F" and "FM" will output the inverse of the stored value, "FM" being routed through a totem-pole first.

## DET.Q

<img src="/resources/ts-det-q.png" style="width: 450px"/>

Can be interpreted as a NAND gate.

## DET.R

<img src="/resources/ts-det-r.png" style="width: 220px"/>

This is an electrostatic discharge (ESD) protection circuit. Search on the internet for "Internal ESD Protection on Integrated Circuits" and "Grounded gate N-channel MOSFET" for more details. For the sake of understanding this schematics, they can be ignored.

## DET.S

<img src="/resources/ts-det-s.png" style="width: 620px"/>

The DET.S component is the RA Multiplexer that switches between the ROW and COL part of the address.

## DET.T

<img src="/resources/ts-det-t.png" style="width: 220px"/>

The DET.T component is similar to a transparent latch and is used to store the C08X soft switches.<br/>
The green loop is the storage node. It has three inputs: itself, D (yellow) and the Reset signal (Red).<br/>
The Reset signal, when HIGH, forces the storage node LOW.<br/>
The two other inputs (itself and D) are connected in a "wired-OR" configuration by the green-blue transistor and the yellow-blue transistor. Since the gate of one transistor is the inverse of the other, the value of "D" will be selected (and stored) when H is LOW (soft switch is changed), and the stored value will be maintained when H is HIGH.<br/>
Finally, the orange-blue transistor disconnect the stored value from the ouptut when the stored value is being changed. And the inversed stored value is output.

## DET.U

<img src="/resources/ts-det-u.png" style="width: 220px"/>

The DET.U component is a bi-directional pin driver. But since the "TS" input is always HIGH in the MMU (64K and DIANA bonding options are constant HIGH), DET.U can be interpreted as a wire connecting "IA" to "OA" to form an input pin.
For the sake of understanding this schematics, these can be read as a simple connection between "I" and "O".