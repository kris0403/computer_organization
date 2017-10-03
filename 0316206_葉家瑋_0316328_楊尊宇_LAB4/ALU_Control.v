//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Control(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [4-1:0] ALUOp_i;

output     [5-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [5-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always @(*)begin
	if(ALUOp_i == 0)begin//R-type
		if(funct_i == 32)ALUCtrl_o <= 0;//add
		else if(funct_i == 34)ALUCtrl_o <= 2;//sub
		else if(funct_i == 36)ALUCtrl_o <= 3;//and
		else if(funct_i == 37)ALUCtrl_o <= 4;//or
		else if(funct_i == 42)ALUCtrl_o <= 5;//slt
		else if(funct_i == 0)ALUCtrl_o <= 8;//sll
		else if(funct_i == 6)ALUCtrl_o <= 9;//srlv
		else if(funct_i == 6'b011000)ALUCtrl_o <= 15;//mul
		else if(funct_i == 6'b001000)ALUCtrl_o <= 21;//jr
	end
	else if(ALUOp_i == 1)begin//addi
		ALUCtrl_o <= 1;
	end
	else if(ALUOp_i == 7)begin//lw
		ALUCtrl_o <= 13;
	end
	else if(ALUOp_i == 8)begin//sw
		ALUCtrl_o <= 14;
	end
end
endmodule     





                    
                    