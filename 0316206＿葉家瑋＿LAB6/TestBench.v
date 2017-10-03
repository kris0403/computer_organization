//Subject:     CO project 4 - Test Bench
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns / 1ps
`define CYCLE_TIME 10			

module TestBench;

//Internal Signals
reg         CLK;
reg         RST;
integer     count;
integer     i;
integer     handle;

//Greate tested modle  
/*
$display("Register===========================================================\n");
	$display("r0=%d, r1=%d, r2=%d, r3=%d, r4=%d, r5=%d, r6=%d, r7=%d\n",
	cpu.RF.Reg_File[0], cpu.RF.Reg_File[1], cpu.RF.Reg_File[2], cpu.RF.Reg_File[3], cpu.RF.Reg_File[4], 
	cpu.RF.Reg_File[5], cpu.RF.Reg_File[6], cpu.RF.Reg_File[7],
	);
	$display("r8=%d, r9=%d, r10=%d, r11=%d, r12=%d, r13=%d, r14=%d, r15=%d\n",
	cpu.RF.Reg_File[8], cpu.RF.Reg_File[9], cpu.RF.Reg_File[10], cpu.RF.Reg_File[11], cpu.RF.Reg_File[12], 
	cpu.RF.Reg_File[13], cpu.RF.Reg_File[14], cpu.RF.Reg_File[15],
	);
	$display("r16=%d, r17=%d, r18=%d, r19=%d, r20=%d, r21=%d, r22=%d, r23=%d\n",
	cpu.RF.Reg_File[16], cpu.RF.Reg_File[17], cpu.RF.Reg_File[18], cpu.RF.Reg_File[19], cpu.RF.Reg_File[20], 
	cpu.RF.Reg_File[21], cpu.RF.Reg_File[22], cpu.RF.Reg_File[23],
	);
	$display("r24=%d, r25=%d, r26=%d, r27=%d, r28=%d, r29=%d, r30=%d, r31=%d\n",
	cpu.RF.Reg_File[24], cpu.RF.Reg_File[25], cpu.RF.Reg_File[26], cpu.RF.Reg_File[27], cpu.RF.Reg_File[28], 
	cpu.RF.Reg_File[29], cpu.RF.Reg_File[30], cpu.RF.Reg_File[31],
	);

*/
reg flag=0;
wire [31:0] instruction_a;
wire [31:0] instruction_b;
wire [31:0] datamem_a;
wire [31:0] datamem_b;
wire [31:0] addr_a;
wire [31:0] addr_b;
wire [106:0] memory_o_1;
wire [106:0] memory_o_2;
/*
wire [107-1:0] mem1;
wire [107-1:0] mem2;
wire read;
wire write;
wire [32-1:0] data;
wire [32-1:0] addr;
wire read2;
wire write2;
*/

Data_Memory DM(
		.clk_i(CLK),
		.addr_1(memory_o_1[68:37]),
		.data_1(memory_o_1[36:5]),
		.MemRead_1(memory_o_1[103:103]),
		.MemWrite_1(memory_o_1[102:102]),
		.data_o1(datamem_a),
		.addr_2(memory_o_2[68:37]),
		.data_2(memory_o_2[36:5]),
		.MemRead_2(memory_o_2[103:103]),
		.MemWrite_2(memory_o_2[102:102]),
		.data_o2(datamem_b)
	   );	

Pipe_CPU_1 CPU_a(
      .clk_i(CLK),
		.rst_n(RST),
		.instr_o(instruction_a),
		.memory_o(datamem_a),
		.pc_in_o(addr_a),
		.mem_e(memory_o_1)
		);

Instruction_Memory InstrMem_a(
       .addr_i(addr_a),  
	    .instr_o(instruction_a)   
	    );	
		 
Pipe_CPU_1 CPU_b(
      .clk_i(CLK),
		.rst_n(RST),
		.instr_o(instruction_b),
		.memory_o(datamem_b),
		.pc_in_o(addr_b),//
		.mem_e(memory_o_2)
		);
		
Instruction_Memory2 InstrMem_b(
       .addr_i(addr_b),  
	    .instr_o(instruction_b)   
	    );
		 

	

//Main function

always #(`CYCLE_TIME/2) CLK = ~CLK;	
initial  begin
	$readmemb("LAB6_machine_1.txt", InstrMem_a.instr_file);//LAB6_machine_1.txt
   $readmemb("LAB6_machine_2.txt", InstrMem_b.instr_file);//  LAB6_machine_2.txt
	CLK = 0;
	RST = 0;
	count = 0;
    #(`CYCLE_TIME)      RST = 1;
    #(`CYCLE_TIME*100)      $stop;

end

//used for new
always@(posedge CLK) begin
	count<=count+1;
end

always@(posedge CLK) begin
    //count = count + 1;
	if( count == 35 ) begin 
	//print result to transcript 
	$display("\nMemory===========================================================\n");
	$display("m0=%d, m1=%d, m2=%d, m3=%d, m4=%d, m5=%d, m6=%d, m7=%d\n\nm8=%d, m9=%d, m10=%d, m11=%d, m12=%d, m13=%d, m14=%d, m15=%d\n\nm16=%d, m17=%d, m18=%d, m19=%d, m20=%d, m21=%d, m22=%d, m23=%d\n\nm24=%d, m25=%d, m26=%d, m27=%d, m28=%d, m29=%d, m30=%d, m31=%d",							 
	          DM.memory[0], DM.memory[1], DM.memory[2], DM.memory[3],
				 DM.memory[4], DM.memory[5], DM.memory[6], DM.memory[7],
				 DM.memory[8], DM.memory[9], DM.memory[10], DM.memory[11],
				 DM.memory[12], DM.memory[13], DM.memory[14], DM.memory[15],
				 DM.memory[16], DM.memory[17], DM.memory[18], DM.memory[19],
				 DM.memory[20], DM.memory[21], DM.memory[22], DM.memory[23],
				 DM.memory[24], DM.memory[25], DM.memory[26], DM.memory[27],
				 DM.memory[28], DM.memory[29], DM.memory[30], DM.memory[31]
			  );
	//$display("\nPC=%d\n",cpu.PC.pc_i);
	end
	else flag<=flag;
end
  
endmodule

