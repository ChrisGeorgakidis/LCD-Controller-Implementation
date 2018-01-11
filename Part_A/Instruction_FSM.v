module Instruction_FSM (clk, reset, next_instruction, clk_cnt, db, LCD_RS, SF_D, LCD_RW, LCD_E, done, enable);
input wire clk, reset;
input wire next_instruction;
input wire [11:0]clk_cnt;
input wire [9:0]db;
	//The [9:8]db refers to LCD_RS and LCD_RW foor each instruction & the [7:0]db refers to DBs
output reg LCD_RS, LCD_RW, LCD_E;
output reg [3:0]SF_D;
output reg done, enable;

//===============================================================================================
//-------------------------------------Define the States-----------------------------------------
//===============================================================================================
parameter IDLE			= 4'd0;
parameter SETUP_HIGH	= 4'd1;
parameter ACTIVE_HIGH	= 4'd2;
parameter HOLD_HIGH		= 4'd3;
parameter WAIT			= 4'd4;
parameter SETUP_LOW 	= 4'd5;
parameter ACTIVE_LOW	= 4'd6;
parameter HOLD_LOW 		= 4'd7;
parameter DONE 			= 4'd8;

//===============================================================================================
//-------------------------------------Instruction FSM-------------------------------------------
//===============================================================================================
wire [3:0]state;
reg [3:0]next_state;

assign state = next_state;


//This FSM checks the values of the clk_cnt and switches to the corresponding state
always @ (posedge clk or posedge reset) begin
  if (reset == 1'b1) begin
	next_state <= IDLE;
  end
  else begin
	case (state)
	IDLE: begin
		if (next_instruction == 1'b1) begin
			next_state <= SETUP_HIGH;
		end
		else begin
			next_state <= IDLE;
		end
	end
	SETUP_HIGH: begin
		if (clk_cnt == 12'd2) begin
			next_state <= ACTIVE_HIGH;
		end
		else begin
			next_state <= SETUP_HIGH;
		end
	end
	ACTIVE_HIGH: begin
		if (clk_cnt == 12'd14) begin
			next_state <= HOLD_HIGH;
		end
		else begin
			next_state <= ACTIVE_HIGH;
		end
	end
	HOLD_HIGH: begin
		if (clk_cnt == 12'd15) begin
			next_state <= WAIT;
	  	end
	  	else begin
			next_state <= HOLD_HIGH;
	  	end
	end
	WAIT: begin
		if (clk_cnt == 12'd65) begin
			next_state <= SETUP_LOW;
	  	end
	  	else begin
			next_state <= WAIT;
	  	end
	end
	SETUP_LOW: begin
		if (clk_cnt == 12'd67) begin
			next_state <= ACTIVE_LOW;
	  	end
	  	else begin
			next_state <= SETUP_LOW;
	  	end
	end
	ACTIVE_LOW: begin
		if (clk_cnt == 12'd79) begin
			next_state <= HOLD_LOW;
	  	end
	  	else begin
			next_state <= ACTIVE_LOW;
	  	end
	end
	HOLD_LOW: begin
		if (clk_cnt == 12'd80) begin
			next_state <= DONE;
	  	end
	  	else begin
			next_state <= HOLD_LOW;
	  	end
	end
	DONE: begin
		if (clk_cnt == 12'd2080) begin
			next_state <= IDLE;
	  	end
	  	else begin
			next_state <= DONE;
	  	end
	end
	default: begin
		next_state <= IDLE;
	end
	endcase
  end
end

//This FSM, depending on the current state, sets the appropriate values to the output signals
always @ (posedge clk or posedge reset) begin
  if (reset == 1'b1) begin
    done    <= 1'b0;
	LCD_E 	<= 1'b0;
	LCD_RS 	<= 1'b0;
	LCD_RW 	<= 1'b0;
	SF_D 	<= 4'b0;
  end
  else begin
	case (state)
	IDLE: begin
		//signals for IDLE
        done    <= 1'b0;
		LCD_E 	<= 1'b0;
		LCD_RS 	<= 1'b0;
		LCD_RW 	<= 1'b0;
		SF_D 	<= 4'b0;
        enable  <= 1'b0;
	end
	SETUP_HIGH: begin
		//signals for SETUP_HIGH
        done    <= 1'b0;
		LCD_E 	<= 1'b0;
		LCD_RS 	<= 1'b0;
		LCD_RW 	<= 1'b0;
		SF_D 	<= db[7:4];
        enable  <= 1'b1;
	end
	ACTIVE_HIGH: begin
		//signals for SETUP_HIGH
		LCD_E 	<= 1'b0;
		LCD_RS 	<= db[9];
		LCD_RW 	<= db[8];
		SF_D 	<= db[7:4];
        enable  <= 1'b1;
	end
	HOLD_HIGH: begin
		//signals for HOLD_HIGH
        done    <= 1'b0;
		LCD_E 	<= 1'b0;
		LCD_RS 	<= 1'b0;
		LCD_RW 	<= 1'b0;
		SF_D 	<= db[7:4];
        enable  <= 1'b1;
	end
	WAIT: begin
		//signals for WAIT
        done    <= 1'b0;
		LCD_E 	<= 1'b0;
		LCD_RS 	<= 1'b0;
		LCD_RW 	<= 1'b0;
		SF_D 	<= db[7:4];
        enable  <= 1'b1;
	end
	SETUP_LOW: begin
		//signals for SETUP_LOW
        done    <= 1'b0;
		LCD_E 	<= 1'b0;
		LCD_RS 	<= 1'b0;
		LCD_RW 	<= 1'b0;
		SF_D 	<= db[3:0];
        enable  <= 1'b1;
	end
	ACTIVE_LOW: begin
		//signals for SETUP_HIGH
        done    <= 1'b0;
		LCD_E 	<= 1'b1;
		LCD_RS 	<= db[9];
		LCD_RW 	<= db[8];
		SF_D 	<= db[3:0];
        enable  <= 1'b1;
	end
	HOLD_LOW: begin
		//signals for HOLD_LOW
        done    <= 1'b0;
		LCD_E 	<= 1'b0;
		LCD_RS 	<= 1'b0;
		LCD_RW 	<= 1'b0;
		SF_D 	<= db[3:0];
        enable  <= 1'b1;
	end
	DONE: begin
		//signals for DONE
        if (clk_cnt == 12'd2080) begin
            done    <= 1'b1;
            enable  <= 1'b0;
	  	end
        else begin
            enable  <= 1'b1;
            done <= 1'b0;
        end
		LCD_E 	<= 1'b0;
		LCD_RS 	<= 1'b0;
		LCD_RW 	<= 1'b0;
		SF_D 	<= db[3:0];
	end
	default: begin
		//signals for default => IDLE
        done    <= 1'b0;
		LCD_E 	<= 1'b0;
		LCD_RS 	<= 1'b0;
		LCD_RW 	<= 1'b0;
		SF_D 	<= 4'b0;
        enable  <= 1'b0;
	end
	endcase
  end
end

endmodule
