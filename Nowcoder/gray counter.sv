`timescale 1ns/1ns

module gray_counter(
    input clk, rst_n,
    output reg [3:0] gray_out
);

    reg [4:0] bin_cnt;
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            bin_cnt <= 5'b0;
        end
        else begin
            bin_cnt <= bin_cnt + 5'b1;
        end
    end

    wire [3:0] bin;
    assign bin = bin_cnt[4:1];

    always @(gray_out, bin) begin
        gray_out = bin ^ (bin >> 1);
    end

endmodule
