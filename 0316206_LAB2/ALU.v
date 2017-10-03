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
input  [4-1:0]   ctrl_i;
input [4:0] shamt;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

assign zero_o = (result_o == 0);
//Parameter

//Main function
always @(*)begin
	case (ctrl_i)
		4'b0000 : result_o <= src1_i + src2_i;//add
		4'b0001 : result_o <= src1_i + src2_i;//addi
		4'b0010 : result_o <= src1_i - src2_i;//sub
		4'b0011 : result_o <= (src1_i & src2_i);//and
		4'b0100 : result_o <= (src1_i | src2_i);//or
		4'b0101 : begin//slt
			if(src1_i < src2_i)result_o <= 1;
			else result_o <= 0;
		end
		4'b0110 : begin//slti
			if(src1_i < src2_i)result_o <= 1;
			else result_o <= 0;
		end
		4'b0111 : begin//beq
			result_o <= src1_i - src2_i;//have problem	
		end
		4'b1000 : begin//sll
			result_o <= (src2_i<<shamt);
		end
		4'b1001 : begin//srlv
			result_o <= (src2_i>>src1_i);
		end
		4'b1010 : begin//lui
			result_o[31:16] <= src2_i[15:0];
			result_o[15:0] <= 0;
		end
		4'b1011 : begin//ori
			result_o <= src1_i|{{16{0}},src2_i[15:0]};
		end
		4'b1100 : begin//bne
			if(src1_i-src2_i == 0)result_o  <= 1;
			else result_o  <= 0;
		end
		default : result_o <= result_o;
	endcase
end
endmodule





                    
                    