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
	shamt
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [5-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

input [4:0] shamt;
//Internal signals
reg    [32-1:0]  result_o;

wire             zero_o;

assign zero_o = (result_o==0)?1:0;
//Parameter

//Main function
always @(*)begin
	if(ctrl_i == 0)begin//add
		result_o <= src1_i + src2_i; 
	end
	else if(ctrl_i == 1)begin//addi
		result_o <= src1_i + src2_i; 
	end
	else if(ctrl_i == 2)begin//sub
		result_o <= src1_i - src2_i; 
	end
	else if(ctrl_i == 3)begin//and
		result_o <= src1_i & src2_i; 
	end
	else if(ctrl_i == 4)begin//or
		result_o <= src1_i | src2_i; 
	end
	else if(ctrl_i == 5)begin//slt
		if(src1_i < src2_i)result_o <= 1;
		else result_o <= 0;
		
	end
	else if(ctrl_i == 13)begin //LW
		result_o <= src1_i + src2_i; 
	end
	else if(ctrl_i == 14)begin //SW
		result_o <= src1_i + src2_i; 
	end
	else result_o <= 0;
end
endmodule





                    
                    