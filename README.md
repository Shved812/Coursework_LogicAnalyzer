# Coursework_LogicAnalyzer
The logic analyzer project is implemented on the Altera Cyclone IV EP4CE6E22C8N FPGA.
The logic analyzer can analyze 16 logic signals at a frequency of up to 100 kHz in this configuration.
The read signals are compressed (encrypted) and sent via UART to the PC.
Where they are then read and decoded by a specially written QT C++ application that outputs signal graphs.

In this project were implemented:
<ul>
  <li>UART transmitter</li>
  <li>Data Compression module</li>
  <li>FIFO bufer</li>
  <li>PLL clocking</li>
  <li>Logical control scheme</li>
</ul>

Computer application for:
<ul>
  <li>Working with a COM port</li>
  <li>Decoding data</li>
  <li>Build of time diagrams</li>
</ul>
