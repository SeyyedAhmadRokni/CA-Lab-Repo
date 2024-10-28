module IF_Stage_Reg(
    input clk, rst, freeze, flush,
    input [31:0] PC_in, Instruction_in,
    output reg [31:0] PC, Instruction
);
    always@(posedge clk,posedge rst) begin
        if (rst == 1'b1)
            PC = 32'b0;
        else
            PC <= PC_in;
            Instruction <= Instruction_in;
    end

endmodule