/*
As you are given it, this ALU only implements Add
  */

module ALU(input logic  [31:0] I1,

	   input logic [31:0] I2,
	   input logic[0:0] selector0, 
	   input logic[0:0] selector1,
	   input logic[0:0] selector2,
	   input logic[0:0] selector3,
	   input logic[0:0] selector4,
	   output logic [31:0] O
	   ); //use a five bit selector line
	
   logic [31:0] sum,lw,sw,jr,jal,nor2,nori,not2,bleu,rolv,rorv;
   logic [31:0] result, result1, result2;
   
   


   //the mux
   mux4to1B32 mpxA11(selector1,selector0,rorv,rolv,not2,nori,result1 );

   mux4to1B32 mpxA12(selector1,selector0,nor2,sw,lw, sum, result2);

   mux4to1B32 mpxA1(1'b0,selector2,32'b0,32'b0,result1,result2,result); //outputs result
   
   
  assign sum = I1 + I2;
  assign lw = sum; 
  assign sw = sum;

  //for not
   assign not2= ~I1;
   
   //not
   assign nor2= ~(I1|I2); //being put into register 2 not 3
   assign nori= ~(I1|I2);
  // assign bleu =(I1-I2); //subtract the values in the ALU

   assign jr=I1; //jumpt to location in Rs unconditionally
   
   
   
   
   
 

   assign O =result;
  // $display("result ",result);
   
   
	
endmodule
