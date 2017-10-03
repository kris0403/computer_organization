`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:32:57 05/26/2016 
// Design Name: 
// Module Name:    Pipe_Reg_special 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Pipe_Reg_special(
                rst_n,
			clk_i,   
			select,
			data_i,
			data_o
);
					
parameter size = 0;
input                    rst_n;
input                    clk_i;	
input							select;	  
input      [size-1: 0] data_i;
output reg [size-1: 0] data_o;
	  
always @(posedge clk_i or negedge  rst_n) begin
	if( rst_n == 0) data_o <= 0;
	else if(select==1)data_o <= data_o;
	else if(data_o[0]==1)data_o <= 0;
    else data_o <= data_i;
end

endmodule	