module PC(input clk/* synthesis keep */ , rst /* synthesis keep */, freeze /* synthesis keep */, input [31:0] in/* synthesis keep */ ,output reg [31:0] out/* synthesis keep */);
always @(posedge rst , posedge clk) begin
    if (rst)
        out = 32'b0;
    else if(freeze)
        out <= out;
    else
        out <= in;
end
endmodule
