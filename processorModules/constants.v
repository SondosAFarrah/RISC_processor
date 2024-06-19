parameter
// Kept these just in case
// Levels

    LOW = 1'b0,
    HIGH = 1'b1,

// Instruction codes
// 4-bit instruction code

	// R-Type Instructions

    AND = 4'b0000, // Reg(Rd) = Reg(Rs1) & Reg(Rs2) 
    ADD = 4'b0001, // Reg(Rd) = Reg(Rs1) + Reg(Rs2) 
    SUB = 4'b0010, // Reg(Rd) = Reg(Rs1) - Reg(Rs2)

    // I-Type Instructions
	
    ADDI = 4'b0011, // Reg(Rd) = Reg(Rs1) & Immediate5
    ANDI = 4'b0100, // Reg(Rd) = Reg(Rs1) + Immediate5
    LW   = 4'b0101, // Reg(Rd) = Mem(Reg(Rs1) + Imm_5)	
    LBu  = 4'b0110, //Reg(Rd) = Mem(Reg(Rs1) + Imm_5)   
	LBs  = 4'b0110,// 	Reg(Rd) = Mem(Reg(Rs1) + Imm_5) 
	
    SW   = 4'b0111, // Mem(Reg(Rs1) + Imm_14) = Reg(Rd)
	BGT  = 4'b1000, /*  if (Reg(Rd) > Reg(Rs1)) 
 							Next PC = PC + sign_extended (Imm)
						else PC = PC + 2*/
	BGTZ = 4'b1000, /* if (Reg(Rd) > Reg(0)) 
 							Next PC = PC + sign_extended (Imm)
						else PC = PC + 2*/
	BLT  = 4'b1001, /* if (Reg(Rd) < Reg(Rs1)) 
 							Next PC = PC + sign_extended (Imm)
						else PC = PC + 2*/	 
	BLTZ = 4'b1001,/* if (Reg(Rd) < Reg(R0)) 
 							Next PC = PC + sign_extended (Imm)
						else PC = PC + 2*/	
			
     BEQ  = 4'b1010, /* if (Reg(Rd) == Reg(Rs1)) 
 							Next PC = PC + sign_extended (Imm)
						else PC = PC + 2*/		  
	BEQZ = 4'b1010,/*if (Reg(Rd) == Reg(R0)) 
 						Next PC = PC + sign_extended (Imm)
					else PC = PC + 2*/
	BNE  = 4'b1011, /* if (Reg(Rd) != Reg(Rs1)) 
 						Next PC = PC + sign_extended (Imm) */		 
	BNEZ = 4'b1011,/* if (Reg(Rd) != Reg(Rs1)) 
 							Next PC = PC + sign_extended (Imm)
						else PC = PC + 2*/
		
    // J-Type Instructions
	
    JMP    = 4'b1100, // Next PC = {PC[15:10], Immediate} 
    CALL  = 4'b1101, /* Next PC = {PC[15:10], Immediate}
						PC + 4 is saved on r15 */
	RET = 4'b1110, // Next PC = r7

    // S-Type Instructions
	
    Sv  = 4'b1111, // M[rs] = imm		
	

// *Signals*

// PC src
// 2-bit select to determine next PC value

	pcDefault = 2'b00, // PC = PC + 1
	pcImm = 2'b01, // jump address
	pcSgnImm = 2'b10, // branch target address
	pcRET = 2'b11, // PC = R7(RET)
	

// Dst Reg
// 1-bit select to determine on which register to write

	//R7 = 1'b0, // RW = R7
	Rd = 1'b1, // RW = Rd

// RB
// 1-bit select to determine second register

	Rs2 = 1'b0, // RB = Rs2
	Rsd = 1'b1, // RB = Rd 
	//Rd = 1'b1, // RW = Rd

// En W
// 1-bit select to E/D write on registers

	WD = 1'b0, // Write enabled
	WE = 1'b1, // Write disabled

	
// ALU src
// 1-bit source select to determine first input of the ALU

	Imm = 1'b0,	// B = Immediate
	BusB = 1'b1, // B = BusB
	
// ALU op
// 2-bit select to determine operation of ALU

	ALU_AND = 2'b00,
	ALU_ADD = 2'b01,
	ALU_SUB = 2'b10,
						  
// Mem R
// 1-bit select to enable read from memory	

	MRD = 1'b0,	// Memory read disabled
	MRE = 1'b1, // Memory read enabled

// Mem W
// 1-bit select to enable write to memory  

	MWD = 1'b0,	// Memory write disabled
	MWE = 1'b1, // Memory write enabled		   
	
// WB									   
// 1-bit select to determine return value from stage 5 
								
	WBALU = 1'b0, // Data from ALU
	WBMem = 1'b1, // Data from memory
	
// ext
// 1-bit select to determine logical or signed extension 

	logExt = 1'b0, // Logical extension
	sgnExt = 1'b1, // Signed extension
	
//Data signal

	
// stack/mem
// 1-bit select to store address of data in memory or push on stack	  
	
	//WBALU = 1'b0, // Data from ALU
	BusA = 1'b1, // Calculate address of the memory
	
// address/data
// 1-bit select to determine source of data to be stored in memory

	//Imm = 1'b0,	// B = Immediate
	//BusB = 1'b1, // B = BusB
	
// 8 registers

    R0 = 3'd0, // zero register
    R1 = 3'd1, // general purpose register
    R2 = 3'd2, // general purpose register
    R3 = 3'd3, // general purpose register
    R4 = 3'd4, // general purpose register
    R5 = 3'd5, // general purpose register
    R6 = 3'd6, // general purpose register
    R7 = 3'd7; // general purpose register

    