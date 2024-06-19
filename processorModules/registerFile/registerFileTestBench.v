module registerFileTestBench ();

    // ----------------- CLOCK -----------------
    
    // clock generator wires/registers
	wire clock;

	// generates clock square wave with 10ns period
	ClockGenerator clock_generator(clock);

    // ----------------- Register File -----------------
 
    // register file wires/registers
    reg [2:0] RA, RB, RW;
    reg sig_enable_write1,sig_enable_write2;
    reg [15:0] BusW1,BusW2;
    wire [15:0] BusA, BusB;	 
	reg [15:0] registers_array [0:7];
    
    // register file ( array of 16 registers )
    registerFile register_file(clock, RA, RB, RW, sig_enable_write1,sig_enable_write2, BusW1, BusW2, BusA, BusB,registers_array);
    
    // ----------------- Simulation -----------------

    initial begin

        
        // test the register file by writing and reading some values from it from different registers
        // and checking if the values are correct

        #0
        RW <= 3'd1; // write to register 1
        BusW1 <= 16'd8; // write value 8
        sig_enable_write1 <= 1; // enable write
		sig_enable_write2 <= 0;

        #10
        RW <= 3'd2; // write to register 2
        BusW2 <= 16'd0; // write value 16
        sig_enable_write2 <= 1; // enable write
		sig_enable_write1 <= 0;
		
        #10
        RA <= 3'd2;
        RB <= 3'd1;
        sig_enable_write1 <= 0; // disable write
		sig_enable_write2 <= 0;
		
        #10

        // results of previouse cycle
        $display("(%0t) > BusA=%0d, BusB=%0d", $time, BusA, BusB);


        // test overwrite
        RW <= 3'd2; // write to register 2
        BusW1 <= 16'd32; // write value 32
        sig_enable_write1 <= 1; // enable write
		sig_enable_write2 <= 0;
		
        #10
        $display("(%0t) > BusA=%0d, BusB=%0d", $time, BusA, BusB);

        // test write without write signal
        RW <= 5'd2; // write to register 2
        BusW1 <= 16'd64; // write value 32
        sig_enable_write1 <= 0; // disable write
		sig_enable_write2 <= 0;
		
        #10
        $display("(%0t) > BusA=%0d, BusB=%0d", $time, BusA, BusB);


        #10 $finish;    // 100 cycle
    end

endmodule