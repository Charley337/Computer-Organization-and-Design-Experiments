`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/24 21:13:16
// Design Name: 
// Module Name: test
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


module test();
    
    reg clk;
    reg rst_n;
    reg c;
    reg a;
    reg b;
    wire b_;
    
    assign b_ = a;
    
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n)             a <= 1'b0;
        else if (c)             a <= 1'b1;
        else                    a <= 1'b0;
    end
    
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n)             b <= 1'b0;
        else if (a)             b <= 1'b1;
        else                    b <= 1'b0;
    end
    
    initial begin
        rst_n = 1'b1;
        clk = 1'b0;
        c = 1'b0;
        #30 begin
            c = 1'b1;
        end
        #20 begin
            c = 1'b0;
        end
    end
    
    always #10 clk = ~clk;
    
endmodule
