`timescale 1ns/1ps

////////////////////////////////////////////////////////////
// Golden DUT
////////////////////////////////////////////////////////////
module DUT_GOLDEN(
  input  wire       clock,
  input  wire       reset,
  input  wire       linea,
  input  wire [3:0] fault_en,   // unused in golden
  output wire       u,
  output wire [2:0] stato_dbg
);

  // State encoding
  localparam A = 3'd0,
             B = 3'd1,
             C = 3'd2,
             D = 3'd3,
             E = 3'd4,
             F = 3'd5,
             G = 3'd6;

  // Registered values
  wire [2:0] stato_q;
  wire       u_q;

  // Next-state / next-output values
  reg  [2:0] stato_d;
  reg        u_d;

  assign stato_dbg = stato_q;
  assign u         = u_q;

  ////////////////////////////////////////////////////////////
  // Register bank (golden = no fault injection enabled)
  ////////////////////////////////////////////////////////////

  // stato[0]
  FI_DFF_DFRTP_FAULTY U_STATO0_G (
    .CLK(clock),
    .D(stato_d[0]),
    .RESET_B(~reset),
    .fault_en(1'b0),
    .Q(stato_q[0])
  );

  // stato[1]
  FI_DFF_DFRTP_FAULTY U_STATO1_G (
    .CLK(clock),
    .D(stato_d[1]),
    .RESET_B(~reset),
    .fault_en(1'b0),
    .Q(stato_q[1])
  );

  // stato[2]
  FI_DFF_DFRTP_FAULTY U_STATO2_G (
    .CLK(clock),
    .D(stato_d[2]),
    .RESET_B(~reset),
    .fault_en(1'b0),
    .Q(stato_q[2])
  );

  // u
  FI_DFF_DFRTP_FAULTY U_OUT_G (
    .CLK(clock),
    .D(u_d),
    .RESET_B(~reset),
    .fault_en(1'b0),
    .Q(u_q)
  );

  ////////////////////////////////////////////////////////////
  // Combinational next-state / next-output logic
  // Mirrors original always @(posedge clock, posedge reset)
  ////////////////////////////////////////////////////////////
  always @* begin
    stato_d = stato_q;
    u_d     = u_q;

    if (reset) begin
      stato_d = A;
      u_d     = 1'b0;
    end
    else begin
      case (stato_q)
        A: begin
          stato_d = B;
          u_d     = 1'b0;
        end

        B: begin
          if (linea == 1'b0)
            stato_d = C;
          else
            stato_d = F;
          u_d = 1'b0;
        end

        C: begin
          if (linea == 1'b0)
            stato_d = D;
          else
            stato_d = G;
          u_d = 1'b0;
        end

        D: begin
          stato_d = E;
          u_d     = 1'b0;
        end

        E: begin
          stato_d = B;
          u_d     = 1'b1;
        end

        F: begin
          stato_d = G;
          u_d     = 1'b0;
        end

        G: begin
          if (linea == 1'b0)
            stato_d = E;
          else
            stato_d = A;
          u_d = 1'b0;
        end

        default: begin
          stato_d = A;
          u_d     = 1'b0;
        end
      endcase
    end
  end

endmodule


////////////////////////////////////////////////////////////
// Faulty DUT
////////////////////////////////////////////////////////////
module DUT_FAULTY(
  input  wire       clock,
  input  wire       reset,
  input  wire       linea,
  input  wire [3:0] fault_en,
  output wire       u,
  output wire [2:0] stato_dbg
);

  localparam A = 3'd0,
             B = 3'd1,
             C = 3'd2,
             D = 3'd3,
             E = 3'd4,
             F = 3'd5,
             G = 3'd6;

  wire [2:0] stato_q;
  wire       u_q;

  reg  [2:0] stato_d;
  reg        u_d;

  assign stato_dbg = stato_q;
  assign u         = u_q;

  ////////////////////////////////////////////////////////////
  // Register bank with FI enables
  // [0] = u
  // [1] = stato[0]
  // [2] = stato[1]
  // [3] = stato[2]
  ////////////////////////////////////////////////////////////

  // fault_en[1] -> stato[0]
  FI_DFF_DFRTP_FAULTY U_STATO0_F (
    .CLK(clock),
    .D(stato_d[0]),
    .RESET_B(~reset),
    .fault_en(fault_en[1]),
    .Q(stato_q[0])
  );

  // fault_en[2] -> stato[1]
  FI_DFF_DFRTP_FAULTY U_STATO1_F (
    .CLK(clock),
    .D(stato_d[1]),
    .RESET_B(~reset),
    .fault_en(fault_en[2]),
    .Q(stato_q[1])
  );

  // fault_en[3] -> stato[2]
  FI_DFF_DFRTP_FAULTY U_STATO2_F (
    .CLK(clock),
    .D(stato_d[2]),
    .RESET_B(~reset),
    .fault_en(fault_en[3]),
    .Q(stato_q[2])
  );

  // fault_en[0] -> u
  FI_DFF_DFRTP_FAULTY U_OUT_F (
    .CLK(clock),
    .D(u_d),
    .RESET_B(~reset),
    .fault_en(fault_en[0]),
    .Q(u_q)
  );

  ////////////////////////////////////////////////////////////
  // Same combinational logic as original b02
  ////////////////////////////////////////////////////////////
  always @* begin
    stato_d = stato_q;
    u_d     = u_q;

    if (reset) begin
      stato_d = A;
      u_d     = 1'b0;
    end
    else begin
      case (stato_q)
        A: begin
          stato_d = B;
          u_d     = 1'b0;
        end

        B: begin
          if (linea == 1'b0)
            stato_d = C;
          else
            stato_d = F;
          u_d = 1'b0;
        end

        C: begin
          if (linea == 1'b0)
            stato_d = D;
          else
            stato_d = G;
          u_d = 1'b0;
        end

        D: begin
          stato_d = E;
          u_d     = 1'b0;
        end

        E: begin
          stato_d = B;
          u_d     = 1'b1;
        end

        F: begin
          stato_d = G;
          u_d     = 1'b0;
        end

        G: begin
          if (linea == 1'b0)
            stato_d = E;
          else
            stato_d = A;
          u_d = 1'b0;
        end

        default: begin
          stato_d = A;
          u_d     = 1'b0;
        end
      endcase
    end
  end

endmodule