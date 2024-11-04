
module ID_Stage(clk, rst, MEM_W_ENIn, WB_ENIn, HazardIn,
                WB_DestIn,
                PCIn, instructionIn, WB_ValueIn,
                PCOut, val_RnOut, val_RmOut,
                Two_srcOut, statusIn, SOut, BOut, MEM_W_ENOut, MEM_R_ENOut, WB_ENOut, iOut,
                EXE_CMDOut, DestOut, RnOut, regFileInp2Out,
                shiftOperandOut, immOut);

    parameter SIZE = 32;

    input wire clk, rst, MEM_W_ENIn, WB_ENIn, HazardIn;
    input wire[3:0] WB_DestIn;
    input wire[SIZE-1:0] PCIn, instructionIn, WB_ValueIn;

    output wire[SIZE-1:0] PCOut, val_RnOut, val_RmOut;
    output wire Two_srcOut, statusIn, SOut, BOut, MEM_W_ENOut, MEM_R_ENOut, WB_ENOut, iOut;
    output wire[3:0] EXE_CMDOut, DestOut, RnOut, regFileInp2Out;
    output wire[11:0] shiftOperandOut;
    output wire[23:0] immOut;

    wire[3:0] cond;
    assign cond = instructionIn[31:28];

    wire[1:0] mode;
    assign mode = instructionIn[27:26];

    wire[0:0] i;
    assign i = instructionIn[25];
    assign iOut = i;

    wire[3:0] opCode;
    assign opCode = instructionIn[24:21];

    wire[0:0] s;
    assign s = instructionIn[20];

    wire[3:0] rn;
    assign rn = instructionIn[19:16];
    assign RnOut = rn;

    wire[3:0] rd;
    assign rd = instructionIn[15:12];
    assign DestOut = rd;

    assign shiftOperandOut = instructionIn[11:0];
    assign immOut = instructionIn[23:0];

    //?
    wire[3:0] rm;
    assign rm = instructionIn[3:0];

    wire[3:0] readReg2;

    multiplexer2Input #(.WIDTH(4)) reg_mux (rd, rm, MEM_W_ENIn, regFileInp2Out);

    RegisterFile registerFile(
        .clk(clk), .rst(rst),
        .src1(rn), .src2(regFileInp2Out), .Dest_wb(WB_DestIn),
        .Result_WB(WB_ValueIn),
        .writeBackEn(WB_ENIn),
        .reg1(val_RnOut), .reg2(val_RnOut)
    );

    assign Two_srcOut = ~i | MEM_W_ENIn;

    wire conditionCheckOut;
    ConditionCheck conditionCheck(.condIn(cond), .condOut(conditionCheckOut), .statusIn(statusIn));

    wire conditionCheckOutOrHazard;
    // assign conditionCheckOutOrHazard = conditionCheckOut | HazardIn;
    assign conditionCheckOutOrHazard = 1'b0;

    wire[8:0] controlUnitOut;
    ControlUnit controlUnit(.opCodeIn(opCode), .SIn(s), .modeIn(mode), 
                            .EXE_CMDOut(controlUnitOut[3:0]), .SOut(controlUnitOut[4]), .BOut(controlUnitOut[5]), 
                            .MEM_W_ENOut(controlUnitOut[6]), .MEM_R_ENOut(controlUnitOut[7]), .WB_ENOut(controlUnitOut[8]));

    wire[8:0] conditionCheckMuxOut;

    mux2Input #(.WIDTH(9))  conditionCheckMux(.in0(controlUnitOut), .in1(9'b0), .sel(conditionCheckOutOrHazard), .out(conditionCheckMuxOut));

    assign EXE_CMDOut = conditionCheckMuxOut[3:0];
    assign SOut = conditionCheckMuxOut[4];
    assign BOut = conditionCheckMuxOut[5];
    assign MEM_W_ENOut = conditionCheckMuxOut[6];
    assign MEM_R_ENOut = conditionCheckMuxOut[7];
    assign WB_ENOut = conditionCheckMuxOut[8];

    assign PCOut = PCIn;
endmodule