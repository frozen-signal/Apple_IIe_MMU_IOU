# The Display Address Generation

## Overview

The correspondance of a pixel's coordinates on the screen to it's location in RAM is not trivial on the Apple IIe. The exact reasons why it's done this way are probably lost to history, but we can speculate that the two main reasons were to waste as little memory as possible, and use the video system for the required dynamic RAM refresh. The display address is generated from the [Video Scanner](video-scanner.md).<br />
<br />
The address depends on two things: the video scanner's outputs and the graphics mode.

The address generation is split in two phases: the ROW address, then the COLUMN address.

