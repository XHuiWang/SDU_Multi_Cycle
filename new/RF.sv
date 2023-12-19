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
// input clk,      //时钟
// input [4:0] rf_rd,      //写地址
// input       rf_we,      //写使能	
// input [31:0] rf_wdata,      //写数据
// input [4:0] rf_raddr1,      //读地址1
// input [4:0] rf_raddr2,      //读地址2
// output [31:0] rf_rdata1,    //读数据1
// output [31:0] rf_rdata2     //读数据2
//     );

// reg [31:0] rf [0:31];      //寄存器文件

// //读优先，异步读
// assign rf_rdata1 = rf[rf_raddr1];
// assign rf_rdata2 = rf[rf_raddr2];

// //同步写
// always @(posedge clk)
// begin
//     if(rf_we)
//         rf[rf_rd] <= rf_wdata;
// end

// endmodule


module RF(
input clk,      //时钟
input [4:0] rf_waddr,      //写地址
input       rf_we,      //写使能    
input [31:0] rf_wdata,      //写数据
input [4:0] rf_raddr1,      //读地址1
input [4:0] rf_raddr2,      //读地址2
output [31:0] rf_rdata1,    //读数据1
output [31:0] rf_rdata2,     //读数据2

input [4:0] rf_raddr3,      //读地址3
output [31:0] rf_rdata3    //读数据3
    );

reg [31:0] rf [0:31];      //寄存器文件

//读优先，异步读
assign rf_rdata1 = (rf_raddr1 == 0) ? 0 : rf[rf_raddr1];
assign rf_rdata2 = (rf_raddr2 == 0) ? 0 : rf[rf_raddr2];
assign rf_rdata3 = (rf_raddr3 == 0) ? 0 : rf[rf_raddr3];

//同步写
always @(posedge clk)
begin
    if(rf_we && rf_waddr != 0) // 当写地址不是0时，才进行写入
        rf[rf_waddr] <= rf_wdata;
end

endmodule
