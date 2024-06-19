module registerFile(clock, RA, RB, RW, sig_enable_write1,sig_enable_write2, BusW1, BusW2, BusA, BusB,registers_array);
    
	input wire clock;

	input wire sig_enable_write1 , sig_enable_write2;

	input wire [2:0] RA, RB, RW;
    
	output reg [15:0] BusA, BusB; 
	
	
	input wire [15:0] BusW1,BusW2;

	 output reg [15:0] registers_array [0:7];
	
	always @(posedge clock) begin
		if(sig_enable_write1==0 && sig_enable_write2==0) begin
			BusB = registers_array[RB];
			BusA = registers_array[RA];
			
		end
	end

	always @(posedge (sig_enable_write1 ||  sig_enable_write2) ) begin
		
		if ( RW != 3'b0 && sig_enable_write1) begin
			registers_array[RW] = BusW1;	
		end
		if ( RW != 3'b0 && sig_enable_write2) begin
			registers_array[RW] = BusW2;	
		end
		
	end

	initial begin
		// Initialize registers to be zeros
		registers_array[0] <= 16'h0000;
		registers_array[1] <= 16'h4444;
		registers_array[2] <= 16'h0001;
		registers_array[3] <= 16'hFFFF;
		registers_array[4] <= 16'h0000;
		registers_array[5] <= 16'h0000;
		registers_array[6] <= 16'h0000;	
		registers_array[7] <= 16'h0000;		

	end
endmodule						 
