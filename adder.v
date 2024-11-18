module Adder(input [N-1:0] a, b , output [N-1:0] out);
    parameter N = 32;
    assign out = a + b;
endmodule