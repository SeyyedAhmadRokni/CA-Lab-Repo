module ID_Stage_Reg
(
    input clk/* synthesis keep */, rst/* synthesis keep */,
    input [31:0] PC_in/* synthesis keep */,
    output reg [31:0] PC/* synthesis keep */
);
    always@(posedge clk,posedge rst) begin
        if (rst)
            PC <= 32'b0;
        else
            PC <= PC_in;
    end
endmodule