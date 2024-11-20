module ID_Stage_tb;
    reg clk, rst, WB_ENIn, HazardIn;
    reg [3:0] WB_DestIn, statusIn;
    reg [31:0] PCIn, instructionIn, WB_ValueIn;
    wire [31:0] PCOut, Val_RnOut, Val_RmOut;
    wire TwoSrcOut, SOut, BOut, MEM_W_ENOut, MEM_R_ENOut, WB_ENOut, IOut;
    wire [3:0] EXE_CMDOut, DestOut, regFileInp2Out, RnOut, src1Out, src2Out;
    wire [11:0] shiftOperandOut;
    wire [23:0] Imm24Out;

    ID_Stage uut (
        .clk(clk), .rst(rst), .instructionIn(instructionIn), .WB_ENIn(WB_ENIn), 
        .WB_DestIn(WB_DestIn), .WB_ValueIn(WB_ValueIn), .HazardIn(HazardIn), 
        .PCIn(PCIn), .statusIn(statusIn), .PCOut(PCOut), .Val_RnOut(Val_RnOut), 
        .Val_RmOut(Val_RmOut), .TwoSrcOut(TwoSrcOut), .SOut(SOut), .BOut(BOut), 
        .EXE_CMDOut(EXE_CMDOut), .MEM_W_ENOut(MEM_W_ENOut), .MEM_R_ENOut(MEM_R_ENOut), 
        .DestOut(DestOut), .IOut(IOut), .regFileInp2Out(regFileInp2Out), 
        .RnOut(RnOut), .shiftOperandOut(shiftOperandOut), .WB_ENOut(WB_ENOut), 
        .Imm24Out(Imm24Out), .src1Out(src1Out), .src2Out(src2Out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1; WB_ENIn = 0; HazardIn = 0; instructionIn = 32'hF1234567;
        WB_DestIn = 4'hA; WB_ValueIn = 32'hDEADBEEF; statusIn = 4'b1010;
        PCIn = 32'h00400000;

        #10 rst = 0; WB_ENIn = 1;
        #10 instructionIn = 32'hE3456789; WB_DestIn = 4'hB;
        #10 HazardIn = 1; WB_ENIn = 0;
        #10 HazardIn = 0;
        #10 $stop;
    end
endmodule
