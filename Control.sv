module Control(ins, MemWrite, regWriteEnable,MemToReg,ALUSrc, RegDst,alu4,alu3,alu2, alu1,alu0);

   input logic [31:0] ins;
   output logic [0:0] MemToReg ,MemWrite, regWriteEnable,ALUSrc,RegDst,alu4,alu3,alu2,alu1, alu0;


   logic [0:0] lw, sw,add,jr,jal,nor2,nori,not2,bleu,rolv,rorv; //add others later

   
   assign lw = ins[31] & ~ins[30] & ~ins[29] & ~ins[28] & ins[27] & ins[26];
   assign sw = ins[31] & ~ins[30] & ins[29] & ~ins[28] & ins[27] & ins[26];
   assign add= ins[31] & ~ins[30] & ~ins[29]& ~ins[28] & ~ ins[27] & ~ins[26];
   assign jr = ~ins[31] & ~ins[30] &ins[29] & ~ins[28] & ~ ins[27] & ~ins[26];
   assign jal =  ~ins[31] & ~ins[30] & ~ins[29] & ~ins[28] & ins[27] & ins[26];
   assign nor2=  ins[31] & ~ins[30] & ~ins[29] & ins[28] & ins[27] & ~ins[26];
   assign nori= ~ins[31] & ~ins[30]& ins[29] & ins[28] & ins[27] & ~ins[26];
   assign not2=  ~ins[31] & ~ins[30] & ~ins[29] & ins[28] & ~ ins[27] & ~ins[26];
   assign bleu= ~ins[31] & ins[30] & ~ins[29]& ~ins[28] & ~ ins[27] & ~ins[26];
   assign rolv= ~ins[31] & ~ins[30] & ~ins[29] & ~ins[28] & ~ins[27] & ~ins[26];
   assign rorv= ~ins[31] & ~ins[30] & ~ins[29] & ~ins[28] & ins[27] & ~ins[26];
   //alu2 alu1 alu0
   //add 000 0
   //lw 001 1
   //sw 010 2
   //nor 011 3
   //nori 100 4
   //not 101 5
   //rolv 110 6
   //rorv 111 7
   //encode the instructions
   assign alu2 = nori|not2|rolv|rorv;
   
     assign alu1 = sw|nor2|rolv|rorv;
   
     assign alu0 = lw|nor2|not2|rorv;
   
  
  
 
   assign alu3 = 1'b0;
   assign alu4 = 1'b0;

   assign ALUSrc= lw|sw|nori; //set this to 0 for add
   
   assign regWriteEnable = lw|add|nor2|not2|nori; //changed this

   //You need to change this to implement sw
   assign MemWrite = sw;
   assign MemToReg= sw|lw; //for nor
   assign RegDst=add|nor2; //forgot to initialize
   
   

   endmodule
