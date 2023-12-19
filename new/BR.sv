`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 12:01:11
// Design Name: 
// Module Name: BR
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

//����br_type,������������
//����pc��rf_rdata1,rf_rdata2,imm����������������,���ڼ�����ת��ַjump_target
//���jump_en,�Ƿ���ת
//�Ե�����CPU��������߼�
//beq��bne��blt��bge��bltu��bgeu��b��bl��jirl��9����תָ��

module BR(
input [8:0] br_type,
input [31:0] pc,
input [31:0] rf_rdata1,
input [31:0] rf_rdata2,
input [31:0] imm,
output logic        jump_en,
output logic [31:0] jump_target
    );
//����
parameter BR_BEQ = 9'b000000001;
parameter BR_BNE = 9'b000000010;
parameter BR_BLT = 9'b000000100;
parameter BR_BGE = 9'b000001000;
parameter BR_BLTU = 9'b000010000;
parameter BR_BGEU = 9'b000100000;
parameter BR_B = 9'b001000000;
parameter BR_BL = 9'b010000000;
parameter BR_JIRL = 9'b100000000;

always @(*) begin
    jump_target = 32'b0;
    case(br_type)

        BR_BNE: begin
            if(rf_rdata1 != rf_rdata2)
            begin
                jump_en = 1'b1;
                jump_target = pc + imm;
            end
                
            else
                jump_en = 1'b0;
        end
       
        default: begin
            jump_en = 1'b0;

        end
    endcase
end





endmodule
