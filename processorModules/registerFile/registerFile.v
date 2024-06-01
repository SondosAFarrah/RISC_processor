module registerFile(clock, RA, RB, RW, sig_enable_write, BusW, BusA, BusB);
    
	input wire clock;

	input wire sig_enable_write;

	input wire [2:0] RA, RB, RW;
    
	output reg [15:0] BusA, BusB; 
	
	
	input wire [15:0] BusW;

	 reg [15:0] registers_array [0:7];
	
	always @(posedge clock) begin
		if(!sig_enable_write) begin
			BusA = registers_array[RA];
			BusB = registers_array[RB];
		end
	end

	always @(posedge sig_enable_write ) begin
		
		if ( RW != 3'b0 && sig_enable_write) begin
			registers_array[RW] = BusW;	
		end
		
	end

	initial begin
		// Initialize registers to be zeros
		registers_array[0] <= 16'h0000;
		registers_array[1] <= 16'h0000;
		registers_array[2] <= 16'h0000;
		registers_array[3] <= 16'h0000;
		registers_array[4] <= 16'h0000;
		registers_array[5] <= 16'h0000;
		registers_array[6] <= 16'h0000;	
		registers_array[7] <= 16'h0000;		

	end
endmodule						 
