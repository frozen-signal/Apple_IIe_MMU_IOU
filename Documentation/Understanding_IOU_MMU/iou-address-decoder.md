# Address decoding inside the IOU

The IOU needs to monitor when special addresses in the range of C0XX are on the address bus. These special addresses are used by the soft-switches, the cassette output, the speaker, and the keyboard subsystem. However, the IOU does not have the address bus as an input, so it relies on the MMU and uses the ORA7-ORA0 pins, A6, and C0XX_N.

## Overview

The IOU needs to identify whether a special address is invoked and, if so, it needs to identify which one (C00X, C01X, C02X, C03X, C04X, C05X, and C07X). To do this, the IOU will first latch the ORA bus when the MMU drives the ROW address. Then the IOU will drive LOW the appropriate signal in a vector that identifies which C0XX is targeted.

## The Address Latch

<img src="/resources/IOUAddressLatch.png" style="width: 280px"/>

To get the lower part or the address, the IOU will latch the ORA bus when the MMU drives the ORA with the ROW part of the address (on the falling edge of P_PHI_2, that is on the falling edge of PRAS_N during PHASE 0). See [P_PHI_2 in "IOU Timing Signals"](iou-timing-signals.md#generation-of-p_phi_2)

> **Note:** LA7 is latched from RA6, this is not an error; the MMU places A7 on ORA6.

## The Address Decode

<img src="/resources/IOUAddressDecoder.png" style="width: 320px"/>

The LS138 above is used as a decoder that converts a 3-bit binary input into eight mutually exclusive active-low outputs. This circuit will select (drive LOW) the corresponding special address signal (C00X_N, C01X_N, C02X_N, C03X_N, C04X_N, C05X_N, C07X_N) from the address bits A6-LA5-LA4. When not enabled, it will instead force all these special address signals HIGH (unselected). It is enabled when all these conditions are met:

 - C0XX_N is LOW (an address in the range of C0XX is on the address bus)
 - Q3 is LOW
 - LA7 is LOW (inverted by the LS04, as pin 6 of the LS138 is active-high) This indicates the address on the bus is in the range of XX[7-0]X.

Combined, these conditions will activate (enable) the LS138 when Q3 drops and an address in the range of C000 to C07F is on the address bus.<br />

<img src="/resources/IOUAddressDecodeTable.png"/>
