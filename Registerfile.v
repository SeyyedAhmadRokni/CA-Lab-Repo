module RegisterFile(
    input clk, rst,
    input [3:0] src1, src2, Dest_wb,
    input [31:0] Input_WB,
    input writeBackEn,
    output [31:0] reg1, reg2
);
    reg [31:0] regmem [15:0];

    integer i;
    assign reg1 = regmem[src1];
    assign reg2 = regmem[src2];
    always @(negedge clk, posedge rst) begin
        if (rst)begin
            for (i = 0; i < 16; i = i + 1) begin
                regmem[i] = i;
            end
            regmem[0] = 32'b0;
        end
        else
            regmem [Dest_wb] = Input_WB;
    end
endmodule