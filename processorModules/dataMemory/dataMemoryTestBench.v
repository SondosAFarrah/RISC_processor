module dataMemoryTestBench ();

    // ----------------- CLOCK -----------------
    
    // clock generator wires/registers
	wire clock;

	// generates clock square wave with 10ns period
	ClockGenerator clock_generator(clock);

    // ----------------- Data Memory -----------------

    // data memory wires/registers/signals
    reg [15:0] DataMemoryAddressBus;
    reg [15:0] DataMemoryInputBus;
    wire [15:0] DataMemoryOutputBus;

    // signals
    reg sig_enable_data_memory_write = 0;
    reg sig_enable_data_memory_read = 0;


    dataMemory data_memory(clock, DataMemoryAddressBus, DataMemoryInputBus, DataMemoryOutputBus, sig_enable_data_memory_write, sig_enable_data_memory_read);
	
    // ----------------- Simulation -----------------

    initial begin

        
        // test the memory by writing and reading some values from it from different addresses
        // and checking if the values are correct

        #0
        DataMemoryAddressBus <= 5'd1; // address 1
        sig_enable_data_memory_read <= 1; // enable read

        #10
        $display("(%0t) > DataMemoryOutputBus=%0d", $time, DataMemoryOutputBus);
        DataMemoryAddressBus <= 5'd1; // address 1

        DataMemoryInputBus <= 16'd16; // write value 16

        sig_enable_data_memory_read <= 0; // disable read
        sig_enable_data_memory_write <= 1; // enable write
        
        #10
        DataMemoryAddressBus <= 5'd1; // address 1
        sig_enable_data_memory_read <= 1; // enable read

        #10
        $display("(%0t) > DataMemoryOutputBus=%0d", $time, DataMemoryOutputBus);

        #10 $finish;  
    end

endmodule