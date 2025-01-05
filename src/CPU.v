module CPU(input clk, rst, forwardENIn,
			output [31:0] PC);

	wire [31:0] 
        // IF, IFR, ID
        IF_IFR_PC, IFR_ID_PC, 
        IF_IFR_Instruction, IFR_ID_Instruction,
        IFR_ID_MEM_W,
        // ID, IDR, EX
        ID_IDR_PC, IDR_EX_PC,  
        ID_IDR_Val_Rn, IDR_EX_Val_Rn, 
        ID_IDR_Val_Rm, IDR_EX_Val_Rm,
        // WB, ID
        WB_ID_WB_Value,
        EXE_EXER_ALU_Res, EXE_EXER_Val_Rm, EXE_IF_branchAddress;

    wire [3:0]
        WB_ID_WB_Dest, 
        IDR_STAT, EX_STAT, STAT_Out,
        ID_IDR_Dest, IDR_EX_Dest, EXE_EXER_Dest, 
        ID_IDR_src1, ID_IDR_src2,  
        IDR_EX_src1, IDR_EX_src2,  
        ID_IDR_EXE_CMD, IDR_EX_EXE_CMD,
        ID_HZ_RegSrc2, ID_HZ_Rn;

    wire [11:0]
        ID_IDR_ShiftOperand, IDR_EX_ShiftOperand;

    wire [23:0]
        ID_IDR_Imm24, IDR_EX_Imm24;

    wire
        ID_IDR_WB_EN, IDR_EX_WB_EN, EXE_EXER_WB_EN, 
        ID_IDR_MEM_R_EN, IDR_EX_MEM_R_EN, EXE_EXER_MEM_R_EN,
        ID_IDR_MEM_W_EN, IDR_EX_MEM_W_EN, EXE_EXER_MEM_W_EN,
        ID_IDR_B, BranchTaken, 
        ID_IDR_S, IDR_EX_S, EXE_STATUS_S,
        WB_ID_WB_EN, 
        ID_IDR_I, IDR_EX_I,
        HazardOut, ID_HZ_TwoSrc,
        MEM_SRAM_ready;

    // assign STAT_Out = 4'b0;
    // assign WB_ID_WB_Dest = 4'b0;
    // assign WB_ID_WB_Value = 31'b0;
    // assign WB_ID_WB_EN = 1'b0;
    // assign HazardOut = 1'b0;

    wire [31:0] IF_BranchAddr;
    wire IF_Branch_taken, IF_flush;

    // assign IF_Branch_taken = 1'b0;
	// assign IF_BranchAddr = 32'b0;

	IF_Stage if_stage(
		.clk(clk), .rst(rst), .freeze(HazardOut), .Branch_taken(BranchTaken),
		.BranchAddr(EXE_IF_branchAddress),
		.PC(IF_IFR_PC), .Instruction(IF_IFR_Instruction)
	);

	IF_Stage_Reg if_stage_reg(
		.clk(clk), .rst(rst), .freeze(HazardOut | ~MEM_SRAM_ready), .flush(BranchTaken),
		.PC_in(IF_IFR_PC), .Instruction_in(IF_IFR_Instruction),
		.PC(IFR_ID_PC), .Instruction(IFR_ID_Instruction)
	);

    wire [3:0] EX_EXR_Dest;
    
    wire MEM_MEMR_MEM_R_EN;
    wire[3:0] MEM_MEMR_Dest;

	wire[31:0] MEM_EX_ALU_Res , MEM_MEMR_MemoryData , MEM_MEMR_ALU;

	ID_Stage instDecode(
		.clk(clk),                             .rst(rst),                  
		.instructionIn(IFR_ID_Instruction),    .WB_ENIn(WB_ID_WB_EN),                 
		.WB_DestIn(WB_ID_WB_Dest),             .WB_ValueIn(WB_ID_WB_Value),           
		.HazardIn(HazardOut),      			   .PCIn(IFR_ID_PC),                      
		.statusIn(STAT_Out),                   .PCOut(ID_IDR_PC),                     
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

        HazardUnit hazardUnit(
		.RnIn(ID_HZ_Rn),                        .reg2In(ID_HZ_RegSrc2), 
		.TwoSrcIn(ID_HZ_TwoSrc),                .EXE_DestIn(EXE_EXER_Dest), 
		.MEM_DestIn(MEM_MEMR_Dest),             .EXE_WB_ENIn(EXE_EXER_WB_EN), 
		.MEM_WB_ENIn(MEM_MEMR_WB_EN),           .MEM_R_ENIn(IDR_EX_MEM_R_EN), 
		.forwardENIn(forwardENIn),              .HazardOut(HazardOut)
	);

	ID_Stage_Reg instDecodeReg(
		.clk(clk), .rst(rst),                 .en(MEM_SRAM_ready), .clr(BranchTaken),
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
		.statusIn(STAT_Out),                  .statusOut(IDR_STAT),
		.src1In(ID_IDR_src1),   		      .src1Out(IDR_EX_src1),
		.src2In(ID_IDR_src2),   		      .src2Out(IDR_EX_src2)
	);

	wire [31:0] 
        EXER_MEM_ALU_Res, 
        EXER_MEM_Val_Rm;

    wire [3:0] 
        EXE_MEM_Dest, 
        EXE_MEM_status,
         EXER_MEMR_Dest;

    wire 
        EXER_MEM_WB_EN, 
        EXER_MEM_MEM_R_EN, 
        EXER_MEM_MEM_W_EN, 
        EXER_MEM_S;

    wire[1:0] selSrc1, selSrc2;

	EXE_Stage exe_stage(
        .clk(clk), .rst(rst),
        .WB_ENIn(IDR_EX_WB_EN),           .MEM_R_ENIn(IDR_EX_MEM_R_EN),
        .MEM_W_ENIn(IDR_EX_MEM_W_EN),     .EXE_CMDIn(IDR_EX_EXE_CMD),
        .SIn(IDR_EX_S),                   .PCIn(IDR_EX_PC),
        .Val_RnIn(IDR_EX_Val_Rn),         .Val_RmIn(IDR_EX_Val_Rm),
        .shiftOperandIn(IDR_EX_ShiftOperand),
        .IIn(IDR_EX_I),                   .Imm24In(IDR_EX_Imm24),
        .DestIn(IDR_EX_Dest),             .statusIn(IDR_STAT),
        .WB_ENOut(EXE_EXER_WB_EN),        .MEM_R_ENOut(EXE_EXER_MEM_R_EN),
        .MEM_W_ENOut(EXE_EXER_MEM_W_EN),  .ALU_ResOut(EXE_EXER_ALU_Res),
        .Val_RmOut(EXE_EXER_Val_Rm),      .DestOut(EXE_EXER_Dest),
        .statusOut(EX_STAT),              .branchAddressOut(EXE_IF_branchAddress),
        .SOut(EXE_STATUS_S),              .WB_ValueIn(WB_ID_WB_Value),
        .ALU_ResIn(EXER_MEM_ALU_Res),     .selSrc1In(selSrc1),
        .selSrc2In(selSrc2)
    );

    EXE_Stage_Reg exe_stage_reg(
        .clk(clk), .rst(rst),             .en(MEM_SRAM_ready), .clr(1'b0),
        .WB_ENIn(EXE_EXER_WB_EN),           .WB_ENOut(EXER_MEM_WB_EN), 
        .MEM_R_ENIn(EXE_EXER_MEM_R_EN),     .MEM_R_ENOut(EXER_MEM_MEM_R_EN),
        .MEM_W_ENIn(EXE_EXER_MEM_W_EN),     .MEM_W_ENOut(EXER_MEM_MEM_W_EN), 
        .ALU_ResIn(EXE_EXER_ALU_Res),     .ALU_ResOut(EXER_MEM_ALU_Res),
        .Val_RmIn(IDR_EX_Val_Rm),         .Val_RmOut(EXER_MEM_Val_Rm),
        .DestIn(IDR_EX_Dest),             .DestOut(EXER_MEMR_Dest));


    StatusRegister statusRegister(
		.clk(clk), .rst(rst), .en(EXE_STATUS_S), .statIn(EX_STAT), .statOut(STAT_Out)
	);

    ///////////////////////////////////////////

	MEM_Stage memory(
		.clk(clk), .rst(rst),            .ALU_ResIn(EXER_MEM_ALU_Res),             
		.MEM_W_ENIn(EXER_MEM_MEM_W_EN),   .MEM_R_ENIn(EXER_MEM_MEM_R_EN),       
		.WB_ENIn(EXER_MEM_WB_EN),         .Value_RmIn(EXER_MEM_Val_Rm),         
		.DestIn(EXER_MEMR_Dest),           .WB_ENOut(MEM_MEMR_WB_EN),           
		.MEM_R_ENOut(MEM_MEMR_MEM_R_EN), .DataMemoryOut(MEM_MEMR_MemoryData), 
		.DestOut(MEM_MEMR_Dest),         .ALU_ResOut(MEM_MEMR_ALU),
		.MEM_EX_ALU_ResOut(MEM_EX_ALU_Res),
        .ready(MEM_SRAM_ready)
	);

    wire[31:0] MEMR_WB_MemoryData , MEMR_WB_ALU;
    wire[3:0] MEMR_WB_Dest;
    wire MEMR_WB_MEM_R_EN , MEMR_WB_WB_EN;

	MEM_Stage_Reg memoryReg(
		.clk(clk), .rst(rst),                   .clr(1'b0), .en(MEM_SRAM_ready), 
		.WB_ENIn(EXER_MEM_WB_EN),               .WB_ENOut(MEMR_WB_WB_EN), 
		.MEM_R_ENIn(EXER_MEM_MEM_R_EN),         .MEM_R_ENOut(MEMR_WB_MEM_R_EN), 
		.ALU_ResIn(EXER_MEM_ALU_Res),           .ALU_ResOut(MEMR_WB_ALU), 
		.DataMemoryIn(MEM_MEMR_MemoryData),     .DataMemoryOut(MEMR_WB_MemoryData), 
		.DestIn(EXER_MEMR_Dest),                .DestOut(MEMR_WB_Dest)
	);
    //////////////////////////////////////////

	WB_Stage writeBack(
		.clk(clk),                     .rst(rst),           
		.ALU_ResIn(MEMR_WB_ALU),       .DataMemoryIn(MEMR_WB_MemoryData), 
		.MEM_R_ENIn(MEMR_WB_MEM_R_EN), .WB_DestIn(MEMR_WB_Dest), 
		.WB_DestOut(WB_ID_WB_Dest),    .WB_ENIn(MEMR_WB_WB_EN), 
		.WB_ENOut(WB_ID_WB_EN),        .WB_ValueOut(WB_ID_WB_Value)
	);

    ForwardingUnit forwardingunit(.forwardEnIn(forwardENIn), .src1In(IDR_EX_src1), .src2In(IDR_EX_src2), 
            .MEM_MEMR_WB_ENIn(EXER_MEM_WB_EN), .WB_ID_WB_ENIn(MEMR_WB_WB_EN), 
            .MEM_MEMR_DestIn(EXER_MEMR_Dest), .WB_ID_WB_DestIn(MEMR_WB_Dest), 
            .selSrc1Out(selSrc1), .selSrc2Out(selSrc2));

	assign PC = WB_ID_WB_Value;

endmodule