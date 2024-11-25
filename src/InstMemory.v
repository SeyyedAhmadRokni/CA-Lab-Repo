module InstMemory(input rst,
                  input [31:0] adr,
                  output reg [31:0] inst);
    reg [31:0] im [4095:0];
    always @(posedge rst)
    begin
        $readmemb("exec_test.txt", im);
    end

    always @(adr)
    begin
        inst <= im[adr>>2];
    end
endmodule