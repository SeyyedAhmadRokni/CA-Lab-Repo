module ForwardingUnit(forwardEnIn, src1In, src2In, 
                      MEM_MEMR_WB_ENIn, WB_ID_WB_ENIn, 
                      MEM_MEMR_DestIn, WB_ID_WB_DestIn, 
                      selSrc1Out, selSrc2Out);
    input forwardEnIn;
    input [3:0] src1In, src2In;
    input MEM_MEMR_WB_ENIn, WB_ID_WB_ENIn;
    input [3:0] MEM_MEMR_DestIn, WB_ID_WB_DestIn;
    output reg [1:0] selSrc1Out, selSrc2Out;

endmodule
