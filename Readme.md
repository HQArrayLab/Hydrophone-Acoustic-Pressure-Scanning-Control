This is a sound field scanning system for underwater acoustic pressure, which contains code for stepper motor control, waveform reading and sound field scanning.

The code and system were developed by Hanming Zheng.

The code was compiled in Matlab 2022b.

The code is open-source.

The code was test on Windows 10.

scan1.m is used for scanning the sound field distribution along the vertical direction.

scan2.m is used for scanning the two-dimensional sound field distribution along both the horizontal and vertical directions.

waveread.m is used for reading and storing the waveforms from a RIGOL oscilloscope.

The system consists of a signal generator (RIGOL DG1032), a oscilloscope (RIGOL MSO5354), a power amplifier, a PA needle hydrophone, a host computer, and the scanning moter (controlled through ZHANGDA TOU Emm42_V5.0 stepper motor closed-loop driver).

![system](https://github.com/HQArrayLab/Hydrophone_system_control/assets/167310828/1afb11e3-76c0-4998-a075-7fb7bc1991f1)

![system2](https://github.com/HQArrayLab/Hydrophone_system_control/assets/167310828/41dffe0a-9e95-4e46-8540-24e8aaeaef0a)
