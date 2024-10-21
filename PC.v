module PC(input clk , rst , freeze , input [31:0] in ,output reg [31:0] out);
always @(posedge clk) begin
    if(freeze)
        out <= out;
    if (rst)
        out <= 32'b0;
    else
        out <= in;
end
endmodule
