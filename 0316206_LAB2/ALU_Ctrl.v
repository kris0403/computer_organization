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

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always@ (*)begin
	if(ALUOp_i == 2)begin
		if(funct_i == 32)ALUCtrl_o <= 0;//add
		else if(funct_i == 34)ALUCtrl_o <= 2;//sub
		else if(funct_i == 36)ALUCtrl_o <= 3;//and
		else if(funct_i == 37)ALUCtrl_o <= 4;//or
		else if(funct_i == 42)ALUCtrl_o <= 5;//slt
		else if(funct_i == 0)ALUCtrl_o <= 8;//sll
		else if(funct_i == 6)ALUCtrl_o <= 9;//srlv
	end		
	else if(ALUOp_i == 3)ALUCtrl_o <= 1;//addi
	else if(ALUOp_i == 0)ALUCtrl_o <= 6;//slti
	else if(ALUOp_i == 1)ALUCtrl_o <= 7;//beq	
	else if(ALUOp_i == 4)ALUCtrl_o <= 10;//lui
	else if(ALUOp_i == 5)ALUCtrl_o <= 11;//ori
	else if(ALUOp_i == 6)ALUCtrl_o <= 12;//bne
	else ALUCtrl_o <= ALUCtrl_o;
end
endmodule     





                    
                    