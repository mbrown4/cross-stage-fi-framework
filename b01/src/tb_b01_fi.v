////////////////////////////////////////////////////////////
// HOW TO RUN
//
// RTL:
// iverilog -g2012 -Wall -DRTL -s tb_b01_compare -o sim_b01_rtl.vvp \
//   FI_DFF.v b01_wrap.v tb_b01.v
// vvp sim_b01_rtl.vvp
//
// GL:
// iverilog -g2012 -Wall -DGL -s tb_b01_compare -o sim_b01_gl.vvp \
//   FI_DFF.v \
//   $PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v \
//   $PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v \
//   b01_gl_faulty.v \
//   tb_b01.v
// vvp sim_b01_gl.vvp
////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tb_b01_compare;

  ////////////////////////////////////////////////////////////
  // Clock
  ////////////////////////////////////////////////////////////

  reg clock = 0;
  always #5 clock = ~clock;

  ////////////////////////////////////////////////////////////
  // Inputs
  ////////////////////////////////////////////////////////////

  reg reset = 0;
  reg line1 = 0;
  reg line2 = 0;
  reg [4:0] fault_en = 5'b00000;

  ////////////////////////////////////////////////////////////
  // Outputs
  ////////////////////////////////////////////////////////////

  wire outp_g, overflw_g;
  wire outp_f, overflw_f;
  wire [2:0] st_g, st_f;

  ////////////////////////////////////////////////////////////
  // DUTs
  ////////////////////////////////////////////////////////////

`ifdef RTL

  DUT_GOLDEN DUT_GOLDEN (
    .line1(line1),
    .line2(line2),
    .reset(reset),
    .outp(outp_g),
    .overflw(overflw_g),
    .stato_dbg(st_g),
    .clock(clock),
    .fault_en(5'b00000)
  );

  DUT_FAULTY DUT_FAULTY (
    .line1(line1),
    .line2(line2),
    .reset(reset),
    .outp(outp_f),
    .overflw(overflw_f),
    .stato_dbg(st_f),
    .clock(clock),
    .fault_en(fault_en)
  );

`elsif GL

  b01 DUT_GOLDEN (
    .line1(line1),
    .line2(line2),
    .reset(reset),
    .outp(outp_g),
    .overflw(overflw_g),
    .clock(clock),
    .fault_en(5'b00000)
  );

  b01 DUT_FAULTY (
    .line1(line1),
    .line2(line2),
    .reset(reset),
    .outp(outp_f),
    .overflw(overflw_f),
    .clock(clock),
    .fault_en(fault_en)
  );

  // Gate-level internal state extraction
  assign st_g = {DUT_GOLDEN.\stato[2] ,
                 DUT_GOLDEN.\stato[1] ,
                 DUT_GOLDEN.\stato[0] };

  assign st_f = {DUT_FAULTY.\stato[2] ,
                 DUT_FAULTY.\stato[1] ,
                 DUT_FAULTY.\stato[0] };

`else
  initial begin
    $display("ERROR: Compile with either -DRTL or -DGL");
    $finish;
  end
`endif

  ////////////////////////////////////////////////////////////
  // Drive Task
  ////////////////////////////////////////////////////////////

  task drive(input bit r, input bit l1, input bit l2);
  begin
    @(negedge clock);
    reset = r;
    line1 = l1;
    line2 = l2;

    @(posedge clock);
    #1;

    $display("CYCLE=%0d | rst=%0b l1=%0b l2=%0b fe=%05b | G:st=%0d o=%0b ov=%0b | F:st=%0d o=%0b ov=%0b %s",
      cycle_count, reset, line1, line2, fault_en,
      st_g, outp_g, overflw_g,
      st_f, outp_f, overflw_f,
      ((outp_g !== outp_f) || (overflw_g !== overflw_f) || (st_g !== st_f)) ? "<-- MISMATCH" : ""
    );
  end
  endtask

  ////////////////////////////////////////////////////////////
  // Mismatch tracker
  ////////////////////////////////////////////////////////////

  reg first_mismatch_seen = 0;

  always @(posedge clock) begin
    if ((outp_g !== outp_f) || (overflw_g !== overflw_f) || (st_g !== st_f)) begin
      if (!first_mismatch_seen) begin
        $display("***** FIRST MISMATCH at cycle %0d *****", cycle_count);
        first_mismatch_seen <= 1;
      end
    end
  end

  ////////////////////////////////////////////////////////////
  // Injection Control
  ////////////////////////////////////////////////////////////

  integer cycle_count = 0;
  integer post_cycles = 0;
  reg injection_seen = 0;

  // Apply fault before the active sampling edge
  always @(negedge clock) begin
    if (cycle_count == 30)
      fault_en <= 5'b01000;   // inject fault into stato[1]
    else
      fault_en <= 5'b00000;
  end

  always @(posedge clock) begin
    cycle_count <= cycle_count + 1;

    if (fault_en != 5'b00000)
      injection_seen <= 1;

    if (injection_seen)
      post_cycles <= post_cycles + 1;

    if (post_cycles == 20) begin
      $display("20 cycles post injection complete.");
      $finish;
    end
  end

  ////////////////////////////////////////////////////////////
  // Stimulus
  ////////////////////////////////////////////////////////////

  integer i;

  initial begin

`ifdef RTL
    $dumpfile("b01_rtl_compare.vcd");
`elsif GL
    $dumpfile("b01_gl_compare.vcd");
`endif

    $dumpvars(0, tb_b01_compare);

    // Reset sequence
    drive(1,0,0);
    drive(1,0,0);
    drive(0,0,0);

    // Deterministic sweep
    for (i = 0; i < 6; i = i + 1) begin
      drive(0,0,0);
      drive(0,0,1);
      drive(0,1,0);
      drive(0,1,1);
    end

    // Random phase
    for (i = 0; i < 20; i = i + 1) begin
      drive(0, $random, $random);
    end

    $display("Stimulus completed.");
    $finish;
  end

endmodule