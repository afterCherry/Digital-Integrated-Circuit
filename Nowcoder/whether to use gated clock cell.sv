// no integrated gated clock cell
always @(posedge clock or negedge reset_b) begin
  if(!reset_b) begin
    test_ff <= 'd0;
  end
  else begin
    test_ff <= test_nxt;
  end
end

assign test_nxt = load_cond?test_data:test_ff;


// integrated clock cell
always @(posedge clock or negedge reset_b) begin
  if(!reset_b) begin
    test_ff <= 'd0;
  end
  else if(load_cond) begin
    test_ff <= test_data;
  end
end
