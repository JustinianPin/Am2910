module testbench();
    reg [11:0] D_tb;
    reg clk_tb, CI_tb, OEn_tb, I_tb, CCn_tb, RLDn_tb;
    wire FULLn_tb, PLn_tb, MAPn_tb, VECTn_tb;
    wire [11:0] Y_tb;
    
    top dut(.D(D_tb), .clk(clk_tb), .FULLn(FULLn_tb), .CI(CI_tb), .Y(Y_tb),  .OEn(OEn_tb), .PLn(PLn_tb), .MAPn(MAPn_tb), .VECTn(VECTn_tb), .I(I_tb), .CCn(CCn_tb), .RLDn(RLDn_tb));

        
endmodule