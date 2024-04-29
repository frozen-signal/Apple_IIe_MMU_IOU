This directory contains few implementations of DRAM_HOLD_TIME. This component add the required delays to the signals used by the Apple IIe RAM chips.

#### NOP
This implementation do not add the required delay.
To be used when the delays are added externally, and with the testbenches.

#### VENDOR/ALTERA
This can be used with Altera FPGA/CPLDs that support the LCELL primitive.

#### Specifications
The DRAM used in the Apple IIe require the MMU / IOU to hold the ORA signal values a certain delay past the Row and Column Address Strobe.<br/>
<br/>
The required timings are as follow:<br/>
<img src="/resources/DRAM_HOLD_TIME.png" width="720">

| Parameter | Min | ASIC<sup>1</sup> | Ours<sup>2</sup> | Max | Unit |
| - | -: | -: | -: | -: | - |
| t<sub>RAH</sub> | 32 | 40 | 60 | 80 | ns |
| t<sub>CAH</sub> | 20 | 172 | 48 |  | ns |

<sup>1</sup> The timings of the original Apple IIe MMU/IOU<br/>
<sup>2</sup> The timings we used in this implementation

##### Concerns specific to the Column Address Strobe
In the case of column address, two signals are used by the Apple IIe: /PCAS and Q3. /PCAS is used by the motherboard RAM and needs no hold time, since the ORA bus will be driven up to the falling edge of Q3. Q3 on the other hand is used as a Column Address Strobe by the AUX RAM. We need to add a hold time to ORA past the falling edge of Q3.
