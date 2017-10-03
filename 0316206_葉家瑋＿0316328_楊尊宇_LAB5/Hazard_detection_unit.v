`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:26:25 05/30/2016 
// Design Name: 
// Module Name:    Hazard_detection_unit 
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
module Hazard_detection_unit(
	pc_src,
	input_memread,
	input_idex,
	input_rs,
	input_rt,
	IF_flush,
	EX_flush,
	ID_flush,
	PC_write,
	IFID_write
    );
	 
/*Hazard_detection_unit ha(
	.pc_src(pcsrc),
	.input_memread(id_ex_instruct[145]),
	.input_idex(id_ex_instruct[9:5]),
	.input_rs(instruct[25:21]),
	.input_rt(instruct[20:16]),
	.IF_flush(if_flush),
	.EX_flush(ex_flush),
	.ID_flush(id_flush),
	.PC_write(pc_write),
	.IFID_write(ifid_write)
	);*/
input  		pc_src;
input	 		input_memread;
input [4:0]	input_idex;
input [4:0]	input_rs;
input	[4:0]	input_rt;
output	reg	IF_flush;
output	reg	EX_flush;
output	reg	ID_flush;
output	reg	PC_write;
output	reg	IFID_write;

always@(*)begin
	if(pc_src)begin
		IF_flush<=1;
		ID_flush<=1;
		EX_flush<=1;
		PC_write<=0;
		IFID_write<=0;
	end
	else if(input_memread&&((input_idex==input_rs)||(input_idex==input_rt)))begin
		IF_flush<=0;
		ID_flush<=1;
		EX_flush<=0;
		PC_write<=0;
		IFID_write<=1;
	end
	else begin
		IF_flush<=0;
		ID_flush<=0;
		EX_flush<=0;
		PC_write<=1;
		IFID_write<=0;
	end
end

endmodule
