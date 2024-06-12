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
		
		// instruction formats:
        // R-Type Instruction Format
        // Opcode_4, Rd_3, Rs1_3, Rs2_3, Unused_3

        // I-Type Instruction Format
        // Opcode_4, m_1, Rd_3, Rs1_3, Immediate_5

        // J-Type Instruction Format
        // Opcode_4, Jump_Offset_12

        // S-Type Instruction Format
        // Opcode_4, Rs_3, Immediate_9
		/*******************************************************/
		
        // R-Type Instructions
        // AND R1, R2, R3
        instruction_memory[0] = {4'b0000, 3'b001, 3'b010, 3'b011, 3'b000}; // AND R1, R2, R3
        // ADD R1, R2, R3
        instruction_memory[1] = {4'b0001, 3'b001, 3'b010, 3'b011, 3'b000}; // ADD R1, R2, R3
        // SUB R1, R2, R3
        instruction_memory[2] = {4'b0010, 3'b001, 3'b010, 3'b011, 3'b000}; // SUB R1, R2, R3
        
        // I-Type Instructions
        // ADDI R1, R0, 8
        instruction_memory[3] = {4'b0011, 1'b0, 3'b001, 3'b000, 5'd8}; // ADDI R1, R0, 8
        // ANDI R1, R0, 12
        instruction_memory[4] = {4'b0100, 1'b0, 3'b001, 3'b000, 5'd12}; // ANDI R1, R0, 12
        // LW R1, 10(R2)
        instruction_memory[5] = {4'b0101, 1'b0, 3'b001, 3'b010, 5'd10}; // LW R1, 10(R2)
        // LBu R1, 15(R2)
        instruction_memory[6] = {4'b0110, 1'b0, 3'b001, 3'b010, 5'd15}; // LBu R1, 15(R2)
        // LBs R1, 15(R2)
        instruction_memory[7] = {4'b0110, 1'b1, 3'b001, 3'b010, 5'd15}; // LBs R1, 15(R2)
        // SW R1, 20(R2)
        instruction_memory[8] = {4'b0111, 1'b0, 3'b001, 3'b010, 5'd20}; // SW R1, 20(R2)
        // BGT R1, R2, 5
        instruction_memory[9] = {4'b1000, 1'b0, 3'b001, 3'b010, 5'd5}; // BGT R1, R2, 5
        // BGTZ R1, 5
        instruction_memory[10] = {4'b1000, 1'b1, 3'b001, 3'b000, 5'd5}; // BGTZ R1, 5
        // BLT R1, R2, 5
        instruction_memory[11] = {4'b1001, 1'b0, 3'b001, 3'b010, 5'd5}; // BLT R1, R2, 5
        // BLTZ R1, 5
        instruction_memory[12] = {4'b1001, 1'b1, 3'b001, 3'b000, 5'd5}; // BLTZ R1, 5
        // BEQ R1, R2, 5
        instruction_memory[13] = {4'b1010, 1'b0, 3'b001, 3'b010, 5'd5}; // BEQ R1, R2, 5
        // BEQZ R1, 5
        instruction_memory[14] = {4'b1010, 1'b1, 3'b001, 3'b000, 5'd5}; // BEQZ R1, 5
        // BNE R1, R2, 5
        instruction_memory[15] = {4'b1011, 1'b0, 3'b001, 3'b010, 5'd5}; // BNE R1, R2, 5
        // BNEZ R1, 5
        instruction_memory[16] = {4'b1011, 1'b1, 3'b001, 3'b000, 5'd5}; // BNEZ R1, 5
        
        // J-Type Instructions
        // JMP 10
        instruction_memory[17] = {4'b1100, 12'd10}; // JMP 10
        // CALL 20
        instruction_memory[18] = {4'b1101, 12'd20}; // CALL 20
        // RET
        instruction_memory[19] = {4'b1110, 12'b0}; // RET
        
        // S-Type Instructions
        // Sv R2, 255
        instruction_memory[20] = {4'b1111, 3'b010, 9'd255}; // Sv R2, 255
    end

endmodule
