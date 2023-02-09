# Coursework_LogicAnalyzer
The logic analyzer project is implemented on the Altera Cyclone IV EP4CE6E22C8N FPGA.
The logic analyzer can analyze 16 logic signals at a frequency of up to 100 kHz in this configuration.
The read signals are compressed (encrypted) and sent via UART to the PC.
Where they are then read and decoded by a specially written QT C++ application that outputs signal graphs.

In this project were implemented:
*UART transmitter
*Data Compression module
*FIFO bufer
*PLL clocking
Logical control scheme
*Computer application for:
*Working with a COM port
*Decoding data
*Build of time diagrams
