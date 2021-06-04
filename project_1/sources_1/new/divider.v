`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/20 09:05:01
// Design Name: 
// Module Name: divider
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


module divider(
    input wire clk,
    output reg clk_o = 2'b0
    );
    reg [31:0] cnt = 2'b0;
    
    always @ (posedge clk) begin
        if(cnt == 49999) begin
            clk_o <= ~clk_o;
            cnt <= 2'b0;
        end
        else begin
            cnt <= cnt + 2'b1;
        end
    end
endmodule
