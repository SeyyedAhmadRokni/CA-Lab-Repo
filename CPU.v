module CPU(input clk, rst);

    wire[31:0] 
		// IF IFR ID
		IF_IFR_PC, IFR_ID_PC, 
		IF_IFR_Instruction, IFR_ID_Instruction,
		IFR_ID_MEM_W,
		// ID IDR EX
		ID_IDR_PC, IDR_EX_PC,  
		ID_IDR_Val_Rn, IDR_EX_Val_Rn, 
		ID_IDR_Val_Rm, IDR_EX_Val_Rm, 
		// WB ID
		WB_ID_WB_Value;


	wire[3:0]
		WB_ID_WB_Dest, 
		IDR_STAT, EX_STAT, STATUS_Out,
		ID_IDR_Dest, IDR_EX_Dest, 
		ID_IDR_src1, ID_IDR_src2,  
		IDR_EX_src1, IDR_EX_src2,  
		ID_IDR_EXE_CMD, IDR_EX_EXE_CMD,
		ID_HZ_RegSrc2, ID_HZ_Rn;

	wire[11:0]
		ID_IDR_ShiftOperand, IDR_EX_ShiftOperand;

	wire[23:0]
		ID_IDR_Imm24, IDR_EX_Imm24;

	wire
		ID_IDR_WB_EN, IDR_EX_WB_EN, 
		ID_IDR_MEM_R_EN, IDR_EX_MEM_R_EN, 
		ID_IDR_MEM_W_EN, IDR_EX_MEM_W_EN, 
		ID_IDR_B, BranchTaken, 
		ID_IDR_S, IDR_EX_S,
		WB_ID_WB_EN, 
		ID_IDR_I, IDR_EX_I,
		HazardOut,ID_HZ_TwoSrc,
		SC_READY; 

		assign STATUS_Out = 4'b0;
		assign WB_ID_WB_Dest = 4'b0;
		assign WB_ID_WB_Value = 31'b0;
		assign WB_ID_WB_EN = 1'b0;
		assign HazardOut = 1'b0;

	ID_Stage instDecode(
		.clk(clk),                             .rst(rst),                  
		.instructionIn(IFR_ID_Instruction),    .WB_ENIn(WB_ID_WB_EN),                 
		.WB_DestIn(WB_ID_WB_Dest),             .WB_ValueIn(WB_ID_WB_Value),           
		.HazardIn(HazardOut),      			   .PCIn(IFR_ID_PC),                      
		.statusIn(STATUS_Out),                   .PCOut(ID_IDR_PC),                     
		.Val_RnOut(ID_IDR_Val_Rn),             .Val_RmOut(ID_IDR_Val_Rm),             
		.TwoSrcOut(ID_HZ_TwoSrc),              .SOut(ID_IDR_S),               
		.BOut(ID_IDR_B),                       .EXE_CMDOut(ID_IDR_EXE_CMD), 
		.MEM_W_ENOut(ID_IDR_MEM_W_EN),         .MEM_R_ENOut(ID_IDR_MEM_R_EN),      
		.WB_ENOut(ID_IDR_WB_EN),               .DestOut(ID_IDR_Dest),         
		.IOut(ID_IDR_I),                       .regFileInp2Out(ID_HZ_RegSrc2),
		.RnOut(ID_HZ_Rn),					   .Imm24Out(ID_IDR_Imm24),
		.src1Out(ID_IDR_src1), 				   .src2Out(ID_IDR_src2),
		.shiftOperandOut(ID_IDR_ShiftOperand)
	);

	ID_Stage_Reg instDecodeReg(
		.clk(clk), .rst(rst),                 .en(SC_READY), .clr(BranchTaken),
		.PCIn(ID_IDR_PC), 			          .PCOut(IDR_EX_PC),
		.WB_ENIn(ID_IDR_WB_EN), 	          .WB_ENOut(IDR_EX_WB_EN), 
		.MEM_R_ENIn(ID_IDR_MEM_R_EN),         .MEM_R_ENOut(IDR_EX_MEM_R_EN), 
		.MEM_W_ENIn(ID_IDR_MEM_W_EN),         .MEM_W_ENOut(IDR_EX_MEM_W_EN),
		.EXE_CMDIn(ID_IDR_EXE_CMD),           .EXE_CMDOut(IDR_EX_EXE_CMD), 
		.BIn(ID_IDR_B), 	      	          .BOut(BranchTaken),
		.SIn(ID_IDR_S), 	      	          .SOut(IDR_EX_S),
		.Val_RmIn(ID_IDR_Val_Rm), 	          .Val_RmOut(IDR_EX_Val_Rm),
		.Val_RnIn(ID_IDR_Val_Rn), 	          .Val_RnOut(IDR_EX_Val_Rn),
		.shiftOperandIn(ID_IDR_ShiftOperand), .shiftOperandOut(IDR_EX_ShiftOperand), 
		.IIn(ID_IDR_I),                       .IOut(IDR_EX_I),      
		.Imm24In(ID_IDR_Imm24),               .Imm24Out(IDR_EX_Imm24), 
		.DestIn(ID_IDR_Dest),                 .DestOut(IDR_EX_Dest), 
		.statusIn(STATUS_Out),                  .statusOut(IDR_STAT),
		.src1In(ID_IDR_src1),   		      .src1Out(IDR_EX_src1),
		.src2In(ID_IDR_src2),   		      .src2Out(IDR_EX_src2)
	);

endmodule