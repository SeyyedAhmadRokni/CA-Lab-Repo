module InstMemory(rst, adr, inst);
    input rst;
    input [15:0] adr;
    output reg [31:0] inst;
    wire [31:0] address;
    assign address = {16'b0,adr};
    reg [31:0] im [16000:0];
    always @(posedge rst)begin
        $readmemb("C:/Users/ahmad/Documents/CA-Lab/0-Project/Codes/inst_test1.txt", im);
    end

    always @(address)begin
        inst = im[address>>2];
    end
endmodule