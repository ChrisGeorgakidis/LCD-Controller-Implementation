module Instruction (clk, reset, next_instruction, db, LCD_RS, LCD_RW, LCD_E, SF_D, done);
input wire clk, reset;
input wire next_instruction;
input wire [9:0]db;

output wire LCD_RS, LCD_RW, LCD_E;
output wire [3:0]SF_D;
output wire done;

wire [11:0] clk_cnt;
wire enable;

Instruction_FSM Instruction_FSM (
    .clk              (clk),
    .reset            (reset),
    .next_instruction (next_instruction),
    .clk_cnt          (clk_cnt),
    .db               (db),
    .LCD_RS           (LCD_RS),
    .SF_D             (SF_D),
    .LCD_RW           (LCD_RW),
    .LCD_E            (LCD_E),
    .done             (done),
    .enable           (enable)
);

ClockCounterGenerator ClockCounterGenerator (
    .clk        (clk),
    .reset      (reset),
    .clk_cnt    (clk_cnt),
    .enable     (enable)
);

endmodule
