always @(posedge clk or negedge rst_async_n) begin
  if(!rst_async_n) begin
    rst_s1 <= 'b0;
    rst_s2 <= 'b1;
  end
  else begin
    rst_s1 <= 1'b1;
    rst_s2 <= rst_s1;
  end
end

assign rst_sync_n = rst_s2;
