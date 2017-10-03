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
wire [154:0] id_ex_instruct;


wire if_flush,ex_flush,id_flush;
wire [10:0] control_output;
wire pc_write;
wire ifid_write;
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
wire [31:0] alu_input_a,alu_input_b;
wire [1:0] result_mux6;
wire [2:0] result_mux7;

//control signal


/**** MEM stage ****/
assign pcsrc = (ex_mem_instruct[104] & ex_mem_instruct[69]);
wire [31:0] data_mem_out;
wire [70:0] mem_wb_instruct;
wire [1:0] forward_a,forward_b;
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
	.select(pc_write),
	.pc_in_i(pc_in),
	.pc_out_o(pc_out)
        );
MUX_2to1 #(.size(32)) MuxPC(
		.data0_i(pc_add_four),
      .data1_i(ex_mem_instruct[101:70]),
      .select_i(pcsrc),
      .data_o(pc_in)	
        );


//Instruction_Memory IM(
instruction_file IM(
	.addr_i(pc_out),
	.instr_o(pc_out_mem)
	    );
			
Adder Add_pc(
	.src1_i(pc_out),
	.src2_i(four),
	.sum_o(pc_add_four)
		);

		
Pipe_Reg_special #(.size(64)) IF_ID(       //N is the total length of input/output
			.rst_n(rst_n),
			.clk_i(clk_i), 
			.select(ifid_write),
			.data_i({pc_add_four,pc_out_mem}),
			.data_o(instruct)
		);
wire [4:0] wbaddress;
assign wbaddress = mem_wb_instruct[4:0];
//Instantiate the components in ID stage
Reg_File RF(
	 .clk_i(clk_i),
	 .rst_n(rst_n),
    .RSaddr_i(instruct[25:21]),
    .RTaddr_i(instruct[20:16]),
    .RDaddr_i(wbaddress),
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

MUX_2to1 #(.size(11)) Mux8(
		.data0_i({regwrite,memtoreg,branch,memread,memwrite,regdst,aluop,alusrc}),
      .data1_i(11'b00000000000),
      .select_i(id_flush),
      .data_o(control_output)	
        );


Hazard_detection_unit ha(
	.pc_src(pcsrc),
	.input_memread(id_ex_instruct[146]),
	.input_idex(id_ex_instruct[10:6]),
	.input_rs(instruct[25:21]),
	.input_rt(instruct[20:16]),
	.IF_flush(if_flush),
	.EX_flush(ex_flush),
	.ID_flush(id_flush),
	.PC_write(pc_write),
	.IFID_write(ifid_write)
	);

Sign_Extend Sign_Extend(
	 .data_i(instruct[15:0]),
    .data_o(instruct_ex)
		);	

Pipe_Reg #(.size(155)) ID_EX(
			.rst_n(rst_n),
			.clk_i(clk_i), 
			.data_i({instruct[25:21],control_output,instruct[63:32],rs_data,rt_data,instruct_ex,instruct[20:16],instruct[15:11],if_flush}),
			.data_o(id_ex_instruct)
		);
		
//Instantiate the components in EX stage	   
Adder ex_Add(
	.src1_i(id_ex_instruct[138:107]),
	.src2_i(id_ex_instruct_shift_left_2),
	.sum_o(id_ex_instruct_sum)
		);

Shift_Left_Two_32  s_l_2(
    .data_i(id_ex_instruct[42:11]),
    .data_o(id_ex_instruct_shift_left_2)
    );


ALU ALU(
	.src1_i(alu_input_a),
	.src2_i(src2_i),
	.ctrl_i(alucontrol),
	.result_o(aluresult),
	.zero_o(zero),
	.shamt(id_ex_instruct[21:17])
		);
		
ALU_Control ALU_Control(
	.funct_i(id_ex_instruct[16:11]),
   .ALUOp_i(id_ex_instruct[143:140]),
   .ALUCtrl_o(alucontrol)
		);

MUX_2to1 #(.size(32)) Mux1(
		.data0_i(alu_input_b),
      .data1_i(id_ex_instruct[42:11]),
      .select_i(id_ex_instruct[139]),
      .data_o(src2_i)	
        );
		
MUX_2to1 #(.size(5)) Mux2(
	.data0_i(id_ex_instruct[10:6]),
   .data1_i(id_ex_instruct[5:1]),
   .select_i(id_ex_instruct[144]),
   .data_o(ex_rd)	
        );
		  
MUX_2to1 #(.size(2)) Mux6(
	.data0_i(id_ex_instruct[149:148]),
	.data1_i(2'b00),
	.select_i(ex_flush),
	.data_o(result_mux6)
	);
	
MUX_2to1 #(.size(3)) Mux7(
	.data0_i(id_ex_instruct[147:145]),
	.data1_i(3'b000),
	.select_i(ex_flush),
	.data_o(result_mux7)
	);
		  
MUX_3to1 #(.size(32)) Mux4(
	.data0_i(id_ex_instruct[106:75]),
	.data1_i(ex_mem_instruct[68:37]),
	.data2_i(wb_instruct),
	.select_i(forward_a),
	.data_o(alu_input_a)
	);
	
MUX_3to1 #(.size(32)) Mux5(
	.data0_i(id_ex_instruct[74:43]),
	.data1_i(ex_mem_instruct[68:37]),
	.data2_i(wb_instruct),
	.select_i(forward_b),
	.data_o(alu_input_b)
	);

Pipe_Reg #(.size(107)) EX_MEM(
			.rst_n(rst_n),
			.clk_i(clk_i),   
			.data_i({result_mux6,result_mux7,id_ex_instruct_sum,zero,aluresult,alu_input_b,ex_rd}),
			.data_o(ex_mem_instruct)
		);
			   
//Instantiate the components in MEM stage

Forwarding_unit FU(
	.control_mem(ex_mem_instruct[106]),
	.control_wb(mem_wb_instruct[70]),
	.input_mem(ex_mem_instruct[4:0]),
	.input_wb(mem_wb_instruct[4:0]),
	.input_rs(id_ex_instruct[154:150]),
	.input_rt(id_ex_instruct[10:6]),
	.forward_a(forward_a),
	.forward_b(forward_b)
	);

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
		.data0_i(mem_wb_instruct[36:5]),
      .data1_i(mem_wb_instruct[68:37]),
      .select_i(mem_wb_instruct[69]),
      .data_o(wb_instruct)	
        );

/*MUX_3to1 #(.size(32)) Mux3(
	
        );*/

/****************************************
signal assignment
****************************************/	
endmodule

