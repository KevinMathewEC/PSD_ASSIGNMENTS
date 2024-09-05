`timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 31.08.2024 10:23:37
    // Design Name: 
    // Module Name: Data_Path
    // Project Name: 
    // Target Devices: 
    // Tool Versions: 
    // Description: 
    // 
    // Dependencies: 
    // 
    // Revision:
    // Revision 0.01 - File Created
    // Additional Comments:
    // 
    //////////////////////////////////////////////////////////////////////////////////


    module Data_Path(
        input clk,
        input reset_n,
        input IR_L,
        input RS1_E,RS2_E,IMM_E,RD_E,TR1_L,TR2_L,IMM_L,TR2_SEL,
        input ALU_E,
        input REG_RD,REG_ADDR_L,REG_DATA_L,REG_DATA_E,
        input PC_E,SP_L,SP_E,
        input DATA_MEM_EN,DATA_MEM_ADDR_L,DATA_MEM_E,DATA_MEM_RD,
        input [3:0]ALU_SEL,
        input [1:0]PC_SEL,
        input AD_S,INS_MEM_EN,
        input PRE_FETCH_L,PRE_FETCH_E,
        input OUTPUT_L,
        output [3:0]opcode,      
        output [2:0]func3,
        output reg [1:0] ALU_COMP,
        output ALU_ZERO,
        output reg [15:0]OUTPUT_MAX
        );
        
        reg [15:0]DATA_BUS;
        
        wire [15:0] INSTR,INSTR_ADDR;
        reg [15:0] PRE_FETCH_REG;
        reg [15:0]INSTRUCTION_REG;//Instruction register
        reg [15:0]TR1,TR2;//Target register (ALU input)
        reg [15:0] IMM;
        
        wire [2:0]rs1_dec,rs2_dec,rd_dec;
        wire [5:0]imm_dec;
   //     wire [3:0]opcode;

        reg [15:0] Reg_Bank_out;
        reg [2:0] Reg_Bank_addr_shdw;
        
        wire [15:0]ALU_OUT;
        wire [1:0]alu_comp;
        
        reg [15:0]PC;
        reg [15:0]PC_init;
        
        wire [15:0]DATA_MEM_OUT;
        //Instruction register
        always@(posedge clk)
        begin
            if(!reset_n)
                INSTRUCTION_REG <= 16'd0;
            else if(IR_L)
                INSTRUCTION_REG <= DATA_BUS;
        end
        
        //Decoder
        assign rs1_dec = INSTRUCTION_REG[8:6];
        assign rs2_dec = INSTRUCTION_REG[5:3];
        assign rd_dec =  INSTRUCTION_REG[11:9];
        assign opcode = INSTRUCTION_REG [15:12];
        assign imm_dec = INSTRUCTION_REG[5:0];
        assign func3 = INSTRUCTION_REG[2:0];


        always@(*)begin
            if(RS1_E)
                DATA_BUS = {13'b0, rs1_dec};
            else if(RS2_E)
                DATA_BUS = {13'b0, rs2_dec};          
            else if(RD_E)
                DATA_BUS = {13'b0, rd_dec};       
            else if(IMM_E)
                DATA_BUS = {{10{imm_dec[5]}}, imm_dec};  
            else if(ALU_E)
                DATA_BUS= ALU_OUT;   
            else if(REG_DATA_E)
                DATA_BUS= Reg_Bank_out;
            else if(PC_E)
                DATA_BUS= PC;   
            else if(DATA_MEM_E)
                DATA_BUS = DATA_MEM_OUT;  
            else if(PRE_FETCH_E)
                DATA_BUS = PRE_FETCH_REG;
 //           else if(TB_DATA_L)//For debug
 //               DATA_BUS = TB_DATA;
            else
                DATA_BUS=16'd0;                                   
        end

        // ALU input 


        always@(posedge clk, negedge reset_n)
        begin
            if(!reset_n) begin
                TR1<=16'd0;
                TR2<=16'd0;
                IMM<=16'd0;
            end
            else begin
            if(TR1_L)
                TR1 <= DATA_BUS;  
            if(TR2_L)
                TR2 <= DATA_BUS;         
            if(IMM_L)
                IMM <= DATA_BUS;         
            end     
        end

        wire [15:0]A,B;

        assign A = TR1;
        assign B = TR2_SEL ? TR2 : IMM;
        ALU alu (
            .sel(ALU_SEL),
            .a(A),
            .b(B),
            .out(ALU_OUT),
            .zero(ALU_ZERO),
            .comp(alu_comp)
        );
    //Output register
    always@(posedge clk)begin
    if(!reset_n) 
        ALU_COMP<=16'd0;

    else if(ALU_SEL == 4'b0100)
        ALU_COMP<=alu_comp;
    end

        //Register Bank
        reg [15:0] Reg_Bank [7:0];


        always@(posedge clk)begin
            if(!reset_n) begin
                Reg_Bank[3'b000]<=16'd0;
                Reg_Bank[3'b001]<=16'd0;
                Reg_Bank[3'b010]<=16'd0;
                Reg_Bank[3'b011]<=16'd0;
                Reg_Bank[3'b100]<=16'd0;
                Reg_Bank[3'b101]<=16'd0;
                Reg_Bank[3'b110]<=16'd0;
                Reg_Bank[3'b111]<=16'd0;
                Reg_Bank_addr_shdw<=4'd0;
            end
            else begin
                if(REG_ADDR_L) begin
                 if(REG_RD)//read from bank
                    Reg_Bank_out <= Reg_Bank[DATA_BUS[2:0]];
                else if(!REG_RD)//write 
                    Reg_Bank_addr_shdw <= DATA_BUS[2:0];
                end

                if(REG_DATA_L)
                    Reg_Bank[Reg_Bank_addr_shdw] <= DATA_BUS;
                else
                    Reg_Bank[Reg_Bank_addr_shdw] <= Reg_Bank[Reg_Bank_addr_shdw]; 
                end
        end


        //PC



        always@(posedge clk)begin
            if(!reset_n)
            PC<=16'd0;
            else begin
                if(PC_SEL == 2'b01)//in case of branch, target address comes from DATA_BUS
                    PC<=DATA_BUS;
                else if(PC_SEL ==2'b10)
                    PC<=PC+16'd1;
                else
                    PC<=PC;
            end
        end

        //SP
        reg [15:0]SP;
        reg [15:0]SP_init;

        always@(posedge clk)begin
            if(!reset_n)
            SP<=16'd0;
            else begin
                if(SP_L)//in case of branch, target address comes from DATA_BUS
                    SP<=DATA_BUS;
                else
                    SP<=SP;
            end
        end    
        
        //DATA MEMORY
        reg [15:0]DATA_MEM_addr_shdw;
         always@(posedge clk)begin
            if(!reset_n)
            DATA_MEM_addr_shdw<=16'd0;
            else begin
                if(DATA_MEM_ADDR_L)//in case of branch, target address comes from DATA_BUS
                    DATA_MEM_addr_shdw<=DATA_BUS;
                else
                    DATA_MEM_addr_shdw<=DATA_MEM_addr_shdw;
            end
        end   
      blk_mem_gen_0 DATA_MEMORY(
      .clka(clk),            // input wire clka
      .rsta(!reset_n),            // input wire rsta
      .ena(DATA_MEM_EN),              // input wire ena
      .wea(DATA_MEM_RD),              // input wire [0 : 0] wea
      .addra(DATA_MEM_addr_shdw[9:0]),          // input wire [9 : 0] addra
      .dina(DATA_BUS),            // input wire [15 : 0] dina
      .douta(DATA_MEM_OUT),          // output wire [15 : 0] douta
      .rsta_busy(rsta_busy)  // output wire rsta_busy
    );

    //INSTRUCTION MEMORY
    assign INSTR_ADDR = AD_S ? SP: PC;
    blk_mem_gen_1 INSTRUCTION_MEMORY (
      .clka(clk),    // input wire clka
      .ena(INS_MEM_EN),      // input wire ena
      .wea(1'b0),      // input wire [0 : 0] wea
      .addra(INSTR_ADDR[9:0]),  // input wire [9 : 0] addra
      .dina(16'd0),    // input wire [15 : 0] dina
      .douta(INSTR)  // output wire [15 : 0] douta
    );

    //PRE-FETCH
         always@(posedge clk)begin
            if(!reset_n)
            PRE_FETCH_REG<=16'd0;
            else begin
                if(PRE_FETCH_L)//in case of branch, target address comes from DATA_BUS
                    PRE_FETCH_REG<=INSTR;
                else
                    PRE_FETCH_REG<=PRE_FETCH_REG;
            end
        end     
    
    //Output register
    always@(posedge clk)begin
    if(!reset_n)
        OUTPUT_MAX<=16'd0;
    else if(OUTPUT_L)
        OUTPUT_MAX<=DATA_BUS;
    end
    
    
    endmodule