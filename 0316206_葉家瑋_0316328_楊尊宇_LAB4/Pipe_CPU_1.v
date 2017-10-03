//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
        clk_i,
		rst_n
		);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_n;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [31:0] pc_in,pc_out;
wire pcsrc;
wire [31:0] pc_add_four;
wire [31:0] four;
assign four = 32'd4;
wire [31:0] pc_out_mem;
wire [63:0] instruct;
/**** ID stage ****/
wire regwrite;
wire [31:0] rs_data,rt_data;
wire [3:0] aluop;
wire alusrc,regdst;
wire branch,memtoreg,memread,memwrite;
wire [31:0] instruct_ex;
wire [148:0] id_ex_instruct;

//control signal


/**** EX stage ****/
wire [4:0] alucontrol;
wire [31:0] aluresult;
wire zero;
wire [31:0] src2_i;
wire [4:0] ex_rd;
wire [31:0] id_ex_instruct_shift_left_2;
wire [31:0] id_ex_instruct_sum;
wire [106:0] ex_mem_instruct;


//control signal


/**** MEM stage ****/
assign pcsrc = (ex_mem_instruct[104] & ex_mem_instruct[69]);
wire [31:0] data_mem_out;
wire [70:0] mem_wb_instruct;
//control signal


/**** WB stage ****/
wire [31:0] wb_instruct;
//control signal


/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage
PC PC(
	.clk_i(clk_i),
	.rst_i(rst_n),
	.pc_in_i(pc_in),
	.pc_out_o(pc_out)
        );
MUX_2to1 #(.size(32)) MuxPC(
		.data0_i(pc_add_four),
      .data1_i(ex_mem_instruct[101:70]),
      .select_i(pcsrc),
      .data_o(pc_in)	
        );


Instr_Memory IM(
	.pc_addr_i(pc_out),
	.instr_o(pc_out_mem)
	    );
			
Adder Add_pc(
	.src1_i(pc_out),
	.src2_i(four),
	.sum_o(pc_add_four)
		);

		
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
			.rst_n(rst_n),
			.clk_i(clk_i),   
			.data_i({pc_add_four,pc_out_mem}),
			.data_o(instruct)
		);
		
//Instantiate the components in ID stage
Reg_File RF(
	 .clk_i(clk_i),
	 .rst_n(rst_n),
    .RSaddr_i(instruct[25:21]),
    .RTaddr_i(instruct[20:16]),
    .RDaddr_i(mem_wb_instruct[4:0]),
    .RDdata_i(wb_instruct),
    .RegWrite_i(mem_wb_instruct[70]),
    .RSdata_o(rs_data),
    .RTdata_o(rt_data)
		);

Decoder Control(
	.instr_op_i(instruct[31:26]),
	.RegWrite_o(regwrite),
	.ALU_op_o(aluop),
	.ALUSrc_o(alusrc),
	.RegDst_o(regdst),
	.Branch_o(branch),
	.MemToReg_o(memtoreg),
	.MemRead(memread),
	.MemWrite(memwrite)
		);


Sign_Extend Sign_Extend(
	 .data_i(instruct[15:0]),
    .data_o(instruct_ex)
		);	

Pipe_Reg #(.size(149)) ID_EX(
			.rst_n(rst_n),
			.clk_i(clk_i),   
			.data_i({regwrite,memtoreg,branch,memread,memwrite,regdst,aluop,alusrc,instruct[63:32],rs_data,rt_data,instruct_ex,instruct[20:16],instruct[15:11]}),
			.data_o(id_ex_instruct)
		);
		
//Instantiate the components in EX stage	   
Adder ex_Add(
	.src1_i(id_ex_instruct[137:106]),
	.src2_i(id_ex_instruct_shift_left_2),
	.sum_o(id_ex_instruct_sum)
		);

Shift_Left_Two_32  s_l_2(
    .data_i(id_ex_instruct[41:10]),
    .data_o(id_ex_instruct_shift_left_2)
    );


ALU ALU(
	.src1_i(id_ex_instruct[105:74]),
	.src2_i(src2_i),
	.ctrl_i(alucontrol),
	.result_o(aluresult),
	.zero_o(zero),
	.shamt(id_ex_instruct[20:16])
		);
		
ALU_Control ALU_Control(
	.funct_i(id_ex_instruct[15:10]),
   .ALUOp_i(id_ex_instruct[142:139]),
   .ALUCtrl_o(alucontrol)
		);

MUX_2to1 #(.size(32)) Mux1(
		.data0_i(id_ex_instruct[73:42]),
      .data1_i(id_ex_instruct[41:10]),
      .select_i(id_ex_instruct[138]),
      .data_o(src2_i)	
        );
		
MUX_2to1 #(.size(5)) Mux2(
	.data0_i(id_ex_instruct[9:5]),
   .data1_i(id_ex_instruct[4:0]),
   .select_i(id_ex_instruct[143]),
   .data_o(ex_rd)	
        );

Pipe_Reg #(.size(107)) EX_MEM(
			.rst_n(rst_n),
			.clk_i(clk_i),   
			.data_i({id_ex_instruct[148:144],id_ex_instruct_sum,zero,aluresult,id_ex_instruct[73:42],ex_rd}),
			.data_o(ex_mem_instruct)
		);
			   
//Instantiate the components in MEM stage
Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(ex_mem_instruct[68:37]),
	.data_i(ex_mem_instruct[36:5]),
	.MemRead_i(ex_mem_instruct[103]),
	.MemWrite_i(ex_mem_instruct[102]),
	.data_o(data_mem_out)
	    );

Pipe_Reg #(.size(71)) MEM_WB(
			.rst_n(rst_n),
			.clk_i(clk_i),   
			.data_i({ex_mem_instruct[106:105],data_mem_out,ex_mem_instruct[68:37],ex_mem_instruct[4:0]}),
			.data_o(mem_wb_instruct)
		);

//Instantiate the components in WB stage


MUX_2to1 #(.size(32)) Mux3(
		.data0_i(mem_wb_instruct[68:37]),
      .data1_i(mem_wb_instruct[36:5]),
      .select_i(mem_wb_instruct[69]),
      .data_o(wb_instruct)	
        );

/*MUX_3to1 #(.size(32)) Mux3(
	
        );*/

/****************************************
signal assignment
****************************************/	
endmodule

