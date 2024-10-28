module multiplexer2Input #(parameter WIDTH = 32)(
    input [WIDTH-1:0] in0/* synthesis keep */,
    input [WIDTH-1:0] in1/* synthesis keep */,
    input  sel/* synthesis keep */,
    output [WIDTH-1:0] out/* synthesis keep */
);
    assign out = sel ? in1 : in0;

endmodule
