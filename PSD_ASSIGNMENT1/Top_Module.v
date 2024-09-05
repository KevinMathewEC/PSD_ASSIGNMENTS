`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2024
// Design Name: 
// Module Name: Top_Module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: Data_Path, Control_Path
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Top_Module(
    input clk,
    input reset_n,
    output wire [15:0]OUTPUT_MAX
);

    // Wires for interconnections between Data_Path and Control_Path
    wire IR_L;
    wire RS1_E, RS2_E, IMM_E, RD_E, TR1_L, TR2_L, IMM_L, TR2_SEL;
    wire ALU_E;
    wire REG_RD, REG_ADDR_L, REG_DATA_L, REG_DATA_E;
    wire PC_E, SP_L, SP_E;
    wire DATA_MEM_EN, DATA_MEM_ADDR_L, DATA_MEM_E, DATA_MEM_RD;
    wire [3:0] ALU_SEL;
    wire [1:0] PC_SEL;
    wire AD_S, INS_MEM_EN;
    wire PRE_FETCH_L, PRE_FETCH_E;
    wire OUTPUT_L;
    
        
    wire [3:0] opcode;
    wire [2:0] func3;
    wire [1:0] ALU_COMP;
    wire ALU_ZERO;

    // Instantiate Data_Path module
(* dont_touch = "TRUE" *)    Data_Path datapath (
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
        .AD_S(AD_S),
        .INS_MEM_EN(INS_MEM_EN),
        .PRE_FETCH_L(PRE_FETCH_L),
        .PRE_FETCH_E(PRE_FETCH_E),
        .OUTPUT_L(OUTPUT_L),
        .opcode(opcode),
        .func3(func3),
        .ALU_COMP(ALU_COMP),
        .ALU_ZERO(ALU_ZERO),
        .OUTPUT_MAX(OUTPUT_MAX)
    );

    // Instantiate Control_Path module
 (* dont_touch = "TRUE" *)   Control_Path controlpath (
        .clk(clk),
        .reset_n(reset_n),
        .opcode(opcode),
        .func3(func3),
        .ALU_COMP(ALU_COMP),
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
        .AD_S(AD_S),
        .INS_MEM_EN(INS_MEM_EN),
        .PRE_FETCH_L(PRE_FETCH_L),
        .PRE_FETCH_E(PRE_FETCH_E),
        .OUTPUT_L(OUTPUT_L)
    );

endmodule
