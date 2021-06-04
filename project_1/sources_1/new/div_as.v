`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 09:05:35
// Design Name: 
// Module Name: div_as
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


module div_as (
    input  wire       clk  ,
    input  wire       rst_n,
    input  wire [7:0] x    ,
    input  wire [7:0] y    ,
    input  wire       start,
    output wire [7:0] z2   ,
    output reg  [7:0] r2 = 0,
    output reg        busy2 = 0     
);

//商
reg [7:0] z0 = 8'b1111_1111;
//被除数的绝对值
reg [15:0] x0 = 0;
//除数的绝对值的补码
reg [7:0] y0 = 0;
//负的除数的绝对值的补码
reg [7:0] y1 = 0;
//符号位
reg sign = 0;
//计数
reg [2:0] cnt = 0;

assign z2[7] = sign;
assign z2[6:0] = z0[6:0];

//计数
always @ (posedge clk) begin
    if(busy2) cnt <= cnt + 1;
    else cnt <= 0;
end

//控制busy2
always @ (posedge clk or negedge rst_n) begin
    //复位
    if(~rst_n) busy2 <= 0;
    
    else begin
        if(start) begin
            busy2 <= 1;
            sign <= x[7] ^ y[7];
        end
        else if(cnt == 3'b111) busy2 <= 0;    
    end
end

//控制循环
always @ (posedge clk) begin
    if(busy2) begin
        if(x0[14:7] >= 8'b1000_0000) begin
            z0 <= z0 << 1;
            r2 <= x0[14:7] + y0;
            x0 <= (x0 << 1) + (y0 << 7);
        end
        else begin
            z0 <= (z0 << 1) + 1;
            r2 <= x0[14:7];
            x0 <= (x0 << 1) + (y1 << 7);
        end
    end
    //初始化
    else begin
        x0[15] <= 0;
        x0[14] <= 1;
        x0[13:7] <= ~y[6:0] + 1;
        x0[6:0] <= x[6:0];
        y0[7] <= 0;
        y0[6:0] <= y[6:0];
        y1[7] <= 1;
        y1[6:0] <= ~y[6:0] + 1;
    end
end

endmodule
