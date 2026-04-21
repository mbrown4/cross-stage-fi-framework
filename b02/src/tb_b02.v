////////////////////////////////////////////////////////////
// HOW TO RUN
//
// RTL:
// iverilog -g2012 -Wall -DRTL -s tb_b02_compare -o sim_b02_rtl.vvp \
//   FI_DFF.v b02_wrap.v tb_b02.v
// vvp sim_b02_rtl.vvp
//
// GL:
// iverilog -g2012 -Wall -DGL -s tb_b02_compare -o sim_b02_gl.vvp \
//   FI_DFF.v \
//   $PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v \
//   $PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v \
//   b02_gl_faulty.v \
//   tb_b02.v
// vvp sim_b02_gl.vvp
////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tb_b02_compare;

`ifdef RTL
  localparam integer FAULT_W = 4;
`elsif GL
  localparam integer FAULT_W = 8;
`else
  localparam integer FAULT_W = 4;
`endif

  ////////////////////////////////////////////////////////////
  // Clock
  ////////////////////////////////////////////////////////////

  reg clock = 0;
  always #5 clock = ~clock;

  ////////////////////////////////////////////////////////////
  // Inputs
  ////////////////////////////////////////////////////////////

  reg reset = 0;
  reg linea = 0;
  reg [FAULT_W-1:0] fault_en = {FAULT_W{1'b0}};

  ////////////////////////////////////////////////////////////
  // Outputs / Debug
  ////////////////////////////////////////////////////////////

  wire u_g, u_f;

`ifdef RTL
  wire [2:0] st_g, st_f;
`elsif GL
  wire [6:0] st_g, st_f;
`endif

  ////////////////////////////////////////////////////////////
  // DUTs
  ////////////////////////////////////////////////////////////

`ifdef RTL

  DUT_GOLDEN golden (
    .clock(clock),
    .reset(reset),
    .linea(linea),
    .fault_en(4'b0000),
    .u(u_g),
    .stato_dbg(st_g)
  );

  DUT_FAULTY faulty (
    .clock(clock),
    .reset(reset),
    .linea(linea),
    .fault_en(fault_en),
    .u(u_f),
    .stato_dbg(st_f)
  );

`elsif GL

  b02 DUT_GOLDEN (
    .clock(clock),
    .reset(reset),
    .linea(linea),
    .fault_en({FAULT_W{1'b0}}),
    .u(u_g)
  );

  b02 DUT_FAULTY (
    .clock(clock),
    .reset(reset),
    .linea(linea),
    .fault_en(fault_en),
    .u(u_f)
  );

  // Gate-level FSM state extraction (7 encoded bits)
  assign st_g = {DUT_GOLDEN.\stato[6] ,
                 DUT_GOLDEN.\stato[5] ,
                 DUT_GOLDEN.\stato[4] ,
                 DUT_GOLDEN.\stato[3] ,
                 DUT_GOLDEN.\stato[2] ,
                 DUT_GOLDEN.\stato[1] ,
                 DUT_GOLDEN.\stato[0] };

  assign st_f = {DUT_FAULTY.\stato[6] ,
                 DUT_FAULTY.\stato[5] ,
                 DUT_FAULTY.\stato[4] ,
                 DUT_FAULTY.\stato[3] ,
                 DUT_FAULTY.\stato[2] ,
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

  task drive(input bit r, input bit l);
  begin
    @(negedge clock);
    reset = r;
    linea = l;

    @(posedge clock);
    #1;

`ifdef RTL
    $display("CYCLE=%0d | rst=%0b linea=%0b fe=%0b | G:st=%0d u=%0b | F:st=%0d u=%0b %s",
      cycle_count, reset, linea, fault_en,
      st_g, u_g,
      st_f, u_f,
      ((u_g !== u_f) || (st_g !== st_f)) ? "<-- MISMATCH" : ""
    );
`elsif GL
    $display("CYCLE=%0d | rst=%0b linea=%0b fe=%0b | G:st=%07b u=%0b | F:st=%07b u=%0b %s",
      cycle_count, reset, linea, fault_en,
      st_g, u_g,
      st_f, u_f,
      ((u_g !== u_f) || (st_g !== st_f)) ? "<-- MISMATCH" : ""
    );
`endif
  end
  endtask

  ////////////////////////////////////////////////////////////
  // Mismatch tracker
  ////////////////////////////////////////////////////////////

  reg first_mismatch_seen = 0;

  always @(posedge clock) begin
    if ((u_g !== u_f) || (st_g !== st_f)) begin
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

  always @(negedge clock) begin
`ifdef RTL
    if (cycle_count == 30)
      fault_en <= 4'b0001;   // inject u in RTL
    else
      fault_en <= 4'b0000;
`elsif GL
    if (cycle_count == 30)
      fault_en <= 8'b00000001; // inject u in GL
    else
      fault_en <= 8'b00000000;
`endif
  end

  always @(posedge clock) begin
    cycle_count <= cycle_count + 1;

    if (fault_en != {FAULT_W{1'b0}})
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
    $dumpfile("b02_rtl_compare.vcd");
`elsif GL
    $dumpfile("b02_gl_compare.vcd");
`endif

    $dumpvars(0, tb_b02_compare);

    // Reset
    drive(1,0);
    drive(1,0);
    drive(0,0);

    // Deterministic walk
    for (i = 0; i < 10; i = i + 1) begin
      drive(0,0);
      drive(0,1);
    end

    // Random phase
    for (i = 0; i < 20; i = i + 1)
      drive(0, $random);

    $display("Stimulus completed.");
    $finish;
  end

endmodule