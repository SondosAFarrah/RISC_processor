module mux_2to1 (
    input a, // Input 0
    input b, // Input 1
    input sel, // Select input
    output reg out // Output
);

always @(*) begin
    case(sel)
        1'b0: out = a;
        1'b1: out = b;
        default: out = 1'b0; // Default output when selection is invalid
    endcase
end

endmodule
