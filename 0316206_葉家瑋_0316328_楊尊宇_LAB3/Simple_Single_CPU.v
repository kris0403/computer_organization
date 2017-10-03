//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [31:0] pc_in,pc_out;
wire [31:0] four;
assign four = 32'd4;
wire [31:0] pc_sum_four;
wire [31:0] instruct;
wire regdst;
wire [4:0] write_reg;
wire regwrite;
wire [31:0] reg_rs,reg_rt;
wire alusrc,branch;
wire [3:0] aluop;
wire [4:0] alucontrol;
wire [31:0] instruct_extend;
wire [31:0] reg_select;
wire [31:0] aluresult;
wire [31:0] instruct_shift;
wire zero;
wire memtoreg;
wire memread,memwrite;
wire [31:0] readdata,writedata;
wire [31:0] add_shift_pc;
wire cjr,branchtype,jump,cjal;
wire [31:0] jumpaddress;
assign jumpaddress = {pc_sum_four[31:28],instruct[25:0],2'b00};
wire [31:0] jump_mux;
wire [4:0] assignreg;
assign assignreg = 5'd31;
wire [4:0] write_reg_first;
wire [31:0] writedata_first;
wire [31:0] branch_and_mux4;
//Greate componentes
Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(aluresult),
	.data_i(reg_rt),
	.MemRead_i(memread),
	.MemWrite_i(memwrite),
	.data_o(readdata)
	);
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(pc_out),     
	    .src2_i(four),     
	    .sum_o(pc_sum_four)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instruct)    
	    );	  

		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instruct[25:21]) ,  
        .RTaddr_i(instruct[20:16]) ,  
        .RDaddr_i(write_reg) ,  
        .RDdata_i(writedata)  , 
        .RegWrite_i (regwrite),
        .RSdata_o(reg_rs) ,  
        .RTdata_o(reg_rt)   
        );


Decoder Decoder(
        .instr_op_i(instruct[31:26]), 
	    .RegWrite_o(regwrite), 
	    .ALU_op_o(aluop),   
	    .ALUSrc_o(alusrc),   
	    .RegDst_o(regdst),   
		.Branch_o(branch) ,
		.MemToReg_o(memtoreg),
		.Branchtype(branchtype),
		.Jump(jump),
		.MemRead(memread),
		.MemWrite(memwrite),
		.cjal(cjal)
	    );

ALU_Ctrl AC(
        .funct_i(instruct[5:0]),   
        .ALUOp_i(aluop),   
        .ALUCtrl_o(alucontrol) 
        );
	
Sign_Extend SE(
        .data_i(instruct[15:0]),
        .data_o(instruct_extend)
        );

	
		
ALU ALU(
        .src1_i(reg_rs),
	    .src2_i(reg_select),
	    .ctrl_i(alucontrol),
	    .result_o(aluresult),
		.zero_o(zero),
		.shamt(instruct[10:6]),
		.cjr(cjr)
	    );
		
Adder Adder2(
        .src1_i(pc_sum_four),     
	    .src2_i(instruct_shift),     
	   .sum_o(add_shift_pc)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(instruct_extend),
        .data_o(instruct_shift)
        ); 		
MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instruct[20:16]),
        .data1_i(instruct[15:11]),
        .select_i(regdst),
        .data_o(write_reg_first)
        );	
		  

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(reg_rt),
        .data1_i(instruct_extend),
        .select_i(alusrc),
        .data_o(reg_select)
        );
	
MUX_2to1 #(.size(32)) Mux_Jump(
        .data0_i(branch_and_mux4),
        .data1_i(jumpaddress),
        .select_i(jump),
        .data_o(jump_mux)
        );	
MUX_2to1 #(.size(5)) Mux_cjal_1(
        .data0_i(write_reg_first),
        .data1_i(assignreg),
        .select_i(cjal),
        .data_o(write_reg)
        );	
MUX_2to1 #(.size(32)) Mux_cjal_2(
        .data0_i(writedata_first),
        .data1_i(pc_sum_four),
        .select_i(cjal),
        .data_o(writedata)
        );		
MUX_2to1 #(.size(32)) Mux_CJR(
        .data0_i(jump_mux),
        .data1_i(reg_rs),
        .select_i(cjr),
        .data_o(pc_in)
        );	
		  
wire temp;
		  
MUX_2to1 #(.size(32)) Mux_Branch_and_mux4(
        .data0_i(pc_sum_four),
        .data1_i(add_shift_pc),
        .select_i(branch&temp),
        .data_o(branch_and_mux4)
        );			  
MUX_4to1 #(.size(1)) Mux_Branchtype(
        .data0_i(zero),
        .data1_i(!(aluresult[31]|zero)),
		  .data2_i(!aluresult[31]),
		  .data3_i(!zero),
        .select_i(branchtype),
        .data_o(temp)
        );	

MUX_3to1 #(.size(32)) Mux_Data_Memory(
        .data0_i(aluresult),
        .data1_i(readdata),
		  .data2_i(instruct_extend),
        .select_i(memtoreg),
        .data_o(writedata_first)
        );	

endmodule
		  


