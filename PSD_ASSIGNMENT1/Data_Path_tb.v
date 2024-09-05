`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2024 01:09:17
// Design Name: 
// Module Name: Data_Path_tb
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


`timescale 1ns / 1ps

`timescale 1ns / 1ps

module Data_Path_tb;

    // Inputs
    reg clk;
    reg reset_n;
    reg IR_L;
    reg RS1_E;
    reg RS2_E;
    reg IMM_E;
    reg RD_E;
    reg TR1_L;
    reg TR2_L;
    reg IMM_L;
    reg TR2_SEL;
    reg ALU_E;
    reg REG_RD;
    reg REG_ADDR_L;
    reg REG_DATA_L;
    reg REG_DATA_E;
    reg PC_E;
    reg SP_L;
    reg SP_E;
    reg DATA_MEM_EN;
    reg DATA_MEM_ADDR_L;
    reg DATA_MEM_E;
    reg DATA_MEM_RD;
    reg [3:0] ALU_SEL;
    reg [1:0] PC_SEL;
    
    reg [15:0] TB_DATA;
    reg TB_DATA_L;

    // Outputs
    wire [1:0] ALU_COMP;
    wire ALU_ZERO;

    // Instantiate the Unit Under Test (UUT)
    Data_Path uut (
        .clk(clk), 
        .reset_n(reset_n), 
        .IR_L(IR_L), 
        .RS1_E(RS1_E), 
        .RS2_E(RS2_E), 
        .IMM_E(IMM_E), 
        .RD_E(RD_E), 
        .TR1_L(TR1_L), 
        .TR2_L(TR2_L), 
        .IMM_L(IMM_L), 
        .TR2_SEL(TR2_SEL), 
        .ALU_E(ALU_E), 
        .REG_RD(REG_RD), 
        .REG_ADDR_L(REG_ADDR_L), 
        .REG_DATA_L(REG_DATA_L), 
        .REG_DATA_E(REG_DATA_E), 
        .PC_E(PC_E), 
        .SP_L(SP_L), 
        .SP_E(SP_E), 
        .DATA_MEM_EN(DATA_MEM_EN), 
        .DATA_MEM_ADDR_L(DATA_MEM_ADDR_L), 
        .DATA_MEM_E(DATA_MEM_E), 
        .DATA_MEM_RD(DATA_MEM_RD), 
        .ALU_SEL(ALU_SEL), 
        .PC_SEL(PC_SEL), 
        .ALU_COMP(ALU_COMP), 
        .ALU_ZERO(ALU_ZERO),
        .TB_DATA(TB_DATA),
        .TB_DATA_L(TB_DATA_L)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset_n = 0;
        IR_L = 0;
        RS1_E = 0;
        RS2_E = 0;
        IMM_E = 0;
        RD_E = 0;
        TR1_L = 0;
        TR2_L = 0;
        IMM_L = 0;
        TR2_SEL = 0;
        ALU_E = 0;
        REG_RD = 0;
        REG_ADDR_L = 0;
        REG_DATA_L = 0;
        REG_DATA_E = 0;
        PC_E = 0;
        SP_L = 0;
        SP_E = 0;
        DATA_MEM_EN = 0;
        DATA_MEM_ADDR_L = 0;
        DATA_MEM_E = 0;
        DATA_MEM_RD = 0;
        ALU_SEL = 0;
        PC_SEL = 0;
        TB_DATA = 0;
        TB_DATA_L = 0;

        // Reset the system
        #10 reset_n = 1;

        // Load an instruction through TB_DATA
        TB_DATA = 16'b0001_001_010_011_000; // Example: opcode = 0001 (sub), rs1 = 001, rs2 = 010, rd = 011
        TB_DATA_L = 1;
        #10 IR_L = 1;
        // Assert IR_L to load instruction
        #10 IR_L = 0; // Deassert after one clock cycle
         TB_DATA_L = 0;

        // Decode and perform the operation
        RS1_E = 1; // Load rs1 to data bus
        #10 RS1_E = 0;

        RS2_E = 1; // Load rs2 to data bus
        #10 RS2_E = 0;

        RD_E = 1; // Load rd to data bus
        #10 RD_E = 0;

        TR1_L = 1; // Load TR1 with data from rs1
        #10 TR1_L = 0;

        TR2_L = 1; // Load TR2 with data from rs2
        #10 TR2_L = 0;

        // Set ALU operation (e.g., subtraction)
        ALU_SEL = 4'b0001; // Subtraction
        ALU_E = 1; // Enable ALU operation
        #10 ALU_E = 0;

        // Check outputs
        #20;

        // Add more test cases as needed...

        // Finish simulation
        $finish;
    end
      
endmodule


