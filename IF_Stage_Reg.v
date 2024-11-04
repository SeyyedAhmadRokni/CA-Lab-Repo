module IF_Stage_Reg(
    input clk/* synthesis keep */, rst/* synthesis keep */, freeze/* synthesis keep */, flush/* synthesis keep */,
    input [31:0] PC_in, Instruction_in/* synthesis keep */,
    output reg [31:0] PC, Instruction/* synthesis keep */
);
    always@(posedge clk,posedge rst) begin
        if (rst) begin
            PC <= 32'b0;
            Instruction <= 32'b0;
        end
        else
            PC <= PC_in;
            Instruction <= Instruction_in;
    end

endmodule