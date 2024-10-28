module adder #( parameter size = 32) (
    input [size-1:0] a, b/* synthesis keep */,
    output [size-1:0] c/* synthesis keep */,
    output carry/* synthesis keep */
);
    assign {carry, c} = a+b;
endmodule