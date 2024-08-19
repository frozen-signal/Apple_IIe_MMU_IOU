# IOU Power-On event and /RESET Pin

## Description and Behavior

### Overview
Some IOU internal registers need to be initialized just once, at power-on, while others need to be initialized everytime the Apple IIe is reset. Two signals exist in the IOU (`POC` and `/RESET`) to help with these initializations.
The `/RESET` signal is routed to an external pin on the IOU and has the following characteristics:
- Active-low
- Bidirectional
- Open-drain
- Has a weak pull-up

### Power-On Behavior
When the Apple IIe is powered on, the IOU manages the `/RESET` signal as follows:

1. Initial state: The IOU holds `/RESET` low for approximately 33 ms[^1].
2. After power-on initialization: The `/RESET` pin becomes an input pin.

> **Note:** While the combined Emulator schematics show different timings (about 275 ms), the actual IOU timing is approximately 35 ms. This delay likely allows various components to stabilize to a known state.
[^1]: This 33 ms duration is effectively masked if a disk controller is present, as the controller extends the /RESET low state to 100 ms.
>
### Emulator Implementation

#### Power-On Delay Generation
In the emulator schematics, the power-on delay is generated using:
1. A Voltage Trigger RC Circuit
2. A 555 timer (functioning as a Schmitt trigger)

The `POC` (Power-On Clear) signal starts HIGH and transitions to LOW after a specific delay.

#### Voltage Trigger RC Circuit
<a align="center" href="/Schematics/MMU_1.jpg">
    <img src="/resources/VTR.png" style="width: 683px"/>
</a>
<p align="center"><i>MMU_1 @B-3</i></p>

- `VTR` likely stands for "Voltage TRigger"
- Initial state: Capacitor discharged, `VTR` at 0V
- After ~242 ms: `VTR` reaches 2/3 Vcc (+3.33V), triggering the 555 Timer

#### 555 timer
<a align="center" href="/Schematics/MMU_1.jpg">
    <img src="/resources/555%20timer.png" style="width: 683px"/>
</a>
<p align="center"><i>MMU_1 @B-2</i></p>

- Output signal: `POC` (Power-On Clear)
- Initial state: `POC` is HIGH (`VTR` < 1/3 Vcc)
- Transition: When `VTR` ≥ 2/3 Vcc (~242 ms), output switches to LOW
- Maintains LOW state until powered off

### /RESET Signal Generation

#### SR Latch
<a align="center" href="/Schematics/MMU_1.jpg">
    <img src="/resources/RESET_N.png" style="width: 683px"/>
</a>
<p align="center"><i>MMU_1 @B-4</i></p>

- Inputs:
  - `S`: Connected to `POC`
  - `R`: Logical AND of:
    - `TC`: HIGH for one PHI_0 cycle when video scanner overflows (See *FIXME*)
    - `P_PHI_1`: Delayed PHI_0 signal (See *FIXME*, can be considered equivalent to PHI_0 for this explanation)

#### /RESET Behavior During Power-On

Initial SR Latch input states:

| Signal   | Value |
|----------|-------|
| `TC`     | LOW   |
| `P_PHI_1`| LOW   |
| `POC`    | HIGH  |

Sequence of events:
1. Initial state: The output of the SR Latch is HIGH, and the 2N3904 creates a low-resistance path to ground, forcing `/RESET` LOW.
2. `POC` transitions to LOW, allowing the video scanner to count up.
3. Video scanner overflow: `TC` goes HIGH for one PHI_0 cycle.
4. Within that cycle, when `P_PHI_0` goes HIGH, the SR Latch resets.
5. SR Latch output LOW: Path from `/RESET` to ground is cut. And `/RESET` is now pulled up by the weak pull-up (3.3K resistor A4). The IOU will not drive the `/RESET` pin again for as long as it has power.
