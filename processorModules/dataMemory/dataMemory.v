// data memory with 256 cells of 16 bits each
module dataMemory(clock, AddressBus, InputBus, OutputBus, sig_enable_write, sig_enable_read,memory);

    // ----------------- SIGNALS -----------------

    // clock
    input wire clock;

    // enable write signal
	input wire sig_enable_write;
    
    // enable write signal
	input wire sig_enable_read;

    // ----------------- INPUTS -----------------

    // address bus
    input wire [15:0] AddressBus;

    // MBR - in
    input wire [15:0] InputBus;

    // ----------------- OUTPUTS -----------------

    // MBR - out
    output reg [15:0] OutputBus;

    // ----------------- INTERNALS -----------------

    // memory
    output reg [15:0] memory [0:255];

    // ----------------- LOGIC -----------------

    // read instruction at positive edge of clock
    always  @(posedge clock) begin
        if (sig_enable_read) begin
            OutputBus <= memory[AddressBus];
        end else if (sig_enable_write) begin
            memory[AddressBus] <= InputBus;
        end
    end

    // ----------------- INITIALIZATION -----------------

    initial begin
        
        // store some initial data
        memory[0] = 16'd10;
        memory[1] = 16'd5;
		memory[16] = 16'd9;
        
    end


endmodule