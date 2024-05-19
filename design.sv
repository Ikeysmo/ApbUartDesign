
//design code goes here
`define DATA_WIDTH 15:0 
`define ADDRESS_WIDTH 31:0 

parameter CR_WRITE_DATA_ADDR = 12'h600;
parameter CR_READ_DATA_ADDR = 12'h602;
parameter CR_BAUD_RATE_ADDR = 12'h604;
parameter CR_STATUS_ADDR = 12'h606;


interface apb_interface;
    logic pclk;
    logic preset_n;   //THIS IS SHARED TO RESET EVERYTHING 
    logic [`ADDRESS_WIDTH] paddr;
    logic pwrite;
    logic [`DATA_WIDTH] prdata;
    logic psel;
    logic penable;
    logic [`DATA_WIDTH] pwdata;
    logic pready;
    logic pslverr; 

    modport master(
        output pwrite, pclk, preset_n, paddr, penable, psel, pwdata,
        input pslverr, pready, prdata
    );

    modport slave(
        input pwrite, pclk, preset_n, paddr, penable, psel, pwdata,
        output pslverr, pready, prdata
    );
endinterface 

interface uart_interface;
    logic uart_tx;
    logic uart_rx;

    modport master(
        input uart_rx,
        output uart_tx
    );
    modport slave(
        input uart_tx,
        output uart_rx 
    );
endinterface

module Apb_Uart(input clk, apb_interface.slave apb_inf, uart_interface.master uart_inf);
    //UART controller that is accessible through APB interface 
    //HAS 4 CREGS starting at base address 0x600. Each CREG is 2 bytes wide 
    //CREG 0x600 [RW]  -- WRITE DATA Register () 
    //CREG 0x602 [RW]  -- READ DATA Register
    //CREG 0x604 [RW] --  BAUD RATE Register ()
    //CREG 0x606 [R] -- STATUS REGISTER (BUSY, )

    reg [`DATA_WIDTH] registers [4]; //instantiate the memory for access 
    wire cr_enable; 

    assign cr_enable = apb_inf.paddr[11:8] == 4'h6; 

    enum reg[1:0] {IDLE, CAPTURE} APB_STATE; 

    //handle apb transactions 
    always@(posedge clk) begin
        if(!apb_inf.preset_n) begin
            apb_inf.pslverr <= 0;
            APB_STATE <= IDLE; 
            // foreach (registers[idx])
            //     registers[idx] <= 0; 
        end
        else begin
            if(apb_inf.psel || APB_STATE == CAPTURE) begin
                case (APB_STATE)
                    IDLE : begin
                        APB_STATE <= CAPTURE;
                        if(~cr_enable)
                            apb_inf.pslverr <= 1; //assert pslverr 
                        else begin
                            if(!apb_inf.pwrite) apb_inf.prdata <= registers[apb_inf.paddr[2:1]];
                            else registers[apb_inf.paddr[2:1]] <= apb_inf.pwdata  ;
                        end
                    end
                    CAPTURE : begin
                        APB_STATE <= IDLE;
                    
                        apb_inf.pslverr <= 0;  //de-assert pslverr 

                    end
                endcase
            end
        end

    end


  
endmodule;
