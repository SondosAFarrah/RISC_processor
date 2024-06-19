`include "constants.v"

module ALU_tb;

	wire EN;

	ClockGenerator clock_generator(EN);


    reg [15:0] A, B;
    wire [15:0] Output;


    // signals
    reg [3:0] ALUop;

	ALU alu(A, B, Output, ALUop,EN);

    initial begin

        #0
        A <= 16'd15;
        B <= 16'd30;
        ALUop <= ALU_AND;

        #10

        A <= 16'd16;
        B <= 16'd101;
        ALUop <= ALU_ADD;

        #10

        A <= 16'd44;
        B <= 16'd15;
        ALUop <= ALU_SUB;

        #10


        #5 $finish;
    end

endmodule