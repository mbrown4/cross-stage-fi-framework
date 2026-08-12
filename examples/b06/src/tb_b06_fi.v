`timescale 1ns/1ps

module tb_b06_fi;

  reg clock = 0;
  always #5 clock = ~clock;

  reg reset = 0;
  reg eql = 0;
  reg cont_eql = 0;
  reg [11:0] fault_en = 12'b0;

  wire [2:1] cc_mux_g, cc_mux_f;
  wire [2:1] uscite_g, uscite_f;
  wire enable_count_g, enable_count_f;
  wire ackout_g, ackout_f;

`ifdef RTL
  wire [2:0] st_g, st_f;
`elsif GL
  wire [6:0] st_g, st_f;
`endif
  wire [11:0] mapped_regs_g, mapped_regs_f;

`ifdef RTL
  b06 DUT_GOLDEN (
    .cc_mux(cc_mux_g),
    .eql(eql),
    .uscite(uscite_g),
    .clock(clock),
    .enable_count(enable_count_g),
    .ackout(ackout_g),
    .reset(reset),
    .cont_eql(cont_eql)
  );
  b06 DUT_FAULTY (
    .cc_mux(cc_mux_f),
    .eql(eql),
    .uscite(uscite_f),
    .clock(clock),
    .enable_count(enable_count_f),
    .ackout(ackout_f),
    .reset(reset),
    .cont_eql(cont_eql)
  );
`elsif GL
  b06 DUT_GOLDEN (
    .cc_mux(cc_mux_g),
    .eql(eql),
    .uscite(uscite_g),
    .clock(clock),
    .enable_count(enable_count_g),
    .ackout(ackout_g),
    .reset(reset),
    .cont_eql(cont_eql),
    .fault_en(12'b0)
  );
  b06 DUT_FAULTY (
    .cc_mux(cc_mux_f),
    .eql(eql),
    .uscite(uscite_f),
    .clock(clock),
    .enable_count(enable_count_f),
    .ackout(ackout_f),
    .reset(reset),
    .cont_eql(cont_eql),
    .fault_en(fault_en)
  );
`else
  initial begin $display("ERROR: Compile with -DRTL or -DGL"); $finish; end
`endif

`ifdef RTL
  assign st_g = DUT_GOLDEN.state;
  assign st_f = DUT_FAULTY.state;
  assign mapped_regs_g[0] = DUT_GOLDEN.state[0];
  assign mapped_regs_f[0] = DUT_FAULTY.state[0];
  assign mapped_regs_g[1] = DUT_GOLDEN.state[1];
  assign mapped_regs_f[1] = DUT_FAULTY.state[1];
  assign mapped_regs_g[2] = DUT_GOLDEN.state[2];
  assign mapped_regs_f[2] = DUT_FAULTY.state[2];
  assign mapped_regs_g[3] = 1'b0; // GL_ONLY
  assign mapped_regs_f[3] = 1'b0; // GL_ONLY
  assign mapped_regs_g[4] = 1'b0; // GL_ONLY
  assign mapped_regs_f[4] = 1'b0; // GL_ONLY
  assign mapped_regs_g[5] = 1'b0; // GL_ONLY
  assign mapped_regs_f[5] = 1'b0; // GL_ONLY
  assign mapped_regs_g[6] = DUT_GOLDEN.uscite[1];
  assign mapped_regs_f[6] = DUT_FAULTY.uscite[1];
  assign mapped_regs_g[7] = 1'b0; // GL_ONLY
  assign mapped_regs_f[7] = 1'b0; // GL_ONLY
  assign mapped_regs_g[8] = DUT_GOLDEN.cc_mux[1];
  assign mapped_regs_f[8] = DUT_FAULTY.cc_mux[1];
  assign mapped_regs_g[9] = 1'b0; // GL_ONLY
  assign mapped_regs_f[9] = 1'b0; // GL_ONLY
  assign mapped_regs_g[10] = DUT_GOLDEN.ackout;
  assign mapped_regs_f[10] = DUT_FAULTY.ackout;
  assign mapped_regs_g[11] = 1'b0; // GL_ONLY
  assign mapped_regs_f[11] = 1'b0; // GL_ONLY
`elsif GL
  assign st_g = {DUT_GOLDEN.\state[6] , DUT_GOLDEN.\state[5] , DUT_GOLDEN.\state[4] , DUT_GOLDEN.\state[3] , DUT_GOLDEN.\state[2] , DUT_GOLDEN.\state[1] , DUT_GOLDEN.\state[0] };
  assign st_f = {DUT_FAULTY.\state[6] , DUT_FAULTY.\state[5] , DUT_FAULTY.\state[4] , DUT_FAULTY.\state[3] , DUT_FAULTY.\state[2] , DUT_FAULTY.\state[1] , DUT_FAULTY.\state[0] };
  assign mapped_regs_g[0] = DUT_GOLDEN.\state[0] ;
  assign mapped_regs_f[0] = DUT_FAULTY.\state[0] ;
  assign mapped_regs_g[1] = DUT_GOLDEN.\state[1] ;
  assign mapped_regs_f[1] = DUT_FAULTY.\state[1] ;
  assign mapped_regs_g[2] = DUT_GOLDEN.\state[2] ;
  assign mapped_regs_f[2] = DUT_FAULTY.\state[2] ;
  assign mapped_regs_g[3] = DUT_GOLDEN.\state[3] ;
  assign mapped_regs_f[3] = DUT_FAULTY.\state[3] ;
  assign mapped_regs_g[4] = DUT_GOLDEN.\state[4] ;
  assign mapped_regs_f[4] = DUT_FAULTY.\state[4] ;
  assign mapped_regs_g[5] = DUT_GOLDEN.\state[5] ;
  assign mapped_regs_f[5] = DUT_FAULTY.\state[5] ;
  assign mapped_regs_g[6] = DUT_GOLDEN.uscite[1];
  assign mapped_regs_f[6] = DUT_FAULTY.uscite[1];
  assign mapped_regs_g[7] = DUT_GOLDEN.uscite[2];
  assign mapped_regs_f[7] = DUT_FAULTY.uscite[2];
  assign mapped_regs_g[8] = DUT_GOLDEN.cc_mux[1];
  assign mapped_regs_f[8] = DUT_FAULTY.cc_mux[1];
  assign mapped_regs_g[9] = DUT_GOLDEN.cc_mux[2];
  assign mapped_regs_f[9] = DUT_FAULTY.cc_mux[2];
  assign mapped_regs_g[10] = DUT_GOLDEN.ackout;
  assign mapped_regs_f[10] = DUT_FAULTY.ackout;
  assign mapped_regs_g[11] = DUT_GOLDEN.\state[6] ;
  assign mapped_regs_f[11] = DUT_FAULTY.\state[6] ;
`endif

  ////////////////////////////////////////////////////////////
  // Complete canonical fault target mapping
  ////////////////////////////////////////////////////////////
  // fault_en[0] = state[0] (RTL) -> _77_
  // fault_en[1] = state[1] (RTL) -> _78_
  // fault_en[2] = state[2] (RTL) -> _79_
  // fault_en[3] = state[3] (GL_ONLY) -> _80_
  // fault_en[4] = state[4] (GL_ONLY) -> _81_
  // fault_en[5] = state[5] (GL_ONLY) -> _82_
  // fault_en[6] = uscite[1] (RTL) -> _83_
  // fault_en[7] = uscite[2] (GL_ONLY) -> _84_
  // fault_en[8] = cc_mux[1] (RTL) -> _85_
  // fault_en[9] = cc_mux[2] (GL_ONLY) -> _86_
  // fault_en[10] = ackout[0] (RTL) -> _87_
  // fault_en[11] = state[6] (GL_ONLY) -> _88_

  localparam [11:0] FI_STATE_0 = 12'b000000000001;
  localparam [11:0] FI_STATE_1 = 12'b000000000010;
  localparam [11:0] FI_STATE_2 = 12'b000000000100;
  localparam [11:0] FI_STATE_3 = 12'b000000001000;
  localparam [11:0] FI_STATE_4 = 12'b000000010000;
  localparam [11:0] FI_STATE_5 = 12'b000000100000;
  localparam [11:0] FI_USCITE_1 = 12'b000001000000;
  localparam [11:0] FI_USCITE_2 = 12'b000010000000;
  localparam [11:0] FI_CC_MUX_1 = 12'b000100000000;
  localparam [11:0] FI_CC_MUX_2 = 12'b001000000000;
  localparam [11:0] FI_ACKOUT_0 = 12'b010000000000;
  localparam [11:0] FI_STATE_6 = 12'b100000000000;
  localparam [11:0] FI_ALL_RTL_MAPPED = 12'b010101000111;
  localparam [11:0] FI_ALL_GL = {12{1'b1}};
  localparam [11:0] FI_NONE = 12'b0;

  `ifndef FI_MASK
  `define FI_MASK FI_STATE_0
  `endif
  `ifndef INJECT_CYCLE
  `define INJECT_CYCLE 30
  `endif
  localparam integer INJECT_AT = `INJECT_CYCLE;
  localparam [11:0] INJECT_MASK = `FI_MASK;

  initial begin
    $display("INJECT_CYCLE=%0d", INJECT_AT);
    $display("INJECT_MASK=%012b", INJECT_MASK);
`ifdef RTL
    if ((INJECT_MASK & 12'b101010111000) != 12'b0)
      $display("WARNING: GL_ONLY target bits are ignored in RTL mode");
`endif
  end

  integer cycle_count = 0;
  integer post_cycles = 0;
  reg injection_seen = 0;
  reg first_mismatch_seen = 0;
  always @(posedge clock) begin
    cycle_count <= cycle_count + 1;
    if (fault_en != 12'b0) injection_seen <= 1;
    if (injection_seen) post_cycles <= post_cycles + 1;
    if (post_cycles == 20) begin $display("20 cycles post injection complete."); $finish; end
  end

  always @(negedge clock) begin
    if (cycle_count == INJECT_AT) fault_en <= INJECT_MASK;
    else fault_en <= 12'b0;
  end

`ifdef RTL
  always @(posedge clock) begin
    #0.2;
    if (!reset) begin
      if (fault_en[0]) DUT_FAULTY.state[0] = ~DUT_FAULTY.state[0];
      if (fault_en[1]) DUT_FAULTY.state[1] = ~DUT_FAULTY.state[1];
      if (fault_en[2]) DUT_FAULTY.state[2] = ~DUT_FAULTY.state[2];
      if (fault_en[6]) DUT_FAULTY.uscite[1] = ~DUT_FAULTY.uscite[1];
      if (fault_en[8]) DUT_FAULTY.cc_mux[1] = ~DUT_FAULTY.cc_mux[1];
      if (fault_en[10]) DUT_FAULTY.ackout = ~DUT_FAULTY.ackout;
    end
  end
`endif

  always @(posedge clock) begin
    #0.5;
    if (mapped_regs_g !== mapped_regs_f) begin
      if (!first_mismatch_seen) begin
        $display("***** FIRST MISMATCH at cycle %0d *****", cycle_count);
        first_mismatch_seen <= 1;
      end
    end
  end

  task drive;
    input r;
    input eql_in;
    input cont_eql_in;
  begin
    @(negedge clock);
    reset = r;
    eql = eql_in;
    cont_eql = cont_eql_in;
    @(posedge clock); #1;
    $display("CYCLE=%0d | rst=%0b eql=%0b cont_eql=%0b fe=%012b | G:cc_mux=%0h F:cc_mux=%0h G:uscite=%0h F:uscite=%0h G:enable_count=%0h F:enable_count=%0h G:ackout=%0h F:ackout=%0h G:st=%0h F:st=%0h G:regs=%012b F:regs=%012b %s",
      cycle_count, reset, eql, cont_eql, fault_en, cc_mux_g, cc_mux_f, uscite_g, uscite_f, enable_count_g, enable_count_f, ackout_g, ackout_f, st_g, st_f, mapped_regs_g, mapped_regs_f, (mapped_regs_g !== mapped_regs_f) ? "<-- MISMATCH" : " ");
  end
  endtask

  integer i;
  initial begin
`ifdef RTL
    $dumpfile("b06_rtl_original_compare.vcd");
`elsif GL
    $dumpfile("b06_gl_faulty_compare.vcd");
`endif
    $dumpvars(0, tb_b06_fi);
    drive(1, 0, 0);
    drive(1, 0, 0);
    drive(0, 0, 0);
    for (i=0; i<50; i=i+1) drive(0, $random, $random);
    $display("Stimulus completed.");
    $finish;
  end
endmodule
