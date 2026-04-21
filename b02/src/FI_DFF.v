`timescale 1ns/1ps

module FI_DFF_DFRTP_FAULTY (
    input  wire CLK,
    input  wire D,
    input  wire RESET_B,
    input  wire fault_en,
    output reg  Q
);

always @(posedge CLK or negedge RESET_B) begin
    if (!RESET_B)
        Q <= 1'b0;
    else if (fault_en)
        Q <= ~D;   // inject upset at capture edge
    else
        Q <= D;
end

endmodule