`timescale 1ns/1ps

module tb_b09_fi;

  reg clock = 0;
  always #5 clock = ~clock;

  reg reset = 0;
  reg x = 0;
  reg [29:0] fault_en = 30'b0;

  wire y_g, y_f;

`ifdef RTL
  wire [2:0] st_g, st_f;
`elsif GL
  wire [3:0] st_g, st_f;
`endif
  wire [29:0] mapped_regs_g, mapped_regs_f;

`ifdef RTL
  b09 DUT_GOLDEN (
    .reset(reset),
    .clock(clock),
    .x(x),
    .y(y_g)
  );
  b09 DUT_FAULTY (
    .reset(reset),
    .clock(clock),
    .x(x),
    .y(y_f)
  );
`elsif GL
  b09 DUT_GOLDEN (
    .reset(reset),
    .clock(clock),
    .x(x),
    .y(y_g),
    .fault_en(30'b0)
  );
  b09 DUT_FAULTY (
    .reset(reset),
    .clock(clock),
    .x(x),
    .y(y_f),
    .fault_en(fault_en)
  );
`else
  initial begin $display("ERROR: Compile with -DRTL or -DGL"); $finish; end
`endif

`ifdef RTL
  assign st_g = DUT_GOLDEN.stato;
  assign st_f = DUT_FAULTY.stato;
  assign mapped_regs_g[0] = DUT_GOLDEN.old[0];
  assign mapped_regs_f[0] = DUT_FAULTY.old[0];
  assign mapped_regs_g[1] = DUT_GOLDEN.old[1];
  assign mapped_regs_f[1] = DUT_FAULTY.old[1];
  assign mapped_regs_g[2] = DUT_GOLDEN.old[2];
  assign mapped_regs_f[2] = DUT_FAULTY.old[2];
  assign mapped_regs_g[3] = DUT_GOLDEN.old[3];
  assign mapped_regs_f[3] = DUT_FAULTY.old[3];
  assign mapped_regs_g[4] = DUT_GOLDEN.old[4];
  assign mapped_regs_f[4] = DUT_FAULTY.old[4];
  assign mapped_regs_g[5] = DUT_GOLDEN.old[5];
  assign mapped_regs_f[5] = DUT_FAULTY.old[5];
  assign mapped_regs_g[6] = DUT_GOLDEN.old[6];
  assign mapped_regs_f[6] = DUT_FAULTY.old[6];
  assign mapped_regs_g[7] = DUT_GOLDEN.old[7];
  assign mapped_regs_f[7] = DUT_FAULTY.old[7];
  assign mapped_regs_g[8] = DUT_GOLDEN.stato[0];
  assign mapped_regs_f[8] = DUT_FAULTY.stato[0];
  assign mapped_regs_g[9] = DUT_GOLDEN.stato[1];
  assign mapped_regs_f[9] = DUT_FAULTY.stato[1];
  assign mapped_regs_g[10] = DUT_GOLDEN.stato[2];
  assign mapped_regs_f[10] = DUT_FAULTY.stato[2];
  assign mapped_regs_g[11] = 1'b0; // GL_ONLY
  assign mapped_regs_f[11] = 1'b0; // GL_ONLY
  assign mapped_regs_g[12] = DUT_GOLDEN.y;
  assign mapped_regs_f[12] = DUT_FAULTY.y;
  assign mapped_regs_g[13] = DUT_GOLDEN.d_in[0];
  assign mapped_regs_f[13] = DUT_FAULTY.d_in[0];
  assign mapped_regs_g[14] = DUT_GOLDEN.d_in[1];
  assign mapped_regs_f[14] = DUT_FAULTY.d_in[1];
  assign mapped_regs_g[15] = DUT_GOLDEN.d_in[2];
  assign mapped_regs_f[15] = DUT_FAULTY.d_in[2];
  assign mapped_regs_g[16] = DUT_GOLDEN.d_in[3];
  assign mapped_regs_f[16] = DUT_FAULTY.d_in[3];
  assign mapped_regs_g[17] = DUT_GOLDEN.d_in[4];
  assign mapped_regs_f[17] = DUT_FAULTY.d_in[4];
  assign mapped_regs_g[18] = DUT_GOLDEN.d_in[5];
  assign mapped_regs_f[18] = DUT_FAULTY.d_in[5];
  assign mapped_regs_g[19] = DUT_GOLDEN.d_in[6];
  assign mapped_regs_f[19] = DUT_FAULTY.d_in[6];
  assign mapped_regs_g[20] = DUT_GOLDEN.d_in[7];
  assign mapped_regs_f[20] = DUT_FAULTY.d_in[7];
  assign mapped_regs_g[21] = DUT_GOLDEN.d_in[8];
  assign mapped_regs_f[21] = DUT_FAULTY.d_in[8];
  assign mapped_regs_g[22] = DUT_GOLDEN.d_out[0];
  assign mapped_regs_f[22] = DUT_FAULTY.d_out[0];
  assign mapped_regs_g[23] = DUT_GOLDEN.d_out[1];
  assign mapped_regs_f[23] = DUT_FAULTY.d_out[1];
  assign mapped_regs_g[24] = DUT_GOLDEN.d_out[2];
  assign mapped_regs_f[24] = DUT_FAULTY.d_out[2];
  assign mapped_regs_g[25] = DUT_GOLDEN.d_out[3];
  assign mapped_regs_f[25] = DUT_FAULTY.d_out[3];
  assign mapped_regs_g[26] = DUT_GOLDEN.d_out[4];
  assign mapped_regs_f[26] = DUT_FAULTY.d_out[4];
  assign mapped_regs_g[27] = DUT_GOLDEN.d_out[5];
  assign mapped_regs_f[27] = DUT_FAULTY.d_out[5];
  assign mapped_regs_g[28] = DUT_GOLDEN.d_out[6];
  assign mapped_regs_f[28] = DUT_FAULTY.d_out[6];
  assign mapped_regs_g[29] = DUT_GOLDEN.d_out[7];
  assign mapped_regs_f[29] = DUT_FAULTY.d_out[7];
`elsif GL
  assign st_g = {DUT_GOLDEN.\stato[3] , DUT_GOLDEN.\stato[2] , DUT_GOLDEN.\stato[1] , DUT_GOLDEN.\stato[0] };
  assign st_f = {DUT_FAULTY.\stato[3] , DUT_FAULTY.\stato[2] , DUT_FAULTY.\stato[1] , DUT_FAULTY.\stato[0] };
  assign mapped_regs_g[0] = DUT_GOLDEN.\old[0] ;
  assign mapped_regs_f[0] = DUT_FAULTY.\old[0] ;
  assign mapped_regs_g[1] = DUT_GOLDEN.\old[1] ;
  assign mapped_regs_f[1] = DUT_FAULTY.\old[1] ;
  assign mapped_regs_g[2] = DUT_GOLDEN.\old[2] ;
  assign mapped_regs_f[2] = DUT_FAULTY.\old[2] ;
  assign mapped_regs_g[3] = DUT_GOLDEN.\old[3] ;
  assign mapped_regs_f[3] = DUT_FAULTY.\old[3] ;
  assign mapped_regs_g[4] = DUT_GOLDEN.\old[4] ;
  assign mapped_regs_f[4] = DUT_FAULTY.\old[4] ;
  assign mapped_regs_g[5] = DUT_GOLDEN.\old[5] ;
  assign mapped_regs_f[5] = DUT_FAULTY.\old[5] ;
  assign mapped_regs_g[6] = DUT_GOLDEN.\old[6] ;
  assign mapped_regs_f[6] = DUT_FAULTY.\old[6] ;
  assign mapped_regs_g[7] = DUT_GOLDEN.\old[7] ;
  assign mapped_regs_f[7] = DUT_FAULTY.\old[7] ;
  assign mapped_regs_g[8] = DUT_GOLDEN.\stato[0] ;
  assign mapped_regs_f[8] = DUT_FAULTY.\stato[0] ;
  assign mapped_regs_g[9] = DUT_GOLDEN.\stato[1] ;
  assign mapped_regs_f[9] = DUT_FAULTY.\stato[1] ;
  assign mapped_regs_g[10] = DUT_GOLDEN.\stato[2] ;
  assign mapped_regs_f[10] = DUT_FAULTY.\stato[2] ;
  assign mapped_regs_g[11] = DUT_GOLDEN.\stato[3] ;
  assign mapped_regs_f[11] = DUT_FAULTY.\stato[3] ;
  assign mapped_regs_g[12] = DUT_GOLDEN.y;
  assign mapped_regs_f[12] = DUT_FAULTY.y;
  assign mapped_regs_g[13] = DUT_GOLDEN.\d_in[0] ;
  assign mapped_regs_f[13] = DUT_FAULTY.\d_in[0] ;
  assign mapped_regs_g[14] = DUT_GOLDEN.\d_in[1] ;
  assign mapped_regs_f[14] = DUT_FAULTY.\d_in[1] ;
  assign mapped_regs_g[15] = DUT_GOLDEN.\d_in[2] ;
  assign mapped_regs_f[15] = DUT_FAULTY.\d_in[2] ;
  assign mapped_regs_g[16] = DUT_GOLDEN.\d_in[3] ;
  assign mapped_regs_f[16] = DUT_FAULTY.\d_in[3] ;
  assign mapped_regs_g[17] = DUT_GOLDEN.\d_in[4] ;
  assign mapped_regs_f[17] = DUT_FAULTY.\d_in[4] ;
  assign mapped_regs_g[18] = DUT_GOLDEN.\d_in[5] ;
  assign mapped_regs_f[18] = DUT_FAULTY.\d_in[5] ;
  assign mapped_regs_g[19] = DUT_GOLDEN.\d_in[6] ;
  assign mapped_regs_f[19] = DUT_FAULTY.\d_in[6] ;
  assign mapped_regs_g[20] = DUT_GOLDEN.\d_in[7] ;
  assign mapped_regs_f[20] = DUT_FAULTY.\d_in[7] ;
  assign mapped_regs_g[21] = DUT_GOLDEN.\d_in[8] ;
  assign mapped_regs_f[21] = DUT_FAULTY.\d_in[8] ;
  assign mapped_regs_g[22] = DUT_GOLDEN.\d_out[0] ;
  assign mapped_regs_f[22] = DUT_FAULTY.\d_out[0] ;
  assign mapped_regs_g[23] = DUT_GOLDEN.\d_out[1] ;
  assign mapped_regs_f[23] = DUT_FAULTY.\d_out[1] ;
  assign mapped_regs_g[24] = DUT_GOLDEN.\d_out[2] ;
  assign mapped_regs_f[24] = DUT_FAULTY.\d_out[2] ;
  assign mapped_regs_g[25] = DUT_GOLDEN.\d_out[3] ;
  assign mapped_regs_f[25] = DUT_FAULTY.\d_out[3] ;
  assign mapped_regs_g[26] = DUT_GOLDEN.\d_out[4] ;
  assign mapped_regs_f[26] = DUT_FAULTY.\d_out[4] ;
  assign mapped_regs_g[27] = DUT_GOLDEN.\d_out[5] ;
  assign mapped_regs_f[27] = DUT_FAULTY.\d_out[5] ;
  assign mapped_regs_g[28] = DUT_GOLDEN.\d_out[6] ;
  assign mapped_regs_f[28] = DUT_FAULTY.\d_out[6] ;
  assign mapped_regs_g[29] = DUT_GOLDEN.\d_out[7] ;
  assign mapped_regs_f[29] = DUT_FAULTY.\d_out[7] ;
`endif

  ////////////////////////////////////////////////////////////
  // Complete canonical fault target mapping
  ////////////////////////////////////////////////////////////
  // fault_en[0] = old[0] (RTL) -> _229_
  // fault_en[1] = old[1] (RTL) -> _230_
  // fault_en[2] = old[2] (RTL) -> _231_
  // fault_en[3] = old[3] (RTL) -> _232_
  // fault_en[4] = old[4] (RTL) -> _233_
  // fault_en[5] = old[5] (RTL) -> _234_
  // fault_en[6] = old[6] (RTL) -> _235_
  // fault_en[7] = old[7] (RTL) -> _236_
  // fault_en[8] = stato[0] (RTL) -> _237_
  // fault_en[9] = stato[1] (RTL) -> _238_
  // fault_en[10] = stato[2] (RTL) -> _239_
  // fault_en[11] = stato[3] (GL_ONLY) -> _240_
  // fault_en[12] = y[0] (RTL) -> _241_
  // fault_en[13] = d_in[0] (RTL) -> _242_
  // fault_en[14] = d_in[1] (RTL) -> _243_
  // fault_en[15] = d_in[2] (RTL) -> _244_
  // fault_en[16] = d_in[3] (RTL) -> _245_
  // fault_en[17] = d_in[4] (RTL) -> _246_
  // fault_en[18] = d_in[5] (RTL) -> _247_
  // fault_en[19] = d_in[6] (RTL) -> _248_
  // fault_en[20] = d_in[7] (RTL) -> _249_
  // fault_en[21] = d_in[8] (RTL) -> _250_
  // fault_en[22] = d_out[0] (RTL) -> _251_
  // fault_en[23] = d_out[1] (RTL) -> _252_
  // fault_en[24] = d_out[2] (RTL) -> _253_
  // fault_en[25] = d_out[3] (RTL) -> _254_
  // fault_en[26] = d_out[4] (RTL) -> _255_
  // fault_en[27] = d_out[5] (RTL) -> _256_
  // fault_en[28] = d_out[6] (RTL) -> _257_
  // fault_en[29] = d_out[7] (RTL) -> _258_

  localparam [29:0] FI_OLD_0 = 30'b000000000000000000000000000001;
  localparam [29:0] FI_OLD_1 = 30'b000000000000000000000000000010;
  localparam [29:0] FI_OLD_2 = 30'b000000000000000000000000000100;
  localparam [29:0] FI_OLD_3 = 30'b000000000000000000000000001000;
  localparam [29:0] FI_OLD_4 = 30'b000000000000000000000000010000;
  localparam [29:0] FI_OLD_5 = 30'b000000000000000000000000100000;
  localparam [29:0] FI_OLD_6 = 30'b000000000000000000000001000000;
  localparam [29:0] FI_OLD_7 = 30'b000000000000000000000010000000;
  localparam [29:0] FI_STATO_0 = 30'b000000000000000000000100000000;
  localparam [29:0] FI_STATO_1 = 30'b000000000000000000001000000000;
  localparam [29:0] FI_STATO_2 = 30'b000000000000000000010000000000;
  localparam [29:0] FI_STATO_3 = 30'b000000000000000000100000000000;
  localparam [29:0] FI_Y_0 = 30'b000000000000000001000000000000;
  localparam [29:0] FI_D_IN_0 = 30'b000000000000000010000000000000;
  localparam [29:0] FI_D_IN_1 = 30'b000000000000000100000000000000;
  localparam [29:0] FI_D_IN_2 = 30'b000000000000001000000000000000;
  localparam [29:0] FI_D_IN_3 = 30'b000000000000010000000000000000;
  localparam [29:0] FI_D_IN_4 = 30'b000000000000100000000000000000;
  localparam [29:0] FI_D_IN_5 = 30'b000000000001000000000000000000;
  localparam [29:0] FI_D_IN_6 = 30'b000000000010000000000000000000;
  localparam [29:0] FI_D_IN_7 = 30'b000000000100000000000000000000;
  localparam [29:0] FI_D_IN_8 = 30'b000000001000000000000000000000;
  localparam [29:0] FI_D_OUT_0 = 30'b000000010000000000000000000000;
  localparam [29:0] FI_D_OUT_1 = 30'b000000100000000000000000000000;
  localparam [29:0] FI_D_OUT_2 = 30'b000001000000000000000000000000;
  localparam [29:0] FI_D_OUT_3 = 30'b000010000000000000000000000000;
  localparam [29:0] FI_D_OUT_4 = 30'b000100000000000000000000000000;
  localparam [29:0] FI_D_OUT_5 = 30'b001000000000000000000000000000;
  localparam [29:0] FI_D_OUT_6 = 30'b010000000000000000000000000000;
  localparam [29:0] FI_D_OUT_7 = 30'b100000000000000000000000000000;
  localparam [29:0] FI_ALL_RTL_MAPPED = 30'b111111111111111111011111111111;
  localparam [29:0] FI_ALL_GL = {30{1'b1}};
  localparam [29:0] FI_NONE = 30'b0;

  `ifndef FI_MASK
  `define FI_MASK FI_OLD_0
  `endif
  `ifndef INJECT_CYCLE
  `define INJECT_CYCLE 30
  `endif
  localparam integer INJECT_AT = `INJECT_CYCLE;
  localparam [29:0] INJECT_MASK = `FI_MASK;

  initial begin
    $display("INJECT_CYCLE=%0d", INJECT_AT);
    $display("INJECT_MASK=%030b", INJECT_MASK);
`ifdef RTL
    if ((INJECT_MASK & 30'b000000000000000000100000000000) != 30'b0)
      $display("WARNING: GL_ONLY target bits are ignored in RTL mode");
`endif
  end

  integer cycle_count = 0;
  integer post_cycles = 0;
  reg injection_seen = 0;
  reg first_mismatch_seen = 0;
  always @(posedge clock) begin
    cycle_count <= cycle_count + 1;
    if (fault_en != 30'b0) injection_seen <= 1;
    if (injection_seen) post_cycles <= post_cycles + 1;
    if (post_cycles == 20) begin $display("20 cycles post injection complete."); $finish; end
  end

  always @(negedge clock) begin
    if (cycle_count == INJECT_AT) fault_en <= INJECT_MASK;
    else fault_en <= 30'b0;
  end

`ifdef RTL
  always @(posedge clock) begin
    #0.2;
    if (!reset) begin
      if (fault_en[0]) DUT_FAULTY.old[0] = ~DUT_FAULTY.old[0];
      if (fault_en[1]) DUT_FAULTY.old[1] = ~DUT_FAULTY.old[1];
      if (fault_en[2]) DUT_FAULTY.old[2] = ~DUT_FAULTY.old[2];
      if (fault_en[3]) DUT_FAULTY.old[3] = ~DUT_FAULTY.old[3];
      if (fault_en[4]) DUT_FAULTY.old[4] = ~DUT_FAULTY.old[4];
      if (fault_en[5]) DUT_FAULTY.old[5] = ~DUT_FAULTY.old[5];
      if (fault_en[6]) DUT_FAULTY.old[6] = ~DUT_FAULTY.old[6];
      if (fault_en[7]) DUT_FAULTY.old[7] = ~DUT_FAULTY.old[7];
      if (fault_en[8]) DUT_FAULTY.stato[0] = ~DUT_FAULTY.stato[0];
      if (fault_en[9]) DUT_FAULTY.stato[1] = ~DUT_FAULTY.stato[1];
      if (fault_en[10]) DUT_FAULTY.stato[2] = ~DUT_FAULTY.stato[2];
      if (fault_en[12]) DUT_FAULTY.y = ~DUT_FAULTY.y;
      if (fault_en[13]) DUT_FAULTY.d_in[0] = ~DUT_FAULTY.d_in[0];
      if (fault_en[14]) DUT_FAULTY.d_in[1] = ~DUT_FAULTY.d_in[1];
      if (fault_en[15]) DUT_FAULTY.d_in[2] = ~DUT_FAULTY.d_in[2];
      if (fault_en[16]) DUT_FAULTY.d_in[3] = ~DUT_FAULTY.d_in[3];
      if (fault_en[17]) DUT_FAULTY.d_in[4] = ~DUT_FAULTY.d_in[4];
      if (fault_en[18]) DUT_FAULTY.d_in[5] = ~DUT_FAULTY.d_in[5];
      if (fault_en[19]) DUT_FAULTY.d_in[6] = ~DUT_FAULTY.d_in[6];
      if (fault_en[20]) DUT_FAULTY.d_in[7] = ~DUT_FAULTY.d_in[7];
      if (fault_en[21]) DUT_FAULTY.d_in[8] = ~DUT_FAULTY.d_in[8];
      if (fault_en[22]) DUT_FAULTY.d_out[0] = ~DUT_FAULTY.d_out[0];
      if (fault_en[23]) DUT_FAULTY.d_out[1] = ~DUT_FAULTY.d_out[1];
      if (fault_en[24]) DUT_FAULTY.d_out[2] = ~DUT_FAULTY.d_out[2];
      if (fault_en[25]) DUT_FAULTY.d_out[3] = ~DUT_FAULTY.d_out[3];
      if (fault_en[26]) DUT_FAULTY.d_out[4] = ~DUT_FAULTY.d_out[4];
      if (fault_en[27]) DUT_FAULTY.d_out[5] = ~DUT_FAULTY.d_out[5];
      if (fault_en[28]) DUT_FAULTY.d_out[6] = ~DUT_FAULTY.d_out[6];
      if (fault_en[29]) DUT_FAULTY.d_out[7] = ~DUT_FAULTY.d_out[7];
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
    input x_in;
  begin
    @(negedge clock);
    reset = r;
    x = x_in;
    @(posedge clock); #1;
    $display("CYCLE=%0d | rst=%0b x=%0b fe=%030b | G:y=%0h F:y=%0h G:st=%0h F:st=%0h G:regs=%030b F:regs=%030b %s",
      cycle_count, reset, x, fault_en, y_g, y_f, st_g, st_f, mapped_regs_g, mapped_regs_f, (mapped_regs_g !== mapped_regs_f) ? "<-- MISMATCH" : " ");
  end
  endtask

  integer i;
  initial begin
`ifdef RTL
    $dumpfile("b09_rtl_original_compare.vcd");
`elsif GL
    $dumpfile("b09_gl_faulty_compare.vcd");
`endif
    $dumpvars(0, tb_b09_fi);
    drive(1, 0);
    drive(1, 0);
    drive(0, 0);
    for (i=0; i<50; i=i+1) drive(0, $random);
    $display("Stimulus completed.");
    $finish;
  end
endmodule
