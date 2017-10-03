`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:31:32 08/18/2010 
// Design Name: 
// Module Name:    Data_Memory 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Data_Memory
(
	clk_i,
	addr_1,
	data_1,
	MemRead_1,
	MemWrite_1,
	data_o1,
	addr_2,
	data_2,
	MemRead_2,
	MemWrite_2,
	data_o2
);

input				clk_i;
input	[31:0]	addr_1;
input	[31:0]	data_1;
input	[31:0]	addr_2;
input	[31:0]	data_2;
input				MemRead_1;
input				MemWrite_1;
input				MemRead_2;
input				MemWrite_2;
output reg [31:0] data_o1;
output reg [31:0] data_o2;
reg flag1,flag2,flag3,flag4;
reg	[7:0]	Mem [0:127];
integer	i;

// For Testbench to debug
wire	[31:0]		memory			[0:31];
assign  memory[0] = {Mem[3], Mem[2], Mem[1], Mem[0]};
assign  memory[1] = {Mem[7], Mem[6], Mem[5], Mem[4]};
assign  memory[2] = {Mem[11], Mem[10], Mem[9], Mem[8]};
assign  memory[3] = {Mem[15], Mem[14], Mem[13], Mem[12]};
assign  memory[4] = {Mem[19], Mem[18], Mem[17], Mem[16]};
assign  memory[5] = {Mem[23], Mem[22], Mem[21], Mem[20]};
assign  memory[6] = {Mem[27], Mem[26], Mem[25], Mem[24]};
assign  memory[7] = {Mem[31], Mem[30], Mem[29], Mem[28]};
assign  memory[8] = {Mem[35], Mem[34], Mem[33], Mem[32]};
assign  memory[9] = {Mem[39], Mem[38], Mem[37], Mem[36]};
assign  memory[10] = {Mem[43], Mem[42], Mem[41], Mem[40]};
assign  memory[11] = {Mem[47], Mem[46], Mem[45], Mem[44]};
assign  memory[12] = {Mem[51], Mem[50], Mem[49], Mem[48]};
assign  memory[13] = {Mem[55], Mem[54], Mem[53], Mem[52]};
assign  memory[14] = {Mem[59], Mem[58], Mem[57], Mem[56]};
assign  memory[15] = {Mem[63], Mem[62], Mem[61], Mem[60]};
assign  memory[16] = {Mem[67], Mem[66], Mem[65], Mem[64]};
assign  memory[17] = {Mem[71], Mem[70], Mem[69], Mem[68]};
assign  memory[18] = {Mem[75], Mem[74], Mem[73], Mem[72]};
assign  memory[19] = {Mem[79], Mem[78], Mem[77], Mem[76]};
assign  memory[20] = {Mem[83], Mem[82], Mem[81], Mem[80]};
assign  memory[21] = {Mem[87], Mem[86], Mem[85], Mem[84]};
assign  memory[22] = {Mem[91], Mem[90], Mem[89], Mem[88]};
assign  memory[23] = {Mem[95], Mem[94], Mem[93], Mem[92]};
assign  memory[24] = {Mem[99], Mem[98], Mem[97], Mem[96]};
assign  memory[25] = {Mem[103], Mem[102], Mem[101], Mem[100]};
assign  memory[26] = {Mem[107], Mem[106], Mem[105], Mem[104]};
assign  memory[27] = {Mem[111], Mem[110], Mem[109], Mem[108]};
assign  memory[28] = {Mem[115], Mem[114], Mem[113], Mem[112]};
assign  memory[29] = {Mem[119], Mem[118], Mem[117], Mem[116]};
assign  memory[30] = {Mem[123], Mem[122], Mem[121], Mem[120]};
assign  memory[31] = {Mem[127], Mem[126], Mem[125], Mem[124]};

initial begin
	for(i=0; i<128; i=i+1)
		Mem[i] = 8'b0;
	/*initial your data memory here*/
		Mem[0] = 8'b00000011;
		Mem[4] = 8'b00000001;
		Mem[8] = 8'b10011000;
		Mem[9] = 8'b11110111;
		Mem[10] = 8'b11110110;
		Mem[11] = 8'b11101110;
		Mem[12] = 8'b00000110;
		Mem[16] = 8'b11101110;
		Mem[17] = 8'b11111010;
		Mem[18] = 8'b11111110;
		Mem[19] = 8'b11101110;
		Mem[20] = 8'b00101110;
		Mem[24] = 8'b00111111;
		Mem[28] = 8'b00000101;
		Mem[32] = 8'b00010001;
		Mem[36] = 8'b00001010;
		Mem[40] = 8'b00000001;
		Mem[44] = 8'b11011110;
		Mem[45] = 8'b11110010;
		Mem[46] = 8'b00001110;
		Mem[47] = 8'b10101010;
		Mem[48] = 8'b00011000;
		Mem[52] = 8'b11111111;
		Mem[53] = 8'b11110100;
		Mem[54] = 8'b10110100;
		Mem[55] = 8'b11101111;
		Mem[56] = 8'b10011111;
end 

always@(addr_1 or MemRead_1) begin
	if(MemRead_1) begin
		data_o1 = {Mem[addr_1+3], Mem[addr_1+2], Mem[addr_1+1], Mem[addr_1]};
	end
	else begin
		flag1<=flag1;
	end	
end

always@(posedge clk_i) begin
    if(MemWrite_1) begin
		Mem[addr_1]   <= data_1[7:0];
		Mem[addr_1+1] <= data_1[15:8];
		Mem[addr_1+2] <= data_1[23:16];
		Mem[addr_1+3] <= data_1[31:24];
	end
	else begin
		flag2<=flag2;
	end
end


always@(addr_2 or MemRead_2) begin
	if(MemRead_2) begin
		data_o2 = {Mem[addr_2+3], Mem[addr_2+2], Mem[addr_2+1], Mem[addr_2]};
	end
	else begin
		flag4<=flag4;
	end
end

always@(posedge clk_i) begin
    if(MemWrite_2) begin
		Mem[addr_2]   <= data_2[7:0];
		Mem[addr_2+1] <= data_2[15:8];
		Mem[addr_2+2] <= data_2[23:16];
		Mem[addr_2+3] <= data_2[31:24];
	end
	else begin
		flag3<=flag3;
	end 
end



endmodule

