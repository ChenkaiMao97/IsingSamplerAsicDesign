`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2019 05:30:42 PM
// Design Name: 
// Module Name: matrixMultiply
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


module loop
    # 
    (parameter PARAMREGNUMBERS = 8'd3  ,
//               INPUT_REG_NUM = 8'd20,
               N = 8'd4,
               DATABITS = 8'd16
    )
    (
    input clk, 
    input [DATABITS-1:0] readySignal, // 8+18+1 = 27
    output reg signed [DATABITS*N-1:0] matrix_output
    );
    integer	 result_row;
    integer  result_column;
    integer  term_number;
    integer  k; // for counting the OUTPUT_REG_NUM
    
    reg [31:0] binary_tree_counter = 0;
    
    reg [DATABITS*N-1:0] sums[N-1:0];
    reg working = 0;
    reg [N-1:0] x = 4'b0101;
    initial begin
        matrix_output = 0;
        for (k = 0; k <= N - 1; k = k + 1)
        begin
            sums[k] = 0;
        end
    end
    always @(posedge clk) begin
        if(readySignal == 1 && working == 0) begin
            working <= 1;
            matrix_output <= 0;
            for (result_row = 0; result_row<=N-1; result_row = result_row +1)
                for (term_number = 0; term_number <= N-1; term_number = term_number +1)
                begin
                    sums[result_row] [(term_number)*DATABITS +: DATABITS]
                        = matrixInputs[(result_row*N+term_number)*DATABITS +: DATABITS]*
                          x[term_number]; 
                end
        end
        else if(working == 1) begin 
            if(binary_tree_counter == N) begin // have done all the summation; TO DO: change this part to efficient algorithm!!
                working <= 0;
                binary_tree_counter <= 0;
            end
            else begin // summing algorithm 
                for(k = 0;k < OUTPUT_REG_NUM; k = k+1) begin
                    matrix_output[DATABITS*k +: DATABITS] <= matrix_output[DATABITS*k +: DATABITS] + sums[k][binary_tree_counter*DATABITS +: DATABITS];
                end
                binary_tree_counter <= binary_tree_counter +1;
            end
        end 
    end
endmodule