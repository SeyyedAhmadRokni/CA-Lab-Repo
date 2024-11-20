module CPU_tb;
    reg clk, rst;
    wire [31:0] PC;
    CPU cpu (clk, rst, PC);

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
