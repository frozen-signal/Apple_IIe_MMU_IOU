# Understanding the MMU and IOU

## About the sources
Throughout the code, there are comments that refers to the emulator schematics. The format is `[Schematics] @[Coords]:[Component]-[OutPin]`
For example this:
```
    -- MMU_1 @B-1:L2-8
    CASEN_N <= OCASEN_N and PHI_0;
```
refers to the schematic named `MMU_1.jpg`, at a location inside square `B-1` and is the output pin `8` of the component `L2`.

## What are the schematics

These schematics were obtained by Henry S. Courbis, founder of ReActiveMicro, at KansasFest 2016. They seem to be the logic schematics for an emulator that combines both the IOU and the MMU. The exact purpose of this emulator is unknown, but they seem to cover everything the IOU and MMU does. It's possible that it was used to develop what would become the Apple //c. The transistor level schematic seem to be closer to the actual MMU, but it is unknown exactly how similar it is to the official MMU.

## Unimplemented parts

Some parts were not implemented. See [Unimplemented parts](Whats-not-implemented.md) for details.

## IOU
 - [Power-On event and /RESET Pin](reset-and-power-on.md)
 - [Video Scanner](video-scanner.md)
 - [Address decoding inside the IOU](iou-address-decoder.md)
 - [IOU Timing Signals](iou-soft-switches.md)
 - [The Display Address Generation](display-address.md)
 - [The Keyboard Subsystem](iou_keyboard_subsystem.md)
 - [The Soft Switches of the IOU](iou-soft-switches.md)
 - [Misc circuits](spkr-casso-other.md)
 - [IOU Timing Signals](iou-timing-signals.md)

## MMU

The MMU also have a transistor-level schematics. Some important details are discussed here: [Notations of the Transistor Level Schematics](ts-notations.md)

- [The ROM and RAM](mmu-rom-ram.md)
- [The Soft Switches of the MMU](mmu-soft-switches.md)
- [Address decoding inside the MMU](mmu-address-decoder.md)
- [The Generation of the multiplexed addresses in the MMU](mmu-ra-mux.md)
- [Miscellaneous MMU signals](mmu-misc.md)
- [IOU Power-On event and /RESET Pin](reset-and-power-on.md)

## Books

Two books are useful in understanding the schematics.<br/>
First, [_Introduction to VLSI systems_ by Carver Mead and Lynn Conway](https://www.google.com/search?q=pdf+Introduction+to+VLSI+Systems+Mead+and+Conway) is useful in understanding the transistor-level schematics.<br/>
And absolutely vital is [_Understanding the Apple IIe_ by Jim Sather](https://archive.org/details/Understanding_the_Apple_IIe)