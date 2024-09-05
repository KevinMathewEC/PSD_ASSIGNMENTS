    `timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 31.08.2024 13:18:47
    // Design Name: 
    // Module Name: ALU
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


    module ALU(

        input [3:0] sel,
        input signed [15:0] a,
        input signed [15:0] b,
        output reg[15:0] out,
        output zero,
        output [1:0] comp
        );

        assign zero = (|out)? 1'b0: 1'b1;
        assign comp = (sel == 4'b0100)?((a>b)? 2'b10: (a<b)? 2'b01:2'b00):2'b00;
        always@(*)
        begin
            case (sel)
            4'b000:begin  out = a+b;//addition
            end
            4'b0001:begin
             out = a-b; //subtraction
             end
            4'b0010:begin
             out = a<<b; //shift left
             end
            4'b0011: begin
            out = a>>b; //shift right
            end
            4'b0100: begin // compare
                out = 16'd0;
       /*        if(a > b)
                    comp = 2'b10;
                else if( a < b)
                    comp = 2'b01;
                else    
                    comp = 2'b00;*/
            end
            4'b0101: begin
            out = a ^ b; //xor
            end
            4'b0110: begin
            out = a | b;//or
            end
            4'b0111: begin
            out = a & b;//and
            end
            default : begin
                out = 16'd0;
      //          comp =2'b00;
            end
            endcase
        end


    endmodule
