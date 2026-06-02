////////////////////////////////////////////////////////////
// HOW TO RUN
//
// RTL:
// iverilog -g2012 -Wall -DRTL -s tb_b01_compare -o sim_b01_rtl.vvp \
//   b01.v tb_b01_fi_compare.v
// vvp sim_b01_rtl.vvp
//
// GL:
// iverilog -g2012 -Wall -DGL -s tb_b01_compare -o sim_b01_gl.vvp \
//   $PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v \
//   $PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v \
//   b01_gl.v tb_b01_fi_compare.v
// vvp sim_b01_gl.vvp
////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tb_b01_fi;

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
  // DUTs: original RTL or unedited GL
  ////////////////////////////////////////////////////////////
`ifdef RTL
  b01 DUT_GOLDEN (
    .line1(line1),
    .line2(line2),
    .reset(reset),
    .outp(outp_g),
    .overflw(overflw_g),
    .clock(clock)
  );

  b01 DUT_FAULTY (
    .line1(line1),
    .line2(line2),
    .reset(reset),
    .outp(outp_f),
    .overflw(overflw_f),
    .clock(clock)
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

`else

  initial begin
    $display("ERROR: Compile with either -DRTL or -DGL");
    $finish;
  end

`endif

  ////////////////////////////////////////////////////////////
  // State visibility
  ////////////////////////////////////////////////////////////

`ifdef RTL

  assign st_g = DUT_GOLDEN.stato;
  assign st_f = DUT_FAULTY.stato;

`elsif GL

  assign st_g = {DUT_GOLDEN.\stato[2] ,
                 DUT_GOLDEN.\stato[1] ,
                 DUT_GOLDEN.\stato[0] };

  assign st_f = {DUT_FAULTY.\stato[2] ,
                 DUT_FAULTY.\stato[1] ,
                 DUT_FAULTY.\stato[0] };

`endif

  ////////////////////////////////////////////////////////////
  // Fault target mapping
  ////////////////////////////////////////////////////////////
  // fault_en[0] = outp
  // fault_en[1] = overflw
  // fault_en[2] = stato[0]
  // fault_en[3] = stato[1]
  // fault_en[4] = stato[2]

  localparam [4:0] FI_OUTP     = 5'b00001;
  localparam [4:0] FI_OVERFLW  = 5'b00010;
  localparam [4:0] FI_STATO_0  = 5'b00100;
  localparam [4:0] FI_STATO_1  = 5'b01000;
  localparam [4:0] FI_STATO_2  = 5'b10000;

  localparam integer INJECT_CYCLE = 30;
  localparam [4:0]   INJECT_MASK  = FI_STATO_0;

  ////////////////////////////////////////////////////////////
  // Cycle counter
  ////////////////////////////////////////////////////////////

  integer cycle_count = 0;
  integer post_cycles = 0;
  reg injection_seen = 0;

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
  // Fault enable pulse
  ////////////////////////////////////////////////////////////

  always @(negedge clock) begin
    if (cycle_count == INJECT_CYCLE)
      fault_en <= INJECT_MASK;
    else
      fault_en <= 5'b00000;
  end

  ////////////////////////////////////////////////////////////
  // Testbench-only fault injection
  ////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////
 `ifdef RTL
  always @(posedge clock) begin
    #0.2;

    if (!reset) begin
      if (fault_en[0])
        DUT_FAULTY.outp = ~DUT_FAULTY.outp;

      if (fault_en[1])
        DUT_FAULTY.overflw = ~DUT_FAULTY.overflw;

      if (fault_en[2])
        DUT_FAULTY.stato[0] = ~DUT_FAULTY.stato[0];

      if (fault_en[3])
        DUT_FAULTY.stato[1] = ~DUT_FAULTY.stato[1];

      if (fault_en[4])
        DUT_FAULTY.stato[2] = ~DUT_FAULTY.stato[2];
    end
  end
 `endif

  ////////////////////////////////////////////////////////////
  // Mismatch tracker
  ////////////////////////////////////////////////////////////

  reg first_mismatch_seen = 0;

  always @(posedge clock) begin
    #0.5;

    if ((outp_g !== outp_f) ||
        (overflw_g !== overflw_f) ||
        (st_g !== st_f)) begin

      if (!first_mismatch_seen) begin
        $display("***** FIRST MISMATCH at cycle %0d *****", cycle_count);
        first_mismatch_seen <= 1;
      end
    end
  end

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
      ((outp_g !== outp_f) ||
       (overflw_g !== overflw_f) ||
       (st_g !== st_f)) ? "<-- MISMATCH" : ""
    );
  end
  endtask

  ////////////////////////////////////////////////////////////
  // Stimulus
  ////////////////////////////////////////////////////////////

  integer i;

  initial begin

`ifdef RTL
    $dumpfile("b01_rtl_original_compare.vcd");
`elsif GL
    $dumpfile("b01_gl_original_compare.vcd");
`endif

    $dumpvars(0, tb_b01_fi);

    drive(1,0,0);
    drive(1,0,0);
    drive(0,0,0);

    for (i = 0; i < 6; i = i + 1) begin
      drive(0,0,0);
      drive(0,0,1);
      drive(0,1,0);
      drive(0,1,1);
    end

    for (i = 0; i < 30; i = i + 1) begin
      drive(0, $random, $random);
    end

    $display("Stimulus completed.");
    $finish;
  end

endmodule
