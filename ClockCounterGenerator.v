module ClockCounterGenerator(clk, reset, clk_cnt);
input wire clk, reset;
output wire [11:0]clk_cnt;

reg [11:0]next_clk_cnt;

assign clk_cnt = next_clk_cnt;

always @ (posedge clk or posedge reset) begin
	if (reset == 1'b1) begin
		next_clk_cnt <= 12'b0;
	end
	else begin
	  	next_clk_cnt <= clk_cnt + 12'd1;
		if (clk_cnt == 12'd2080) begin
		  next_clk_cnt <= 12'd0;
		end
	end
endmodule


//sxolio gia git
