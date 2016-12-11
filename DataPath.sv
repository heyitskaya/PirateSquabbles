module DataPath(clock, pcQ, instr, pcD, regWriteEnable);

   // The clock will be driven from the testbench 
   // The instruction, pcQ and pcD are sent to the testbench to
   // make debugging easier
   

   input logic clock;
   output logic [31:0] instr;
   output logic [31:0] pcQ;
   output logic [31:0] pcD;
   output logic [0:0] regWriteEnable;
   
   // The PC is just a register
   // for now, it is always enabled so it updates on every clock cycle
   // Its ports are above
   
   enabledRegister PC(pcD,pcQ,clock,1'b1);

   // set up a hard-wired connection to a value
   
   logic [31:0] constant4;

   initial
     constant4 <= 32'b100;

   // construct the adder for the PC incrementing circuit.

   logic [31:0] adderIn1, adderIn2, adderOut;
   
   adder psAdd(adderIn1,adderIn2,adderOut);

   // Connect the adder to the right inputs and output
   // notice that using pcD and pcQ here and above in the PC register is like
   // connecting a wire  BUT the wires have a direction. E.g. the first
   // line below says a signal goes from pcQ to adderIn1
   
   assign adderIn1 = pcQ;
   assign adderIn2 = constant4;
   assign pcD = adderOut;

   
   // construct the instuctionmemory
   // wired to PC and instruction

   logic [31:0] instA;
   
   
   instructionMemory imem(instA,instr);

   // Wire instruction memory

   assign instA = pcQ;

   // construct the control unit  This unit generates the signals that control the datapath
   // it will have many more ports later


   logic [0:0] 	memWrite,alu4,alu3, alu2, alu1, alu0, ALUSrc,MemToReg,RegDst;
   
   
   Control theControl(instr, memWrite, regWriteEnable,MemToReg, ALUSrc,RegDst,alu4,alu3,alu2, alu1, alu0);
   
   
   // construct the register file with (currently mostly) unused values to connect to it
   
   logic [4:0] 	       A3, A2, A1; //5 bits
   logic 	       WE3;     //1 bit
   logic [31:0]        WD3, RD1, RD2;  //32 bits
   

   
   registerFile theRegisters(A1,A2, 
			     A3, clk, WE3, WD3, RD1, RD2);

   // attach the A1 port to 5 bits of the instruction

   
   logic [31:0]   RD;

   assign clk = clock;
   assign A1 = instr[25:21]; //attaching A1 to 5 bits of the instruction
   assign A2 = instr[20:16]; //attaching A2
   
//   assign A3 = instr[20:16]; //attaching A3 to 20-16 bits of instruction
   
   
   assign WE3 = regWriteEnable;

  
   
   
   
   logic [31:0]        SignImm;

   // sign extend the immediate field
   //  
   assign SignImm = {{16{instr[15]}}, instr[15:0]};

   logic [31:0]        SrcA, SrcB,ALUResult;
  
   logic [0:0] 	       selector0,selector1,selector2,selector3,selector4;
 	       


   
   ALU theALU(SrcA, SrcB, selector0,selector1,selector2,selector3,selector4, ALUResult); //changed from 5 bit 0 to ALUSelect
   
  
   assign selector0=alu0;  //assign the bits
   assign selector1=alu1;
   assign selector2=alu2;
   assign selector3 = 1'b0;
   assign selector4 = 1'b0;
   
   
   
   assign SrcA=RD1;
  // assign SrcB=SignImm; //got rid of this
   

   
   
   logic [31:0]        WD, dataA, WD3_pre , SrcB_pre;
   logic [0:0] 	       WE;
   logic [4:0] 	       A3_pre; //5 bits
   

   dataMemory data(dataA, RD, WD, clk, WE);

   mux2to1B5 muxReg(RegDst,instr[15:11],instr[20:16],A3_pre);

   //mux with ALUSrc
  //  selector
   //2 selector lines 4 inputs
   mux4to1B32 aluMux(1'b0,ALUSrc,32'b0,32'b0, SignImm, RD2, SrcB_pre); //change this?

   //mux with MemToReg selector
   mux4to1B32 memToRegMux(1'b0,MemToReg,32'b0,32'b0, RD, ALUResult, WD3_pre);

   
    
  // mux4to1B32 aluControlMux(1'b0,ALUControl,32'b0,32'b0, SrcB, SrcA, ALUResult);
  // assign MemToReg=
   
 
   assign dataA=ALUResult;
   assign clk=clock;
   assign WD3=WD3_pre;
   assign A3=A3_pre;
   
   assign SrcB=SrcB_pre; //added this assign
   assign WD=RD2;
   assign WE=memWrite;
  
    always @ (negedge clk)
      begin
	// $display("SrcA ",SrcA);
	// $display("SrcB ",SrcB);
	 $display("ALUSrc ",ALUSrc);
	 $display("WD3_pre ", WD3_pre);
	 $display("RD ", RD);
	 $display("selector2 ",selector2);

	 $display("selector1 ",selector1);
	 $display("selector0 ",selector0);	 
	 
	 
	 
	 
	$display("ALUresult %h ",ALUResult);
     
	
     end

endmodule

