`include "constants.v"
// PC register and its logic

// PC src can be one of the following:
// 0- PC + 2	 
// 1- Jump target address (if instruction is J-Type: JMP, CALL)
// 2- Branch target address (if instruction is I-Type & function is BEQ and zero flag is 1)
// 3- R7 (if instruction is RET)

module pcModule(clock, PC, I_TypeImmediate, J_TypeImmediate, R7, sig_pc_src);

    // ----------------- INPUTS -----------------

    // clock
    input wire clock;
    
    // PC source signal
    input wire [1:0] sig_pc_src;

    //R7
    input wire [15:0] R7;

    // extended I-Type immediate bus
    input wire [15:0] I_TypeImmediate;

    // extended J-Type immediate bus
    input wire signed [15:0] J_TypeImmediate;

    // ----------------- OUTPUTS -----------------

    // PC
    output reg [15:0] PC;

    // ----------------- INTERNALS -----------------

    // PC + 4
    wire [15:0] pc_plus_2;

    // JTA
    wire [15:0] jump_target_address;

    // BTA
    wire [15:0] brach_target_address;
    
    assign pc_plus_2 = PC + 16'd2;
    assign jump_target_address = PC + J_TypeImmediate;
    assign brach_target_address = PC + I_TypeImmediate;

    initial begin
		PC <= 16'd0;
	end


    always @(posedge clock) begin
        case (sig_pc_src)
            pcDefault: begin
                // default      : PC = PC + 2
                PC = pc_plus_2;      
            end  
            pcRET:  begin
                // R7       : PC = R7
                PC = R7;  
            end  
            pcSgnImm: begin
                // Taken Branch : PC = PC + J_TypeImmediate
                PC = brach_target_address;
            end  
            pcImm: begin
                // Jump         : PC = PC + I_TypeImmediate
                PC = jump_target_address;
            end  
        endcase
	end

    

endmodule