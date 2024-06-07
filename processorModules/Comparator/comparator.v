module comparator (
    input [15:0] BusA,    // rs or R0
    input [15:0] BusB,    // rd
    input [3:0] opCode,   // operation code
    output reg zero       // output: 1 if condition is true (branch taken), 0 otherwise
);

always @(*) begin
    case (opCode)
        4'b1000: zero = (BusB > BusA) ? 1 : 0;  // BGT
        4'b1001: zero = (BusB > 16'd0) ? 1 : 0; // BGTZ
        4'b1010: zero = (BusB < BusA) ? 1 : 0;  // BLT
        4'b1011: zero = (BusB < 16'd0) ? 1 : 0; // BLTZ
        4'b1100: zero = (BusB == BusA) ? 1 : 0; // BEQ
        4'b1101: zero = (BusB == 16'd0) ? 1 : 0; // BEQZ
        4'b1110: zero = (BusB != BusA) ? 1 : 0; // BNE
        4'b1111: zero = (BusB != 16'd0) ? 1 : 0; // BNEZ
        default: zero = 0;                      // Default case: no branch
    endcase
end

endmodule
