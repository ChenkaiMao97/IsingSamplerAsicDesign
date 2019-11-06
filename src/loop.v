`timescale 1ns / 1ps

module loop
    # 
    (parameter N = 8'd4,
               DATABITS = 8'd16
    )
    (
    input clk, 
    input readySignal,
    output reg signed [DATABITS*N-1:0] matrix_output
    );
    integer  result_row;
    integer  term_number;
    integer  k; // for counting N
    
    reg [7:0] binary_tree_counter = 0;
    reg [DATABITS*N-1:0] matrixInputs[N-1:0];
    reg [DATABITS*N-1:0] sums[N-1:0];
    reg [3:0] FSM = 0;
    reg [N-1:0] x = 4'b0101;
    initial begin
        matrix_output = 0;
        for (k = 0; k <= N - 1; k = k + 1)
        begin
            sums[k] = 0;
        end
        for (result_row = 0; result_row<=N-1; result_row = result_row+1)
            for (k = 0; k <= N - 1; k = k + 1)
            begin
                matrixInputs[result_row][k*DATABITS +: DATABITS] = result_row+k;
            end
    end
    always @(posedge clk) begin
        if(readySignal == 1 && FSM == 0) begin
            FSM <= 1;
            matrix_output <= 0;
            for (result_row = 0; result_row<=N-1; result_row = result_row +1)
                for (term_number = 0; term_number <= N-1; term_number = term_number +1)
                begin
                    sums[result_row][term_number*DATABITS +: DATABITS]
                        <= matrixInputs[result_row][term_number*DATABITS +: DATABITS]*x[term_number]; 
                end
        end
        else if(FSM == 1) begin 
            if(binary_tree_counter == N) begin
                FSM <= 0;
                binary_tree_counter <= 0;
            end
            else begin // summing algorithm 
                for(k = 0;k < N; k = k+1) begin
                    matrix_output[DATABITS*k +: DATABITS] <= matrix_output[DATABITS*k +: DATABITS] + sums[k][binary_tree_counter*DATABITS +: DATABITS];
                end
                binary_tree_counter <= binary_tree_counter +1;
            end
        end 
    end
endmodule
