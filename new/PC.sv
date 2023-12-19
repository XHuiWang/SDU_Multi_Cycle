`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/08 22:37:15
// Design Name: 
// Module Name: PC
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


module PC(
input   logic   clk,
input   logic   rstn,
input   logic   [31:0]  nPC,
input  logic           PC_we,
output  logic   [31:0]  PC
    );

always@(posedge clk)
    begin
        if(!rstn)
            PC <= 32'h1c00_0000;
        else if(PC_we)
            PC <= nPC;
    end

endmodule
