`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 21:22:36
// Design Name: 
// Module Name: PC_MUX
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


module PC_MUX(
input [31:0] pc,
input [31:0] jump_target,
input        jump_en,
output logic [31:0] npc
    );

assign npc = (jump_en == 1'b1) ? jump_target : (pc+4);

endmodule
