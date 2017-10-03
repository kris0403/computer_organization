`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:52:50 05/02/2016 
// Design Name: 
// Module Name:    MUX_4to1 
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
module MUX_4to1(
   data0_i,
   data1_i,
   data2_i,
   data3_i,
   select_i,
  data_o
    );
//I/O ports      

parameter size = 0;	     
input   [size-1:0] data0_i;          
input   [size-1:0] data1_i;
input   [size-1:0] data2_i;
input   [size-1:0] data3_i;
input              select_i;
output  [size-1:0] data_o; 

//Internal Signals
reg     [size-1:0] data_o;

//Main function

always@(*)begin
	if(select_i==0) data_o<=data0_i;
	else if(select_i==1) data_o<=data1_i;
	else if(select_i==2) data_o<=data2_i;
	else if(select_i==3) data_o<=data3_i;
	else data_o<=data_o;
end


endmodule
