This directory contains few implementations of MMU_HOLD_TIME, a component that adds the delays specific to the MMU.

#### NOP
This implementation do not add the required delay.
To be used when the delays are added externally and with the testbenches.

#### DELAY_CLK
This implementation add the required delay through a clock signal.
To be used when the delays are generated from an internal or external oscillator.
NOTE: The number of ticks will need to be adjusted depending on the DELAY_CLK frequency.

#### VENDOR/ALTERA
This can be used with Altera FPGA/CPLDs that support the LCELL primitive.

#### Specifications
The signals /EN80 is required to hold it's value a certain delay past the PHI_0 change.<br/>
The signals /ROMEN1 and /ROMEN2 also show a hold delay, but don't seem to be necessary. It is added nonetheless for the sake of being closer to the ASIC MMU's timings.
<br/>
To add the delay, we add a delay to PHI_0 and use this delayed signal in the computation of /EN80, /ROMEN1, and /ROMEN2.
<br/>
<br/>
The required timings are as follow:<br/>
##### /EN80
<img src="/resources/EN80_HOLD_TIME.png" width="720">

##### /ROMEN2 and /ROMEN1
<img src="/resources/ROMEN_HOLD_TIME.png" width="720">

##### Timings
| Parameter | Min | ASIC<sup>1</sup> | Ours<sup>2</sup> | Max | Unit |
| - | -: | -: | -: | -: | - |
| t<sub>EH</sub> |  | 45 | 45 |  | ns |
| t<sub>RH</sub> | 0 | 45 | 45 |  | ns |

<sup>1</sup> The timings of the original Apple IIe MMU/IOU<br/>
<sup>2</sup> The timings we used in this implementation
