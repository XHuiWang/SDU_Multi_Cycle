`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/08 23:49:33
// Design Name: 
// Module Name: RF
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


// module RF(
// input clk,      //ʱ��
// input [4:0] rf_rd,      //д��ַ
// input       rf_we,      //дʹ��	
// input [31:0] rf_wdata,      //д����
// input [4:0] rf_raddr1,      //����ַ1
// input [4:0] rf_raddr2,      //����ַ2
// output [31:0] rf_rdata1,    //������1
// output [31:0] rf_rdata2     //������2
//     );

// reg [31:0] rf [0:31];      //�Ĵ����ļ�

// //�����ȣ��첽��
// assign rf_rdata1 = rf[rf_raddr1];
// assign rf_rdata2 = rf[rf_raddr2];

// //ͬ��д
// always @(posedge clk)
// begin
//     if(rf_we)
//         rf[rf_rd] <= rf_wdata;
// end

// endmodule


module RF(
input clk,      //ʱ��
input [4:0] rf_waddr,      //д��ַ
input       rf_we,      //дʹ��    
input [31:0] rf_wdata,      //д����
input [4:0] rf_raddr1,      //����ַ1
input [4:0] rf_raddr2,      //����ַ2
output [31:0] rf_rdata1,    //������1
output [31:0] rf_rdata2,     //������2

input [4:0] rf_raddr3,      //����ַ3
output [31:0] rf_rdata3    //������3
    );

reg [31:0] rf [0:31];      //�Ĵ����ļ�

//�����ȣ��첽��
assign rf_rdata1 = (rf_raddr1 == 0) ? 0 : rf[rf_raddr1];
assign rf_rdata2 = (rf_raddr2 == 0) ? 0 : rf[rf_raddr2];
assign rf_rdata3 = (rf_raddr3 == 0) ? 0 : rf[rf_raddr3];

//ͬ��д
always @(posedge clk)
begin
    if(rf_we && rf_waddr != 0) // ��д��ַ����0ʱ���Ž���д��
        rf[rf_waddr] <= rf_wdata;
end

endmodule
