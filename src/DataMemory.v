module DataMemory(clk, rst, ALU_ResIn, Value_RmIn, 
                  MEM_W_ENIn, MEM_R_ENIn, resultOut);
    input clk, rst;
    input [31:0] Value_RmIn, ALU_ResIn;
    input MEM_R_ENIn, MEM_W_ENIn;

    output reg [31:0] resultOut;

    localparam WordCount = 256;

    reg [31:0] dataMem [0:WordCount - 1]; // 256B memory

    wire [31:0] dataAdr, adr;
    assign dataAdr =  ALU_ResIn - 32'd1024;
    assign adr = {2'b00, dataAdr[31:2]}; // Align address to the word boundary

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst)
            for (i = 0; i < WordCount; i = i + 1) begin
                dataMem[i] <= 32'd0;
            end
        else if (MEM_W_ENIn)
            dataMem[adr] <= Value_RmIn;
    end

    always @(MEM_R_ENIn or adr) begin
        resultOut = 32'b0;
        if (MEM_R_ENIn)
            resultOut = dataMem[adr];
    end
endmodule
