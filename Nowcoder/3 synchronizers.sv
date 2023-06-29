// level synchronizer
module level_synchronizer(
  input clk1;
  input clk2;
  input rst_n;
  input data_a;
  output logic a_ff3;
);

  logic a_ff1, a_ff2;
  always @(posedge clk1 or negedge rst_n) begin
    if(!rst_n) begin
      a_ff1 <= 'b0;
    end
    else begin
      a_ff1 <= data_a;
    end
  end

  always @(posedge clk2 or negedge rst_n) begin
    if(!rst_n) begin
      {a_ff3,a_ff2} <= 2'b00;
    end
    else begin
      {a_ff3,a_ff2} <= {a_ff2, a_ff1};
    end
  end

endmodule

// edge synchronizer
module edge_synchronizer(
  input clk;
  input rst_n;
  input data_a;
  output logic a_ff3; 
  output logic up_edge;
  output logic down_edge;
  output logic edg;
);

  logic a_ff1, a_ff2;
  always @(posedge clk or negedge rst) begin
    if(!rst_n) begin
      {a_ff3, a_ff2, a_ff1} <= 3'b000;
    end
    else begin
      {a_ff3, a_ff2, a_ff1} <= {a_ff2, a_ff1, data_a};
    end
  end

  assign up_edge = a_ff2 && ~a_ff3;
  assign down_edge = ~a_ff2 && a_ff3;
  assign edg = a_ff2 ^ a_ff3;

endmodule

// pulse synchronizer
module pulse_synchronizer(
  input clk1,
  input clk2,
  input rst_n;
  input in_pulse;
  output logic out_pulse;  
);

  // first FF
  logic data, a_ff1, a_ff2, a_ff3;
  always @(posedge clk1 or nededge rst_n) begin
    if(!rst_n) begin
      data <= 'b0;
    end
    else begin
      data <= data ^ in_pulse;
    end
  end

  // synchronizer and FF
  always @(posedge clk2 or negedge rst_n) begin
    if(!rst_n) begin
      {a_ff3, a_ff2, a_ff1} <= 3'b000;
    end
    else begin
      {a_ff3, a_ff2, a_ff1} <= {a_ff2, a_ff1, data};
    end
  end

  // xor
  assign out_pulse = a_ff2 ^ aff3;

endmodule
