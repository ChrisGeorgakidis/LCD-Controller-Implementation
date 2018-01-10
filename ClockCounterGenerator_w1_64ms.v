module ClockCounterGenerator_w1_64ms(clk, reset, enable, clk_cnt);
input wire clk, reset, enable;
output wire [16:0]clk_cnt;

reg [16:0]next_clk_cnt;

assign clk_cnt = next_clk_cnt;

always @ (posedge clk or posedge reset)
begin
	if (reset == 1'b1) begin
		next_clk_cnt <= 17'b0;
	end
	else begin
		if (enable == 1) begin
		  	next_clk_cnt <= clk_cnt + 17'd1;
			if (clk_cnt == 17'd82000) begin
			  next_clk_cnt <= 17'd0;
			end
		end
		else begin
			next_clk_cnt <= 17'd0;
		end
	end
end
endmodule
