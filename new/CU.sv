`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/13 10:40:58
// Design Name: 
// Module Name: CU
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


module CU(
input clk,
input rstn,
input [31:0] instr,

output logic PC_we,
output logic MEM_we,
output logic RF_we


    );

logic [31:0] CS;
logic [31:0] NS;

localparam IF = 32'h0000_0001;
localparam ID = 32'h0000_0002;
localparam EX1 = 32'h0000_0004;
localparam EX2 = 32'h0000_0008;
localparam EX3 = 32'h0000_0010;
localparam CMP = 32'h0000_0020;
localparam WB = 32'h0000_0040;
localparam R_DM  = 32'h0000_0080;
localparam W_DM  = 32'h0000_0100;
localparam PC_JUMP  = 32'h0000_0200;

//处理CS
always@(posedge clk or negedge rstn)
    begin
        if(!rstn)
            CS <= IF;
        else
            CS <= NS;
    end

//处理NS
always@(*)
    begin
        case(CS)
            IF: NS = ID;
            ID: 
                begin
                    case(instr[31:26])
                        6'b000000: NS = EX1;
                        6'b000101: NS = EX1;
                        6'b001010: 
                            begin
                                if(instr[25:22] == 4'b0010)//ld.w
                                    NS = EX2;
                                else if(instr[25:22] == 4'b0110)//st.w
                                    NS = EX3;
                            end
                        6'b010111: NS = CMP;
                        default: NS = IF;
                    endcase
                end
            EX1: NS = WB;
            EX2: NS = R_DM;
            EX3: NS = W_DM;
            CMP: NS = PC_JUMP;
            WB: NS = IF;
            R_DM: NS = WB;
            W_DM: NS = IF;
            PC_JUMP: NS = IF;

            default: NS = IF;

        endcase
    end

//处理输出
always @(*) begin
    case(CS)

        WB: begin
            PC_we = 1'b1;
            MEM_we = 1'b0;
            RF_we = 1'b1;
        end

        W_DM: begin
            PC_we = 1'b1;
            MEM_we = 1'b1;
            RF_we = 1'b0;
        end

        PC_JUMP: begin
            PC_we = 1'b1;
            MEM_we = 1'b0;
            RF_we = 1'b0;
        end
        default: begin
            PC_we = 1'b0;
            MEM_we = 1'b0;
            RF_we = 1'b0;
        end
    endcase
end



endmodule
