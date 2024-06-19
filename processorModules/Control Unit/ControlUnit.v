`include "constants.v"

module controlUnit(
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
        instructionCode
    );	
	
	// ----------------- INPUTS -----------------	
	
	// clock
    input wire clock;
	
    // mode
    input wire mode;

	// zero flag and negative Flag 
    input wire zeroFlag;
	
	// function code
    input wire [3:0] instructionCode; 
	
	// ----------------- OUTPUTS -----------------
	
    output reg [3:0] sigPCSrc = pcDefault;
    output reg [1:0] sigALUOp;
    output reg sigDstReg, sigRB, sigALUSrc, sigWB, sigExt, sigAddData, sigAddAddress, sigMode;

    output reg  sigENW1 = LOW,	  
                sigENW2 = LOW,
                sigMemW = LOW,
                sigMemR = LOW;	
				
    output reg  enE = LOW,
                enIF = LOW,
                enID = LOW, 
                enMem = LOW,
                enWRB = LOW;
				
	 // Code to determine stages and manage stage paths
    `define STG_FTCH 3'b000
    `define STG_DCDE 3'b001
    `define STG_EXEC 3'b010
    `define STG_MEM 3'b011
    `define STG_WRB 3'b100
    `define STG_INIT 3'b101	
	
	reg [2:0] currentStage = `STG_INIT;
    reg [2:0] nextStage = `STG_FTCH;		 
	
	
	always@(posedge clock) begin 

        currentStage = nextStage;

    end	   
	
	always@(posedge clock) begin 

        case (currentStage)

            `STG_INIT: begin                                    
                enIF = LOW;
                nextStage <= `STG_FTCH;
                 end	   
	
	 `STG_FTCH: begin 
                // Disable all previous stages leading up to IF
                enID = LOW;
                enE = LOW;
			    enMem = LOW;
			    enWRB = LOW;

                // Disable signals
                sigENW1 = LOW;		  
		        sigENW2 = LOW;
                sigMemW = LOW;
                sigMemR = LOW;

                // Enable IF
                enIF = HIGH; // Fetch after finding PC src

                // Determine next stage
                nextStage <= `STG_DCDE;	
				
		      // Determine next PC through testing of opcodes
                if (instructionCode == BGT && zeroFlag || instructionCode == BLT && zeroFlag || instructionCode == BEQ && zeroFlag || instructionCode == BNE && zeroFlag ||instructionCode == BNEZ && zeroFlag || BGTZ && zeroFlag || BLTZ && zeroFlag ) begin

                    sigPCSrc = pcSgnImm;

                end else if (instructionCode == JMP || instructionCode == CALL) begin

                    sigPCSrc = pcImm;

                end else if (instructionCode == RET) begin

                    sigPCSrc = pcRET;		//R7

                end else begin

                    sigPCSrc = pcDefault;

                end	 
            
            end	  	
			
			
	     `STG_DCDE: begin 
                // Disable all previous stages leading up to ID
                enIF = LOW;

                // Enable IF
                enID = HIGH;
                
                // Next stage is determined by opcode
				if (instructionCode == CALL || instructionCode == RET ||instructionCode == JMP) begin
					nextStage <= `STG_FTCH;
				end	
				else begin
					nextStage <= `STG_EXEC;
				end	 
		
				sigRB =(instructionCode == AND || instructionCode == ADD || instructionCode == SUB) ? LOW : HIGH;	
				sigENW1= LOW;			 
			    sigENW2 =LOW;  
				sigExt=(instructionCode==BNEZ||instructionCode==BNE||instructionCode==BEQZ||instructionCode==BEQ||instructionCode==BLTZ||instructionCode==BLT||instructionCode==BGTZ||instructionCode==BGT||instructionCode==LBs||instructionCode==LBu)  ? HIGH : LOW;
				sigDstReg =(instructionCode == CALL)? HIGH : LOW; 


            end
		
			`STG_EXEC: begin
				
                
                // Disable all previous stages leading up to execute stage
                enID = LOW;
				//sigENW1 = !sigENW1;
                // Enable execute stage
                enE = HIGH;	 
				
				sigALUSrc=(instructionCode == ADDI || instructionCode == ANDI || instructionCode == LW|| instructionCode == LBu || instructionCode == LBs|| instructionCode == SW)? HIGH : LOW; 
				
				sigMode=(instructionCode==BGTZ && mode==1||instructionCode==BLTZ && mode==1||instructionCode==BEQZ && mode==1||instructionCode==BNEZ && mode==1 ||instructionCode==LBs && mode==1)	? HIGH : LOW; 
				
				
                // Next stage is determined by opcode
                if  (instructionCode == LW || instructionCode == LBu || instructionCode == SW || instructionCode == LBs|| instructionCode ==Sv ) begin

                    nextStage <= `STG_MEM;

                end else if (instructionCode == AND || instructionCode == ADD || instructionCode == SUB || instructionCode == ANDI || instructionCode == ADDI) begin 

                    nextStage <= `STG_WRB;

                end else begin

                    nextStage <= `STG_FTCH;

                end

                // Set ALUOp signal based on the opcodes
                if (instructionCode == AND || instructionCode == ANDI) begin

                    sigALUOp = ALU_AND;

                end else if (instructionCode == ADD || instructionCode == ADDI || instructionCode == LW || instructionCode == SW) begin

                    sigALUOp = ALU_ADD;

                end else begin

                    sigALUOp = ALU_SUB;

                end	
				sigENW1 = LOW;
                sigENW2 = LOW;
            end	
			
			`STG_MEM: begin 
				enMem = HIGH;
                // Disable all previous stages leading up to memory stage
				enE = LOW;
				enID = LOW;

                // Enable memory stage
				
                
                // Next stage determined by opcodes
                nextStage <= (instructionCode == LW ||instructionCode == LBu ||instructionCode == LBs) ? `STG_WRB : `STG_FTCH;

                // Memory write is determined by the SW instruction
				sigMemW	=(instructionCode==Sv||instructionCode==SW)? HIGH : LOW; 
				
                // Memory Read is determined by Load instructions
                 sigMemR=(instructionCode==LBs||instructionCode==LBu||instructionCode==LW)  ? HIGH : LOW; 

                // Signals determined by opcodes 
			    sigAddData=(instructionCode==Sv)? HIGH : LOW; 
				
				sigAddAddress=(instructionCode==Sv)? HIGH : LOW; 	
				
				sigExt=(instructionCode==BNEZ||instructionCode==BNE||instructionCode==BEQZ||instructionCode==BEQ||instructionCode==BLTZ||instructionCode==BLT||instructionCode==BGTZ||instructionCode==BGT||instructionCode==LBs||instructionCode==LBu)  ? HIGH : LOW;
				

                end
				
			`STG_WRB: begin
				enWRB=HIGH;	
                // Disable all previous stages leading up to WRB
                sigMemW = LOW;
                sigMemR = LOW;
                enE = LOW;
				enMem = LOW;

                // Enable WRB stage
				sigRB =~(instructionCode == AND || instructionCode == ADD || instructionCode == SUB) ?LOW : HIGH;	
                
                // Next stage following WRB is IF
                nextStage <= `STG_FTCH;

                // Enable writing to register filw
				sigENW1=(instructionCode == AND || instructionCode == ADD || instructionCode == SUB||instructionCode==LBs||instructionCode==LBu||instructionCode==LW||instructionCode==ADDI||instructionCode==ANDI)? HIGH : LOW; 
				sigENW2=(instructionCode ==CALL)? HIGH : LOW;  
                // Determine the register to write to
				sigWB =(instructionCode==LBs||instructionCode==LBu||instructionCode==LW)  ? HIGH : LOW;
                // Set to 1 for all instructions
				sigDstReg =(instructionCode == CALL)? HIGH : LOW; 	
				
				sigExt=(instructionCode==BNEZ||instructionCode==BNE||instructionCode==BEQZ||instructionCode==BEQ||instructionCode==BLTZ||instructionCode==BLT||instructionCode==BGTZ||instructionCode==BGT||instructionCode==LBs||instructionCode==LBu)  ? HIGH : LOW;

            end		

        endcase
    end



endmodule




				
				
				