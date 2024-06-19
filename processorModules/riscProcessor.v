`include "constants.v"
module riscProcessor();
		
    initial begin		 
		#0 
        $display("(%0t) > initializing processor ...", $time);
		
        #450 $finish;
    end
														  
	
    // clock generator wires/registers
	wire clock;
	wire enIF, enID, enE, enMem, enWRB;
	
    // ----------------- Control Unit -----------------
								   
	wire [3:0] sigPCSrc; 
    wire [1:0] sigALUOp;
	wire sigRB, sigDstReg, sigALUSrc, sigExt, sigENW1,sigENW2,  sigAddData, sigMemR, sigMemW, sigWB,sigAddAddress,sigMode;
	wire zeroFlag;
	

    // ----------------- Instrution Memory -----------------

    // instruction memory wires/registers		
    wire [15:0] PC; // output of PC Module input to instruction memory
    reg [15:0] InstructionMem; // output if instruction memory, input to other modules
	
    // Instruction Parts
    wire [3:0] OpCode; // function code

    // R-Type
    wire [2:0] Rs1, Rd, Rs2; // register selection
	wire  mode;
    
	
	// ----------------- Register File -----------------
	wire [2:0] RA, RB, RW;
	wire [15:0] BusA, BusB, BusW1 , BusW2,BusAC;
	
	// ----------------- ALU -----------------
	wire [15:0] A, B;
	wire [15:0] ALURes;
	
	
	// ----------------- Data Memory -----------------
	wire [15:0]	AddressBus, InputBus,OutputBus; 
	assign AddressBus = (sigAddAddress == LOW) ? ALURes : BusA;
	assign InputBus = (sigAddData == LOW ) ? BusB :  extendedImm5;
	
    // ----------------- Assignment -----------------

    // Function Code
    assign OpCode = InstructionMem[15:12];

    // R-Type
	
    assign Rd = (OpCode==ADD ||OpCode== AND ||OpCode==SUB ||OpCode==Sv)?InstructionMem[11:9] :InstructionMem[10:8] ;
    assign Rs1 = (OpCode==ADD ||OpCode== AND ||OpCode==SUB ||OpCode==Sv)? InstructionMem[8:6] : InstructionMem[7:5];
    assign Rs2 = InstructionMem[5:3];								 

    // I-Type
    wire signed [4:0] Imm5;
    assign Imm5 = InstructionMem[4:0];
	assign mode = InstructionMem[11];
	
	// J-Type
	wire [11:0]	Imm12;
	assign Imm12 = InstructionMem[11:0];
	
						  
	// S-Type
	wire [8:0]	Imm9;
	assign Imm9 = InstructionMem[8:0];
																				
    // ----------------- Register File -----------------
	wire [15:0] WBOutput;
	wire EnReg;
    assign RA = Rs1;
    assign RB = (sigRB == LOW) ? Rs2 : Rd;
    assign RW = (sigDstReg == LOW) ? Rd : 3'b111; 
	assign EnReg = (enID || enWRB);
	assign BusW1 =  WBOutput; 
	assign BusW2 =  (PC + 2'd2);
	

    // ----------------- ALU -----------------
	wire [15:0] extendedImm5 ,extendedImm12 ;
	wire [15:0] signExtendedImm, zeroExtendedImm;
	assign signExtendedImm = {{11{Imm5[4]}}, Imm5};
	assign zeroExtendedImm = {{11{1'b0}}, Imm5};
	assign extendedImm5 = (sigExt == HIGH) ?  signExtendedImm: zeroExtendedImm;
	assign A = BusA;
	assign B = (sigALUSrc == LOW) ? BusB : extendedImm5;	
	assign BusAC = (sigMode==LOW) ? BusA : 3'b000;
    assign extendedImm12 = {{4{Imm12[11]}}, Imm12};
    										  
	ClockGenerator clock_generator(.clock(clock) );

    // -----------------------------------------------------------------
    // ----------------- Control Unit -----------------
    // -----------------------------------------------------------------
    

    controlUnit cu(
        clock,

         // signal outputs
        sigPCSrc,
        sigDstReg,
        sigRB,
        sigENW1,  
        sigENW2,
        sigALUSrc,
        sigALUOp,
        sigExt,
        sigAddData,
        sigMemR,
        sigMemW,
        sigWB,
        sigAddAddress,
        sigMode,

        // Enable signals to be outputted by the CU
        enIF, // enable instruction fetch
        enID, // enable instruction decode
        enE,  // enable execute
        enMem,// enable memory
        enWRB,

        // inputs
        zeroFlag, 
        mode,

        // Opcode to determine signals
        OpCode
    );


    // -----------------------------------------------------------------
    // ----------------- PC Module -----------------
    // -----------------------------------------------------------------

    pcModule pcMod(enIF, PC, extendedImm5, extendedImm12,r7, sigPCSrc);
	
	// -----------------------------------------------------------------
    // ----------------- Instruction Memory -----------------
    // -----------------------------------------------------------------
    
    instructionMemory insMem(enIF, PC, InstructionMem);
	
    // -----------------------------------------------------------------
    // ----------------- Register File -----------------
    // -----------------------------------------------------------------
									  			  	
	wire [15:0] registers_array [0:7]; 
	wire [15:0] r7 = registers_array[7];
    registerFile regFile(clock, RA, RB, RW, sigENW1,sigENW2, BusW1, BusW2, BusA, BusB,registers_array);
	                                      
    // -----------------------------------------------------------------
    // ----------------- ALU -----------------
    // -----------------------------------------------------------------

    ALU alu(A, B, ALURes, OpCode, enE); 
			
		   
	// -----------------------------------------------------------------
    // ----------------- Comparator -----------------
    // ----------------------------------------------------------------- 
	comparator comp(BusAC,BusB,OpCode,zeroFlag);
	
    // -----------------------------------------------------------------
    // ----------------- Data Memory -----------------
    // -----------------------------------------------------------------
	wire [15:0] memory [0:255];
    dataMemory dataMem(enMem, AddressBus, InputBus, OutputBus, sigMemW, sigMemR,memory);

    // -----------------------------------------------------------------
    // ----------------- Write Back -----------------
    // -----------------------------------------------------------------

    assign WBOutput = (sigWB == 0) ? ALURes : OutputBus;


endmodule