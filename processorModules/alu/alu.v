`include "constants.v"

module ALU(A, B, Output, ALUop,EN);

	// ----------------- SIGNALS & INPUTS -----------------

    // chip select for ALU operation
	input wire [3:0] ALUop;
	
	//Enable flag
	input wire EN;

	// operands
	input wire [15:0] A, B;

	// ----------------- OUTPUTS -----------------

	output reg	[15:0]	Output;


	// ----------------- LOGIC -----------------


	always @(EN) begin 
		//#1 // To wait for ALU source mux to select operands
		case (ALUop)
			AND:  Output <= A & B;
			ANDI:  Output <= A & B;
			ADD:  Output <= A + B;
			ADDI:  Output <= A + B;
			LW:  Output <= A + B;
			LBu:  Output <= A + B;
			LBs:  Output <= A + B;
			SW:  Output <= A + B;
			SUB:  Output <= A - B; 
			default: Output <= 0;
		endcase
	end	
	
	initial begin
		if (EN == LOW)begin
			Output = 16'd0;
		end
	end

endmodule