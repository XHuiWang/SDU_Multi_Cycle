`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 21:30:26
// Design Name: 
// Module Name: CPU_TOP
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


module CPU_TOP(
input clk,
input rstn,
output logic  [31:0] pc_chk, //用于SDU进行断点检查，在单周期cpu中，pc_chk = pc
output logic  [31:0] npc,    //next_pc
output logic  [31:0] pc_out,
output logic  [31:0] IR,     //当前指令
output logic  [31:0] IMM,    //立即数
output logic  [31:0] CTL,    //控制信号，你可以将所有控制信号集成一根bus输出
output logic  [31:0] A,      //ALU的输入A
output logic  [31:0] B,      //ALU的输入B
output logic  [31:0] Y,      //ALU的输出
output logic  [31:0] MDR,    //数据存储器的输出

input [31:0] addr,   
output logic [31:0] dout_rf,
output logic [31:0] dout_dm,
output logic [31:0] dout_im,
input [31:0] din,
input we_dm,
input we_im,
input clk_ld,
input debug
    );

//定义CPU内部信号
    logic [31:0] pc;
    logic [31:0] nPC;
    logic [31:0] jump_target[0:1];
    logic jump_en[0:1];
    logic [31:0] instr[0:1];
    // logic [4:0]  rf_raddr1[0:1];
    // logic [4:0]  rf_raddr2[0:1];
    logic [4:0]  rf_raddr1;
    logic [4:0]  rf_raddr2;
    logic [31:0] rf_rdata1[0:1];
    logic [31:0] rf_rdata2[0:1];
    logic rf_we;
    logic [4:0] rf_waddr[0:1];
    logic [31:0] rf_wdata;
    logic [1:0] alu_src1_sel[0:1];
    logic [1:0] alu_src2_sel[0:1];
    logic [11:0] alu_op[0:1];
    logic [31:0] alu_src1;
    logic [31:0] alu_src2;
    logic [31:0] alu_result[0:1];
    logic [31:0] imm[0:1];
    logic [8:0]  br_type[0:1];
    logic mem_we;
    logic [9:0] mem_addr;
    // logic [31:0] mem_wdata;
    logic [31:0] mem_rdata[0:1];
    logic wb_sel[0:1];
    logic PC_we;

    assign mem_addr = alu_result[1][11:2];

/*
addr是SDU输出给cpu的地址，
cpu根据这个地址从ins_mem/reg_file/data_mem中读取数据，三者共用一个地址！
注意，这个地址是你在串口输入的地址，不需要进行任何处理，直接接入cpu中的对应模块即可
dout_rf 是从reg_file中读取的addr地址的数据
dout_dm 是从data_mem中读取的addr地址的数据
dout_im 是从ins_mem中读取的addr地址的数据
din 是SDU输出给cpu的数据，cpu需要将这个数据写入到addr地址对应的存储器中
we_dm 是数据存储器写使能信号，当we_dm为1时，cpu将din中的数据写入到addr地址对应的存储器中
we_im 是指令存储器写使能信号，当we_im为1时，cpu将din中的数据写入到addr地址对应的存储器中
clk_ld 是SDU输出的用于调试时写入ins_mem/data_mem的时钟，要跟clk_cpu区分开，这两个clk同时只会有一个在工作
debug 是调试信号，当debug为1时，cpu的ins_mem和data_mem应使用clk_ld时钟，否则使用clk时钟
*/

assign  pc_chk = pc;
assign  npc = nPC;
assign  pc_out = pc;
assign  IR = instr[1];
assign  IMM = imm[1];
assign  CTL = {alu_op[1],alu_src1_sel[1],alu_src2_sel[1],br_type[1],wb_sel[1],rf_we,mem_we,PC_we};
assign  A = alu_src1;
assign  B = alu_src2;
assign  Y = alu_result[1];
assign  MDR = mem_rdata[1];


logic clk_rm;
always@(*)
    begin
    if(debug == 1'b1)
        clk_rm = clk_ld;
    else
        clk_rm = clk;    
    end





register #(.WIDTH(32), .RST_VAL(0)) reg_IR(
    .clk(clk),
    .rst(rstn),
    .en(1'b1),
    .d(instr[0]),
    .q(instr[1])
    );

register #(.WIDTH(32), .RST_VAL(0)) reg_RF_IMM(
    .clk(clk),
    .rst(rstn),
    .en(1'b1),
    .d(imm[0]),
    .q(imm[1])
    );

// register #(.WIDTH(5), .RST_VAL(0)) reg_RF_RADDR1(
//     .clk(clk),
//     .rst(rstn),
//     .en(1'b1),
//     .d(rf_raddr1[0]),
//     .q(rf_raddr1[1])
//     );

// register #(.WIDTH(5), .RST_VAL(0)) reg_RF_RADDR2(
//     .clk(clk),
//     .rst(rstn),
//     .en(1'b1),
//     .d(rf_raddr2[0]),
//     .q(rf_raddr2[1])
//     );

register #(.WIDTH(5), .RST_VAL(0)) reg_RF_WADDR(
    .clk(clk),
    .rst(rstn),
    .en(1'b1),
    .d(rf_waddr[0]),
    .q(rf_waddr[1])
    );

register #(.WIDTH(12), .RST_VAL(0)) reg_ALU_OP(
    .clk(clk),
    .rst(rstn),
    .en(1'b1),
    .d(alu_op[0]),
    .q(alu_op[1])
    );

register #(.WIDTH(2), .RST_VAL(0)) reg_ALU_SRC1_SEL(
    .clk(clk),
    .rst(rstn),
    .en(1'b1),
    .d(alu_src1_sel[0]),
    .q(alu_src1_sel[1])
    );

register #(.WIDTH(2), .RST_VAL(0)) reg_ALU_SRC2_SEL(
    .clk(clk),
    .rst(rstn),
    .en(1'b1),
    .d(alu_src2_sel[0]),
    .q(alu_src2_sel[1])
    );

register #(.WIDTH(9), .RST_VAL(0)) reg_BR_TYPE(
    .clk(clk),
    .rst(rstn),
    .en(1'b1),
    .d(br_type[0]),
    .q(br_type[1])
    );

register #(.WIDTH(1), .RST_VAL(0)) reg_RF_WBSEL(
    .clk(clk),
    .rst(rstn),
    .en(1'b1),
    .d(wb_sel[0]),
    .q(wb_sel[1])
    );

register #(.WIDTH(32), .RST_VAL(0)) reg_ALU_RES(
    .clk(clk),
    .rst(rstn),
    .en(1'b1),
    .d(alu_result[0]),
    .q(alu_result[1])
    );

register #(.WIDTH(32), .RST_VAL(0)) reg_RF_RDATA1(
    .clk(clk),
    .rst(rstn),
    .en(1'b1),
    .d(rf_rdata1[0]),
    .q(rf_rdata1[1])
    );

register #(.WIDTH(32), .RST_VAL(0)) reg_RF_RDATA2(
    .clk(clk),
    .rst(rstn),
    .en(1'b1),
    .d(rf_rdata2[0]),
    .q(rf_rdata2[1])
    );

register #(.WIDTH(32), .RST_VAL(0)) reg_MEM_RDATA(
    .clk(clk),
    .rst(rstn),
    .en(1'b1),
    .d(mem_rdata[0]),
    .q(mem_rdata[1])
    );

register #(.WIDTH(32), .RST_VAL(0)) reg_JUMP_TAR(
    .clk(clk),
    .rst(rstn),
    .en(1'b1),
    .d(jump_target[0]),
    .q(jump_target[1])
    );

register #(.WIDTH(1), .RST_VAL(0)) reg_JUMP_EN(
    .clk(clk),
    .rst(rstn),
    .en(1'b1),
    .d(jump_en[0]),
    .q(jump_en[1])
    );


CU CU_01(
    .clk(clk),
    .rstn(rstn),
    .instr(instr[1]),
    .PC_we(PC_we),
    .MEM_we(mem_we),
    .RF_we(rf_we)
);


PC pc01(
    .clk(clk),
    .rstn(rstn),
    .nPC(nPC),
    .PC(pc),
    .PC_we(PC_we)
    );

PC_MUX pc_mux01(
    .pc(pc),
    .jump_target(jump_target[1]),
    .jump_en(jump_en[1]),
    .npc(nPC)
    );


IM im_01 (
    .a(pc[11:2]),        // input wire [9 : 0] a
    .d(din),        // input wire [31 : 0] d
    .dpra(addr[9:0]),  // input wire [9 : 0] dpra
    .clk(clk_rm),    // input wire clk
    .we(we_im),      // input wire we
    .spo(instr[0]),    // output wire [31 : 0] spo
    .dpo(dout_im)//              
  );

RF rf01(
    .clk(clk),
    .rf_waddr(rf_waddr[1]),
    .rf_we(rf_we),
    .rf_wdata(rf_wdata),
    .rf_raddr1(rf_raddr1),
    .rf_raddr2(rf_raddr2),
    .rf_rdata1(rf_rdata1[0]),
    .rf_rdata2(rf_rdata2[0]),
    .rf_raddr3(addr[4:0]),
    .rf_rdata3(dout_rf)
    );



ALU alu01(
    .f(alu_op[1]),
    .a(alu_src1),
    .b(alu_src2),
    .y(alu_result[0])
    );

ALU_SRC1_MUX alu_src1_mux01(
    .pc(pc),
    .rf_rdata1(rf_rdata1[1]),
    .alu_src1_sel(alu_src1_sel[1]),
    .alu_src1(alu_src1)
    );

ALU_SRC2_MUX alu_src2_mux01(
    .imm(imm[1]),
    .rf_rdata2(rf_rdata2[1]),
    .alu_src2_sel(alu_src2_sel[1]),
    .alu_src2(alu_src2)
    );

WB_MUX wb_mux01(
    .wb_sel(wb_sel[1]),
    .alu_result(alu_result[1]),
    .mem_rdata(mem_rdata[1]),
    .wb_rdata(rf_wdata)
    ); 

BR br01(
    .br_type(br_type[1]),
    .pc(pc),
    .rf_rdata1(rf_rdata1[1]),
    .rf_rdata2(rf_rdata2[1]),
    .imm(imm[1]),
    .jump_en(jump_en[0]),
    .jump_target(jump_target[0])
    );

DEC dec01(
    .instr(instr[1]),
    .rf_waddr(rf_waddr[0]),
    .we_sel(wb_sel[0]),
    .rf_raddr1(rf_raddr1),
    .rf_raddr2(rf_raddr2),
    .alu_op(alu_op[0]),
    .alu_src1_sel(alu_src1_sel[0]),
    .alu_src2_sel(alu_src2_sel[0]),
    .br_type(br_type[0]),
    .imm(imm[0])
    );


DM dm_01 (
    .a(mem_addr),        // input wire [9 : 0] a
    .d(rf_rdata2[1]),        // input wire [31 : 0] d
     .dpra(addr[9:0]),  // input wire [9 : 0] dpra
    .clk(clk_rm),    // input wire clk
    .we(mem_we||we_dm),      // input wire we
    .spo(mem_rdata[0]),   // output wire [31 : 0] spo
    .dpo(dout_dm)    // output wire [31 : 0] dpo
  );


endmodule
