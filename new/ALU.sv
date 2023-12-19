`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/08 23:12:25
// Design Name: 
// Module Name: ALU
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


module ALU(
    input      [11:0] f,       //功能选择
    input      [31:0] a, b,   //两操作数
    output reg [31:0] y       //运算结果
    );

    wire [32:0] adder_out;
    reg  [32:0] adder_a;   
    reg  [32:0] adder_b;
    reg         adder_cin;
    adder_33
        adder_01(.a(adder_a),.b(adder_b),.cin(adder_cin),.cout(),.sum(adder_out));


always @(*) begin
    adder_cin = 0;
    case (f)
        12'b0000_0000_0001: 
        begin
            adder_a = a;
            adder_b = b;
        end
        12'b0000_0000_0010:  
        begin
            adder_a = a;
            adder_b = ~b;
            adder_cin = 1;
        end
        12'b0000_0000_0100:
        begin
            adder_a =  $signed (a) ;
            adder_b =  $signed(~b+1);                 
        end
        
        12'b0000_0000_1000:
        begin
            adder_a = {1'b0,a};
            adder_b = (~{1'b0,b});
            adder_cin = 1;
        end
        default:
        begin
            adder_a = 0;
            adder_b = 0;
        end

    endcase
end

always @(*) begin
    case (f)
        12'b0000_0000_0001:  y = adder_out[31:0];
        12'b0000_0000_0010:  y = adder_out[31:0];//例化同一个加法器
        12'b0000_0000_0100:  y = adder_out[32];//为1,a<b
        12'b0000_0000_1000:  y = adder_out[32];
        12'b0000_0001_0000:  y = a&b;
        12'b0000_0010_0000:  y = a|b;
        12'b0000_0100_0000:  y = ~(a|b);
        12'b0000_1000_0000:  y = a^b;
        12'b0001_0000_0000:  y = a<<b[4:0];
        12'b0010_0000_0000:  y = a>>b[4:0];
        12'b0100_0000_0000:  y = $signed(a)>>>b[4:0];       //算术右移
        12'b1000_0000_0000:  y = b;        
        default: y = 0;
    endcase
end


endmodule

