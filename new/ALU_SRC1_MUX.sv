`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 21:22:01
// Design Name: 
// Module Name: ALU_SRC1_MUX
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


module ALU_SRC1_MUX(
input [31:0] pc,
input [31:0] rf_rdata1,
input [1:0] alu_src1_sel,
output logic [31:0] alu_src1
    );

always @(*) begin
    case (alu_src1_sel)
        2'b00: alu_src1 = 0;
        2'b01: alu_src1 = pc;
        2'b10: alu_src1 = rf_rdata1;
        default: alu_src1 = 0;
    endcase
end
endmodule
