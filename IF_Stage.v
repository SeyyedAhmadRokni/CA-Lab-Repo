module IF_Stage(
    input clk, 
    rst, 
    freeze, 
    Branch_taken,
    input [31:0] BranchAddr,
    output [31:0] PC, Instruction
);
    wire[31:0] pc_out, instMem_out, adder_out, mux_out;
    wire adder_carryOut;
    adder addPc(32'd4, pc_out, adder_out, adder_carryOut);
    multiplexer2Input mux2Input(adder_out, BranchAddr, Branch_taken, mux_out);
    InstMemory instMem(rst, pc_out, instMem_out);
    PC pc(clk, rst, freeze, mux_out, pc_out);
    
    assign PC = adder_out;
    assign Instruction = instMem_out;

endmodule