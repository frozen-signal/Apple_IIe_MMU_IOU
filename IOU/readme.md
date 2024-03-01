# IOU

### Ordered Pins and Signal Names
| IOU Socket<br/>Pin number | Port Name in IOU.vhdl |
|------------|------|
|1          | _GND_                            |
|2          | LGR_TXT_N (Also called GR)       |
|3          | SEGA                             |
|4          | SEGB                             |
|5          | SEGC (Also called VC)            |
|6          | S_80COL_N (Also called 80VID')   |
|7          | CASSO                            |
|8          | SPKR                             |
|9          | MD7                              |
|10         | AN0                              |
|11         | AN1                              |
|12         | AN2                              |
|13         | AN3                              |
|14         | R_W_N                            |
|15         | RESET_N                          |
|16         | _(N.C.)_                         |
|17         | ORA0                             |
|18         | ORA1                             |
|19         | ORA2                             |
|20         | ORA3                             |
|21         | ORA4                             |
|22         | ORA5                             |
|23         | ORA6                             |
|24         | ORA7                             |
|25         | PRAS_N                           |
|26         | PHI_0                            |
|27         | Q3                               |
|28         | _Vcc_                            |
|29         | A6                               |
|30         | C0XX_N                           |
|31         | IAKD                             |
|32         | IKSTRB                           |
|33         | VID7                             |
|34         | VID6                             |
|35         | RA9_N                            |
|36         | RA10_N                           |
|37         | CLRGAT_N                         |
|38         | WNDW_N                           |
|39         | SYNC_N                           |
|40         | H0                               |


##### When 5 volts exceed the selected programmable logic device's maximum ratings
If 5v exceeds the selected programmable logic device's maximum ratings, voltgage level conversion must be done on all input ports.<br/>
In the case of the bidirectional ports, the input/outout state must be exposed so that the bus transceiver can set the proper direction.<br/>
To expose these ports, search for `EXPOSE_ENABLE_SIGNALS` in `IOU.vhdl` and follow the instructions.

##### TODOs
Add reference design schematics for 5v and 3.3v devices.