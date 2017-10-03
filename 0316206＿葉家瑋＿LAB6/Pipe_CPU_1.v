//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
module Pipe_CPU_1(
      clk_i,
		rst_n,
		instr_o,
		memory_o,
		pc_in_o,
		mem_e
		);   
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_n;
input [31:0] instr_o;
input	[31:0] memory_o;
output [31:0] pc_in_o;
output [106:0] mem_e;
/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [31:0] pc_in_i,pc_in_o;
wire [4:0] mux11;
wire [31:0] sum_o;
wire [31:0] instr_o;
wire pcwrite;

/**** ID stage ****/
wire [63:0] ifid;
wire [31:0] src1,src2;
wire [31:0] RSdata_o,RTdata_o,sign_extend;
wire [2:0] ALU_op_o;
wire 	memwrite,memread,Branch_o,flush,exflush,ifidwrite,RegDst_o,memtoreg,RegWrite_o,ALUSrc_o;

/**** EX stage ****/
wire [152:0] idex;
wire [31:0] new_src2;
wire [31:0] ALU_result;
wire [31:0] shift_left_two;
wire [31:0] pc_sum;
wire [4:0] mux2_result;
wire [3:0] ALUCtrl_o;
wire zero_o,mux_control;

/**** MEM stage ****/
wire [106:0] mem_e;
wire [31:0] memory_o;

/**** WB stage ****/
wire [70:0] memwb;
wire [31:0] wb_rd;
wire [9:0] main_control;
wire [1:0] forward_a,forward_b;


wire [31:0] const_four;
assign const_four = 4;
			

wire [4:0] const_zero;
assign const_zero = 0;

/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux4(
		.data0_i(sum_o),
      .data1_i(mem_e[101:70]),
      .select_i(mem_e[69]&mem_e[104]),
      .data_o(pc_in_i)
        );
		  
ProgramCounter PC(
	.clk_i(clk_i),      
	.rst_i (rst_n), 
	.pcwrite(pcwrite),
	.pc_in_i(pc_in_i) ,   
	.pc_out_o(pc_in_o) 
        );//check
		  
hazard ha(
            .id_rs(ifid[25:21]),
			   .id_rt(ifid[20:16]),
			   .ex_rt(idex[9:5]),
				.select(mem_e[69]&mem_e[104]),
			   .exmem_read(idex[149]),
			   .pcwrite(pcwrite),
			   .ifid_write(ifidwrite),
			   .mux_control(mux_control),
				.flush(flush),
			   .EX_flush(exflush)
         );
			

Adder Add_pc(
       .src1_i(pc_in_o),     
	    .src2_i(const_four),     
	    .sum_o(sum_o)   
		);
		   
IF_ID IF(       //N is the total length of input/output
			.flush(flush),
			.ifidwrite(ifidwrite),
         .rst_i(rst_n),
			.clk_i(clk_i),   
			.data_i({sum_o,instr_o}),
			.data_o(ifid)
		);
		
//Instantiate the components in ID stage
Reg_File RF(
		.clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(ifid[25:21]),  
        .RTaddr_i(ifid[20:16]),  
        .RDaddr_i(memwb[4:0]), 
        .RDdata_i(wb_rd), 
        .RegWrite_i (memwb[70]),///----------------------
        .RSdata_o(RSdata_o),  
        .RTdata_o(RTdata_o)  
		);
		
Sign_Extend Sign_Extend(
		.data_i(ifid[15:0]),
      .data_o(sign_extend)
		);

Decoder Control(
		.instr_op_i(ifid[31:26]), 
	    .RegWrite_o(RegWrite_o), 
	    .ALU_op_o(ALU_op_o),   
	    .ALUSrc_o(ALUSrc_o),   
	    .RegDst_o(RegDst_o),   
		.Branch_o(Branch_o),	
		.memtoreg(memtoreg),
		.memread(memread),
		.memwrite(memwrite)	
		);

MUX_2to1 #(.size(10)) Mux7(
		.data0_i(10'd0),
        .data1_i({RegWrite_o,memtoreg,Branch_o,memread,memwrite,RegDst_o,ALU_op_o,ALUSrc_o}),
        .select_i(mux_control),
        .data_o(main_control)
        );


Pipe_Reg #(.size(153)) ID_EX(
			.rst_i(rst_n),
			.clk_i(clk_i),   
			.data_i({main_control,ifid[63:32],RSdata_o,RTdata_o,sign_extend,ifid[25:21],ifid[20:16],ifid[15:11]}),
			.data_o(idex)
		);

MUX_3to1 #(.size(32))Mux5(
               .data0_i(idex[110:79]),
               .data1_i(wb_rd),
					.data2_i(mem_e[68:37]),//----------
               .select_i(forward_a),
               .data_o(src1)
      );

MUX_3to1 #(.size(32)) Mux6(
               .data0_i(idex[78:47]),
               .data1_i(wb_rd),
					.data2_i(mem_e[68:37]),//--------------
               .select_i(forward_b),
               .data_o(src2)
               );	
					
MUX_2to1 #(.size(32)) Mux1(
		  .data0_i(src2),
        .data1_i(idex[46:15]),
        .select_i(idex[143]),
        .data_o(new_src2)
        );					
	   
		
//Instantiate the components in EX stage	   
ALU ALU(
		.rst_n(rst_n),
		.src1_i(src1),
	   .src2_i(new_src2),
	   .ctrl_i(ALUCtrl_o),
	   .result_o(ALU_result),
		.zero_o(zero_o)
		);
		
ALU_Ctrl ALU_Control(
		  .funct_i(idex[20:15]),  
        .ALUOp_i(idex[146:144]),   
        .ALUCtrl_o(ALUCtrl_o)
		);
		
Adder Adder2(
        .src1_i(idex[142:111]),     
	    .src2_i(shift_left_two),     
	    .sum_o(pc_sum)      
	    );		

Shift_Left_Two_32 Shifter1(
        .data_i(idex[46:15]),
        .data_o(shift_left_two)
        ); 

forward FA(
         .MemRd(mem_e[4:0]),
			.WbRd(memwb[4:0]),
			.ExeRs(idex[14:10]),
			.ExeRt(idex[9:5]),
			.MemWb(mem_e[106]),
			.Wb(memwb[70]),
			.forward_a(forward_a),
			.forward_b(forward_b)
         );
			
MUX_2to1 #(.size(5)) Mux2(
		  .data0_i(idex[9:5]),
        .data1_i(idex[4:0]),
        .select_i(idex[147]),
        .data_o(mux2_result)
        );



MUX_2to1 #(.size(5)) Mux9(
		  .data0_i(const_zero),
        .data1_i(idex[152:148]),
        .select_i(exflush),
        .data_o(mux11)
        );	
Pipe_Reg #(.size(107)) EX_MEM(
			.rst_i(rst_n),
			.clk_i(clk_i),   
			.data_i({mux11,pc_sum,zero_o,ALU_result,src2,mux2_result}),
			.data_o(mem_e)
		);
			   
//Instantiate the components in MEM stage


Pipe_Reg #(.size(71)) MEM_WB(
			.rst_i(rst_n),
			.clk_i(clk_i),   
			.data_i({mem_e[106:105],memory_o,mem_e[68:37],mem_e[4:0]}),
			.data_o(memwb)
		);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
		  .data0_i(memwb[36:5]),
        .data1_i(memwb[68:37]),
        .select_i(memwb[69:69]),
        .data_o(wb_rd)
        );

/****************************************
signal assignment
****************************************/	
endmodule

