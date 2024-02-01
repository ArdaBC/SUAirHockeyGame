`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2024 11:58:59 AM
// Design Name: 
// Module Name: top_module
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


module top_module(
    input clk,
    input rst,
    
    input BTNA,
    input BTNB,
    
    input [1:0] DIRA,
    input [1:0] DIRB,
    
    input [2:0] YA,
    input [2:0] YB,
   
    output LEDA,
    output LEDB,
    output [4:0] LEDX,
    
    output a_out,b_out,c_out,d_out,e_out,f_out,g_out,p_out,
    output [7:0]an
);
    wire [55:0]SSDTemp;
    clk_divider clk_div(clk, rst, clk_out);
    debouncer debA(clk_out,rst,BTNA, btnAout);
    debouncer debB(clk_out,rst,BTNB,btnBout);
    hockey hockeyBoard(clk_out,rst,btnAout,btnBout,DIRA,DIRB,YA,YB,LEDA,LEDB,LEDX,SSDTemp[55:49],SSDTemp[48:42],SSDTemp[41:35],SSDTemp[34:28],SSDTemp[27:21],SSDTemp[20:14],SSDTemp[13:7],SSDTemp[6:0]);
    ssd ssdA(clk,rst,SSDTemp[55:49],SSDTemp[48:42],SSDTemp[41:35],SSDTemp[34:28],SSDTemp[27:21],SSDTemp[20:14],SSDTemp[13:7],SSDTemp[6:0],a_out,b_out,c_out,d_out,e_out,f_out,g_out,p_out,an);
	
endmodule
