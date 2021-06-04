`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/24 20:35:49
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench();
    reg         clk      ;
    reg         rst_n    ;
    reg         wr       ;
    reg         rd       ;
    reg  [3:0]  byte     ;
    reg  [3:0]  addr     ;
    reg  [31:0] wdata    ;
    wire        rdata_v  ;
    wire [31:0] rdata    ;
    
    top u_top(
        .clk      (clk),
        .rst_n    (rst_n),
        .wr       (wr),
        .rd       (rd),
        .byte     (byte),
        .addr     (addr),
        .wdata    (wdata),
        .rdata_v  (rdata_v),
        .rdata    (rdata)     
    );
    
    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        wr = 1'b0;
        rd = 1'b0;
        byte = 4'h0;
        addr = 4'h0;
        wdata = 32'h0;
        #20 rst_n = 1'b1;
        #10 begin
            wr = 1'b1;
            byte = 4'hf;
            addr = 4'h1;
            wdata = 32'h0011;
        end
        #20 begin
            wr = 1'b0;
            byte = 4'h0;
            addr = 4'h0;
            wdata = 32'h0000;
        end
        #40 begin
            rd = 1'b1;
            byte = 4'hf;
            addr = 4'h1;
        end
        #20 begin
            rd = 1'b0;
            byte = 4'h0;
            addr = 4'h0;
        end
    end
    
    always #10 clk = ~clk;
    
endmodule
