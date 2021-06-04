`timescale 1ns / 1ps

module cache(
    // 全局信号
    input clk,
    input reset,
    // 从CPU来的访问信号
    input [12:0] raddr_from_cpu,     // CPU來的读地址
    input rreq_from_cpu,            // CPU来的读请求
    // 从下层内存模块来的信号
    input [31:0] rdata_from_mem,     // 内存读取的数据
    input rvalid_from_mem,          // 内存读取数据可用标志
    // 输出给CPU的信号
    output [7:0] rdata_to_cpu,      // 输出给CPU的数据
    output hit_to_cpu,              // 输出给CPU的命中标志
    // 输出给下层内存模块的信号
    output reg rreq_to_mem,         // 输出给下层内存模块的读请求
    output reg [12:0] raddr_to_mem  // 输出给下层模块的突发传输首地址
    );
    
    reg             wea;
    reg             hit;
    reg     [1:0]   current_state;
    reg     [1:0]   next_state;
    wire    [6:0]   addra;
    wire    [36:0]  dina;
    wire    [36:0]  douta;
    
    blk_mem_gen_0 your_instance_name (
        .clka(clk),    // input wire clka
        .wea(wea),      // input wire [0 : 0] wea
        .addra(addra),  // input wire [6 : 0] addra
        .dina(dina),    // input wire [36 : 0] dina
        .douta(douta)  // output wire [36 : 0] douta
    );
    
    assign dina = { rvalid_from_mem, raddr_from_cpu[12:9], rdata_from_mem };
    assign addra = raddr_from_cpu[8:2];
    
    //用于选择电路的中间变量
    wire [7:0] selector_0 = {raddr_from_cpu[0], raddr_from_cpu[0], raddr_from_cpu[0], raddr_from_cpu[0], raddr_from_cpu[0], raddr_from_cpu[0], raddr_from_cpu[0], raddr_from_cpu[0]};
    wire [7:0] selector_1 = {raddr_from_cpu[1], raddr_from_cpu[1], raddr_from_cpu[1], raddr_from_cpu[1], raddr_from_cpu[1], raddr_from_cpu[1], raddr_from_cpu[1], raddr_from_cpu[1]};
    //组合逻辑——连接rdata_to_cpu
    assign rdata_to_cpu = (douta[7:0] & (selector_1 ^ 8'hff) & (selector_0 ^ 8'hff)) ^ (douta[15:8] & (selector_1 ^ 8'hff) & selector_0) ^ (douta[23:16] & selector_1 & (selector_0 ^ 8'hff)) ^ (douta[31:24] & selector_1 & selector_0);
    assign hit_to_cpu = hit;

    //三段式状态机__第一段
    always @ (posedge clk or posedge reset) begin
        if (reset) current_state <= 2'b00;
        else current_state <= next_state;
    end
    //三段式状态机__第二段
    always @ (*) begin
        case(current_state)
            2'b00: begin
                if (rreq_from_cpu) next_state <= 2'b10;
                else next_state <= 2'b00;
            end
            2'b01: begin
                if (hit) next_state <= 2'b00;
                else next_state <= 2'b11;
            end
            2'b11: begin
                if (rvalid_from_mem) next_state <= 2'b10;
                else next_state <= 2'b11;
            end
            2'b10: begin
                next_state <= 2'b01;
            end
        endcase
    end
    
    //三段式状态机__第三段
    
    //控制 hit 模块
    always @ (posedge clk or posedge reset) begin
        if (reset) hit <= 0;
        else begin
            if (next_state != 2'b01) hit <= 0;
            else begin
                if (raddr_from_cpu[12:9] == douta[35:32] && douta[36]) hit <= 1'b1;
                else hit <= 1'b0;
            end 
        end
    end
    
    //控制状态 rreq_to_mem 的模块
    always @ (posedge clk or posedge reset) begin
        if (reset) rreq_to_mem <= 0;
        else begin
            if (next_state != 2'b11) rreq_to_mem <= 1'b0;
            else begin
                rreq_to_mem <= 1'b1;
            end
        end
    end
    
    //控制 raddr_to_mem 的模块
    always @ (posedge clk or posedge reset) begin
        if (reset) raddr_to_mem <= 13'h0;
        else begin
            if (next_state != 2'b11) raddr_to_mem <= 13'h0;
            else begin
                raddr_to_mem <= {raddr_from_cpu[12:2], 2'b00};
            end
        end
    end
    
    //控制 wea 的模块
    always @ (posedge clk or posedge reset) begin
        if (reset) wea <= 1'b0;
        else begin
            if (next_state != 2'b11) wea <= 1'b0;
            else wea <= 1'b1;
        end
    end

endmodule
