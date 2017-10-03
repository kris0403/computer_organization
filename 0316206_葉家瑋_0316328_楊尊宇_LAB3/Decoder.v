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
	Branchtype,
	Jump,
	MemRead,
	MemWrite,
	cjal
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [4-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output			MemToReg_o;
output			Branchtype;
output			Jump;
output			MemRead;
output			MemWrite;
output			cjal;
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
	else if(instr_op_i==10)begin//SLTI
		ALU_op_o <= 2; ALUSrc_o <= 1; RegWrite_o <= 1;
		RegDst_o <= 0; Branch_o <= 0; MemToReg_o <= 0;
		Branchtype <= 0; Jump <= 0;
		MemRead <= 0; MemWrite <= 0; cjal <= 0;
	end
	else if(instr_op_i==4)begin//BEQ
		ALU_op_o <= 3; ALUSrc_o <= 0; RegWrite_o <= 0;
		RegDst_o <= 0; Branch_o <= 1; MemToReg_o <= 0;
		Branchtype <= 0; Jump <= 0;
		MemRead <= 0; MemWrite <= 0; cjal <= 0;
	end
	else if(instr_op_i==15)begin//LUI
		ALU_op_o <= 4; ALUSrc_o <= 1; RegWrite_o <= 1;
		RegDst_o <= 0; Branch_o <= 0; MemToReg_o <= 0;
		Branchtype <= 0; Jump <= 0;
		MemRead <= 0; MemWrite <= 0; cjal <= 0;
	end
	else if(instr_op_i==13)begin//ORI
		ALU_op_o <= 5; ALUSrc_o <= 1; RegWrite_o <= 1;
		RegDst_o <= 0; Branch_o <= 0; MemToReg_o <= 0;
		Branchtype <= 0; Jump <= 0;
		MemRead <= 0; MemWrite <= 0; cjal <= 0;
	end
	else if(instr_op_i==5)begin//BNE
		ALU_op_o <= 6; ALUSrc_o <= 0; RegWrite_o <= 0;
		RegDst_o <= 0; Branch_o <= 1; MemToReg_o <= 0;
		Branchtype <= 3; Jump <= 0;
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
	else if(instr_op_i==6'b000010)begin//JUMP
		ALU_op_o <= 9; ALUSrc_o <= 0; RegWrite_o <= 0;
		RegDst_o <= 0; Branch_o <= 0; MemToReg_o <= 0;
		Branchtype <= 0; Jump <= 1;
		MemRead <= 0; MemWrite <= 0; cjal <= 0;
	end
	else if(instr_op_i==6'b000111)begin//BGT
		ALU_op_o <= 10; ALUSrc_o <= 0; RegWrite_o <= 0;
		RegDst_o <= 0; Branch_o <= 1; MemToReg_o <= 0;
		Branchtype <= 1; Jump <= 0;
		MemRead <= 0; MemWrite <= 0; cjal <= 0;
	end
	else if(instr_op_i==6'b000101)begin//BNEZ
		ALU_op_o <= 11; ALUSrc_o <= 0; RegWrite_o <= 0;
		RegDst_o <= 0; Branch_o <= 1; MemToReg_o <= 0;
		Branchtype <= 3; Jump <= 0;
		MemRead <= 0; MemWrite <= 0; cjal <= 0;
	end
	else if(instr_op_i==6'b000001)begin//BGNZ
		ALU_op_o <= 12; ALUSrc_o <= 0; RegWrite_o <= 0;
		RegDst_o <= 0; Branch_o <= 1; MemToReg_o <= 0;
		Branchtype <= 2; Jump <= 0;
		MemRead <= 0; MemWrite <= 0; cjal <= 0;
	end
	else if(instr_op_i==6'b000011)begin//JAL
		ALU_op_o <= 13; ALUSrc_o <= 0; RegWrite_o <= 1;
		RegDst_o <= 0; Branch_o <= 0; MemToReg_o <= 0;
		Branchtype <= 0; Jump <= 1;
		MemRead <= 0; MemWrite <= 0; cjal <= 1;
	end
	/*else if(instr_op_i==6'b000000)begin//JR
		ALU_op_o <= 0; ALUSrc_o <= 0; RegWrite_o <= 1;
		RegDst_o <= 1; Branch_o <= 0; MemToReg_o <= 0;
		Branchtype <= 0; Jump <= 0;
		MemRead <= 0; MemWrite <= 0; cjal <= 0;
	end*/
end

endmodule





                    
                    