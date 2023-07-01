// synchronous reset
always @(posedge clk) begin
  if(!rst_n) begin
    out <= 'b0;
  end
  else begin
    out <= in;
  end
end

// asynchronous reset
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    out <= 'b0;
  end
  else begin
    out <= in;
  end
end
