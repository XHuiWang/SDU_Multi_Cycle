`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 12:23:10
// Design Name: 
// Module Name: WB_MUX
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


//寄存器堆写回多选器，用于选择写回的数据。写回的数据可能来自ALU，也可能来自数据存储器。选择信号由译码器给出。
//输入选择信号wb_sel，由译码器给出
//输入alu_result，mem_rdata，用于选择写回数据
//输出wb_rdata，用于写回寄存器
//选择信号为1时，选择alu_result，否则选择mem_rdata

module WB_MUX(
input  wb_sel,
input [31:0] alu_result,
input [31:0] mem_rdata,
output reg [31:0] wb_rdata

    );

assign wb_rdata = (wb_sel == 1'b1) ? alu_result : mem_rdata;


endmodule


