module Configure_FSM (clk, reset, enable, busy, next_instruction);
input wire clk, reset;
input wire enable, busy;
output reg next_instruction;

//===============================================================================================
//-------------------------------------Define the States-----------------------------------------
//===============================================================================================
parameter IDLE                          = 3'b0;
parameter FUNCTION_SET 					= 3'd1;
parameter ENTRY_MODE_SET 				= 3'd2;
parameter DISPLAY_ON_OFF 				= 3'd3;
parameter WAIT_1.64MS                   = 3'd4;
parameter SET_DDRAM_ADDRESS_1 			= 3'd5;
parameter WRITE_DATA_TO_DDRAM_1 	= 3'd6;
parameter SET_DDRAM_ADDRESS_2			= 3'd5;
parameter WRITE_DATA_TO_DDRAM_2 	= 3'd6;
parameter WAIT_1SEC                     = 3'd7;

// parameter CLEAR_DISPLAY 				= 4'd1;
// parameter RETURN_CURSOR_HOME			= 4'd2;
// parameter CURSOR_AND_DISPLAY_SHIFT 		= 4'd5;
// parameter SET_CGRAM_ADDRESS 			= 4'd7;
// parameter READY_BUSY_FLAG_ADDRESS 		= 4'd9;
// parameter READ_DATA_FROM_CGRAM_DDRAM 	= 4'd11;

//===============================================================================================
//--------------------------------------Configure FSM--------------------------------------------
//===============================================================================================

wire [3:0]state;
reg [3:0]next_state;
//reg [11:0]clk_cnt;

assign state = next_state;

always @ (posedge clk or posedge reset) begin
    if (reset == 1) begin
        next_state <= IDLE;
    end
    else begin
        case(state) begin
            IDLE: begin
                if (enable == 1'b1) begin
                  next_state <= FUNCTION_SET;
                end else begin
                  next_state <= IDLE;
                end
            end
            FUNCTION_SET: begin
                
            end
            ENTRY_MODE_SET: begin
              
            end
            DISPLAY_ON_OFF: begin
              
            end
            CLEAR_DISPLAY: begin
              
            end
            WAIT_1.64MS: begin
              
            end
            SET_DDRAM_ADDRESS_1: begin
              
            end
            WRITE_DATA_TO_DDRAM_1: begin
              
            end
            SET_DDRAM_ADDRESS_2: begin
              
            end
            WRITE_DATA_TO_DDRAM_2: begin
              
            end
            WAIT_1SEC: begin
              
            end
        end
    end
end

endmodule
