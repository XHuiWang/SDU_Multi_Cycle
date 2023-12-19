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


//�Ĵ�����д�ض�ѡ��������ѡ��д�ص����ݡ�д�ص����ݿ�������ALU��Ҳ�����������ݴ洢����ѡ���ź���������������
//����ѡ���ź�wb_sel��������������
//����alu_result��mem_rdata������ѡ��д������
//���wb_rdata������д�ؼĴ���
//ѡ���ź�Ϊ1ʱ��ѡ��alu_result������ѡ��mem_rdata

module WB_MUX(
input  wb_sel,
input [31:0] alu_result,
input [31:0] mem_rdata,
output reg [31:0] wb_rdata

    );

assign wb_rdata = (wb_sel == 1'b1) ? alu_result : mem_rdata;


endmodule


