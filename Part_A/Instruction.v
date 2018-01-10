module Instruction (clk, reset, next_instruction, LCD_RS, LCD_RW, LCD_E, SF_D, done)
input wire clk, reset;
input wire next_instruction;
input wire [9:0]db;

output reg LCD_RS, LCD_RW, LCD_E;
output reg [3:0]SF_D;
output reg done;

wire [11:0] clk_cnt;

Instruction_FSM Instruction_FSM (
    .clk              (clk),
    .reset            (reset),
    .next_instruction (next_instruction),
    .clk_cnt          (clk_cnt),
    .LCD_RS           (LCD_RS),
    .SF_D             (SF_D),
    .LCD_RW           (LCD_RW),
    .LCD_E            (LCD_E),
    .done             (done)
);

ClockCounterGenerator ClockCounterGenerator (
    .clk        (clk),
    .reset      (reset),
    .clk_cnt    (clk_cnt)
);

endmodule
