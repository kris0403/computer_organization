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
wire [31:0] pc_add_4,instruct;
wire [31:0] const_4;
assign const_4 = 32'd4;
wire RegDst;
wire [4:0] write_reg;
wire [31:0] ALU_result;
wire RegWrite;
wire [31:0] reg_o1,reg_o2;
wire [2:0]ALU_op;//have problem
wire ALUSrc,Branch;
wire [3:0] ALU_control;
wire [31:0] extend_out;
wire [31:0] ALUSrc_select;
wire zero_o;
wire [31:0] shift_left_2;
wire [31:0] adder_2;
wire branch_and_zero;
assign branch_and_zero = (Branch & zero_o);
//Greate componentes


ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(pc_out),     
	    .src2_i(const_4),     
	    .sum_o(pc_add_4)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instruct)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instruct[20:16]),
        .data1_i(instruct[15:11]),
        .select_i(RegDst),
        .data_o(write_reg)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instruct[25:21]) ,  
        .RTaddr_i(instruct[20:16]) ,  
        .RDaddr_i(write_reg) ,  
        .RDdata_i(ALU_result)  , 
        .RegWrite_i (RegWrite),
        .RSdata_o(reg_o1) ,  
        .RTdata_o(reg_o2)   
        );
	
Decoder Decoder(
        .instr_op_i(instruct[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALU_op),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),   
		.Branch_o(Branch)   
	    );

ALU_Ctrl AC(
        .funct_i(instruct[5:0]),   
        .ALUOp_i(ALU_op),   
        .ALUCtrl_o(ALU_control) 
        );
	
Sign_Extend SE(
        .data_i(instruct[15:0]),
        .data_o(extend_out)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(reg_o2),
        .data1_i(extend_out),
        .select_i(ALUSrc),
        .data_o(ALUSrc_select)
        );	
		
ALU ALU(
        .src1_i(reg_o1),
	    .src2_i(ALUSrc_select),
	    .ctrl_i(ALU_control),
	    .result_o(ALU_result),
		.zero_o(zero_o),
	.shamt(instruct[10:6])
	    );
		
Adder Adder2(
        .src1_i(pc_add_4),     
	    .src2_i(shift_left_2),     
	    .sum_o(adder_2)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(extend_out),
        .data_o(shift_left_2)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_add_4),
        .data1_i(adder_2),
        .select_i(branch_and_zero),
        .data_o(pc_in)
        );	

endmodule
		  


