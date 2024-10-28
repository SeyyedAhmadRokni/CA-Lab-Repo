module PC(input clk , rst , freeze , input [31:0] in ,output reg [31:0] out);
always @(posedge rst , posedge clk) begin
    if (rst)
        out = 32'b0;
    else if(freeze)
        out <= out;
    else
        out <= in;
end
endmodule
