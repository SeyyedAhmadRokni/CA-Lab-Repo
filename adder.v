module adder #( parameter size = 32) (
    input [size-1:0] a, b,
    output [size-1:0] c,
    output carry
);
    assign {carry, c} = a+b;
endmodule