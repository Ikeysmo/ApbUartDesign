# APB UART (HAS) #

## Summary ##
APB UART Design is an untested design for the purpose of learning/testing. APB Uart is a UART (Universal Asynchronous Receiver Transciever) that is designed to be incorporated into a SOC. 
This is made possible by implementing the APB (Advanced Peripheral Bus) protocol in order to configure the UART via 4 CSR (Control status registers). 



### CREGS (Control Registers) ###

| Name | Address | R/W | Description|
|------|------|-----|-----|
| CR WRITE REG | 0x600 | RW|  Configure UART DATA to send out  |
| CR READ REG | 0x602 | RW| Configure UART DATA to read |
| CR BAUD_RATE REG | 0x604 | RW| Configure UART Baud Rate |
| CR STATUS REG | 0x606 | R| Read UART STATUS (Busy, Tx, etc)  |


