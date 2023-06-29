// binary coding
case(SEL) begin
  2'b00: output=a;
  2'b01: output=b;
  2'b10: output=c;
  2'b11: output=d;
  default: output='X';
endcase

// one-hot coding
case(SEL) begin
  4'b0001: output=a;
  4'b0010: output=b;
  4'b0100: output=c;
  4'b1000: output=d;
  default: output = 'X';
endcase
