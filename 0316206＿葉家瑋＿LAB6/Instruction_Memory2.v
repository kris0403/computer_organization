`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:     
// Design Name: 
// Module Name:    Instruction_Memory 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Instruction_Memory2
(
	addr_i, 
	instr_o
);

// Interface
input	[31:0]		addr_i;
output [31:0]		instr_o;
integer          i;

// Instruction File
reg		[31:0]		instr_file	[0:31];

initial begin

    for ( i=0; i<32; i=i+1 )
            instr_file[i] = 32'b0;
        
    $readmemb("LAB6_machine_2.txt", instr_file);  //Read instruction from "LAB6_machine_2.txt"   
end

assign	instr_o = instr_file[addr_i/4];  

endmodule
