`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 09:03:02
// Design Name: 
// Module Name: top
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


module top (
    input  wire       clk  ,
    input  wire       rst_n,
    input  wire [7:0] x    ,
    input  wire [7:0] y    ,
    input  wire       start,
    output wire [7:0] z1   ,
    output wire [7:0] r1   ,
    output wire [7:0] z2   ,
    output wire [7:0] r2   ,
    output wire       busy     
);

wire busy1;
wire busy2;
wire sign_x = x[7];
wire [7:0] r1_unsign;
wire [7:0] r2_unsign;

assign r1[6:0] = r1_unsign[6:0];
assign r2[6:0] = r2_unsign[6:0];
assign r1[7] = sign_x;
assign r2[7] = sign_x;

div_rr u_div_rr (
    .clk    (clk  ),
    .rst_n  (rst_n),
    .x      (x    ),
    .y      (y    ),
    .start  (start),
    .z1     (z1   ),
    .r1     (r1_unsign   ),
    .busy1  (busy1)
);

div_as u_div_as (
    .clk    (clk  ),
    .rst_n  (rst_n),
    .x      (x    ),
    .y      (y    ),
    .start  (start),
    .z2     (z2   ),
    .r2     (r2_unsign   ),
    .busy2  (busy2)
);

assign busy = busy1 | busy2;

endmodule

