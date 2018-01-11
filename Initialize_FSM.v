module Initialize_FSM (clk, reset, clk_cnt, enable, SF_D, LCD_E);

input wire clk, reset;
input wire [19:0]clk_cnt;
output reg enable, LCD_E;
output reg [11:0]SF_D;

reg [3:0]next_state;
wire [3:0]state;

parameter OFF    = 4'd0;
parameter STATE1 = 4'd1;
parameter STATE2 = 4'd2;
parameter STATE3 = 4'd3;
parameter STATE4 = 4'd4;
parameter STATE5 = 4'd5;
parameter STATE6 = 4'd6;
parameter STATE7 = 4'd7;
parameter STATE8 = 4'd8;
parameter STATE9 = 4'd9;
parameter DONE   = 4'd10;

assign state = next_state;

always @ (posedge clk or posedge reset)
begin
    if (reset == 1) begin
        next_state <= OFF;
    end
    else begin
        case (state)
        OFF: begin
            next_state <= STATE1;
        end
        STATE1: begin
            if (clk_cnt == 20'd750000) begin
                next_state <= STATE2;
            end
            else begin
                next_state <= STATE1;
            end
        end
        STATE2: begin
            if (clk_cnt == 20'd750012) begin
                next_state <= STATE3;
            end
            else begin
                next_state <= STATE2;
            end
        end
        STATE3: begin
            if (clk_cnt == 20'd955012) begin
                next_state <= STATE4;
            end
            else begin
                next_state <= STATE3;
            end
        end
        STATE4: begin
            if (clk_cnt == 20'd955024) begin
                next_state <= STATE5;
            end
            else begin
                next_state <= STATE4;
            end
        end
        STATE5: begin
            if (clk_cnt == 20'd960024) begin
                next_state <= STATE6;
            end
            else begin
                next_state <= STATE5;
            end
        end
        STATE6: begin
            if (clk_cnt == 20'd960036) begin
                next_state <= STATE7;
            end
            else begin
                next_state <= STATE6;
            end
        end
        STATE7: begin
            if (clk_cnt == 20'd962036) begin
                next_state <= STATE8;
            end
            else begin
                next_state <= STATE7;
            end
        end
        STATE8: begin
            if (clk_cnt == 20'd962048) begin
                next_state <= STATE9;
            end
            else begin
                next_state <= STATE8;
            end
        end
        STATE9: begin
            if (clk_cnt == 20'd964048) begin
                next_state <= DONE;
            end
            else begin
                next_state <= STATE9;
            end
        end
        DONE: begin
            next_state <= DONE;
        end
        default: begin
            next_state <= STATE1;
        end
        endcase
    end
end

always @ (posedge clk or posedge reset)
begin
    if (reset == 1) begin
        enable <= 1'b0;
        LCD_E <= 1'b0;
        SF_D[11:8] <= 4'b0000;
    end
    else begin
        case (state)
        OFF: begin
            enable <= 1'b0;
            LCD_E <= 1'b0;
            SF_D[11:8] <= 4'b0000;
        end
        STATE1: begin
            enable <= 1'b0;
            LCD_E <= 1'b0;
            SF_D[11:8] <= 4'b0000;
        end
        STATE2: begin
            enable <= 1'b0;
            LCD_E <= 1'b1;
            SF_D[11:8] <= 4'b0011;
        end
        STATE3: begin
            enable <= 1'b0;
            LCD_E <= 1'b0;
            SF_D[11:8] <= 4'b0000;
        end
        STATE4: begin
            enable <= 1'b0;
            LCD_E <= 1'b1;
            SF_D[11:8] <= 4'b0011;
        end
        STATE5: begin
            enable <= 1'b0;
            LCD_E <= 1'b0;
            SF_D[11:8] <= 4'b0000;
        end
        STATE6: begin
            enable <= 1'b0;
            LCD_E <= 1'b1;
            SF_D[11:8] <= 4'b0011;
        end
        STATE7: begin
            enable <= 1'b0;
            LCD_E <= 1'b0;
            SF_D[11:8] <= 4'b0000;
        end
        STATE8: begin
            enable <= 1'b0;
            LCD_E <= 1'b1;
            SF_D[11:8] <= 4'b0010;
        end
        STATE9: begin
            enable <= 1'b0;
            LCD_E <= 1'b0;
            SF_D[11:8] <= 4'b0000;
        end
        DONE: begin
            enable <= 1'b1;
            LCD_E <= 1'b0;
            SF_D[11:8] <= 4'b0000;
        end
        default: begin
            enable <= 1'b0;
            LCD_E <= 1'b0;
            SF_D[11:8] <= 4'b0000;
        end
        endcase
    end
end

endmodule
