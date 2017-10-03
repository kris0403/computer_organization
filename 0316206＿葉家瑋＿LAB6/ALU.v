//Subject:     CO project 1 - ALU
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
	rst_n,
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input rst_n;
input signed [32-1:0]  src1_i;
input signed [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter

assign zero_o=(result_o==0)? 1: 0;

//Main function
/*your code here*/
always@(*)begin
	if(rst_n==0)begin
		result_o<=32'd0;
	end
	else if(ctrl_i==4'b0000)begin //and
		result_o<=src1_i&src2_i;
	end
	else if(ctrl_i==4'b0011)begin //mult
		result_o<=src1_i*src2_i;
	end
	else if(ctrl_i==4'b0010)begin //add
		result_o<=src1_i+src2_i;
	end
	else if(ctrl_i==4'b0001)begin //or
		result_o<=src1_i|src2_i;
	end
	else if(ctrl_i==4'b0110)begin //sub
		result_o<=src1_i-src2_i;
	end
	else if(ctrl_i==4'b1111)begin //slti
		if(src1_i<src2_i)result_o<=32'd1;
		else result_o<=32'd0;	
	end
	else if(ctrl_i==4'b0111)begin //slt
		if(src1_i<src2_i)result_o<=32'd1;
		else result_o<=32'd0;
	end
	else if(ctrl_i==4'b0010)begin //lw //sw
		result_o<=src1_i+src2_i;
	end
	else if(ctrl_i==4'b1010)begin //addi
		result_o<=src1_i+src2_i;
	end
	else if(ctrl_i==4'b1110)begin //beq
		result_o<=src1_i-src2_i;
	end
	else begin
		result_o <= result_o;
	end
end

endmodule

