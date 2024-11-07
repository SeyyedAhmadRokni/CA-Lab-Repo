module adder #( parameter size = 32) (
    input [size-1:0] a, b,
    output [size-1:0] sum,
    output carry
);
    assign {carry, sum} = a+b;
endmodule