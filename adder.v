module adder #(
    parameter size = 32;
) (
    input a, 
    input b,
    output c,
    output carry
);
    assign {carry, c} = a+b;
  
endmodule