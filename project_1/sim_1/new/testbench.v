`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/10 20:57:47
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

reg clk;
reg rst_n;
reg [7:0] x;
reg [7:0] y;
reg start;
wire [7:0] z1;
wire [7:0] r1;
wire [7:0] z2;
wire [7:0] r2;
wire busy;

top u_top(
    .clk (clk),
    .rst_n (rst_n),
    .x (x),
    .y (y),
    .start (start),
    .z1 (z1),
    .r1 (r1),
    .z2 (z2),
    .r2 (r2),
    .busy (busy)
);

initial begin
    clk = 0;
    rst_n = 1;
    start = 0;
    x = 0;
    y = 0;
    #30 begin
        start = 1;
        x = 81;
        y = 7;
    end
    #20 begin
        start = 0;
        x = 0;
        y = 0;
    end
end

//…˙≥… ±÷”
always #10 clk = ~clk;

endmodule

