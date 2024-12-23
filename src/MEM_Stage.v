module MEM_Stage(clk, rst, ALU_ResIn, MEM_W_ENIn, MEM_R_ENIn, WB_ENIn, 
                 Value_RmIn, DestIn, WB_ENOut, MEM_R_ENOut,
                 DataMemoryOut, DestOut, ALU_ResOut, MEM_EX_ALU_ResOut);

    parameter N = 32;
    input wire[0:0] clk, rst;
    
    input wire[0:0] MEM_R_ENIn, MEM_W_ENIn, WB_ENIn;
    input wire[3:0] DestIn;
    input wire[N - 1:0] ALU_ResIn, Value_RmIn;


    output wire[0:0] MEM_R_ENOut, WB_ENOut;
    output wire[3:0] DestOut;
    output wire[N - 1:0] DataMemoryOut, ALU_ResOut, MEM_EX_ALU_ResOut;


    // DataMemory DM(
    //     .clk(clk), .rst(rst), .ALU_ResIn(ALU_ResIn),
    //     .Value_RmIn(Value_RmIn), .MEM_W_ENIn(MEM_W_ENIn), 
    //     .MEM_R_ENIn(MEM_R_ENIn), .resultOut(DataMemoryOut)
    // );
    
    output ready;
    wire [15:0] SRAM_DQ;
    wire [17:0] SRAM_ADDR;
    output SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N;

    Sram_Controller sram_controller(
        .clk(clk), .rst(rst), .wr_en(MEM_W_ENIn), .rd_en(MEM_R_ENIn),
        .address(ALU_ResIn), .writeData(Value_RmIn), .readData(DataMemoryOut), .ready(ready),
        .SRAM_DQ(SRAM_DQ), .SRAM_ADDR(SRAM_ADDR),
        .SRAM_UB_N(SRAM_UB_N), .SRAM_LB_N(SRAM_LB_N), .SRAM_WE_N(SRAM_WE_N), .SRAM_CE_N(SRAM_CE_N), .SRAM_OE_N(SRAM_OE_N)
    );

    SRAM sram(
        .clk(clk), .rst(rst), .SRAM_WE_NIn(SRAM_ADDR), .SRAM_ADDRIn(ALU_ResIn), .SRAM_DQInOut(SRAM_DQ)
    )

    assign MEM_R_ENOut = MEM_R_ENIn;
    assign WB_ENOut = WB_ENIn;
    assign DestOut = DestIn;
    assign ALU_ResOut = ALU_ResIn;
    assign MEM_EX_ALU_ResOut = ALU_ResIn;

endmodule