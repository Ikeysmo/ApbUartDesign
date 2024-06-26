# APB UART (HAS) #

## Summary ##
APB UART Design is an (untested) design for the purpose of learning/testing. APB Uart is a UART (Universal Asynchronous Receiver Transciever) that is designed to be incorporated into a SOC. 
This is made possible by implementing the APB (Advanced Peripheral Bus) protocol in order to configure the UART via 4 CSR (Control status registers). 



## CREGS Map Overview (Control Registers) ##

| Name | Address | R/W | Description|
|------|------|-----|-----|
| CR WRITE REG | 0x600 | RW|  Configure UART DATA to send out  |
| CR READ REG | 0x602 | RW| Configure UART DATA to read |
| CR BAUD_RATE REG | 0x604 | RW| Configure UART Baud Rate |
| CR STATUS REG | 0x606 | R| Read UART STATUS (Busy, Tx, etc)  |



### CR WRITE REG (ADDR: 0x600) 
|Bits|Field| Description
|--|--|--|
| 15:10 | RESERVED | N/A | 
|9:9 | UART_EN | Enable the UART |
| 8: 8 | TX Send | Sends TX Byte | 
| 7:0 | DATA_BYTE_TX | TX Byte that gets transmitted |


### CR READ REG (ADDR: 0x602)
|Bits|Field| Description
|--|--|--|
| 15:8 | RESERVED | N/A
| 7:0 | DATA_BYTE_RX | TX Byte that was received. Ignore further Tx's until cleared |


### CR BAUD_RATE REG (ADDR: 0x604)
|Bits|Field| Description
|--|--|--|
| 15:12 | ID | ID Bits. Should read out 0x8C|
| 11:0 | Baudrate | Baud rate that UART operates at.  |


### CR STATUS REG (ADDR: 0x606)
|Bits|Field| Description
|--|--|--|
| 1:1 | RX_DATA_READY | RX has received data|
| 0:0 | TX_BUSY | TX is busy right now |

## Programming the APB UART ##

Must program via APB protocol. APB_UART does not support transfers with wait states. In order to transmit a valid UART TX data byte, you must 
1) Enable UART (set UART_EN)
2) Program BAUD rate (IGNORE THIS STEP FOR NOW) 
3) Program  WRITE Register DATA appropriately (TX_BUSY should go high)
4) Send TX SEND (program the register)
5) Poll The TX_BUSY until it goes low 
