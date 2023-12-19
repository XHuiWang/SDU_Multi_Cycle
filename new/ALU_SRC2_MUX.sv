`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 21:22:15
// Design Name: 
// Module Name: ALU_SRC2_MUX
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


module ALU_SRC2_MUX(
input [31:0] imm,
input [31:0] rf_rdata2,
input [1:0] alu_src2_sel,
output logic [31:0] alu_src2
    );

always @(*) begin
    case (alu_src2_sel)
        2'b00: alu_src2 = 32'h4;
        2'b01: alu_src2 = imm;
        2'b10: alu_src2 = rf_rdata2;
        default: alu_src2 = 32'h4; 
    endcase
end

endmodule
