`include "constant.v"

module ALU(A, B, Output, flag_zero, flag_negative, ALUop,EN);

	// ----------------- SIGNALS & INPUTS -----------------

    // chip select for ALU operation
	input wire [2:0] ALUop;
	
	//Enable flag
	input wire EN;

	// operands
	input wire [15:0] A, B;

	// ----------------- OUTPUTS -----------------

	output reg	[15:0]	Output;
	output reg			flag_zero;
	output reg			flag_negative;

	// ----------------- LOGIC -----------------

	assign flag_zero = (0 == Output);
	assign flag_negative = (Output[15] == 1); // if 2s complement number is negative, MSB is 1

	always @(EN) begin 
		#1 // To wait for ALU source mux to select operands
		case (ALUop)
			ALU_AND:  Output <= A & B;
			ALU_ADD:  Output <= A + B;
			ALU_SUB:  Output <= A - B; 
			default: Output <= 0;
		endcase
	end	
	
	initial begin
		if (EN == LOW)begin
			Output = 15'd0;
		end
	end

endmodule