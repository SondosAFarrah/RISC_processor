module mux_2to1_tb;

  // Inputs
  reg a;
  reg b;
  reg sel;

  // Output
  wire out;

  // Instantiate the mux_2to1 module
  mux_2to1 uut (
    .a(a),
    .b(b),
    .sel(sel),
    .out(out)
  );

  // Initialize inputs
  initial begin
    a = 1'b0;
    b = 1'b1;
    sel = 1'b0;
    
    // Loop to change selection every 20 time units
    repeat (10) begin
      #20;
      sel = ~sel; // Toggle selection
    end
  end

  // Display output
  always @* begin
    $display("a = %b, b = %b, sel = %b, out = %b", a, b, sel, out);
  end

endmodule
