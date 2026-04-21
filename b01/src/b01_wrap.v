`timescale 1ns/1ps

module DUT_GOLDEN(
  input  wire clock,
  input  wire reset,
  input  wire line1,
  input  wire line2,
  input  wire [4:0] fault_en,   // passed in, but golden ties/ignores by using 0s internally
  output wire  outp,
  output wire  overflw,
  output wire [2:0] stato_dbg
);

  // State encoding
  localparam a   = 3'd0,
             b   = 3'd1,
             c   = 3'd2,
             e   = 3'd3,
             f   = 3'd4,
             g   = 3'd5,
             wf0 = 3'd6,
             wf1 = 3'd7;

  wire [2:0] stato_q;
  wire outp_q;
  wire overflw_q;

  reg  [2:0] stato_d;
  reg  outp_d;
  reg  overflw_d;

  assign stato_dbg = stato_q;
  assign outp = outp_q;
  assign overflw = overflw_q;

  /////////////////////////////////////////////////////////////
  // Register bank (golden = no fault injection enabled)
  ////////////////////////////////////////////////////////////

  // stat[0]
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

  // outp
  FI_DFF_DFRTP_FAULTY U_OUTP_G (
    .CLK(clock),
    .D(outp_d),
    .RESET_B(~reset),
    .fault_en(1'b0),
    .Q(outp_q)
  );

  // overflw
  FI_DFF_DFRTP_FAULTY U_OV_G (
    .CLK(clock),
    .D(overflw_d),
    .RESET_B(~reset),
    .fault_en(1'b0),
    .Q(overflw_q)
  );

  ////////////////////////////////////////////////////////////
  // Combinational next-state / next-output logic
  // Mirrors original always @(posedge clock, posedge reset)
  ////////////////////////////////////////////////////////////
  always @* begin
    stato_d    = stato_q;
    outp_d     = outp_q;;
    overflw_d  = overflw_q;

    if (reset) begin
      stato_d    = a;
      outp_d     = 1'b0;
      overflw_d  = 1'b0;
    end

    else begin
      case (stato_q)
        a: begin
          if (line1 && line2) stato_d = f;
          else                stato_d = b;
          outp_d     = line1 ^ line2;
          overflw_d  = 1'b0;
        end

        e: begin
          if (line1 && line2) stato_d = f;
          else                stato_d = b;
          outp_d     = line1 ^ line2;
          overflw_d  = 1'b1;
        end

        b: begin
          if (line1 && line2) stato_d = g;
          else                stato_d = c;
          outp_d     = line1 ^ line2;
          overflw_d  = 1'b0;
        end

        f: begin
          if (line1 || line2) stato_d = g;
          else                stato_d = c;
          outp_d     = ~(line1 ^ line2);
          overflw_d  = 1'b0;
        end

        c: begin
          if (line1 && line2) stato_d = wf1;
          else                stato_d = wf0;
          outp_d     = line1 ^ line2;
          overflw_d  = 1'b0;
        end

        g: begin
          if (line1 || line2) stato_d = wf1;
          else                stato_d = wf0;
          outp_d     = ~(line1 ^ line2);
          overflw_d  = 1'b0;
        end

        wf0: begin
          if (line1 && line2) stato_d = e;
          else                stato_d = a;
          outp_d     = line1 ^ line2;
          overflw_d  = 1'b0;
        end

        wf1: begin
          if (line1 || line2) stato_d = e;
          else                stato_d = a;
          outp_d     = ~(line1 ^ line2);
          overflw_d  = 1'b0;
        end

        default: begin
          stato_d    = a;
          outp_d     = 1'b0;
          overflw_d  = 1'b0;
        end
      endcase
    end
  end

endmodule

////////////////////////////////////////////////////////////
// Faulty DUT
////////////////////////////////////////////////////////////
module DUT_FAULTY(
  input  wire clock,
  input  wire reset,
  input  wire line1,
  input  wire line2,
  input  wire [4:0] fault_en,
  output wire  outp,
  output wire  overflw,
  output wire [2:0] stato_dbg
);

  localparam a   = 3'd0,
             b   = 3'd1,
             c   = 3'd2,
             e   = 3'd3,
             f   = 3'd4,
             g   = 3'd5,
             wf0 = 3'd6,
             wf1 = 3'd7;

  wire [2:0] stato_q;
  wire outp_q;
  wire overflw_q;

  reg  [2:0] stato_d;
  reg  outp_d;
  reg  overflw_d;

  assign stato_dbg = stato_q;
  assign outp      = outp_q;
  assign overflw   = overflw_q;

  ////////////////////////////////////////////////////////////
  // Register bank with FI enables
  // [0]=outp, [1]=overflw, [2]=stato[0], [3]=stato[1], [4]=stato[2]
  ////////////////////////////////////////////////////////////
  // fault_en[2] -> stato[0]
  FI_DFF_DFRTP_FAULTY U_STATO0_F (
    .CLK(clock),
    .D(stato_d[0]),
    .RESET_B(~reset),
    .fault_en(fault_en[2]),
    .Q(stato_q[0])
  );

  // fault_en[3] -> stato[1]
  FI_DFF_DFRTP_FAULTY U_STATO1_F (
    .CLK(clock),
    .D(stato_d[1]),
    .RESET_B(~reset),
    .fault_en(fault_en[3]),
    .Q(stato_q[1])
  );

  // fault_en[4] -> stato[2]
  FI_DFF_DFRTP_FAULTY U_STATO2_F (
    .CLK(clock),
    .D(stato_d[2]),
    .RESET_B(~reset),
    .fault_en(fault_en[4]),
    .Q(stato_q[2])
  );

  // fault_en[0] -> outp
  FI_DFF_DFRTP_FAULTY U_OUTP_F (
    .CLK(clock),
    .D(outp_d),
    .RESET_B(~reset),
    .fault_en(fault_en[0]),
    .Q(outp_q)
  );

  // fault_en[1] -> overflw
  FI_DFF_DFRTP_FAULTY U_OV_F (
    .CLK(clock),
    .D(overflw_d),
    .RESET_B(~reset),
    .fault_en(fault_en[1]),
    .Q(overflw_q)
  );

  // Same combinational logic
  always @* begin
    stato_d    = stato_q;
    outp_d     = outp_q;
    overflw_d  = overflw_q;

    if (reset) begin
      stato_d    = a;
      outp_d     = 1'b0;
      overflw_d  = 1'b0;
    end
    else begin
      case (stato_q)
        a: begin
          if (line1 && line2) stato_d = f;
          else                stato_d = b;
          outp_d     = line1 ^ line2;
          overflw_d  = 1'b0;
        end

        e: begin
          if (line1 && line2) stato_d = f;
          else                stato_d = b;
          outp_d     = line1 ^ line2;
          overflw_d  = 1'b1;
        end

        b: begin
          if (line1 && line2) stato_d = g;
          else                stato_d = c;
          outp_d     = line1 ^ line2;
          overflw_d  = 1'b0;
        end

        f: begin
          if (line1 || line2) stato_d = g;
          else                stato_d = c;
          outp_d     = ~(line1 ^ line2);
          overflw_d  = 1'b0;
        end

        c: begin
          if (line1 && line2) stato_d = wf1;
          else                stato_d = wf0;
          outp_d     = line1 ^ line2;
          overflw_d  = 1'b0;
        end

        g: begin
          if (line1 || line2) stato_d = wf1;
          else                stato_d = wf0;
          outp_d     = ~(line1 ^ line2);
          overflw_d  = 1'b0;
        end

        wf0: begin
          if (line1 && line2) stato_d = e;
          else                stato_d = a;
          outp_d     = line1 ^ line2;
          overflw_d  = 1'b0;
        end

        wf1: begin
          if (line1 || line2) stato_d = e;
          else                stato_d = a;
          outp_d     = ~(line1 ^ line2);
          overflw_d  = 1'b0;
        end

        default: begin
          stato_d    = a;
          outp_d     = 1'b0;
          overflw_d  = 1'b0;
        end
      endcase
    end
  end

endmodule