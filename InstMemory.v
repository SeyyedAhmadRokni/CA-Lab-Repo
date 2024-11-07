module InstMemory(input rst/* synthesis keep */, input [31:0] adr/* synthesis keep */, output reg [31:0] inst/* synthesis keep */);
    reg [31:0] im [4095:0];
    always @(posedge rst)
    begin
        $readmemb("inst_test1.txt", im);
    end
    always @(adr)
    begin
        inst <= im[adr>>2];
    end
endmodule