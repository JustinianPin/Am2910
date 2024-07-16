module mux(D, R, F, mPC, SEL, do);
    input [11:0] D, R, F, mPC;
    input [1:0] SEL;
    output reg [11:0] do;
    always@(D or R or F or mPC or SEL)
    begin
        case(SEL)
            2'b00: do <= D;
            2'b01: do <= R;
            2'b10: do <= F;
            2'b11: do <= mPC;
        endcase
    end
endmodule

module reg_cnt(di, clk, RLDn, DEC, HOLD, LOAD, do, R0);
    input [11:0] di;
    input clk, RLDn, DEC, HOLD, LOAD;
    output reg [11:0] do;
    output reg R0;
    always@(posedge clk)
        if(~RLDn) //register
            do <= di;   
        else if(DEC)
        begin
            if(di != 12'b0) //counter DEC = 1 , if RLDn = 1    
                do <= di - 1;
            else
                do <= 12'b0;
        end
        else // HOLD = 1 || LOAD = 1
            do <= di;
            
     always@(posedge clk)  //ZERO DETECTOR MODULE
        if(do)
            R0 = 1'b0;
        else
            R0 = 1'b1;       
endmodule
    
module mPC_cnt(di, clk, CI, CLEAR, COUNT, do);
    input [11:0] di;
    input clk, CI, CLEAR, COUNT;
    output reg [11:0] do;
    always@(posedge clk)
        if(CI && COUNT)
            do <= di + 1;
        else if(CLEAR)
            do <= 12'b0;
        else
            do <= di;
endmodule

module mem_stack(clk, SP, di, do, PUSH, POP, HOLD, CLEAR); /// am inlocuit addr cu SP
    input clk, PUSH, POP, HOLD, CLEAR; //we: PUSH = 1 /POP=0/HOLD=0/CLEAR=0
    input [2:0] SP; //3 bits: 8 words memory
    input [11:0] di; //este do din mPC
    output reg [11:0] do; //merge la MUX
    reg [11:0] mem[0:7];  // stiva
    always@(posedge clk)
    begin
        if(PUSH || POP || CLEAR) //SP va decide.
            mem[SP] <= di;
        do <= mem[SP]; //HOLD 
    end
endmodule

module stack_pointer(clk, PUSH, POP, HOLD, CLEAR, SP, FULLn);
    input clk, PUSH, POP, HOLD, CLEAR;
    output reg [2:0] SP;
    output reg FULLn;
    always@(posedge clk)
    begin
        if(PUSH)
        begin
            if(SP != 3'b111)  
            begin     
                SP <= SP + 1;
                FULLn <= 1'b1;
            end
            else
                FULLn <= 1'b0;
        end
        else if(POP)
        begin
            if(SP != 3'b0)
                SP <= SP - 1;
            else //redundant
                SP <= 3'b0; 
        end
        else if(CLEAR) //RESET
            SP <= 3'b0;
        else //HOLD. redundant
            SP <= SP;
    end
endmodule

module ins_PLA(I, CCn, R0,                 //in
               DEC, HD, LD,                //REG-CNT
               SEL, CLR,                   //MUX
               PUSH, POP, HOLD, CLEAR,     //STACK & SP
               PLn,MAPn,VECTn);            //out
    input [3:0] I;
    input CCn,R0;
    output reg DEC, HD, LD;  //REG-CNT
    output reg [1:0] SEL; //MUX
    output reg CLR;       //MUX
    output reg PUSH, POP, HOLD, CLEAR; // STACK & SP
    output reg PLn, MAPn, VECTn;
    
    
    /// TO DO:      PLn, MAPn, VECTn
      
always@(I or CCn or R0)
    casex({I, CCn, R0})   
        6'b0000_1_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_0_1_0_1_0_00_1_0_1_1; //0
        6'b0000_0_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_0_1_0_1_0_00_1_0_1_1;
        6'b0001_1_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_1_0_11_0_0_1_1; //1
        6'b0001_0_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b1_0_0_0_0_1_0_00_0_0_1_1;
        6'b0010_1_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_1_0_00_0_1_0_1; //2
        6'b0010_0_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_1_0_00_0_1_0_1;
        6'b0011_1_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_1_0_11_0_0_1_1; //3
        6'b0011_0_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_1_0_00_0_0_1_1; 
        6'b0100_1_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b1_0_0_0_0_1_0_11_0_0_1_1; //4
        6'b0100_0_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b1_0_0_0_0_0_1_11_0_0_1_1;
        6'b0101_1_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b1_0_0_0_0_1_0_01_0_0_1_1; //5
        6'b0101_0_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b1_0_0_0_0_1_0_00_0_0_1_1;
        6'b0110_1_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_1_0_11_0_1_1_0; //6
        6'b0110_0_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_1_0_00_0_1_1_0;
        6'b0111_1_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_1_0_01_0_0_1_1; //7
        6'b0111_0_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_1_0_00_0_0_1_1;
        6'b1000_1_0: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_1_0_0_10_0_0_1_1; //8
        6'b1000_1_1: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_1_0_0_0_1_0_11_0_0_1_1;
        6'b1000_0_0: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_1_0_0_10_0_0_1_1;
        6'b1000_0_1: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_1_0_0_0_1_0_11_0_0_1_1;
        6'b1001_1_0: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_1_0_0_00_0_0_1_1; //9
        6'b1001_1_1: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_1_0_11_0_0_1_1;
        6'b1001_0_0: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_1_0_0_00_0_0_1_1;
        6'b1001_0_1: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_1_0_11_0_0_1_1;
        6'b1010_1_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_1_0_11_0_0_1_1; //10
        6'b1010_0_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_1_0_0_0_1_0_10_0_0_1_1;
        6'b1011_1_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_1_0_11_0_0_1_1; //11
        6'b1011_0_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_1_0_0_0_1_0_00_0_0_1_1;
        6'b1100_1_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_0_1_11_0_0_1_1; //12
        6'b1100_0_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_0_1_11_0_0_1_1;
        6'b1101_1_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_1_0_10_0_0_1_1; //13
        6'b1101_0_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_1_0_0_0_1_0_11_0_0_1_1;
        6'b1110_1_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_1_0_11_0_0_1_1; //14
        6'b1110_0_x: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_0_1_0_11_0_0_1_1;
        6'b1111_1_0: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_0_1_0_1_0_0_10_0_0_1_1; //15
        6'b1111_1_1: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_1_0_0_0_1_0_00_0_0_1_1;
        6'b1111_0_0: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_1_0_0_1_0_0_11_0_0_1_1;
        6'b1111_0_1: {PUSH, POP, HOLD, CLEAR, DEC, HD, LD, SEL, CLR, PLn, MAPn, VECTn} = 13'b0_1_0_0_0_1_0_11_0_0_1_1;
     endcase
endmodule

module three_state_outputs(di, OEn, Y);
    input [11:0] di;
    input OEn;
    output reg [11:0] Y;
    always@(*) //
        if(~OEn)
            Y <= di; 
endmodule
//top va merge dupa ce rezolvam cu PLn, MAPn, VECTn
module top(D, clk, FULLn, CI, Y,  OEn, PLn, MAPn, VECTn, I, CCn, RLDn); //puse in ordinea acelor de ceas, dupa diagrama 
    
    //inputs & outputs
    input [11:0] D;
    input clk, CI, OEn, CCn, RLDn;
    input [3:0] I;
    output FULLn, PLn, MAPn, VECTn;
    output [11:0] Y;
    
    //wires:
    wire DEC, HD, LD; //INS_PLA -> Reg_cnt 
    wire [11:0] reg_cnt_out, out_mPC, out_mem_stack, out_mux;
    wire R0; // Zero-detector (in Reg_cnt) -> I
    wire PUSH, POP, HOLD, CLEAR; // INS_PLA -> Stack & SP
    wire SP; 
    wire SEL, CLR; //INS_PLA -> Mux
    
    // intantces of modules:
    reg_cnt reg_cnt_TOP(.di(D), .clk(clk), .RLDn(RLDn), .DEC(DEC), .HOLD(HD), .LOAD(LD), .do(reg_cnt_out), .R0(R0));
    stack_pointer stack_pointer_TOP(.clk(clk), .PUSH(PUSH), .POP(POP), .HOLD(HOLD), .CLEAR(CLEAR), .SP(SP), .FULLn(FULLn));
    mem_stack mem_stack_TOP(.clk(clk), .SP(SP), .di(out_mPC), .do(out_mem_stack), .PUSH(PUSH), .POP(POP), .HOLD(HOLD), .CLEAR(CLEAR));
    mPC_cnt mPC_cnt_TOP(.di(out_mux), .clk(clk), .CI(CI), .do(out_mPC));
    mux mux_TOP(.D(D), .R(reg_cnt_out), .F(out_mem_stack), .mPC(out_mPC), .SEL(SEL), .CLEAR(CLR), .do(out_mux));
    ins_PLA ins_PLA_TOP(.I(I), .CCn(CCn), .R0(R0), .DEC(DEC), .HD(HD), .LD(LD), .SEL(SEL), .CLR(CLR), .PUSH(PUSH), .POP(POP), .HOLD(HOLD), .CLEAR(CLEAR), .PLn(PLn), .MAPn(MAPn), .VECTn(VECTn));
    three_state_outputs three_state_outputs_TOP(.di(out_mux), .OEn(OEn), .Y(Y));
    
endmodule