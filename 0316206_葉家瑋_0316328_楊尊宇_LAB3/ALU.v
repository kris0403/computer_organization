//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o,
	shamt,
	cjr
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [5-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;
output 				cjr;
input [4:0] shamt;
//Internal signals
reg    [32-1:0]  result_o;
reg 					cjr;
wire             zero_o;

assign zero_o = (result_o==0)?1:0;
//Parameter

//Main function
always @(*)begin
	if(ctrl_i == 0)begin//add
		result_o <= src1_i + src2_i; cjr<=0;
	end
	else if(ctrl_i == 1)begin//addi
		result_o <= src1_i + src2_i; cjr<=0;
	end
	else if(ctrl_i == 2)begin//sub
		result_o <= src1_i - src2_i; cjr<=0;
	end
	else if(ctrl_i == 3)begin//and
		result_o <= src1_i & src2_i; cjr<=0;
	end
	else if(ctrl_i == 4)begin//or
		result_o <= src1_i | src2_i; cjr<=0;
	end
	else if(ctrl_i == 5)begin//slt
		if(src1_i < src2_i)result_o <= 1;
		else result_o <= 0;
		cjr<=0;
	end
	else if(ctrl_i == 6)begin//slti
		if(src1_i < src2_i)result_o <= 1;
		else result_o <= 0;
		cjr<=0;
	end
	else if(ctrl_i == 7)begin//BEQ
		result_o<=src1_i-src2_i;
		cjr<=0;
	end
	else if(ctrl_i == 8)begin//SLL
		result_o <= (src2_i << shamt);
		cjr<=0;
	end
	else if(ctrl_i == 9)begin//SRLV
		result_o <= (src2_i >> src1_i);
		cjr<=0;
	end
	else if(ctrl_i == 10)begin//LUI
		result_o[31:16] <= src2_i; result_o[15:0]<=0; cjr<=0;
	end
	else if(ctrl_i == 11)begin //ori
		result_o <= src1_i|{{16{0}},src2_i[15:0]}; cjr<=0;
	end
	else if(ctrl_i == 12)begin //bne
		result_o<=src1_i-src2_i;
		cjr<=0;
	end
	else if(ctrl_i == 13)begin //LW
		result_o <= src1_i + src2_i; cjr<=0;
	end
	else if(ctrl_i == 14)begin //SW
		result_o <= src1_i + src2_i; cjr<=0;
	end
	else if(ctrl_i == 15)begin //MUL
		result_o <= src1_i * src2_i; cjr<=0;
	end
	else if(ctrl_i == 16)begin //JUMP
		cjr<=0; result_o<= src1_i + src2_i;
	end
	else if(ctrl_i == 17)begin //BGT
		cjr<=0; result_o<=src1_i-src2_i;
	end
	else if(ctrl_i == 18)begin //BNEZ
		cjr<=0; result_o<=src1_i;
	end
	else if(ctrl_i == 19)begin //BGEZ
		cjr<=0; result_o<=src1_i;
	end
	else if(ctrl_i == 20)begin //JAL
		cjr<=0; result_o<=result_o;
	end
	else if(ctrl_i == 21)begin //JR
		cjr<=1; result_o<=0;
	end
	else result_o <= result_o;
end
endmodule





                    
                    