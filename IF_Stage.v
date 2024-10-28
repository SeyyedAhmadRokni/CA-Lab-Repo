module IF_Stage(
    input clk/* synthesis keep */, rst/* synthesis keep */, freeze/* synthesis keep */, Branch_taken/* synthesis keep */,
    input [31:0] BranchAddr/* synthesis keep */,
    output [31:0] PC, Instruction/* synthesis keep */
);
    wire[31:0] pc_out_1 , instMem_out_1 , adder_out_1 , mux_out_1/* synthesis keep */;
    wire adder_carryOut_1/* synthesis keep */;
    adder addPc(32'd4 , pc_out_1 , adder_out_1 , adder_carryOut_1);
    multiplexer2Input mux2Input(adder_out_1 ,BranchAddr, Branch_taken, mux_out_1);
    InstMemory instMem(rst , pc_out_1 ,  instMem_out_1);
    PC pc(clk ,rst ,freeze ,mux_out_1 ,pc_out_1);
    
    assign PC = pc_out_1;
    assign Instruction = instMem_out_1;

endmodule