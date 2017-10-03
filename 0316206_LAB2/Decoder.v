//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Parameter


//Main function
always @(*)begin
	if(instr_op_i== 0)begin
		RegDst_o <= 1;RegWrite_o <= 1;Branch_o <= 0;ALUSrc_o <= 0;ALU_op_o <= 2;
	end
	else if(instr_op_i== 8)begin
		RegDst_o <= 0;RegWrite_o <= 1;Branch_o <= 0;ALUSrc_o <= 1;ALU_op_o <= 3;
	end
	else if(instr_op_i== 10)begin
		RegDst_o <= 0;RegWrite_o <= 1;Branch_o <= 0;ALUSrc_o <= 1;ALU_op_o <= 0;
	end
	else if(instr_op_i== 4)begin
		RegDst_o<=0; RegWrite_o <= 0;Branch_o <= 1;ALUSrc_o <= 0;ALU_op_o <= 1;
	end
	else if(instr_op_i== 15)begin
		RegDst_o <= 0;RegWrite_o <= 1;Branch_o <= 0;ALUSrc_o <= 1;ALU_op_o <= 4;
	end
	else if(instr_op_i== 13)begin
		RegDst_o <= 0;RegWrite_o <= 1;Branch_o <= 0;ALUSrc_o <= 1;ALU_op_o <= 5;
	end
	else if(instr_op_i== 5)begin
		RegDst_o<=0; RegWrite_o <= 0;Branch_o <= 1;ALUSrc_o <= 0;ALU_op_o <= 6;
	end
end

endmodule





                    
                    