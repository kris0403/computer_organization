//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//------------------------------------6--------------------------------------------

module Decoder(
   instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	memtoreg,
 	memread,
 	memwrite,	
	);//jump_o,
 	//branchtype_o,
     
//I/O ports
input  [6-1:0] instr_op_i;

output reg        RegWrite_o;
output reg [3-1:0] ALU_op_o;
output reg        ALUSrc_o;
output reg        RegDst_o;
output reg        Branch_o;
output reg			memtoreg;
output reg			memread;
output reg			memwrite;
//Internal Signals
reg flush;
reg jump_o;
reg [2-1:0] branchtype_o;
//Parameter


//Main function
always@(*)begin
	if(instr_op_i==6'b000000)begin//rformat
		memwrite <=1'b0;
		RegDst_o<=1'b1;
		ALUSrc_o<=1'b0;
		memtoreg<=1'd0;
		memread <=1'b0;
		RegWrite_o <=1'b1;
		jump_o <=1'b0;
		Branch_o<=1'b0;
		branchtype_o<=2'd0;
		ALU_op_o<=3'b010;
		flush<=1'b0;
	end
	else if(instr_op_i==6'b001000)begin//addi
		memwrite <=1'b0;
		memread <=1'b0;
		Branch_o <=1'b0;
		RegDst_o <=1'b0;
		ALUSrc_o <=1'b1;
		memtoreg <=1'd0;
		RegWrite_o <=1'b1;
		jump_o <=1'b0;
		branchtype_o <=2'd0;
		ALU_op_o <=3'b110;
		flush <=1'b0;
	end
	else if(instr_op_i==6'b001010)begin//slti
		memwrite <= 1'b0;
		memread <= 1'b0;
		RegWrite_o <= 1'b1;
		ALUSrc_o <= 1'b1;
		jump_o <= 1'b0;
		Branch_o <= 1'b0;
		RegDst_o <= 1'b0;
		memtoreg <= 1'd0;
		branchtype_o <= 2'd0;
		ALU_op_o <= 3'b111;
		flush <= 1'b0;
	end
	else if(instr_op_i==6'b101011)begin//sw
		memwrite<=1'b1;
		jump_o<=1'b0;
		memread<=1'b0;
		RegWrite_o<=1'b0;
		Branch_o<=1'b0;
		RegDst_o<=1'b0;
		ALUSrc_o<=1'b1;
		memtoreg<=1'd1;
		ALU_op_o<=3'b000;
		branchtype_o<=2'd0;
		flush<=1'b0;
	end
	else if(instr_op_i==6'b000100)begin//beq
		memwrite <=1'b0;
		memread <=1'b0;
		RegWrite_o <=1'b0;
		jump_o <=1'b0;
		Branch_o <=1'b1;
		ALUSrc_o <=1'b0;
		memtoreg <=1'd1;
		branchtype_o <=2'd0;
		ALU_op_o <=3'b001;
		RegDst_o <=1'b0;
		flush <=1'b1;
	end
	else if(instr_op_i==6'b100011)begin//lw
		memwrite<=1'b0;
		memread<=1'b1;
		RegWrite_o<=1'b1;
		flush<=1'b0;
		jump_o<=1'b0;
		ALUSrc_o<=1'b1;
		memtoreg<=1'd1;
		branchtype_o<=2'd0;
		ALU_op_o<=3'b000;
		Branch_o<=1'b0;
		RegDst_o<=1'b0;
	end
	else begin
		memwrite<=1'b0;
		memread<=1'b0;
	end
	
end

endmodule





                    
                    