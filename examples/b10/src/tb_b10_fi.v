`timescale 1ns/1ps

module tb_b10_fi;

  reg clock = 0;
  always #5 clock = ~clock;

  reg reset = 0;
  reg r_button = 0;
  reg g_button = 0;
  reg key = 0;
  reg start = 0;
  reg test = 0;
  reg rts = 0;
  reg rtr = 0;
  reg [3:0] v_in = 0;
  reg [23:0] fault_en = 24'b0;

  wire [3:0] v_out_g, v_out_f;
  wire cts_g, cts_f;
  wire ctr_g, ctr_f;

`ifdef RTL
  wire [3:0] st_g, st_f;
`elsif GL
  wire [10:0] st_g, st_f;
`endif
  wire [23:0] mapped_regs_g, mapped_regs_f;

`ifdef RTL
  b10 DUT_GOLDEN (
    .r_button(r_button),
    .g_button(g_button),
    .key(key),
    .start(start),
    .reset(reset),
    .test(test),
    .cts(cts_g),
    .ctr(ctr_g),
    .rts(rts),
    .rtr(rtr),
    .clock(clock),
    .v_in(v_in),
    .v_out(v_out_g)
  );
  b10 DUT_FAULTY (
    .r_button(r_button),
    .g_button(g_button),
    .key(key),
    .start(start),
    .reset(reset),
    .test(test),
    .cts(cts_f),
    .ctr(ctr_f),
    .rts(rts),
    .rtr(rtr),
    .clock(clock),
    .v_in(v_in),
    .v_out(v_out_f)
  );
`elsif GL
  b10 DUT_GOLDEN (
    .r_button(r_button),
    .g_button(g_button),
    .key(key),
    .start(start),
    .reset(reset),
    .test(test),
    .cts(cts_g),
    .ctr(ctr_g),
    .rts(rts),
    .rtr(rtr),
    .clock(clock),
    .v_in(v_in),
    .v_out(v_out_g),
    .fault_en(24'b0)
  );
  b10 DUT_FAULTY (
    .r_button(r_button),
    .g_button(g_button),
    .key(key),
    .start(start),
    .reset(reset),
    .test(test),
    .cts(cts_f),
    .ctr(ctr_f),
    .rts(rts),
    .rtr(rtr),
    .clock(clock),
    .v_in(v_in),
    .v_out(v_out_f),
    .fault_en(fault_en)
  );
`else
  initial begin $display("ERROR: Compile with -DRTL or -DGL"); $finish; end
`endif

`ifdef RTL
  assign st_g = DUT_GOLDEN.stato;
  assign st_f = DUT_FAULTY.stato;
  assign mapped_regs_g[0] = DUT_GOLDEN.stato[0];
  assign mapped_regs_f[0] = DUT_FAULTY.stato[0];
  assign mapped_regs_g[1] = DUT_GOLDEN.stato[1];
  assign mapped_regs_f[1] = DUT_FAULTY.stato[1];
  assign mapped_regs_g[2] = DUT_GOLDEN.stato[2];
  assign mapped_regs_f[2] = DUT_FAULTY.stato[2];
  assign mapped_regs_g[3] = DUT_GOLDEN.stato[3];
  assign mapped_regs_f[3] = DUT_FAULTY.stato[3];
  assign mapped_regs_g[4] = 1'b0; // GL_ONLY
  assign mapped_regs_f[4] = 1'b0; // GL_ONLY
  assign mapped_regs_g[5] = 1'b0; // GL_ONLY
  assign mapped_regs_f[5] = 1'b0; // GL_ONLY
  assign mapped_regs_g[6] = 1'b0; // GL_ONLY
  assign mapped_regs_f[6] = 1'b0; // GL_ONLY
  assign mapped_regs_g[7] = 1'b0; // GL_ONLY
  assign mapped_regs_f[7] = 1'b0; // GL_ONLY
  assign mapped_regs_g[8] = 1'b0; // GL_ONLY
  assign mapped_regs_f[8] = 1'b0; // GL_ONLY
  assign mapped_regs_g[9] = 1'b0; // GL_ONLY
  assign mapped_regs_f[9] = 1'b0; // GL_ONLY
  assign mapped_regs_g[10] = 1'b0; // GL_ONLY
  assign mapped_regs_f[10] = 1'b0; // GL_ONLY
  assign mapped_regs_g[11] = DUT_GOLDEN.ctr;
  assign mapped_regs_f[11] = DUT_FAULTY.ctr;
  assign mapped_regs_g[12] = DUT_GOLDEN.sign[3];
  assign mapped_regs_f[12] = DUT_FAULTY.sign[3];
  assign mapped_regs_g[13] = DUT_GOLDEN.v_out[0];
  assign mapped_regs_f[13] = DUT_FAULTY.v_out[0];
  assign mapped_regs_g[14] = DUT_GOLDEN.v_out[1];
  assign mapped_regs_f[14] = DUT_FAULTY.v_out[1];
  assign mapped_regs_g[15] = DUT_GOLDEN.v_out[2];
  assign mapped_regs_f[15] = DUT_FAULTY.v_out[2];
  assign mapped_regs_g[16] = DUT_GOLDEN.v_out[3];
  assign mapped_regs_f[16] = DUT_FAULTY.v_out[3];
  assign mapped_regs_g[17] = DUT_GOLDEN.voto0;
  assign mapped_regs_f[17] = DUT_FAULTY.voto0;
  assign mapped_regs_g[18] = DUT_GOLDEN.voto1;
  assign mapped_regs_f[18] = DUT_FAULTY.voto1;
  assign mapped_regs_g[19] = DUT_GOLDEN.voto2;
  assign mapped_regs_f[19] = DUT_FAULTY.voto2;
  assign mapped_regs_g[20] = DUT_GOLDEN.voto3;
  assign mapped_regs_f[20] = DUT_FAULTY.voto3;
  assign mapped_regs_g[21] = DUT_GOLDEN.last_g;
  assign mapped_regs_f[21] = DUT_FAULTY.last_g;
  assign mapped_regs_g[22] = DUT_GOLDEN.last_r;
  assign mapped_regs_f[22] = DUT_FAULTY.last_r;
  assign mapped_regs_g[23] = DUT_GOLDEN.cts;
  assign mapped_regs_f[23] = DUT_FAULTY.cts;
`elsif GL
  assign st_g = {DUT_GOLDEN.\stato[10] , DUT_GOLDEN.\stato[9] , DUT_GOLDEN.\stato[8] , DUT_GOLDEN.\stato[7] , DUT_GOLDEN.\stato[6] , DUT_GOLDEN.\stato[5] , DUT_GOLDEN.\stato[4] , DUT_GOLDEN.\stato[3] , DUT_GOLDEN.\stato[2] , DUT_GOLDEN.\stato[1] , DUT_GOLDEN.\stato[0] };
  assign st_f = {DUT_FAULTY.\stato[10] , DUT_FAULTY.\stato[9] , DUT_FAULTY.\stato[8] , DUT_FAULTY.\stato[7] , DUT_FAULTY.\stato[6] , DUT_FAULTY.\stato[5] , DUT_FAULTY.\stato[4] , DUT_FAULTY.\stato[3] , DUT_FAULTY.\stato[2] , DUT_FAULTY.\stato[1] , DUT_FAULTY.\stato[0] };
  assign mapped_regs_g[0] = DUT_GOLDEN.\stato[0] ;
  assign mapped_regs_f[0] = DUT_FAULTY.\stato[0] ;
  assign mapped_regs_g[1] = DUT_GOLDEN.\stato[1] ;
  assign mapped_regs_f[1] = DUT_FAULTY.\stato[1] ;
  assign mapped_regs_g[2] = DUT_GOLDEN.\stato[2] ;
  assign mapped_regs_f[2] = DUT_FAULTY.\stato[2] ;
  assign mapped_regs_g[3] = DUT_GOLDEN.\stato[3] ;
  assign mapped_regs_f[3] = DUT_FAULTY.\stato[3] ;
  assign mapped_regs_g[4] = DUT_GOLDEN.\stato[4] ;
  assign mapped_regs_f[4] = DUT_FAULTY.\stato[4] ;
  assign mapped_regs_g[5] = DUT_GOLDEN.\stato[5] ;
  assign mapped_regs_f[5] = DUT_FAULTY.\stato[5] ;
  assign mapped_regs_g[6] = DUT_GOLDEN.\stato[6] ;
  assign mapped_regs_f[6] = DUT_FAULTY.\stato[6] ;
  assign mapped_regs_g[7] = DUT_GOLDEN.\stato[7] ;
  assign mapped_regs_f[7] = DUT_FAULTY.\stato[7] ;
  assign mapped_regs_g[8] = DUT_GOLDEN.\stato[8] ;
  assign mapped_regs_f[8] = DUT_FAULTY.\stato[8] ;
  assign mapped_regs_g[9] = DUT_GOLDEN.\stato[9] ;
  assign mapped_regs_f[9] = DUT_FAULTY.\stato[9] ;
  assign mapped_regs_g[10] = DUT_GOLDEN.\stato[10] ;
  assign mapped_regs_f[10] = DUT_FAULTY.\stato[10] ;
  assign mapped_regs_g[11] = DUT_GOLDEN.ctr;
  assign mapped_regs_f[11] = DUT_FAULTY.ctr;
  assign mapped_regs_g[12] = DUT_GOLDEN.\sign[3] ;
  assign mapped_regs_f[12] = DUT_FAULTY.\sign[3] ;
  assign mapped_regs_g[13] = DUT_GOLDEN.v_out[0];
  assign mapped_regs_f[13] = DUT_FAULTY.v_out[0];
  assign mapped_regs_g[14] = DUT_GOLDEN.v_out[1];
  assign mapped_regs_f[14] = DUT_FAULTY.v_out[1];
  assign mapped_regs_g[15] = DUT_GOLDEN.v_out[2];
  assign mapped_regs_f[15] = DUT_FAULTY.v_out[2];
  assign mapped_regs_g[16] = DUT_GOLDEN.v_out[3];
  assign mapped_regs_f[16] = DUT_FAULTY.v_out[3];
  assign mapped_regs_g[17] = DUT_GOLDEN.voto0;
  assign mapped_regs_f[17] = DUT_FAULTY.voto0;
  assign mapped_regs_g[18] = DUT_GOLDEN.voto1;
  assign mapped_regs_f[18] = DUT_FAULTY.voto1;
  assign mapped_regs_g[19] = DUT_GOLDEN.voto2;
  assign mapped_regs_f[19] = DUT_FAULTY.voto2;
  assign mapped_regs_g[20] = DUT_GOLDEN.voto3;
  assign mapped_regs_f[20] = DUT_FAULTY.voto3;
  assign mapped_regs_g[21] = DUT_GOLDEN.last_g;
  assign mapped_regs_f[21] = DUT_FAULTY.last_g;
  assign mapped_regs_g[22] = DUT_GOLDEN.last_r;
  assign mapped_regs_f[22] = DUT_FAULTY.last_r;
  assign mapped_regs_g[23] = DUT_GOLDEN.cts;
  assign mapped_regs_f[23] = DUT_FAULTY.cts;
`endif

  ////////////////////////////////////////////////////////////
  // Complete canonical fault target mapping
  ////////////////////////////////////////////////////////////
  // fault_en[0] = stato[0] (RTL) -> _197_
  // fault_en[1] = stato[1] (RTL) -> _198_
  // fault_en[2] = stato[2] (RTL) -> _199_
  // fault_en[3] = stato[3] (RTL) -> _200_
  // fault_en[4] = stato[4] (GL_ONLY) -> _201_
  // fault_en[5] = stato[5] (GL_ONLY) -> _202_
  // fault_en[6] = stato[6] (GL_ONLY) -> _203_
  // fault_en[7] = stato[7] (GL_ONLY) -> _204_
  // fault_en[8] = stato[8] (GL_ONLY) -> _205_
  // fault_en[9] = stato[9] (GL_ONLY) -> _206_
  // fault_en[10] = stato[10] (GL_ONLY) -> _207_
  // fault_en[11] = ctr[0] (RTL) -> _208_
  // fault_en[12] = sign[3] (RTL) -> _209_
  // fault_en[13] = v_out[0] (RTL) -> _210_
  // fault_en[14] = v_out[1] (RTL) -> _211_
  // fault_en[15] = v_out[2] (RTL) -> _212_
  // fault_en[16] = v_out[3] (RTL) -> _213_
  // fault_en[17] = voto0[0] (RTL) -> _214_
  // fault_en[18] = voto1[0] (RTL) -> _215_
  // fault_en[19] = voto2[0] (RTL) -> _216_
  // fault_en[20] = voto3[0] (RTL) -> _217_
  // fault_en[21] = last_g[0] (RTL) -> _218_
  // fault_en[22] = last_r[0] (RTL) -> _219_
  // fault_en[23] = cts[0] (RTL) -> _220_

  localparam [23:0] FI_STATO_0 = 24'b000000000000000000000001;
  localparam [23:0] FI_STATO_1 = 24'b000000000000000000000010;
  localparam [23:0] FI_STATO_2 = 24'b000000000000000000000100;
  localparam [23:0] FI_STATO_3 = 24'b000000000000000000001000;
  localparam [23:0] FI_STATO_4 = 24'b000000000000000000010000;
  localparam [23:0] FI_STATO_5 = 24'b000000000000000000100000;
  localparam [23:0] FI_STATO_6 = 24'b000000000000000001000000;
  localparam [23:0] FI_STATO_7 = 24'b000000000000000010000000;
  localparam [23:0] FI_STATO_8 = 24'b000000000000000100000000;
  localparam [23:0] FI_STATO_9 = 24'b000000000000001000000000;
  localparam [23:0] FI_STATO_10 = 24'b000000000000010000000000;
  localparam [23:0] FI_CTR_0 = 24'b000000000000100000000000;
  localparam [23:0] FI_SIGN_3 = 24'b000000000001000000000000;
  localparam [23:0] FI_V_OUT_0 = 24'b000000000010000000000000;
  localparam [23:0] FI_V_OUT_1 = 24'b000000000100000000000000;
  localparam [23:0] FI_V_OUT_2 = 24'b000000001000000000000000;
  localparam [23:0] FI_V_OUT_3 = 24'b000000010000000000000000;
  localparam [23:0] FI_VOTO0_0 = 24'b000000100000000000000000;
  localparam [23:0] FI_VOTO1_0 = 24'b000001000000000000000000;
  localparam [23:0] FI_VOTO2_0 = 24'b000010000000000000000000;
  localparam [23:0] FI_VOTO3_0 = 24'b000100000000000000000000;
  localparam [23:0] FI_LAST_G_0 = 24'b001000000000000000000000;
  localparam [23:0] FI_LAST_R_0 = 24'b010000000000000000000000;
  localparam [23:0] FI_CTS_0 = 24'b100000000000000000000000;
  localparam [23:0] FI_ALL_RTL_MAPPED = 24'b111111111111100000001111;
  localparam [23:0] FI_ALL_GL = {24{1'b1}};
  localparam [23:0] FI_NONE = 24'b0;

  `ifndef FI_MASK
  `define FI_MASK FI_STATO_0
  `endif
  `ifndef INJECT_CYCLE
  `define INJECT_CYCLE 30
  `endif
  localparam integer INJECT_AT = `INJECT_CYCLE;
  localparam [23:0] INJECT_MASK = `FI_MASK;

  initial begin
    $display("INJECT_CYCLE=%0d", INJECT_AT);
    $display("INJECT_MASK=%024b", INJECT_MASK);
`ifdef RTL
    if ((INJECT_MASK & 24'b000000000000011111110000) != 24'b0)
      $display("WARNING: GL_ONLY target bits are ignored in RTL mode");
`endif
  end

  integer cycle_count = 0;
  integer post_cycles = 0;
  reg injection_seen = 0;
  reg first_mismatch_seen = 0;
  always @(posedge clock) begin
    cycle_count <= cycle_count + 1;
    if (fault_en != 24'b0) injection_seen <= 1;
    if (injection_seen) post_cycles <= post_cycles + 1;
    if (post_cycles == 20) begin $display("20 cycles post injection complete."); $finish; end
  end

  always @(negedge clock) begin
    if (cycle_count == INJECT_AT) fault_en <= INJECT_MASK;
    else fault_en <= 24'b0;
  end

`ifdef RTL
  always @(posedge clock) begin
    #0.2;
    if (!reset) begin
      if (fault_en[0]) DUT_FAULTY.stato[0] = ~DUT_FAULTY.stato[0];
      if (fault_en[1]) DUT_FAULTY.stato[1] = ~DUT_FAULTY.stato[1];
      if (fault_en[2]) DUT_FAULTY.stato[2] = ~DUT_FAULTY.stato[2];
      if (fault_en[3]) DUT_FAULTY.stato[3] = ~DUT_FAULTY.stato[3];
      if (fault_en[11]) DUT_FAULTY.ctr = ~DUT_FAULTY.ctr;
      if (fault_en[12]) DUT_FAULTY.sign[3] = ~DUT_FAULTY.sign[3];
      if (fault_en[13]) DUT_FAULTY.v_out[0] = ~DUT_FAULTY.v_out[0];
      if (fault_en[14]) DUT_FAULTY.v_out[1] = ~DUT_FAULTY.v_out[1];
      if (fault_en[15]) DUT_FAULTY.v_out[2] = ~DUT_FAULTY.v_out[2];
      if (fault_en[16]) DUT_FAULTY.v_out[3] = ~DUT_FAULTY.v_out[3];
      if (fault_en[17]) DUT_FAULTY.voto0 = ~DUT_FAULTY.voto0;
      if (fault_en[18]) DUT_FAULTY.voto1 = ~DUT_FAULTY.voto1;
      if (fault_en[19]) DUT_FAULTY.voto2 = ~DUT_FAULTY.voto2;
      if (fault_en[20]) DUT_FAULTY.voto3 = ~DUT_FAULTY.voto3;
      if (fault_en[21]) DUT_FAULTY.last_g = ~DUT_FAULTY.last_g;
      if (fault_en[22]) DUT_FAULTY.last_r = ~DUT_FAULTY.last_r;
      if (fault_en[23]) DUT_FAULTY.cts = ~DUT_FAULTY.cts;
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
    input r_button_in;
    input g_button_in;
    input key_in;
    input start_in;
    input test_in;
    input rts_in;
    input rtr_in;
    input v_in_in;
  begin
    @(negedge clock);
    reset = r;
    r_button = r_button_in;
    g_button = g_button_in;
    key = key_in;
    start = start_in;
    test = test_in;
    rts = rts_in;
    rtr = rtr_in;
    v_in = v_in_in;
    @(posedge clock); #1;
    $display("CYCLE=%0d | rst=%0b r_button=%0b g_button=%0b key=%0b start=%0b test=%0b rts=%0b rtr=%0b v_in=%0b fe=%024b | G:v_out=%0h F:v_out=%0h G:cts=%0h F:cts=%0h G:ctr=%0h F:ctr=%0h G:st=%0h F:st=%0h G:regs=%024b F:regs=%024b %s",
      cycle_count, reset, r_button, g_button, key, start, test, rts, rtr, v_in, fault_en, v_out_g, v_out_f, cts_g, cts_f, ctr_g, ctr_f, st_g, st_f, mapped_regs_g, mapped_regs_f, (mapped_regs_g !== mapped_regs_f) ? "<-- MISMATCH" : " ");
  end
  endtask

  integer i;
  initial begin
`ifdef RTL
    $dumpfile("b10_rtl_original_compare.vcd");
`elsif GL
    $dumpfile("b10_gl_faulty_compare.vcd");
`endif
    $dumpvars(0, tb_b10_fi);
    drive(1, 0, 0, 0, 0, 0, 0, 0, 0);
    drive(1, 0, 0, 0, 0, 0, 0, 0, 0);
    drive(0, 0, 0, 0, 0, 0, 0, 0, 0);
    for (i=0; i<50; i=i+1) drive(0, $random, $random, $random, $random, $random, $random, $random, $random);
    $display("Stimulus completed.");
    $finish;
  end
endmodule
