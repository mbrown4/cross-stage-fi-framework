`timescale 1ns/1ps

module DUT_GOLDEN(
  input  wire clock,
  input  wire reset,
  input  wire line1,
  input  wire line2,
  input  wire [4:0] fault_en,   // passed in, but golden ties/ignores by using 0s internally
  output reg  outp,
  output reg  overflw,
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
  reg  [2:0] stato_d;
  reg  outp_d;
  reg  overflw_d;

  assign stato_dbg = stato_q;

  // State register
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
    .Q(outp)
  );

  // overflw
  FI_DFF_DFRTP_FAULTY U_OV_G (
    .CLK(clock),
    .D(overflw_d),
    .RESET_B(~reset),
    .fault_en(1'b0),
    .Q(overflw)
  );

  // Combinational next-state + output logic
  always @* begin
    stato_d    = stato_q;
    outp_d     = 1'b0;
    overflw_d  = 1'b0;

    case(stato_q)
      a: begin
        stato_d = (line1 & line2) ? f : b;
        outp_d  = line1 ^ line2;
      end
      e: begin
        stato_d   = (line1 & line2) ? f : b;
        outp_d    = line1 ^ line2;
        overflw_d = 1'b1;
      end
      b: begin
        stato_d = (line1 & line2) ? g : c;
        outp_d  = line1 ^ line2;
      end
      f: begin
        stato_d = (line1 | line2) ? g : c;
        outp_d  = ~(line1 ^ line2);
      end
      c: begin
        stato_d = (line1 & line2) ? wf1 : wf0;
        outp_d  = line1 ^ line2;
      end
      g: begin
        stato_d = (line1 | line2) ? wf1 : wf0;
        outp_d  = ~(line1 ^ line2);
      end
      wf0: begin
        stato_d = (line1 & line2) ? e : a;
        outp_d  = line1 ^ line2;
      end
      wf1: begin
        stato_d = (line1 | line2) ? e : a;
        outp_d  = ~(line1 ^ line2);
      end
    endcase
  end

  // Registered outputs (match original RTL structure)
  always @(posedge clock or posedge reset) begin
    if (reset) begin
      outp     <= 1'b0;
      overflw  <= 1'b0;
    end else begin
      outp     <= outp_d;
      overflw  <= overflw_d;
    end
  end

endmodule

module DUT_FAULTY(
  input  wire clock,
  input  wire reset,
  input  wire line1,
  input  wire line2,
  input  wire [4:0] fault_en,
  output reg  outp,
  output reg  overflw,
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
  reg  [2:0] stato_d;
  reg  outp_d;
  reg  overflw_d;

  assign stato_dbg = stato_q;

  // Fault-injected state register
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
    .Q(outp)
  );

  // fault_en[1] -> overflw
  FI_DFF_DFRTP_FAULTY U_OV_F (
    .CLK(clock),
    .D(overflw_d),
    .RESET_B(~reset),
    .fault_en(fault_en[1]),
    .Q(overflw)
  );

  // Same combinational logic
  always @* begin
    stato_d    = stato_q;
    outp_d     = 1'b0;
    overflw_d  = 1'b0;

    case(stato_q)
      a: begin
        stato_d = (line1 & line2) ? f : b;
        outp_d  = line1 ^ line2;
      end
      e: begin
        stato_d   = (line1 & line2) ? f : b;
        outp_d    = line1 ^ line2;
        overflw_d = 1'b1;
      end
      b: begin
        stato_d = (line1 & line2) ? g : c;
        outp_d  = line1 ^ line2;
      end
      f: begin
        stato_d = (line1 | line2) ? g : c;
        outp_d  = ~(line1 ^ line2);
      end
      c: begin
        stato_d = (line1 & line2) ? wf1 : wf0;
        outp_d  = line1 ^ line2;
      end
      g: begin
        stato_d = (line1 | line2) ? wf1 : wf0;
        outp_d  = ~(line1 ^ line2);
      end
      wf0: begin
        stato_d = (line1 & line2) ? e : a;
        outp_d  = line1 ^ line2;
      end
      wf1: begin
        stato_d = (line1 | line2) ? e : a;
        outp_d  = ~(line1 ^ line2);
      end
    endcase
  end

  /*always @(posedge clock or posedge reset) begin
    if (reset) begin
      outp     <= 1'b0;
      overflw  <= 1'b0;
    end else begin
      outp     <= outp_d;
      overflw  <= overflw_d;
    end
  end*/

endmodule