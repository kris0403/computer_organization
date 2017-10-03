module forward(
               MemRd,
					WbRd,
					ExeRs,
					ExeRt,
					MemWb,
					Wb,
					forward_a,
					forward_b
               );	   
			
//I/O ports               
input   [4:0] MemRd;       
input   [4:0] ExeRt;
input   [4:0] WbRd;
input   [4:0] ExeRs;
input	MemWb;
input Wb;
output reg [1:0] forward_a; 
output reg [1:0] forward_b;

//Main function
always@(*)begin
	if((MemRd==ExeRs)&&(MemWb)&&(MemRd!=0)) forward_a <=2'b10;
	else if((WbRd==ExeRs)&&(Wb)&&(WbRd!=0)&&!((MemRd==ExeRs)&&(MemWb)&&(MemRd!=0))) forward_a <=2'b01;
	else forward_a <=2'b00;
end

always@(*)begin
	if((MemRd==ExeRt)&&(MemWb)&&(MemRd!=0)) forward_b <=2'b10;
	else if((Wb)&&(WbRd!=0)&&(WbRd==ExeRt)&&!((MemRd==ExeRt)&&(MemWb)&&(MemRd!=0))) forward_b <=2'b01;
	else forward_b <=2'b00;
end

endmodule
