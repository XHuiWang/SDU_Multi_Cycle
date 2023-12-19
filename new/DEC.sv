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

//译码器，用于译码指令，给出控制信号
//输入指令instr，由IM给出
//输出控制信号:
//rf_we，rf_waddr,we_sel用于写回寄存器
//rf_raddr1,rf_raddr2用于读取寄存器
//mem_we用于数据存储器DM
//alu_op，alu_src1_sel，alu_src2_sel用于ALU
//br_type用于BR
//imm用于BR和ALU

//先实现6条指令，add.w,addi.w,lu12i.w,ld.w,st.w,bne
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

//ADD.w数据通路：译码后取操作数：instr[9:5]为rf_raddr1，instr[14:10]为rf_raddr2
//运算：alu_op为12'h1，alu_src1_sel为2'b10，alu_src2_sel为2'b10
//写回：rf_we为1'b1，rf_waddr为instr[4:0]，we_sel为1'b1

//ADDI.w数据通路：译码:产生立即数imm为instr[21:10]，alu_src1_sel为2'b10，alu_src2_sel为2'b01
//取操作数：instr[9:5]为rf_raddr1
//运算：alu_op为12'h1，alu_src1_sel为2'b10，alu_src2_sel为2'b01
//写回：rf_we为1'b1，rf_waddr为instr[4:0]，we_sel为1'b1

//ADD和ADDI的区别在于alu_src2_sel不同，ADD为2'b10，ADDI为2'b01

//LUI.w数据通路：译码:产生立即数imm，alu_src1_sel为2'b10，alu_src2_sel为2'b00

//LD.w数据通路：译码：产生立即数imm为instr[21:10]，alu_src1_sel为2'b10，alu_src2_sel为2'b01
//取操作数：instr[9:5]为rf_raddr1，alu_src1_sel为2'b10，alu_src2_sel为2'b01
//运算：alu_op为12'h1
//访存：mem_we为1'b0(不写内存，读内存)
//写回：rf_we为1'b1，rf_waddr为instr[4:0]，we_sel为1'b0，选择mem_rdata

//ST.w数据通路：译码：产生立即数imm为instr[21:10]，alu_src1_sel为2'b10，alu_src2_sel为2'b01
//写数据来自instr[4:0]号寄存器


//BNE数据通路：默认不写回也不写内存，故直接处理跳转即可

always @(*) begin
    br_type = 9'b0;//默认不跳转
    imm = 32'b0;//默认立即数为0
    // rf_we = 1'b0;//默认不写回
    rf_waddr = instr[4:0];//默认写回地址为instr[4:0]
    we_sel = 1'b1;//默认写回数据为alu_result
    rf_raddr1 = 5'b0;//默认读取寄存器1地址为0
    rf_raddr2 = 5'b0;//默认读取寄存器2地址为0
    // mem_we = 1'b0;//默认不写入数据存储器
    alu_op = 12'b0;//默认alu_op为0,alu输出0
    alu_src1_sel = 2'b0;//默认alu_src1_sel为0
    alu_src2_sel = 2'b0;//默认alu_src2_sel为0

    //译码

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
    LUI: begin//用imm与0相加，alu_op为12'h1，alu_src1_sel为2'b00，alu_src2_sel为2'b01
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
