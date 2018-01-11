module LCD_tb ();

reg clk, reset;
wire LCD_E;
wire LCD_RS, LCD_RW;
wire [11:0]SF_D;

LCD_controller LCD_controller (
    .clk        (clk),
    .reset      (reset),
    .LCD_E      (LCD_E),
    .LCD_RS     (LCD_RS),
    .LCD_RW     (LCD_RW),
    .SF_D       (SF_D)
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
