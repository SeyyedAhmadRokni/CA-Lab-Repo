module RegisterFile_tb;
    reg clk, rst;
    reg [3:0] src1, src2, Dest_wb;
    reg [31:0] Input_WB;
    reg writeBackEn;
    wire [31:0] reg1, reg2;

    RegisterFile uut (
        .clk(clk),
        .rst(rst),
        .src1(src1),
        .src2(src2),
        .Dest_wb(Dest_wb),
        .Input_WB(Input_WB),
        .writeBackEn(writeBackEn),
        .reg1(reg1),
        .reg2(reg2)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1; src1 = 4'd1; src2 = 4'd2; Dest_wb = 4'd3; Input_WB = 32'hA5A5A5A5; writeBackEn = 1;
        #10 rst = 0;
        #10 Dest_wb = 4'd3; Input_WB = 32'hDEADBEEF;
        #10 writeBackEn = 0; src1 = 4'd3;
        #10 writeBackEn = 1; src2 = 4'd3; Dest_wb = 4'd2; Input_WB = 32'hCAFEBABE;
        #10 $stop;
    end
endmodule
