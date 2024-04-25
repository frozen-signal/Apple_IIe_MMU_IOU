This directory contains all the components that may need to be changed depending on the hardware used.

### Summary of Components:
#### POWER_ON_DETECTION
A component that drives a signal HIGH when power-on event is detected, keep it high for 2.4 milisecond, and then drives it LOW for as long as the Apple IIe has power.
<br/>
**Need to be modified if** your FPGA/CPLD do not initialize flip-flops and other memory elements at '0' on power-on.

#### DRAM_HOLD_TIME
A component that adds the delays required by the Apple IIe's multiplexed DRAM.

#### MMU_HOLD_TIME
A component that adds the delays specific to the MMU.

##### Devices supported
- ALTERA devices that support the LCELL primitive.
