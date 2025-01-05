module CPU_tb;
    reg clk, rst;
    wire [31:0] PC;
    wire forwardEn;
    assign forwardEn = 1'b1;
    CPU cpu (clk, rst, forwardEn, PC);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #10 rst = 0; 
        #10000 $stop;
    end
endmodule
