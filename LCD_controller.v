module LCD_controller (clk, reset, LCD_E, SF_D11, SF_D10, SF_D9, SF_D8, LCD_RS, LCD_RW);
input wire clk, reset;
output reg LCD_E;
output wire LCD_RS, LCD_RW;
output reg SF_D11, SF_D10, SF_D9, SF_D8;

wire [11:0]init_sfd;
wire [11:0]instr_sfd;
wire init_lcd_e, instr_lcd_e;
wire enable, done, next_instruction, enable_w1s, enable_w1_64ms, enable_instr_cnt;
wire [19:0]init_clk_cnt;
wire [11:0]instruction_clk_cnt;
wire [25:0]cnt_1s;
wire [16:0]cnt_1_64ms;
wire [9:0]db;

///////////////////////////////////////////////////
///////////////////////////////////////////////////
//assign SF_D = enable ? instr_sfd : init_sfd;
//assign LCD_E = enable ? instr_lcd_e : init_lcd_e;
/*SF_D <= {nit_sfd[11:8], 8'b00000000}*/
always @ (posedge clk or posedge reset) begin
    if(reset) begin
        SF_D11  <= 1'b0;
        SF_D10  <= 1'b0;
        SF_D9   <= 1'b0;
        SF_D8   <= 1'b0;
        LCD_E   <= 1'b1;
    end
    else begin
        if (enable == 1'b1) begin
            SF_D11  <= instr_sfd[11];
            SF_D10  <= instr_sfd[10];
            SF_D9   <= instr_sfd[9];
            SF_D8   <= instr_sfd[8];
            LCD_E <= instr_lcd_e;
        end
        else begin
            SF_D11  <= init_sfd[11];
            SF_D10  <= init_sfd[10];
            SF_D9   <= init_sfd[9];
            SF_D8   <= init_sfd[8];
            LCD_E <= init_lcd_e;
        end
    end
end

///////////////////////////////////////////////////
///////////////////////////////////////////////////

Initialize_FSM Initialize_FSM (
    .clk      (clk),
    .reset    (reset),
    .clk_cnt  (init_clk_cnt),
    .enable   (enable),
    .SF_D     (init_sfd),
    .LCD_E    (init_lcd_e)
);

Init_counter_generator Init_counter_generator (
    .clk      (clk),
    .reset    (reset),
    .clk_cnt  (init_clk_cnt)
);

///////////////////////////////////////////////////
///////////////////////////////////////////////////

Configure_FSM Configure_FSM (
    .clk              (clk),
    .reset            (reset),
    .enable           (enable),
    .done             (done),
    .cnt_1s           (cnt_1s),
    .cnt_1_64ms       (cnt_1_64ms),
    .next_instruction (next_instruction),
    .db               (db),
    .enable_w1s       (enable_w1s),
    .enable_w1_64ms   (enable_w1_64ms)
);

ClockCounterGenerator_w1_64ms ClockCounterGenerator_w1_64ms (
    .clk      (clk),
    .reset    (reset),
    .enable   (enable_w1_64ms),
    .clk_cnt  (cnt_1_64ms)
);

ClockCounterGenerator_w1s ClockCounterGenerator_w1s(
    .clk      (clk),
    .reset    (reset),
    .enable   (enable_w1s),
    .clk_cnt  (cnt_1s)
);

///////////////////////////////////////////////////
///////////////////////////////////////////////////

Instruction_FSM Instruction_FSM (
    .clk              (clk),
    .reset            (reset),
    .next_instruction (next_instruction),
    .clk_cnt          (instruction_clk_cnt),
    .db               (db),
    .LCD_RS           (LCD_RS),
    .SF_D             (instr_sfd),
    .LCD_RW           (LCD_RW),
    .LCD_E            (instr_lcd_e),
    .done             (done),
    .enable           (enable_instr_cnt)
);

Instruction_ClockCounterGenerator Instruction_ClockCounterGenerator (
    .clk        (clk),
    .reset      (reset),
    .clk_cnt    (instruction_clk_cnt),
    .enable     (enable_instr_cnt)
);


endmodule
