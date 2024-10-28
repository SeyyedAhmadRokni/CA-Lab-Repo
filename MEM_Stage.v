module MEM_Stage
(
    input clk/* synthesis keep */, rst/* synthesis keep */,
    input [31:0] PC_in/* synthesis keep */,
    output [31:0] PC/* synthesis keep */
);
    assign PC = PC_in;
endmodule