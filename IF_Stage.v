module IF_Stage(
    input clk, rst, freeze, Branch_taken,
    input [31:0] BranchAddr,
    output [31:0] PC, Instruction
);
    wire[31:0] pc_out_1 , instMem_out_1 , adder_out_1 , mux_out_1;
    wire adder_carryOut_1;
    adder addPc(32'd4 , pc_out_1 , adder_out_1 , adder_carryOut_1);
    multiplexer2Input mux2Input(adder_out_1 ,BranchAddr, Branch_taken, mux_out_1);
    InstMemory instMem(rst , pc_out_1 ,  instMem_out_1);
    PC pc(clk ,rst ,freeze ,mux_out_1 ,pc_out_1);
    
    assign PC = pc_out_1;
    assign Instruction = instMem_out_1;

endmodule