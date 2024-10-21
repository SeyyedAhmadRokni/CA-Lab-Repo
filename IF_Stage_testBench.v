    `timescale 1ns/1ns

module IF_Stage_testBench;
    reg clk;
    reg rst;
    reg freeze;
    reg Branch_taken;
    reg [31:0] BranchAddr;

    wire [31:0] PC;
    wire [31:0] Instruction;

    IF_Stage uut (
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .Branch_taken(Branch_taken),
        .BranchAddr(BranchAddr),
        .PC(PC),
        .Instruction(Instruction)
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    initial begin
        rst = 1;
        freeze = 0;
        Branch_taken = 0;
        BranchAddr = 32'h00000000;
        #20 rst = 0;
        #10;
        freeze = 1;
        #10;
        freeze = 0;

        Branch_taken = 1;
        BranchAddr = 32'h00000010;
        #10 Branch_taken = 0;

        #100;
        $stop;
    end

endmodule
