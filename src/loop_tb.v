`timescale 1ns/10ps

module loop_tb;
	parameter N = 4, 
		  DATABITS = 8'd16;
	reg clk;
	reg readySignal;
	wire signed [DATABITS*N-1:0] matrix_output;

	loop 
	#(
	.N(N),
	.DATABITS(DATABITS)
	)
	L1(
	.clk(clk),
	.readySignal(readySignal),
	.matrix_output(matrix_output)
	);

	initial begin
		clk = 1'b0;
		readySignal = 1'b0;
		#50 readySignal = 1'b1;
		#50 readySignal = 1'b0;
		#500 $stop;	
	end

	always begin
                #25 clk = !clk;
        end

endmodule

