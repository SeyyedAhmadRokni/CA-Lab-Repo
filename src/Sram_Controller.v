module Sram_Controller (
     clk, rst, wr_en, rd_en,
     address, writeData, readData, ready,
     SRAM_DQ, SRAM_ADDR,
     SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N
);
    input clk, rst, wr_en, rd_en;
    input [31:0] address, writeData;
    output reg [31:0] readData;
    output reg ready;
    
    inout [15:0] SRAM_DQ;
    reg [15:0] SRAM_DQ_REG;
    output reg [17:0] SRAM_ADDR;
    output reg SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N;

    reg [2:0] ps, ns;

    assign SRAM_DQ = wr_en ? SRAM_DQ_REG : 16'bz;

    always @(posedge clk, rst)begin
        if (rst)
            ps <= 3'd0;
        else
            ps <= ns;
    end
    
    always @(ps, wr_en, rd_en) begin
        case (ps)
            3'd0: ns <= (wr_en || rd_en) ? 3'd1 : 3'd0;
            3'd1: ns <= 3'd2;
            3'd2: ns <= 3'd3;
            3'd3: ns <= 3'd4;
            3'd4: ns <= 3'd5;
            3'd5: ns <= 3'd0;
        endcase
    end

    always @(ps, wr_en, rd_en, address, writeData, SRAM_ADDR, SRAM_DQ_REG) begin
        {SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N} = 4'b1;
        ready = 1'b0;
        SRAM_DQ_REG = 16'b0;
        case (ps)
            3'd0: begin
                ready = ~(wr_en | rd_en);
            end
            3'd1: begin
                SRAM_ADDR = address[18:1];
                if (wr_en)begin
                    SRAM_WE_N = 1'b0;
                    SRAM_DQ_REG = writeData[15:0];
                end

            end
            3'd2: begin
                SRAM_WE_N = 1'b0;
                SRAM_ADDR = SRAM_ADDR + 1;
                if (wr_en)
                    SRAM_DQ_REG = writeData[31:16];
                else if (rd_en)
                    readData[15:0] = SRAM_DQ_REG;

            end
            3'd3: begin
                if (rd_en)begin
                    SRAM_WE_N = 1'b0;
                    readData[31:16] = SRAM_DQ_REG;
                end


            end
            3'd4: begin

            end
            3'd5: begin
                ready = 1'b1;
            end
        endcase

    end



endmodule