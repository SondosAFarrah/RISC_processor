module comparatorTestBench;

// Testbench signals
reg [15:0] BusA;
reg [15:0] BusB;
reg [3:0] opCode;
wire zero;

// Instantiate the comparator module
comparator uut (
    .BusA(BusA),
    .BusB(BusB),
    .opCode(opCode),
    .zero(zero)
);

initial begin
    // Initialize testbench signals
    BusA = 16'd0;
    BusB = 16'd0;
    opCode = 4'd0;

    // Display the header
    $display("Time\tBusA\tBusB\topCode\tzero");

    // Monitor the signals
    $monitor("%0t\t%0d\t%0d\t%0b\t%b", $time, BusA, BusB, opCode, zero);

    // Test cases
    #10 BusA = 16'd10; BusB = 16'd20; opCode = 4'b1000; // BGT: BusB > BusA (20 > 10)
    #10 BusA = 16'd10; BusB = 16'd5;  opCode = 4'b1000; // BGT: BusB > BusA (5 > 10)
    #10 BusA = 16'd0;  BusB = 16'd5;  opCode = 4'b1001; // BGTZ: BusB > 0 (5 > 0)
    #10 BusA = 16'd0;  BusB = -16'd5; opCode = 4'b1001; // BGTZ: BusB > 0 (-5 > 0)
    #10 BusA = 16'd20; BusB = 16'd10; opCode = 4'b1010; // BLT: BusB < BusA (10 < 20)
    #10 BusA = 16'd10; BusB = 16'd20; opCode = 4'b1010; // BLT: BusB < BusA (20 < 10)
    #10 BusA = 16'd0;  BusB = -16'd5; opCode = 4'b1011; // BLTZ: BusB < 0 (-5 < 0)
    #10 BusA = 16'd0;  BusB = 16'd5;  opCode = 4'b1011; // BLTZ: BusB < 0 (5 < 0)
    #10 BusA = 16'd10; BusB = 16'd10; opCode = 4'b1100; // BEQ: BusB == BusA (10 == 10)
    #10 BusA = 16'd10; BusB = 16'd20; opCode = 4'b1100; // BEQ: BusB == BusA (20 == 10)
    #10 BusA = 16'd0;  BusB = 16'd0;  opCode = 4'b1101; // BEQZ: BusB == 0 (0 == 0)
    #10 BusA = 16'd0;  BusB = 16'd10; opCode = 4'b1101; // BEQZ: BusB == 0 (10 == 0)
    #10 BusA = 16'd10; BusB = 16'd20; opCode = 4'b1110; // BNE: BusB != BusA (20 != 10)
    #10 BusA = 16'd10; BusB = 16'd10; opCode = 4'b1110; // BNE: BusB != BusA (10 != 10)
    #10 BusA = 16'd0;  BusB = 16'd10; opCode = 4'b1111; // BNEZ: BusB != 0 (10 != 0)
    #10 BusA = 16'd0;  BusB = 16'd0;  opCode = 4'b1111; // BNEZ: BusB != 0 (0 != 0)
    
    // End of test
    #10 $finish;
end

endmodule
