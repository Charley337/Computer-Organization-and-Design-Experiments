`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/03 17:09:05
// Design Name: 
// Module Name: testbench2
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


module testbench2();

reg clk;
reg reset;
reg [1:0] state_c;
reg [1:0] state_n;

always @ (posedge clk or posedge reset) begin
    if (reset) state_c <= 0;
    else begin
        state_c <= state_n;
    end
end

always @ (posedge clk or posedge reset) begin
    if (reset) state_n <= 0;
    else begin
        case(state_c)
            2'b00: state_n <= 2'b01;
            2'b01: state_n <= 2'b10;
            2'b10: state_n <= 2'b11;
            2'b11: state_n <= 2'b00;
        endcase
    end
end

initial begin
    clk = 0;
    reset = 1;
    #40 reset = 0;
end

always begin
    #10 clk = ~clk;
end

endmodule
