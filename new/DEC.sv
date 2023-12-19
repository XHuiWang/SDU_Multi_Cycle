`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 12:33:00
// Design Name: 
// Module Name: DEC
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

//����������������ָ����������ź�
//����ָ��instr����IM����
//��������ź�:
//rf_we��rf_waddr,we_sel����д�ؼĴ���
//rf_raddr1,rf_raddr2���ڶ�ȡ�Ĵ���
//mem_we�������ݴ洢��DM
//alu_op��alu_src1_sel��alu_src2_sel����ALU
//br_type����BR
//imm����BR��ALU

//��ʵ��6��ָ�add.w,addi.w,lu12i.w,ld.w,st.w,bne
//add.w:000000_0000_01_00000_rk[4:0]_rj[4:0]_rd[4:0]
//addi.w:000000_1010_si[11:0]_rj[4:0]_rd[4:0]
//lu12i.w:000101_0_si[19:0]_rd[4:0]
//ld.w:001010_0010_si[11:0]_rj[4:0]_rd[4:0]
//st.w:001010_0110_si[11:0]_rj[4:0]_rd[4:0]
//bne:010111_offset[15:0]_rj[4:0]_rd[4:0]

module DEC(
input [31:0] instr,
//
// output logic rf_we,
output logic [4:0] rf_waddr,
output logic       we_sel,
output logic [4:0] rf_raddr1,
output logic [4:0] rf_raddr2,
//
// output logic mem_we,
//
output logic [11:0] alu_op,
output logic [1:0] alu_src1_sel,
output logic [1:0] alu_src2_sel,
//
output logic [8:0] br_type,
output logic [31:0] imm
    );


parameter ARI =  6'b000000;
parameter LUI =  6'b000101;
parameter MEM =  6'b001010;
parameter BNE =  6'b010111;

//ADD.w����ͨ·�������ȡ��������instr[9:5]Ϊrf_raddr1��instr[14:10]Ϊrf_raddr2
//���㣺alu_opΪ12'h1��alu_src1_selΪ2'b10��alu_src2_selΪ2'b10
//д�أ�rf_weΪ1'b1��rf_waddrΪinstr[4:0]��we_selΪ1'b1

//ADDI.w����ͨ·������:����������immΪinstr[21:10]��alu_src1_selΪ2'b10��alu_src2_selΪ2'b01
//ȡ��������instr[9:5]Ϊrf_raddr1
//���㣺alu_opΪ12'h1��alu_src1_selΪ2'b10��alu_src2_selΪ2'b01
//д�أ�rf_weΪ1'b1��rf_waddrΪinstr[4:0]��we_selΪ1'b1

//ADD��ADDI����������alu_src2_sel��ͬ��ADDΪ2'b10��ADDIΪ2'b01

//LUI.w����ͨ·������:����������imm��alu_src1_selΪ2'b10��alu_src2_selΪ2'b00

//LD.w����ͨ·�����룺����������immΪinstr[21:10]��alu_src1_selΪ2'b10��alu_src2_selΪ2'b01
//ȡ��������instr[9:5]Ϊrf_raddr1��alu_src1_selΪ2'b10��alu_src2_selΪ2'b01
//���㣺alu_opΪ12'h1
//�ô棺mem_weΪ1'b0(��д�ڴ棬���ڴ�)
//д�أ�rf_weΪ1'b1��rf_waddrΪinstr[4:0]��we_selΪ1'b0��ѡ��mem_rdata

//ST.w����ͨ·�����룺����������immΪinstr[21:10]��alu_src1_selΪ2'b10��alu_src2_selΪ2'b01
//д��������instr[4:0]�żĴ���


//BNE����ͨ·��Ĭ�ϲ�д��Ҳ��д�ڴ棬��ֱ�Ӵ�����ת����

always @(*) begin
    br_type = 9'b0;//Ĭ�ϲ���ת
    imm = 32'b0;//Ĭ��������Ϊ0
    // rf_we = 1'b0;//Ĭ�ϲ�д��
    rf_waddr = instr[4:0];//Ĭ��д�ص�ַΪinstr[4:0]
    we_sel = 1'b1;//Ĭ��д������Ϊalu_result
    rf_raddr1 = 5'b0;//Ĭ�϶�ȡ�Ĵ���1��ַΪ0
    rf_raddr2 = 5'b0;//Ĭ�϶�ȡ�Ĵ���2��ַΪ0
    // mem_we = 1'b0;//Ĭ�ϲ�д�����ݴ洢��
    alu_op = 12'b0;//Ĭ��alu_opΪ0,alu���0
    alu_src1_sel = 2'b0;//Ĭ��alu_src1_selΪ0
    alu_src2_sel = 2'b0;//Ĭ��alu_src2_selΪ0

    //����

case (instr[31:26])
    ARI: begin
        rf_raddr1 = instr[9:5];
        alu_src1_sel = 2'b10;
        alu_op = 12'h1;
        // rf_we = 1'b1;
        we_sel = 1'b1;

        case (instr[25:22])
            4'b0000: begin//ADD
            rf_raddr2 = instr[14:10];
            alu_src2_sel = 2'b10;
            end
            4'b1010: begin//ADDI
            imm = $signed(instr[21:10]);
            alu_src2_sel = 2'b01;
            end
        endcase
    end
    LUI: begin//��imm��0��ӣ�alu_opΪ12'h1��alu_src1_selΪ2'b00��alu_src2_selΪ2'b01
        imm = {instr[24:5],12'b0};
        alu_op = 12'h1;
        alu_src1_sel = 2'b00;
        alu_src2_sel = 2'b01;
        // rf_we = 1'b1;
        we_sel = 1'b1;
    end
    MEM: begin
        case (instr[25:22])
            4'b0010: begin//LD
            imm = $signed(instr[21:10]);
            alu_src1_sel = 2'b10;
            alu_src2_sel = 2'b01;
            rf_raddr1 = instr[9:5];
            alu_op = 12'h1;
            // mem_we = 1'b0;
            // rf_we = 1'b1;
            we_sel = 1'b0;
            end
            4'b0110: begin//ST
            imm = $signed(instr[21:10]);
            alu_src1_sel = 2'b10;
            alu_src2_sel = 2'b01;
            rf_raddr1 = instr[9:5];
            alu_op = 12'h1;
            // mem_we = 1'b1;
            rf_raddr2 = instr[4:0];
            end
            
        endcase
    end
    BNE: begin
        imm = $signed({instr[25:10],2'b0});
        rf_raddr1 = instr[9:5];
        rf_raddr2 = instr[4:0];
        br_type = 9'b000000010;
    end

    default:;
endcase


    
end


endmodule
