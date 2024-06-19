`include "constants.v"
module pcModuleTestBench ();

    // ----------------- CLOCK -----------------
    
    // clock generator wires/registers
	wire clock;

	// generates clock square wave with 10ns period
	ClockGenerator clock_generator(clock);

    // ----------------- PC Module Ports -----------------
 
    // register file wires/registers
    reg [3:0] sig_pc_src = pcDefault;
    reg [15:0] R7;
    reg signed [15:0] J_TypeImmediate, I_TypeImmediate;
    wire [15:0] PC;
    
    pcModule pc_module(clock, PC, I_TypeImmediate, J_TypeImmediate, R7, sig_pc_src);
    
    // ----------------- Simulation -----------------

    initial begin

        
        // test the pc module by using different inputs and checking if the outputs are correct

        #0
        $display("(%0t) > PC=%0d", $time, PC);
        sig_pc_src <= pcDefault; // PC source default

        #10
        $display("(%0t) > PC=%0d", $time, PC);
        sig_pc_src <= pcRET; // PC source default
        R7 <= 16'd2; // write value 2

        #10
        $display("(%0t) > PC=%0d", $time, PC);
        sig_pc_src <= pcImm; // PC source default
        J_TypeImmediate <= 16'd10; // add 10 to PC

        #10
        $display("(%0t) > PC=%0d", $time, PC);
        sig_pc_src <= pcImm; // PC source default
        J_TypeImmediate <= -16'd10; // subtract 10 from PC

        #10
        $display("(%0t) > PC=%0d", $time, PC);
        sig_pc_src <= pcSgnImm; // PC source default
        I_TypeImmediate <= 16'd8; // add to PC via taken branch

        #10
        // results of previouse cycle
        $display("(%0t) > PC=%0d", $time, PC);

        #10 $finish;    // 100 cycle
    end

endmodule