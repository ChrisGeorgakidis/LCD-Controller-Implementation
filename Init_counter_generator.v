module Init_counter_generator (clk, reset, clk_cnt);
input wire clk, reset;
output wire [19:0]clk_cnt;

reg [19:0]next_clk_cnt;

assign clk_cnt = next_clk_cnt;

always @ (posedge clk or posedge reset)
begin
	if (reset == 1'b1) begin
		next_clk_cnt <= 20'b0;
	end
	else begin
	  	next_clk_cnt <= clk_cnt + 20'd1;
		if (clk_cnt == 20'd964048) begin
		  next_clk_cnt <= 20'd0;
		end
	end
end
endmodule
