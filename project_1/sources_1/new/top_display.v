`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/17 20:15:30
// Design Name: 
// Module Name: top_display
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


module top_display(
    input  wire       clk  ,
    input  wire       rst_n,
    input  wire [7:0] x    ,
    input  wire [7:0] y    ,
    input  wire       start_i,
    output wire        led0_en,
    output wire        led1_en,
    output wire        led2_en,
    output wire        led3_en,
    output wire        led4_en,
    output wire        led5_en,
    output wire        led6_en,
    output wire        led7_en,
    output wire        led_ca ,
    output wire        led_cb ,
    output wire        led_cc ,
    output wire        led_cd ,
    output wire        led_ce ,
    output wire        led_cf ,
    output wire        led_cg ,
    output wire        led_dp
    );
    
//    reg [7:0] u_z1;
//    reg [7:0] u_z2;
//    reg [7:0] u_r1;
//    reg [7:0] u_r2;
//    reg [7:0] u_busy;
    wire [7:0] u_z1_;
    wire [7:0] u_z2_;
    wire [7:0] u_r1_;
    wire [7:0] u_r2_;
    wire u_busy_;
    wire clk_o;
    reg start = 2'b0;
    reg start_f = 2'b0;
    
    always @ (posedge clk) begin
        if(start_i == 1) begin
            start <= start_i ^ start_f;
            start_f <= 2'b1;
        end
        else begin
            start_f <= 2'b0;
            start <= 2'b0;
        end
    end
    
//    always @ (*) begin
//        u_z1 <= u_z1_;
//        u_z2 <= u_z2_;
//        u_r1 <= u_r1_;
//        u_r2 <= u_r2_;
//        u_busy <= u_busy_;
//    end
    
    divider u_div(
        .clk    (clk),
        .clk_o  (clk_o)
    );
    
    top u_top(
        .clk    (clk),
        .rst_n  (rst_n),
        .x      (x),
        .y      (y),
        .start  (start),
        .z1     (u_z1_),
        .r1     (u_r1_),
        .z2     (u_z2_),
        .r2     (u_r2_),
        .busy   (u_busy_)
    );
    
    display u_display(
//        .clk        (clk_o),
//        .rst_n      (rst_n),
//        .busy       (u_busy),
//        .z1         (u_z1),
//        .r1         (u_r1),
//        .z2         (u_z2),
//        .r2         (u_r2),
//        .led0_en    (led0_en),
//        .led1_en    (led1_en),
//        .led2_en    (led2_en),
//        .led3_en    (led3_en),
//        .led4_en    (led4_en),
//        .led5_en    (led5_en),
//        .led6_en    (led6_en),
//        .led7_en    (led7_en),
//        .led_ca     (led_ca),
//        .led_cb     (led_cb),
//        .led_cc     (led_cc),
//        .led_cd     (led_cd),
//        .led_ce     (led_ce),
//        .led_cf     (led_cf),
//        .led_cg     (led_cg),
//        .led_dp     (led_dp)
        
        .clk        (clk_o),
        .rst_n      (rst_n),
        .busy       (u_busy_),
        .z1         (u_z1_),
        .r1         (u_r1_),
        .z2         (u_z2_),
        .r2         (u_r2_),
        .led0_en    (led0_en),
        .led1_en    (led1_en),
        .led2_en    (led2_en),
        .led3_en    (led3_en),
        .led4_en    (led4_en),
        .led5_en    (led5_en),
        .led6_en    (led6_en),
        .led7_en    (led7_en),
        .led_ca     (led_ca),
        .led_cb     (led_cb),
        .led_cc     (led_cc),
        .led_cd     (led_cd),
        .led_ce     (led_ce),
        .led_cf     (led_cf),
        .led_cg     (led_cg),
        .led_dp     (led_dp)
    );
    
endmodule
