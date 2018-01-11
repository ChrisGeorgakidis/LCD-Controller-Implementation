module Configure_FSM (clk, reset, enable, done, cnt_1s, cnt_1_64ms, next_instruction, db, enable_w1s, enable_w1_64ms);
input wire clk, reset;
input wire enable, done;
input wire [25:0]cnt_1s;
input wire [16:0]cnt_1_64ms;

output reg next_instruction;
output reg [9:0]db;
output reg enable_w1s, enable_w1_64ms;



//===============================================================================================
//-------------------------------------Define the States-----------------------------------------
//===============================================================================================
parameter IDLE                          = 4'b0;
parameter FUNCTION_SET 					= 4'd1;
parameter ENTRY_MODE_SET 				= 4'd2;
parameter DISPLAY_ON_OFF 				= 4'd3;
parameter CLEAR_DISPLAY                 = 4'd4;
parameter WAIT_1_64MS                   = 4'd5;
parameter SET_DDRAM_ADDRESS_1 			= 4'd6;
parameter WRITE_DATA_TO_DDRAM_1 	    = 4'd7;
parameter SET_DDRAM_ADDRESS_2			= 4'd8;
parameter WRITE_DATA_TO_DDRAM_2 	    = 4'd9;
parameter WAIT_1SEC                     = 4'd10;

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
reg [4:0]counter;
reg [25:0]clk_cnt;

assign state = next_state;

//State Transition
always @ (posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
        next_state <= IDLE;
    end
    else begin
        case (state)
            IDLE: begin
                if (enable == 1'b1) begin
                    next_state <= FUNCTION_SET;
                    next_instruction <= 1'b1;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b0;
                end
                else begin
                    next_state <= IDLE;
                    next_instruction <= 1'b0;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b0;
                end
            end
            FUNCTION_SET: begin
                if (done == 1'b1) begin
                    next_state <= ENTRY_MODE_SET;
                    next_instruction <= 1'b1;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b0;
                end
                else begin
                    next_state <= FUNCTION_SET;
                    next_instruction <= 1'b0;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b0;
                end
            end
            ENTRY_MODE_SET: begin
                if (done == 1'b1) begin
                    next_state <= DISPLAY_ON_OFF;
                    next_instruction <= 1'b1;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b0;
                end
                else begin
                    next_state <= ENTRY_MODE_SET;
                    next_instruction <= 1'b0;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b0;
                end
            end
            DISPLAY_ON_OFF: begin
                if (done == 1'b1) begin
                    next_state <= CLEAR_DISPLAY;
                    next_instruction <= 1'b1;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b0;
                end
                else begin
                    next_state <= DISPLAY_ON_OFF;
                    next_instruction <= 1'b0;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b0;
                end
            end
            CLEAR_DISPLAY: begin
                if (done == 1'b1) begin
                    next_state <= WAIT_1_64MS;
                    next_instruction <= 1'b0;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b1;
                end
                else begin
                    next_state <= CLEAR_DISPLAY;
                    next_instruction <= 1'b0;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b0;
                end
            end
            WAIT_1_64MS: begin
                if (cnt_1_64ms == 17'd82000) begin
                    next_state <= SET_DDRAM_ADDRESS_1;
                    next_instruction <= 1'b1;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b0;
                end
                else begin
                    next_state <= WAIT_1_64MS;
                    next_instruction <= 1'b0;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b1;
                end
            end
            SET_DDRAM_ADDRESS_1: begin
                if (done == 1'b1) begin
                    next_state <= WRITE_DATA_TO_DDRAM_1;
                    next_instruction <= 1'b1;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b0;
                end
                else begin
                    next_state <= SET_DDRAM_ADDRESS_1;
                    next_instruction <= 1'b0;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b0;
                end
            end
            WRITE_DATA_TO_DDRAM_1: begin
                if (counter == 4'd15 && done == 1'b1) begin
                    next_state <= SET_DDRAM_ADDRESS_2;
                    next_instruction <= 1'b1;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b0;
                end
                else begin
                    if (done == 1'b1) begin
                        next_state <= SET_DDRAM_ADDRESS_1;
                        next_instruction <= 1'b1;
                        enable_w1s <= 1'b0;
                        enable_w1_64ms <= 1'b0;
                    end
                    else begin
                        next_state <= WRITE_DATA_TO_DDRAM_1;
                        next_instruction <= 1'b0;
                        enable_w1s <= 1'b0;
                        enable_w1_64ms <= 1'b0;
                    end
                end
            end
            SET_DDRAM_ADDRESS_2: begin
                if (done == 1'b1) begin
                    next_state <= WRITE_DATA_TO_DDRAM_2;
                    next_instruction <= 1'b1;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b0;
                end
                else begin
                    next_state <= SET_DDRAM_ADDRESS_2;
                    next_instruction <= 1'b0;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b0;
                end
            end
            WRITE_DATA_TO_DDRAM_2: begin
                if (counter == 4'd15 && done == 1'b1) begin
                    next_state <= WAIT_1SEC;
                    next_instruction <= 1'b1;
                    enable_w1s <= 1'b1;
                    enable_w1_64ms <= 1'b0;
                end
                else begin
                    if (done == 1'b1) begin
                        next_state <= SET_DDRAM_ADDRESS_2;
                        next_instruction <= 1'b1;
                        enable_w1s <= 1'b0;
                        enable_w1_64ms <= 1'b0;
                    end
                    else begin
                        next_state <= WRITE_DATA_TO_DDRAM_2;
                        next_instruction <= 1'b0;
                        enable_w1s <= 1'b0;
                        enable_w1_64ms <= 1'b0;
                    end
                end
            end
            WAIT_1SEC: begin
                if (cnt_1s == 26'd65000000) begin
                    next_state <= SET_DDRAM_ADDRESS_1;
                    next_instruction <= 1'b1;
                    enable_w1s <= 1'b0;
                    enable_w1_64ms <= 1'b0;
                end
                else begin
                    next_state <= WAIT_1SEC;
                    next_instruction <= 1'b0;
                    enable_w1s <= 1'b1;
                    enable_w1_64ms <= 1'b0;
                end
            end
            default: begin
                next_state <= IDLE;
                next_instruction <= 1'b0;
                enable_w1s <= 1'b0;
                enable_w1_64ms <= 1'b0;
            end
        endcase
    end
end

//Signals
always @ (posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
        db <= 10'b00_0000_0000;
    end
    else begin
        case (state)
        IDLE: begin
            db <= 10'b00_0000_0000;
        end
        FUNCTION_SET: begin
            db <= 10'b00_0010_1000;
        end
        ENTRY_MODE_SET: begin
            db <= 10'b00_0000_0111;
        end
        DISPLAY_ON_OFF: begin
            //db <= 10'b00_0000_0DCB    //D:display on/off, C: cursor, B: blinking 
            db <= 10'b00_0000_1111;
        end
        CLEAR_DISPLAY: begin
            db <= 10'b00_0000_0001;
        end
        WAIT_1_64MS: begin
            db <= 10'b00_0000_0000;
        end
        SET_DDRAM_ADDRESS_1: begin
            if (counter == 5'b00000) begin
                db <= 10'b00_1000_0000;
            end
        end
        WRITE_DATA_TO_DDRAM_1: begin
            db <= {2'b10, BRAM[address]};
            //counter <= counter + 1;
        end
        SET_DDRAM_ADDRESS_2: begin
            if (counter == 5'b00000) begin
                db <= 10'b00_1010_1000;
            end
        end
        WRITE_DATA_TO_DDRAM_2: begin
            db <= {2'b10, BRAM[address]};
            //counter <= counter + 1;
        end
        WAIT_1SEC: begin
            db <= 10'b00_0000_0000;
        end
        endcase
    end
end


endmodule
