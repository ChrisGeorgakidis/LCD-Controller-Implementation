module ClockCounterGenerator_w1s(clk, reset, enable, clk_cnt);
input wire clk, reset, enable;
output wire [25:0]clk_cnt;

reg [25:0]next_clk_cnt;

assign clk_cnt = next_clk_cnt;

always @ (posedge clk or posedge reset)
begin
	if (reset == 1'b1) begin
		next_clk_cnt <= 26'b0;
	end
	else begin
		if (enable == 1) begin
	  		next_clk_cnt <= clk_cnt + 26'd1;
			if (clk_cnt == 26'd65000000) begin
		  		next_clk_cnt <= 26'd0;
			end
		end
		else begin
			next_clk_cnt <= 26'd0;
		end
	end
end
endmodule
