# Understanding the MMU and IOU

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

