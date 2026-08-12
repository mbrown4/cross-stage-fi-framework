`timescale 1ns/1ps

module FI_DFF_DFRTP_FAULTY (
  input CLK,
  input D,
  input RESET_B,
  input fault_en,
  output reg Q
);

always @(posedge CLK or negedge RESET_B) begin
  if (!RESET_B)
    Q <= 1'b0;
  else if (fault_en)
    Q <= ~Q;
  else
    Q <= D;
end

endmodule


module FI_DFF_DFSTP_FAULTY (
  input CLK,
  input D,
  input SET_B,
  input fault_en,
  output reg Q
);

always @(posedge CLK or negedge SET_B) begin
  if (!SET_B)
    Q <= 1'b1;
  else if (fault_en)
    Q <= ~Q;
  else
    Q <= D;
end

endmodule