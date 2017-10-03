module hazard(
            id_rs,
			   id_rt,
			   ex_rt,
				select,
			   exmem_read,
			   pcwrite,
			   ifid_write,
			   mux_control,
			   flush,
			   EX_flush
               );

parameter size = 0;			   
			
//I/O ports  
input   select;             
input   [4:0] id_rs;          
input   [4:0] id_rt; 
input   [4:0] ex_rt; 
input   exmem_read;
output reg pcwrite;
output reg ifid_write;
output reg mux_control; 
output reg flush;
output reg EX_flush;

//Main function
always@(*)begin
	if(select)begin
		mux_control <=1'b0;
		flush <=1'b0;
		pcwrite <=1'b1;
		ifid_write <=1'b1;
		EX_flush <=1'b0;
	end
	else if(((ex_rt==id_rs)||(ex_rt==id_rt))&&exmem_read)begin//stall
		mux_control <=1'b0;
		pcwrite <=1'b0;
		ifid_write <=1'b0;
		flush <=1'b1;
		EX_flush <=1'b1;		
	end
	else begin
		mux_control <=1'b1;
		pcwrite <=1'b1;
		ifid_write <=1'b1;
		flush <=1'b1;
		EX_flush <=1'b1;
	end
end
endmodule
