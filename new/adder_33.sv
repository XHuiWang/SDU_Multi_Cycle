`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/08 23:15:25
// Design Name: 
// Module Name: adder_33
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


module adder_33(
    input [32:0]    a,
    input [32:0]    b,
    output [32:0]   sum,
    input           cin,
    output          cout
    );
    assign {cout, sum} = a + b + cin;
    
endmodule
