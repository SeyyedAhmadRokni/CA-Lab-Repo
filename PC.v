module PC(input clk,reset,input [31:0] PCnext,output reg [31:0] PCout);
always @(posedge clk, posedge reset) begin
    if (reset)
        PCout <= 0;
     else
        PCout <= PCnext;
end
endmodule
