`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/03 10:32:58
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
reg reset;
reg [12:0] test_addr;
reg cache_rreq;

wire [7:0] cache_rdata;
wire cache_hit;

wire rreq_cache2mem;
wire [12:0] raddr_cache2mem;
wire [31:0] rdata_mem2cache;
wire rvalid_mem2cache;

cache cache0(      .clk(clk),
                .reset(reset),
                .raddr_from_cpu(test_addr),
                .rreq_from_cpu(cache_rreq),
                .rdata_to_cpu(cache_rdata),
                .hit_to_cpu(cache_hit),
                .rreq_to_mem(rreq_cache2mem),
                .raddr_to_mem(raddr_cache2mem),
                .rdata_from_mem(rdata_mem2cache),
                .rvalid_from_mem(rvalid_mem2cache) );
mem_wrap mem0(  .clk(clk),
                .reset(reset),
                .rreq(rreq_cache2mem),
                .raddr(raddr_cache2mem),
                .rdata(rdata_mem2cache),
                .rvalid(rvalid_mem2cache)
                 );

initial begin
    clk = 0;
    reset = 1;
    test_addr = 13'h0000;
    cache_rreq = 0;
    #30 reset = 0;
    #40 begin
        test_addr = 13'h0001;
        cache_rreq = 1;
    end
    #20 begin
        cache_rreq = 0;
    end
    #460 begin
        cache_rreq = 1;
        test_addr = 13'h1012;
    end
    #20 begin
        cache_rreq = 0;
    end
    #540 begin
        cache_rreq = 1;
        test_addr = 13'h0001;
    end
    #20 begin
        cache_rreq = 0;
    end
end

always begin
    #10 clk = ~clk;
end

endmodule
