`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2024 19:02:53
// Design Name: 
// Module Name: Top_Module_tb
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


module Top_Module_tb(

    );
    
    
    // Inputs to the top module
    reg clk;
    reg reset_n;

    // Instantiate the Top_Module
    Top_Module uut (
        .clk(clk),
        .reset_n(reset_n)
    );

    // Clock generation (50 MHz clock -> 20 ns period)
    always #10 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        reset_n = 0;

        // Apply reset
        #100;         // Hold reset for 100 ns
        reset_n = 1;  // Release reset
        
        // Simulate for some time
        #20000;        // Run the simulation for 1000 ns after releasing reset

        // Finish simulation
        $finish;
    end

endmodule
