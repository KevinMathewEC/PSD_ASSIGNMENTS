`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2024 14:59:29
// Design Name: 
// Module Name: Control_Path
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


module Control_Path(
    input clk,
    input reset_n,
    input [3:0] opcode,
    input [2:0]func3,
    input [1:0]ALU_COMP,
    output IR_L,
    output RS1_E, RS2_E, IMM_E, RD_E, TR1_L, TR2_L, IMM_L, TR2_SEL,
    output ALU_E,
    output REG_RD, REG_ADDR_L, REG_DATA_L, REG_DATA_E,
    output PC_E, SP_L, SP_E,
    output DATA_MEM_EN, DATA_MEM_ADDR_L, DATA_MEM_E, DATA_MEM_RD,
    output [3:0] ALU_SEL,
    output [1:0] PC_SEL,
    output AD_S, INS_MEM_EN,
    output PRE_FETCH_L, PRE_FETCH_E,
    output OUTPUT_L


    );

    reg [3:0]state;
    reg [3:0]alu_sel;
    
    reg [2:0]instruction_type;
    reg HALT;
    
    reg [3:0]opcode_reg;


    assign AD_S = ((state==4'd1) ||  (state == 4'd4)) ? 1'b0: 1'b0; //No SP used
    assign INS_MEM_EN = ((state == 4'd2) ||  (state == 4'd5));
    assign PRE_FETCH_L = ((state == 4'd3) );//|| (state == 4'd6)
    assign PC_SEL = ((instruction_type==3'b010) || (instruction_type==3'b011) ||(instruction_type==3'b100) )? ((state == 4'd3)? 2'b10:(state ==4'd12) ? 2'b01:2'b00):((state == 4'd3))? 2'b10:2'b00;
    assign PRE_FETCH_E =  (state == 4'd4);
    assign IR_L =  (state == 4'd4);
    assign RS1_E =  (state == 4'd5);
    assign REG_ADDR_L = ((instruction_type==3'b001) || (instruction_type == 3'b101) ||  (instruction_type == 3'b110)) ? ((state == 4'd5)|| (state == 4'd8) ) : ((instruction_type==3'b010) || (instruction_type==3'b011) ||(instruction_type==3'b100) )? ((state == 4'd5) || (state == 4'd7)):((state == 4'd5)|| (state == 4'd7) ||  (state == 4'd9))  ;
    assign REG_RD = ((instruction_type==3'b001) || (instruction_type == 3'b101) ) ? (state == 4'd5) : (instruction_type == 3'b110)?((state==4'd5) || (state ==4'd8)):(state == 4'd5)||  (state == 4'd7) ;
    assign REG_DATA_E = ((instruction_type==3'b001) || (instruction_type == 3'b101) ) ? (state == 4'd6) : (instruction_type == 3'b110)? ((state==4'd6) || (state==4'd10)): (state == 4'd6) ||  (state == 4'd8);
    assign TR1_L =  ((instruction_type==3'b010) || (instruction_type==3'b011) ||(instruction_type==3'b100) )? ((state == 4'd6) || (state == 4'd10)):(state == 4'd6);
    assign RS2_E =  ((instruction_type==3'b001) || (instruction_type == 3'b101) ||  (instruction_type == 3'b110) || (instruction_type==3'b010) || (instruction_type==3'b011) ||(instruction_type==3'b100)) ? 1'b0 : (state == 4'd7);
    assign TR2_L =  ((instruction_type==3'b001) || (instruction_type == 3'b101) ||  (instruction_type == 3'b110)) ? 1'b0 : (state == 4'd8);
    assign RD_E =  ((instruction_type==3'b001) || (instruction_type == 3'b101) ||  (instruction_type == 3'b110)) ? (state == 4'd8) :((instruction_type==3'b010) || (instruction_type==3'b011) ||(instruction_type==3'b100) ) ? (state == 4'd7):(state == 4'd9);
    assign TR2_SEL = ((instruction_type==3'b001) || (instruction_type == 3'b101) ||  (instruction_type == 3'b110)) ? 1'b0 : ((instruction_type==3'b010) || (instruction_type==3'b011) ||(instruction_type==3'b100) )? (state == 4'd9):(state == 4'd10);
    assign ALU_SEL = ((instruction_type==3'b001) || (instruction_type == 3'b101) ||  (instruction_type == 3'b110)) ? ((state == 4'd9)? alu_sel:4'd0) : ((instruction_type==3'b010) || (instruction_type==3'b011) ||(instruction_type==3'b100) )? (((state == 4'd9) || (state == 4'd12))? alu_sel : 4'd0):(state == 4'd10)? alu_sel:4'd0;
    assign ALU_E =  ((instruction_type==3'b001) || (instruction_type == 3'b101) ||  (instruction_type == 3'b110)) ? (state == 4'd9):((instruction_type==3'b010) || (instruction_type==3'b011) ||(instruction_type==3'b100) )? (state == 4'd12):(state == 4'd10);
    assign REG_DATA_L = (instruction_type==3'b001) ? (state == 4'd9):(instruction_type==3'b101) ?(state == 4'd11):((instruction_type==3'b110) || ((instruction_type==3'b010) || (instruction_type==3'b011) ||(instruction_type==3'b100) )) ?1'b0:(state == 4'd10);
    assign IMM_E = ((instruction_type == 3'b001) || (instruction_type == 3'b101) ||  (instruction_type == 3'b110))? (state == 4'd7): ((instruction_type==3'b010) || (instruction_type==3'b011) ||(instruction_type==3'b100) )? (state == 4'd11):1'b0;
    assign IMM_L = ((instruction_type == 3'b001) || (instruction_type == 3'b101) ||  (instruction_type == 3'b110))? (state == 4'd7):((instruction_type==3'b010) || (instruction_type==3'b011) ||(instruction_type==3'b100) )?(state == 4'd11) :1'b0;
    assign DATA_MEM_ADDR_L = ((instruction_type == 3'b101) ||  (instruction_type == 3'b110))? (state == 4'd9): 1'b0;
    assign DATA_MEM_EN = ((instruction_type == 3'b101)||  (instruction_type == 3'b110))?(state == 4'd10): 1'b0;
    assign DATA_MEM_E = (instruction_type == 3'b101) ? (state == 4'd11):(instruction_type == 3'b110)? (state == 4'd10):1'b0;
    assign DATA_MEM_RD = (instruction_type == 3'b110)? (state == 4'd10):1'b0;
    assign PC_E = ((instruction_type==3'b010) || (instruction_type==3'b011) ||(instruction_type==3'b100) )?(state==4'd10):1'b0;
    assign OUTPUT_L = (instruction_type == 3'b111)? (state == 4'd6):1'b0;
    assign SP_E = 1'b0;
    assign SP_L = 1'b0;
    
    always@(*)begin
   if(instruction_type == 3'b000)begin 
    case(func3)
        3'b000: alu_sel = 4'b0000;  // ADD 
        3'b001: alu_sel = 4'b0001;  // SUB 
        3'b010: alu_sel = 4'b0010;  // SLL (Shift Left Logical)
        3'b011: alu_sel = 4'b0011;  // SRL (Shift Right Logical)
        3'b100: alu_sel = 4'b0100;  // COMP
        3'b101: alu_sel = 4'b0101;  //  XOR
        3'b110: alu_sel = 4'b0110;  // OR
        3'b111: alu_sel = 4'b0111;  // AND
        default: alu_sel = 4'b0000; // Default to ADD if func3 is unrecognized
    endcase
    end
    else if((instruction_type == 3'b101) || (instruction_type == 3'b110) || (instruction_type == 3'b001))begin
        alu_sel =4'b0000;
    end
    else if(((instruction_type==3'b010) || (instruction_type==3'b011) ||(instruction_type==3'b100) )) begin
        if(state == 4'd9) //COMP
           alu_sel  = 4'b0100;
        else    
            alu_sel = 4'b0000;
    end
    else
        alu_sel =4'b0000;
    end
    
   always@(*)begin
    case(opcode_reg)
        4'b0001: instruction_type = 3'b000;  // R-type 
        4'b0010: instruction_type = 3'b001;  // I-type (ADDI)
        4'b0011: instruction_type = 3'b010;  // BNE 
        4'b0100: instruction_type = 3'b011;  // BLT
        4'b0101: instruction_type = 3'b100;  // BGT
        4'b0110: instruction_type = 3'b101;  // Load 
        4'b0111: instruction_type = 3'b110;  // Store
        4'b1111: instruction_type = 3'b111;  // END
        default:  instruction_type = 3'b000; 
    endcase

    end

    always@(posedge clk)
    begin
        if(!reset_n)begin
            state <= 4'd0;
            HALT<=1'b0;
        end
        else begin
            if(((instruction_type==3'b000) || (instruction_type == 3'b110)) && (state == 4'd10)  )begin //R-Type and Store
                    state <=4'd3;
            end

            else if((instruction_type==3'b001) && (state == 4'd9))begin // I-Type
                    state <=4'd3;
            end
            else if((instruction_type==3'b101) && (state == 4'd11))begin //Load
                    state <=4'd3;
            end
            else if ((instruction_type==3'b010) && ((state == 4'd10) || (state == 4'd12)))begin //BNE
                  if((ALU_COMP == 2'b00))
                        state <= 4'd3;
                  else if(state == 4'd12)
                        state <=4'd1;
                  else
                        state <= state+4'd1;
            
            end
            else if ((instruction_type==3'b011) && ((state == 4'd10) || (state == 4'd12)))begin //BLT
                    if((ALU_COMP ==2'b00) || (ALU_COMP == 2'b01))
                        state <= 4'd3;
                    else if(state == 4'd12)
                        state <=4'd1;    
                    else
                        state <= state+4'd1;               
            end
             else if ((instruction_type==3'b100) && ((state == 4'd10) || (state == 4'd12)) )begin //BGT
                    if((ALU_COMP ==2'b00) || (ALU_COMP == 2'b10))
                        state <= 4'd3;
                    else if(state == 4'd12)
                        state <=4'd1;
                    else
                        state <= state+4'd1;
            end            
            else if((instruction_type==3'b111) && (state == 4'd6)) begin
                    state <=4'd0;
                    HALT <=1'b1;
            end
            else if(!HALT)
                state <= state + 4'd1;

        end
    end
//Opcode Reg to reduce combo logic path
    always@(posedge clk) begin
    if(!reset_n) begin
        opcode_reg<=4'd0;
 
      end
    else begin
        opcode_reg<=opcode;
        end
    end

endmodule
