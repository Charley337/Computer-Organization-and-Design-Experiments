module slave (
    input  wire        clk      ,   
    input  wire        rst_n    ,
    output reg         a_ready  ,
    input  wire        a_valid  ,  
    input  wire [3:0]  a_opcode ,
    input  wire [3:0]  a_mask   ,
    input  wire [3:0]  a_address,
    input  wire [31:0] a_data   ,
    input  wire        d_ready  ,
    output reg         d_valid  ,
    output reg  [3:0]  d_opcode ,
    output reg  [31:0] d_data   ,
    output reg         reg_wr   ,
    output reg         reg_rd   ,
    output reg  [3:0]  reg_byte ,
    output reg  [3:0]  reg_addr ,
    output reg  [31:0] reg_wdata,
    input  wire [31:0] reg_rdata
);
// Your code here
//控制a_ready
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)                                                 a_ready <= 1'b0;
    else                                                        a_ready <= 1'b1;
end

//控制d_valid
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)                                                 d_valid <= 1'b0;
    else if (reg_rd || reg_wr)                                           d_valid <= 1'b1;
    else                                                        d_valid <= 1'b0;
end

//控制d_opcode
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)                                                 	d_opcode <= 4'h0;
    else if (a_valid && a_opcode[2])                            	d_opcode <= 4'h1;
    else if (a_valid && (a_opcode == 4'h0 || a_opcode == 4'h1))         d_opcode <= 4'h0;
end

//控制d_data
always @ (*) begin
    if (~rst_n)                                                 d_data = 32'h0;
    else                                                        d_data = reg_rdata;
end

//控制reg_wr
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)                                                 reg_wr <= 1'b0;
    else if (a_valid && a_opcode[2] == 0)                       reg_wr <= 1'b1;
    else                                                        reg_wr <= 1'b0;
end

//控制reg_rd
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)                                                 reg_rd <= 1'b0;
    else if (a_opcode[2])                                       reg_rd <= 1'b1;
    else                                                        reg_rd <= 1'b0;
end

//控制reg_byte
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)                                                 reg_byte <= 4'h0;
    else                                                        reg_byte <= a_mask;
end

//控制reg_addr
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)                                                 reg_addr <= 4'h0;
    else                                                        reg_addr <= a_address;
end

//控制reg_wdata
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)                                                 reg_wdata <= 32'h0;
    else                                                        reg_wdata <= a_data;
end
endmodule
