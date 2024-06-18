`include "constant.v"

module controlUnitTestBench;

    reg clock;
    reg [3:0] instructionCode;
    reg zeroFlag, mode;

    // Output signals
    wire [1:0] sigPCSrc, sigALUOp;
    wire sigDstReg, sigRB, sigALUSrc, sigWB, sigExt, sigAddData, sigAddAddress, sigMode;
    wire sigENW1, sigENW2, sigMemW, sigMemR;

    // Stage enable signals
    wire enE, enIF, enID, enMem, enWRB;

    controlUnit control_unit(
        .clock(clock),

        // Signal outputs
        .sigPCSrc(sigPCSrc),   
		.sigRB(sigRB),	
		.sigENW1(sigENW1),
        .sigENW2(sigENW2),	
        .sigALUSrc(sigALUSrc),	
        .sigExt(sigExt),	
        .sigALUOp(sigALUOp),
        .sigAddAddress(sigAddAddress),
        .sigAddData(sigAddData),
        .sigMemR(sigMemR),
        .sigMemW(sigMemW),
        .sigWB(sigWB),		
        .sigMode(sigMode),		
        .sigDstReg(sigDstReg),

        // Enable signals
        .enIF(enIF),
        .enID(enID),
        .enE(enE),
        .enMem(enMem),
        .enWRB(enWRB),

        // Inputs
        .zeroFlag(zeroFlag),
        .mode(mode),

        // Opcode
        .instructionCode(instructionCode)
    );

    initial begin
        // Initialize the clock
        clock = 0;
        forever #10 clock = ~clock; // 50 MHz clock
    end

    initial begin
        // Initialize inputs
        zeroFlag = 0;
        mode = 0;
        instructionCode = 4'b0000;

        // Testing different instructions

        // R-Type Instructions
        instructionCode = 4'b0000; // AND
        #40;
        instructionCode = 4'b0001; // ADD
        #40;
        instructionCode = 4'b0010; // SUB
        #40;

        // I-Type ALU Instructions
        instructionCode = 4'b0011; // ANDI
        #40;
        instructionCode = 4'b0100; // ADDI
        #40;

        // Load/Store Instructions
        instructionCode = 4'b0101; // LW
        #50;
        instructionCode = 4'b0110; // LBu
        #50;
        instructionCode = 4'b0111; // LBs
        #50;
        instructionCode = 4'b1000; // SW
        #40;

        // Branch Instructions
        instructionCode = 4'b1001; // BGT and Taken
        zeroFlag = 1;
        #30;
        instructionCode = 4'b1001; // BGT and not Taken
        zeroFlag = 0;
        #30;
        instructionCode = 4'b1010; // BLT and Taken
        zeroFlag = 1;
        #30;
        instructionCode = 4'b1010; // BLT and not Taken
        zeroFlag = 0;
        #30;
        instructionCode = 4'b1011; // BEQ and Taken
        zeroFlag = 1;
        #30;
        instructionCode = 4'b1011; // BEQ and not Taken
        zeroFlag = 0;
        #30;

        // J-Type Instructions
        instructionCode = 4'b1100; // JMP
        #20;
        instructionCode = 4'b1101; // CALL
        #30;
        instructionCode = 4'b1110; // RET
        #30;

        // Sv Instruction
        instructionCode = 4'b1111; // Sv
        #40;
        instructionCode = 4'b1111; // Sv 
        mode = 1;
        #40;



        #10 $finish;
    end

    initial begin
        $monitor("Time: %0d, PCSrc: %b,RB: %b,ENW1: %b, ENW2: %b, ALUSrc: %b,Ext: %b, ALUOp: %b,AddAddress: %b,AddData: %b,MemR: %b, MemW: %b,Mode: %b,WB: %b, DstReg: %b,  enIF: %b, enID: %b, enE: %b, enMem: %b, enWRB: %b",
            $time, sigPCSrc, sigRB, sigENW1, sigENW2,sigALUSrc,sigExt,sigALUOp,sigAddAddress,  sigAddData, sigMemR, sigMemW,sigMode,sigWB, sigDstReg,enIF, enID, enE, enMem, enWRB);
    end

endmodule
