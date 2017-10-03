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
	Branch_o,
	MemToReg_o,
	MemRead,
	MemWrite
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [4-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output			MemToReg_o;
output			MemRead;
output			MemWrite;
//Internal Signals
reg    [4-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg				MemToReg_o;
reg				Branchtype;
reg				Jump;
reg				MemRead;
reg				MemWrite;
reg				cjal;
//Parameter


//Main function

always@(*)begin
	if(instr_op_i==0)begin//R-type
		ALU_op_o <= 0; ALUSrc_o <= 0; RegWrite_o <= 1;
		RegDst_o <= 1; Branch_o <= 0; MemToReg_o <= 0;
		Branchtype <= 0; Jump <= 0;
		MemRead <= 0; MemWrite <= 0; cjal <= 0;
	end
	else if(instr_op_i==8)begin//ADDI
		ALU_op_o <= 1; ALUSrc_o <= 1; RegWrite_o <= 1;
		RegDst_o <= 0; Branch_o <= 0; MemToReg_o <= 0;
		Branchtype <= 0; Jump <= 0;
		MemRead <= 0; MemWrite <= 0; cjal <= 0;
	end
	else if(instr_op_i==6'b100011)begin//LW
		ALU_op_o <= 7; ALUSrc_o <= 1; RegWrite_o <= 1;
		RegDst_o <= 0; Branch_o <= 0; MemToReg_o <= 1;
		Branchtype <= 0; Jump <= 0;
		MemRead <= 1; MemWrite <= 0; cjal <= 0;
	end
	else if(instr_op_i==6'b101011)begin//SW
		ALU_op_o <= 8; ALUSrc_o <= 1; RegWrite_o <= 0;
		RegDst_o <= 0; Branch_o <= 0; MemToReg_o <= 0;
		Branchtype <= 0; Jump <= 0;
		MemRead <= 0; MemWrite <= 1; cjal <= 0;
	end
	else begin
		ALU_op_o <= 0; ALUSrc_o <= 0; RegWrite_o <= 0;
		RegDst_o <= 0; Branch_o <= 0; MemToReg_o <= 0;
		Branchtype <= 0; Jump <= 0;
		MemRead <= 0; MemWrite <= 0; cjal <= 0;
	end
	/*else if(instr_op_i==6'b000000)begin//JR
		ALU_op_o <= 0; ALUSrc_o <= 0; RegWrite_o <= 1;
		RegDst_o <= 1; Branch_o <= 0; MemToReg_o <= 0;
		Branchtype <= 0; Jump <= 0;
		MemRead <= 0; MemWrite <= 0; cjal <= 0;
	end*/
end

endmodule





                    
                    