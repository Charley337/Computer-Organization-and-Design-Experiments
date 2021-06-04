`timescale 1ns / 1ps

module cache(
    // ȫ���ź�
    input clk,
    input reset,
    // ��CPU���ķ����ź�
    input [12:0] raddr_from_cpu,     // CPU��Ķ���ַ
    input rreq_from_cpu,            // CPU���Ķ�����
    // ���²��ڴ�ģ�������ź�
    input [31:0] rdata_from_mem,     // �ڴ��ȡ������
    input rvalid_from_mem,          // �ڴ��ȡ���ݿ��ñ�־
    // �����CPU���ź�
    output [7:0] rdata_to_cpu,      // �����CPU������
    output hit_to_cpu,              // �����CPU�����б�־
    // ������²��ڴ�ģ����ź�
    output reg rreq_to_mem,         // ������²��ڴ�ģ��Ķ�����
    output reg [12:0] raddr_to_mem  // ������²�ģ���ͻ�������׵�ַ
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
    
    //����ѡ���·���м����
    wire [7:0] selector_0 = {raddr_from_cpu[0], raddr_from_cpu[0], raddr_from_cpu[0], raddr_from_cpu[0], raddr_from_cpu[0], raddr_from_cpu[0], raddr_from_cpu[0], raddr_from_cpu[0]};
    wire [7:0] selector_1 = {raddr_from_cpu[1], raddr_from_cpu[1], raddr_from_cpu[1], raddr_from_cpu[1], raddr_from_cpu[1], raddr_from_cpu[1], raddr_from_cpu[1], raddr_from_cpu[1]};
    //����߼���������rdata_to_cpu
    assign rdata_to_cpu = (douta[7:0] & (selector_1 ^ 8'hff) & (selector_0 ^ 8'hff)) ^ (douta[15:8] & (selector_1 ^ 8'hff) & selector_0) ^ (douta[23:16] & selector_1 & (selector_0 ^ 8'hff)) ^ (douta[31:24] & selector_1 & selector_0);
    assign hit_to_cpu = hit;

    //����ʽ״̬��__��һ��
    always @ (posedge clk or posedge reset) begin
        if (reset) current_state <= 2'b00;
        else current_state <= next_state;
    end
    //����ʽ״̬��__�ڶ���
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
    
    //����ʽ״̬��__������
    
    //���� hit ģ��
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
    
    //����״̬ rreq_to_mem ��ģ��
    always @ (posedge clk or posedge reset) begin
        if (reset) rreq_to_mem <= 0;
        else begin
            if (next_state != 2'b11) rreq_to_mem <= 1'b0;
            else begin
                rreq_to_mem <= 1'b1;
            end
        end
    end
    
    //���� raddr_to_mem ��ģ��
    always @ (posedge clk or posedge reset) begin
        if (reset) raddr_to_mem <= 13'h0;
        else begin
            if (next_state != 2'b11) raddr_to_mem <= 13'h0;
            else begin
                raddr_to_mem <= {raddr_from_cpu[12:2], 2'b00};
            end
        end
    end
    
    //���� wea ��ģ��
    always @ (posedge clk or posedge reset) begin
        if (reset) wea <= 1'b0;
        else begin
            if (next_state != 2'b11) wea <= 1'b0;
            else wea <= 1'b1;
        end
    end

endmodule
