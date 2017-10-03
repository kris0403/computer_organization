`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:41:01 05/26/2016 
// Design Name: 
// Module Name:    Forwarding_unit 
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
module Forwarding_unit(
	control_mem,
	control_wb,
	input_mem,
	input_wb,
	input_rs,
	input_rt,
	forward_a,
	forward_b
    );
/*
.control_mem(ex_mem_instruct[105]),
	.control_wb(mem_wb_instruct[69]),
	.input_mem(ex_mem_instruct[4:0]),
	.input_wb(mem_wb_instruct[4:0]),
	.input_rs(id_ex_instruct[154:150]),
	.input_rt(id_ex_instruct[9:5]),
	.forward_a(forward_a),
	.forward_b(forward_b) */	 
input control_mem;
input control_wb;
input[4:0] input_mem;
input[4:0] input_wb;
input[4:0] input_rs;
input[4:0] input_rt;
output reg [1:0] forward_a;
output reg [1:0] forward_b;

always @(*)begin
	if((control_mem)&&(input_mem!=0)&&(input_mem==input_rs))forward_a<=2'b01;
	else if((control_wb)&&(input_wb!=0)&&!((control_mem)&&(input_mem!=0)&&(input_mem==input_rs))&&(input_wb==input_rs))forward_a<=2'b10;
	else forward_a<=2'b00;
end
always @(*)begin
	if((control_mem)&&(input_mem!=0)&&(input_mem==input_rt))forward_b<=2'b01;
	else if((control_wb)&&(input_wb!=0)&&!((control_mem)&&(input_mem!=0)&&(input_mem==input_rt))&&(input_wb==input_rt))forward_b<=2'b10;
	else forward_b<=2'b00;
end
endmodule
