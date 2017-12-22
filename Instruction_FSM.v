//////////////////////////////////////////////////////////////////////////////////
// Company: 	University of Thessaly
// Engineer: 	Georgakidis Christos, Stamoulis John
//
// Create Date:    18:00:00 12/10/2017
// Design Name:
// Module Name:    Instruction_FSM
// Project Name:   LCD Controller Implementation
// Target Devices: Spartan 3E
// Tool versions:
// Description:
//
// Dependencies: 	The clock should be set to 50MHz.
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments: This module performs the full initialization procedure.
//								Once init is done, the module takes in DATA and processes
//								it according to OPER. When idle, the module indicates RDY.
//								ENB, indicates that DATA and OPER are valid and the module
//								should start to read the lines.
//								Note: the calling module must keep DATA valid until RDY re-asserts
//
//////////////////////////////////////////////////////////////////////////////////
module Instruction_FSM (clk, reset, next_instruction, clk_cnt, LCD_RS, SF_D, LCD_RW, LCD_E, busy);
input wire clk, reset;
input wire next_instruction;
input wire [11:0]clk_cnt;
input reg [9:0]db;
	//The [9:8]db refers to LCD_RS and LCD_RW foor each instruction & the [7:0]db refers to DBs
output reg LCD_RS, LCD_RW, LCD_E;
output reg [3:0]SF_D;
output reg busy;

//===============================================================================================
//------------------------------Define the BASIC Command Set-------------------------------------
//===============================================================================================
parameter CLEAR_DISPLAY 				= ;
parameter RETURN_CURSOR_HOME			= ;
parameter ENTRY_MODE_SET 				= ;
parameter DISPLAY_ON_OFF 				= ;
parameter CURSOR_AND_DISPLAY_SHIFT 		= ;
parameter FUNCTION_SET 					= ;
parameter SET_CGRAM_ADDRESS 			= ;
parameter SET_DDRAM_ADDRESS 			= ;
parameter READY_BUSY_FLAG_ADDRESS 		= ;
parameter WRITE_DATA_TO_CGRAM_DDRAM 	= ;
parameter READ_DATA_FROM_CGRAM_DDRAM 	= ;

//===============================================================================================
//-------------------------------------Define the States-----------------------------------------
//===============================================================================================
parameter IDLE			= 3'd0;
parameter SETUP_HIGH	= 3'd1;
parameter ACTIVE_HIGH	= 3'd2;
parameter HOLD_HIGH		= 3'd3;
parameter WAIT			= 3'd4;
parameter SETUP_LOW 	= 3'd5;
parameter ACTIVE_LOW	= 3'd6;
parameter HOLD_LOW 		= 3'd7;
parameter DONE 			= 3'd8;

//===============================================================================================
//-------------------------------------Instruction FSM-------------------------------------------
//===============================================================================================
wire [2:0]state;
reg [2:0]next_state;
reg [11:0]clk_cnt;

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

//This FSM, depending on the current state, sets the appropriate values int the output signals
always @ (posedge clk or posedge reset) begin
  if (reset == 1'b1) begin
    busy    <= 1'b0;
	LCD_E 	<= 1'b0;
	LCD_RS 	<= 1'b0;
	LCD_RW 	<= 1'b0;
	SF_D 	<= 4'b0;
  end
  else begin
	case (state)
	IDLE: begin
		//signals for IDLE
        busy    <= 1'b0;
		LCD_E 	<= 1'b0;
		LCD_RS 	<= 1'b0;
		LCD_RW 	<= 1'b0;
		SF_D 	<= 4'b0;
	end
	SETUP_HIGH: begin
		//signals for SETUP_HIGH
        busy    <= 1'b1;
		LCD_E 	<= 1'b0;
		LCD_RS 	<= 1'b0;
		LCD_RW 	<= 1'b0;
		SF_D 	<= db[7:4];
	end
	ACTIVE_HIGH: begin
		//signals for SETUP_HIGH
		LCD_E 	<= 1'b1;
		LCD_RS 	<= db[9];
		LCD_RW 	<= db[8];
		SF_D 	<= db[7:4];
	end
	HOLD_HIGH: begin
		//signals for HOLD_HIGH
        busy    <= 1'b1;
		LCD_E 	<= 1'b0;
		LCD_RS 	<= 1'b0;
		LCD_RW 	<= 1'b0;
		SF_D 	<= db[7:4];
	end
	WAIT: begin
		//signals for WAIT
        busy    <= 1'b1;
		LCD_E 	<= 1'b0;
		LCD_RS 	<= 1'b0;
		LCD_RW 	<= 1'b0;
		SF_D 	<= db[7:4];
	end
	SETUP_LOW: begin
		//signals for SETUP_LOW
        busy    <= 1'b1;
		LCD_E 	<= 1'b0;
		LCD_RS 	<= 1'b0;
		LCD_RW 	<= 1'b0;
		SF_D 	<= db[3:0];
	end
	ACTIVE_LOW: begin
		//signals for SETUP_HIGH
        busy    <= 1'b1;
		LCD_E 	<= 1'b1;
		LCD_RS 	<= db[9];
		LCD_RW 	<= db[8];
		SF_D 	<= db[3:0];
	end
	HOLD_LOW: begin
		//signals for HOLD_LOW
        busy    <= 1'b1;
		LCD_E 	<= 1'b0;
		LCD_RS 	<= 1'b0;
		LCD_RW 	<= 1'b0;
		SF_D 	<= db[3:0];
	end
	DONE: begin
		//signals for DONE
        busy    <= 1'b1;
		LCD_E 	<= 1'b0;
		LCD_RS 	<= 1'b0;
		LCD_RW 	<= 1'b0;
		SF_D 	<= db[3:0];
	end
	default: begin
		//signals for default => IDLE
        busy    <= 1'b0;
		LCD_E 	<= 1'b0;
		LCD_RS 	<= 1'b0;
		LCD_RW 	<= 1'b0;
		SF_D 	<= 4'b0;
	end
	endcase
  end
end

endmodule
