module LCD_tb ();

reg clk, reset;
wire LCD_E;
wire LCD_RS, LCD_RW;
wire SF_D11, SF_D10, SF_D9, SF_D8;

LCD_controller LCD_controller (
    .clk        (clk),
    .reset      (reset),
    .LCD_E      (LCD_E),
    .LCD_RS     (LCD_RS),
    .LCD_RW     (LCD_RW),
    .SF_D11     (SF_D11),
    .SF_D10     (SF_D10),
    .SF_D9     (SF_D9),
    .SF_D8     (SF_D8)
);

initial begin
    clk = 0;
    reset = 1;
    #500 reset = 0;
end

always begin
    #10 clk <= ~clk;
end

endmodule
