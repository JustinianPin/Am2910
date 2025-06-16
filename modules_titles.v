module mux(D, R, F, mPC, SEL, CLEAR, do);

module reg_cnt(di, clk, RLDn, DEC, HOLD, LOAD, do, R0);

module mPC_cnt(di, clk, CI, do);

module mem_stack(clk, SP, di, do, PUSH, POP, HOLD, CLEAR);

module stack_pointer(clk, PUSH, POP, HOLD, CLEAR, SP, FULLn);

module ins_PLA(I, CCn, R0,                 //in
               DEC, HD, LD,                //REG-CNT
               SEL, CLR,                   //MUX
               PUSH, POP, HOLD, CLEAR,     //STACK & SP
               PLn,MAPn,VECTn);            //out

module three_state_outputs(di, OEn, Y);

module top(D, clk, FULLn, CI, Y,  OEn, PLn, MAPn, VECTn, I, CCn, RLDn); 


// EXEMPLU DE INSTANTIERE TOP:
module s1(clk, reset, pla, plb, sel, datain, dataout);

	input clk, reset, pla, plb, sel;
	input [7:0] datain;
	output [3:0] dataout;

	wire [3:0] neta, netb;

	reg4 reg4a( .clk(clk), .reset(reset), .pl(pla), .di(datain[3:0]), .do(neta));
	reg4 reg4b( .clk(clk), .reset(reset), .pl(plb), .di(datain[7:4]), .do(netb));
	mux_1_2_4b mux_inst( .a(neta), .b(netb), .sel(sel), .z(dataout));

endmodule