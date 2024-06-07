 module mux_4to1 (
    input [3:0] data,  // 4-bit input data
    input [1:0] sel,   // 2-bit select input
    output reg out     // Output
);

always @(*) begin
    case(sel)
        2'b00: out = data[0];
        2'b01: out = data[1];
        2'b10: out = data[2];
        2'b11: out = data[3];
        default: out = 1'b0; // Default output when selection is invalid
    endcase
end

endmodule
