// stores program instructions ( used 16 bit cells )

module instructionMemory(clock, AddressBus, InstructionReg);

    // ----------------- INPUTS -----------------

    // clock
    input wire clock;

    // address bus
    input wire [15:0] AddressBus;

    // ----------------- OUTPUTS -----------------

    // instruction register
    output reg [15:0] InstructionReg;

    // ----------------- INTERNALS -----------------

    // instruction memory
    reg [15:0] instruction_memory [0:255]; // Each instruction is 16 bits, memory size can be adjusted as needed

    // ----------------- LOGIC -----------------

    always @(posedge clock) begin
        InstructionReg <= instruction_memory[AddressBus];
    end

    // ----------------- INITIALIZATION -----------------

    initial begin
        // load instructions from file
        // $readmemh("instructions.txt", instruction_memory);

        // instruction formats:
        // R-Type Instruction Format
        // Opcode_4, Rd_3, Rs1_3, Rs2_3, Unused_3

        // I-Type Instruction Format
        // Opcode_4, m_1, Rd_3, Rs1_3, Immediate_5

        // J-Type Instruction Format
        // Opcode_4, Jump_Offset_12

        // S-Type Instruction Format
        // Opcode_4, Rs_3, Immediate_8

        // ----------------- Addition Loop Program -----------------

        // // R1 = 2
        // instruction_memory[1] = { 4'b0011, 1'b0, 3'b001, 3'b000, 5'd2 }; // ADDI R1, R0, 2

        // // R2 = 3
        // instruction_memory[2] = { 4'b0011, 1'b0, 3'b010, 3'b000, 5'd3 }; // ADDI R2, R0, 3

        // // R3 = R1 + R2
        // instruction_memory[3] = { 4'b0001, 3'b011, 3'b001, 3'b010, 3'b000 }; // ADD R3, R1, R2

        // // R3 = R3 + R3
        // instruction_memory[4] = { 4'b0001, 3'b011, 3'b011, 3'b011, 3'b000 }; // ADD R3, R3, R3

        // // Jump -4; jump to instruction_memory[3]
        // instruction_memory[5] = { 4'b1100, 12'd3 }; // JMP -4

        // // SUB R3, R1, R2; subtract R1 and R2 and store in R3
        // instruction_memory[6] = { 4'b0010, 3'b011, 3'b001, 3'b010, 3'b000 }; // SUB R3, R1, R2

        // ----------------- Shift Loop Program -----------------

        // // R1 = 8
        // instruction_memory[1] = { 4'b0011, 1'b0, 3'b001, 3'b000, 5'd8 }; // ADDI R1, R0, 8

        // // R2 = 14
        // instruction_memory[2] = { 4'b0011, 1'b0, 3'b010, 3'b000, 5'd14 }; // ADDI R2, R0, 14

        // // R3 = R1 & R2 = 8
        // instruction_memory[3] = { 4'b0000, 3'b011, 3'b001, 3'b010, 3'b000 }; // AND R3, R1, R2

        // // R4 = 2
        // instruction_memory[4] = { 4'b0011, 1'b0, 3'b100, 3'b000, 5'd2 }; // ADDI R4, R0, 2

        // // R5 = R3 >> 3 = 1
        // instruction_memory[5] = { 4'b0100, 1'b0, 3'b101, 3'b011, 5'd3 }; // SLR R5, R3, 3

        // // R6 = R3 << R4 = 32
        // instruction_memory[6] = { 4'b0101, 1'b0, 3'b110, 3'b011, 3'b100, 3'b000 }; // SLLV R6, R3, R4

        // // Jump -4; jump to instruction_memory[5]
        // instruction_memory[7] = { 4'b1100, 12'd5 }; // JMP -4

        // ----------------- Branch Program -----------------

        // R1 = 8
        instruction_memory[0] = { 4'b0011, 1'b0, 3'b001, 3'b000, 5'd8 }; // ADDI R1, R0, 8

        // R2 = 14
        instruction_memory[2] = { 4'b0011, 1'b0, 3'b010, 3'b000, 5'd14 }; // ADDI R2, R0, 14

        // Branch +8 if R1 == R2 ( Not Taken )
        instruction_memory[3] = { 4'b1010, 1'b0, 3'b001, 3'b010, 5'd8 }; // BEQ R1, R2, 8

        // R1 = 14
        instruction_memory[4] = { 4'b0011, 1'b0, 3'b001, 3'b000, 5'd14 }; // ADDI R1, R0, 14

        // Branch +8 if R1 == R2 ( Taken )
        instruction_memory[5] = { 4'b1010, 1'b0, 3'b001, 3'b010, 5'd8 }; // BEQ R1, R2, 8

        // dead code should not be executed
        // R4 = 1
        instruction_memory[6] = { 4'b0011, 1'b0, 3'b100, 3'b000, 5'd1 }; // ADDI R4, R0, 1

        // R5 = 2
        instruction_memory[1] = { 4'b0011, 1'b0, 3'b101, 3'b000, 5'd2 }; // ADDI R5, R0, 2
    end

endmodule
