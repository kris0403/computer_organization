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
input  [32-1:0]  src1_i;
input  [32-1:0]  src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]  result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter
assign zero_o = (result_o==0); 
//Main function
/*your code here*/
always@(*)begin
	if(!rst_n)begin
		result_o<=0;
	end
	else begin
		case(ctrl_i)
			4'b0000:begin
				result_o<=(src1_i&src2_i);
			end
			4'b0001:begin
				result_o<=(src1_i|src2_i);
			end
			4'b0010:begin
				result_o<=(src1_i+src2_i);
			end
			4'b0110:begin
				result_o<=(src1_i-src2_i);
			end
			4'b1100:begin
				result_o<=!(src1_i|src2_i);
			end
			4'b1101: begin 
				result_o<=!(src1_i&src2_i);
			end
			4'b0111:begin
			  if(src1_i<src2_i)result_o<=1;
			  else result_o<=0;
			end
			4'b1000:begin
			  if(src1_i>src2_i)result_o<=1;
			  else result_o<=0;
			end
			4'b1001:begin
			  if(src1_i<=src2_i)result_o<=1;
			  else result_o<=0;
			end
			4'b1010:begin
			  if(src1_i>=src2_i)result_o<=1;
			  else result_o<=0;
			end
			4'b1011:begin
			  if(src1_i==src2_i)result_o<=1;
			  else result_o<=0;
			end
			4'b1110:begin
			  if(src1_i!=src2_i)result_o<=1;
			  else result_o<=0;
			end
			4'b0011: result_o<=(src1_i*src2_i);
			4'b0100: result_o<=1;
			4'b0100: begin
				if(src1_i==0)result_o<=1;
				else result_o<=0;
			end
			default: begin
				result_o<=result_o;
			end
		endcase
	end
end	

endmodule

