module MEM_Stage(clk, rst, ALU_ResIn, MEM_W_ENIn, MEM_R_ENIn, WB_ENIn, 
                 Value_RmIn, DestIn, WB_ENOut, MEM_R_ENOut,
                 DataMemoryOut, DestOut, ALU_ResOut, MEM_EX_ALU_ResOut,
                 ready, SRAM_DQ, SRAM_ADDR, SRAM_WE_N);

    parameter N = 32;
    input clk, rst;
    
    input MEM_R_ENIn, MEM_W_ENIn, WB_ENIn;
    input [3:0] DestIn;
    input [N - 1:0] ALU_ResIn, Value_RmIn;
    

    output MEM_R_ENOut, WB_ENOut;
    output [3:0] DestOut;
    output [N - 1:0] DataMemoryOut, ALU_ResOut, MEM_EX_ALU_ResOut;
    output ready;
    output SRAM_WE_N;
    output [17:0] SRAM_ADDR;

    // DataMemory DM(
    //     .clk(clk), .rst(rst), .ALU_ResIn(ALU_ResIn),
    //     .Value_RmIn(Value_RmIn), .MEM_W_ENIn(MEM_W_ENIn), 
    //     .MEM_R_ENIn(MEM_R_ENIn), .resultOut(DataMemoryOut)
    // );
    
    inout [15:0] SRAM_DQ;
    wire SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N;
  

    Sram_Controller sram_controller(
        .clk(clk), .rst(rst), .wr_en(MEM_W_ENIn), .rd_en(MEM_R_ENIn),
        .address(ALU_ResIn), .writeData(Value_RmIn), .readData(DataMemoryOut), .ready(ready),
        .SRAM_DQ(SRAM_DQ), .SRAM_ADDR(SRAM_ADDR),
        .SRAM_UB_N(SRAM_UB_N), .SRAM_LB_N(SRAM_LB_N), .SRAM_WE_N(SRAM_WE_N), .SRAM_CE_N(SRAM_CE_N), .SRAM_OE_N(SRAM_OE_N)
    );

    // assign DataMemoryOut = MEM_R_ENIn ? readData : 32'b0;

    // SRAM sram(
    //     .clk(clk), .rst(rst), .SRAM_WE_NIn(SRAM_WE_N), .SRAM_ADDRIn(SRAM_ADDR), .SRAM_DQInOut(SRAM_DQ)
    // );

    assign MEM_R_ENOut = MEM_R_ENIn;
    assign WB_ENOut = WB_ENIn;
    assign DestOut = DestIn;
    assign ALU_ResOut = ALU_ResIn;
    assign MEM_EX_ALU_ResOut = ALU_ResIn;

endmodule