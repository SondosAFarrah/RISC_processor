module mux_4to1_tb;

// Inputs
reg [3:0] data;
reg [1:0] sel;

// Output
wire out;

// Instantiate the mux_4to1 module
mux_4to1 uut (
    .data(data),
    .sel(sel),
    .out(out)
);

// Initialize inputs
initial begin
    data = 4'b0000;
    sel = 2'b00;
    
    // Change selection and inputs
    #10;
    sel = 2'b01;
    data = 4'b1101;
    
    // Change selection and inputs
    #10;
    sel = 2'b10;
    data = 4'b0010;
    
    // Change selection and inputs
    #10;
    sel = 2'b11;
    data = 4'b1111;
end

// Display output
always @* begin
    $display("data = %b, sel = %b, out = %b", data, sel, out);
end

endmodule
