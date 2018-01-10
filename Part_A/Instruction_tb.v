module Instruction_tb ();

reg clk, reset, next_instruction;
reg [9:0]db;
wire LCD_RS, LCD_RW, LCD_E, done;
wire [3:0]SF_D;

  Instruction Instruction (
      .clk              (clk),
      .reset            (reset),
      .next_instruction (next_instruction),
      .db               (db),
      .LCD_RS           (LCD_RS),
      .LCD_RW           (LCD_RW),
      .LCD_E            (LCD_E),
      .SF_D             (SF_D),
      .done             (done)
  );

  initial begin
    next_instruction <= 1'b0;
    clk = 0;
    reset = 1;
    #100 reset = 0;

    next_instruction <= 1'b1;
    db <= 10'b00_1010_0101;
    #20 next_instruction <= 1'b0;

    #5000000 next_instruction <= 1'b1;  //συνολικά 2080*20ns κανει
    db <= 10'b00_1111_0000;
    #20 next_instruction <= 1'b0;
  end

  always begin
    #10 clk <= ~clk;
  end

endmodule
