`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.08.2024 14:22:44
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb(

    );

    // Inputs
    reg [3:0] sel;
    reg [15:0] a;
    reg [15:0] b;

    // Outputs
    wire [15:0] out;
    wire zero;
    wire [1:0] comp;

    // Instantiate the Unit Under Test (UUT)
    ALU uut (
        .sel(sel),
        .a(a),
        .b(b),
        .out(out),
        .zero(zero),
        .comp(comp)
    );

    // Testbench variables
    integer i;
    reg [15:0] expected_out;
    reg [1:0] expected_comp;

    initial begin
        // Apply test vectors
        // Test addition
        sel = 4'b0000; a = 16'sd15; b = 16'sd10; #10;
        expected_out = 16'sd25; check_results(expected_out, 2'b00);
        
        // Test subtraction
        sel = 4'b0001; a = 16'sd20; b = 16'sd5; #10;
        expected_out = 16'sd15; check_results(expected_out, 2'b00);
        
        // Test signed addition overflow
        sel = 4'b0000; a = 16'sd32767; b = 16'sd1; #10;
        expected_out = 16'sd32768; check_results(expected_out, 2'b00);
        
        // Test signed subtraction with negative result
        sel = 4'b0001; a = 16'sd10; b = 16'sd15; #10;
        expected_out = 16'b1111111111111011; // Two's complement of -5
        check_results(expected_out, 2'b00);
        
        // Test shift left
        sel = 4'b0010; a = 16'sd2; b = 16'sd3; #10;
        expected_out = 16'sd16; check_results(expected_out, 2'b00);
        
        // Test shift right
        sel = 4'b0011; a = 16'sd16; b = 16'sd2; #10;
        expected_out = 16'sd4; check_results(expected_out, 2'b00);
        
        // Test compare a > b
        sel = 4'b0100; a = 16'sd10; b = 16'sd5; #10;
        expected_out = 16'sd0; expected_comp = 2'b10; check_results(expected_out, expected_comp);
        
        // Test compare a < b
        sel = 4'b0100; a = 16'sd5; b = 16'sd10; #10;
        expected_out = 16'sd0; expected_comp = 2'b01; check_results(expected_out, expected_comp);
        
        // Test compare a == b
        sel = 4'b0100; a = 16'sd10; b = 16'sd10; #10;
        expected_out = 16'sd0; expected_comp = 2'b00; check_results(expected_out, expected_comp);
        
        // Test xor
        sel = 4'b0101; a = 16'sd12; b = 16'sd6; #10;
        expected_out = 16'sd10; check_results(expected_out, 2'b00);
        
        // Test or
        sel = 4'b0110; a = 16'sd12; b = 16'sd6; #10;
        expected_out = 16'sd14; check_results(expected_out, 2'b00);
        
        // Test and
        sel = 4'b0111; a = 16'sd12; b = 16'sd6; #10;
        expected_out = 16'sd4; check_results(expected_out, 2'b00);
        
                // Test compare a > b (signed)
        sel = 4'b0100; a = 16'sd10; b = 16'sd5; #10;
        expected_out = 16'sd0; expected_comp = 2'b10; check_results(expected_out, expected_comp);
        
        // Test compare a < b (signed)
        sel = 4'b0100; a = 16'sd5; b = 16'sd10; #10;
        expected_out = 16'sd0; expected_comp = 2'b01; check_results(expected_out, expected_comp);
        
        // Test compare a == b (signed)
        sel = 4'b0100; a = 16'sd10; b = 16'sd10; #10;
        expected_out = 16'sd0; expected_comp = 2'b00; check_results(expected_out, expected_comp);
        
         // Test compare a > b (signed)
        sel = 4'b0100; a = 16'h000A; b = 16'h0005; #10;
        expected_out = 16'h0000; expected_comp = 2'b10; check_results(expected_out, expected_comp);
        
        // Test compare a < b (signed)
        sel = 4'b0100; a = 16'h0005; b = 16'h000A; #10;
        expected_out = 16'h0000; expected_comp = 2'b01; check_results(expected_out, expected_comp);
        
        // Test compare a == b (signed)
        sel = 4'b0100; a = 16'h000A; b = 16'h000A; #10;
        expected_out = 16'h0000; expected_comp = 2'b00; check_results(expected_out, expected_comp);
        
        // Test compare with negative values (a > b)
        sel = 4'b0100; a = 16'hFFFB; b = 16'hFFF6; #10;
        expected_out = 16'h0000; expected_comp = 2'b10; check_results(expected_out, expected_comp);
        
        // Test compare with negative values (a < b)
        sel = 4'b0100; a = 16'hFFF6; b = 16'hFFFB; #10;
        expected_out = 16'h0000; expected_comp = 2'b01; check_results(expected_out, expected_comp);
        
        // Test compare with mixed sign values (a > b)
        sel = 4'b0100; a = 16'h0005; b = 16'hFFFB; #10;
        expected_out = 16'h0000; expected_comp = 2'b10; check_results(expected_out, expected_comp);
        
        // Test compare with mixed sign values (a < b)
        sel = 4'b0100; a = 16'hFFFB; b = 16'h0005; #10;
        expected_out = 16'h0000; expected_comp = 2'b01; check_results(expected_out, expected_comp);
        
        // Test xor
        sel = 4'b0101; a = 16'h000C; b = 16'h0006; #10;
        expected_out = 16'h000A; check_results(expected_out, 2'b00);
        
        // Test or
        sel = 4'b0110; a = 16'h000C; b = 16'h0006; #10;
        expected_out = 16'h000E; check_results(expected_out, 2'b00);
        
        // Test and
        sel = 4'b0111; a = 16'h000C; b = 16'h0006; #10;
        expected_out = 16'h0004; check_results(expected_out, 2'b00);
        
        
                // Test addition of positive numbers
        sel = 4'b0000; a = 16'h000A; b = 16'h0014; #10;
        expected_out = 16'h001E; check_results(expected_out, 2'b00);
        
        // Test addition with positive and negative numbers
        sel = 4'b0000; a = 16'h000F; b = 16'hFFF6; #10;
        expected_out = 16'h0009; check_results(expected_out, 2'b00);
        
        // Test addition of negative numbers
        sel = 4'b0000; a = 16'hFFF1; b = 16'hFFF6; #10;
        expected_out = 16'hFFD7; check_results(expected_out, 2'b00);
        
        // Test addition with overflow
        sel = 4'b0000; a = 16'h7FFF; b = 16'h0001; #10;
        expected_out = 16'h8000; // Overflow should result in wrapping around
        check_results(expected_out, 2'b00);
        
        // Test subtraction of positive numbers
        sel = 4'b0001; a = 16'h001E; b = 16'h000A; #10;
        expected_out = 16'h0014; check_results(expected_out, 2'b00);
        
        // Test subtraction resulting in a negative number
        sel = 4'b0001; a = 16'h000A; b = 16'h001E; #10;
        expected_out = 16'hFFE8; // -24 in 2's complement
        check_results(expected_out, 2'b00);
        
        // Test subtraction with negative numbers
        sel = 4'b0001; a = 16'hFFF6; b = 16'hFFF1; #10;
        expected_out = 16'h0005; check_results(expected_out, 2'b00);
        
        // Test subtraction with overflow (result exceeds 16-bit signed range)
        sel = 4'b0001; a = 16'h8000; b = 16'h0001; #10;
        expected_out = 16'h7FFF; // Result wraps to the maximum positive value in 16-bit
        check_results(expected_out, 2'b00);
        
        // Test addition resulting in zero
        sel = 4'b0000; a = 16'h0005; b = 16'hFFFB; #10;
        expected_out = 16'h0000; check_results(expected_out, 2'b00);
        
        // Test subtraction resulting in zero
        sel = 4'b0001; a = 16'h000A; b = 16'h000A; #10;
        expected_out = 16'h0000; check_results(expected_out, 2'b00);

        // Additional test cases
        // Test addition with large positive and large negative values
        sel = 4'b0000; a = 16'h7FFF; b = 16'h8000; #10;
        expected_out = 16'hFFFF; // Overflow results in wrapping around to -1
        check_results(expected_out, 2'b00);

        // Test subtraction with large positive and large negative values
        sel = 4'b0001; a = 16'h8000; b = 16'h7FFF; #10;
        expected_out = 16'h0001; // Result is -32767 + 32768 = 1
        check_results(expected_out, 2'b00);
        
        $finish;
    end

    // Task to check results and print error messages
    task check_results;
        input [15:0] exp_out;
        input [1:0] exp_comp;
        begin
            if (out !== exp_out) begin
                $display("Error: Expected out = %d, but got %d", exp_out, out);
            end
            if (comp !== exp_comp) begin
                $display("Error: Expected comp = %b, but got %b", exp_comp, comp);
            end
        end
    endtask

endmodule
