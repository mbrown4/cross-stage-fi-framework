`timescale 1ns/1ps

module tb_b08_fi;

  reg CLOCK = 0;
  always #5 CLOCK = ~CLOCK;

  reg RESET = 0;
  reg START = 0;
  reg [7:0] I = 0;
  reg [21:0] fault_en = 22'b0;

  wire [3:0] O_g, O_f;

`ifdef RTL
  wire [2:0] st_g, st_f;
`elsif GL
  wire [3:0] st_g, st_f;
`endif
  wire [21:0] mapped_regs_g, mapped_regs_f;

`ifdef RTL
  b08 DUT_GOLDEN (
    .CLOCK(CLOCK),
    .RESET(RESET),
    .START(START),
    .I(I),
    .O(O_g)
  );
  b08 DUT_FAULTY (
    .CLOCK(CLOCK),
    .RESET(RESET),
    .START(START),
    .I(I),
    .O(O_f)
  );
`elsif GL
  b08 DUT_GOLDEN (
    .CLOCK(CLOCK),
    .RESET(RESET),
    .START(START),
    .I(I),
    .O(O_g),
    .fault_en(22'b0)
  );
  b08 DUT_FAULTY (
    .CLOCK(CLOCK),
    .RESET(RESET),
    .START(START),
    .I(I),
    .O(O_f),
    .fault_en(fault_en)
  );
`else
  initial begin $display("ERROR: Compile with -DRTL or -DGL"); $finish; end
`endif

`ifdef RTL
  assign st_g = DUT_GOLDEN.STATO;
  assign st_f = DUT_FAULTY.STATO;
  assign mapped_regs_g[0] = DUT_GOLDEN.STATO[0];
  assign mapped_regs_f[0] = DUT_FAULTY.STATO[0];
  assign mapped_regs_g[1] = DUT_GOLDEN.STATO[2];
  assign mapped_regs_f[1] = DUT_FAULTY.STATO[2];
  assign mapped_regs_g[2] = 1'b0; // GL_ONLY
  assign mapped_regs_f[2] = 1'b0; // GL_ONLY
  assign mapped_regs_g[3] = DUT_GOLDEN.MAR[0];
  assign mapped_regs_f[3] = DUT_FAULTY.MAR[0];
  assign mapped_regs_g[4] = DUT_GOLDEN.MAR[1];
  assign mapped_regs_f[4] = DUT_FAULTY.MAR[1];
  assign mapped_regs_g[5] = DUT_GOLDEN.MAR[2];
  assign mapped_regs_f[5] = DUT_FAULTY.MAR[2];
  assign mapped_regs_g[6] = DUT_GOLDEN.O[0];
  assign mapped_regs_f[6] = DUT_FAULTY.O[0];
  assign mapped_regs_g[7] = DUT_GOLDEN.O[1];
  assign mapped_regs_f[7] = DUT_FAULTY.O[1];
  assign mapped_regs_g[8] = DUT_GOLDEN.O[2];
  assign mapped_regs_f[8] = DUT_FAULTY.O[2];
  assign mapped_regs_g[9] = DUT_GOLDEN.O[3];
  assign mapped_regs_f[9] = DUT_FAULTY.O[3];
  assign mapped_regs_g[10] = DUT_GOLDEN.IN_R[0];
  assign mapped_regs_f[10] = DUT_FAULTY.IN_R[0];
  assign mapped_regs_g[11] = DUT_GOLDEN.IN_R[1];
  assign mapped_regs_f[11] = DUT_FAULTY.IN_R[1];
  assign mapped_regs_g[12] = DUT_GOLDEN.IN_R[2];
  assign mapped_regs_f[12] = DUT_FAULTY.IN_R[2];
  assign mapped_regs_g[13] = DUT_GOLDEN.IN_R[3];
  assign mapped_regs_f[13] = DUT_FAULTY.IN_R[3];
  assign mapped_regs_g[14] = DUT_GOLDEN.IN_R[4];
  assign mapped_regs_f[14] = DUT_FAULTY.IN_R[4];
  assign mapped_regs_g[15] = DUT_GOLDEN.IN_R[5];
  assign mapped_regs_f[15] = DUT_FAULTY.IN_R[5];
  assign mapped_regs_g[16] = DUT_GOLDEN.IN_R[6];
  assign mapped_regs_f[16] = DUT_FAULTY.IN_R[6];
  assign mapped_regs_g[17] = DUT_GOLDEN.IN_R[7];
  assign mapped_regs_f[17] = DUT_FAULTY.IN_R[7];
  assign mapped_regs_g[18] = DUT_GOLDEN.OUT_R[0];
  assign mapped_regs_f[18] = DUT_FAULTY.OUT_R[0];
  assign mapped_regs_g[19] = DUT_GOLDEN.OUT_R[1];
  assign mapped_regs_f[19] = DUT_FAULTY.OUT_R[1];
  assign mapped_regs_g[20] = DUT_GOLDEN.OUT_R[2];
  assign mapped_regs_f[20] = DUT_FAULTY.OUT_R[2];
  assign mapped_regs_g[21] = DUT_GOLDEN.OUT_R[3];
  assign mapped_regs_f[21] = DUT_FAULTY.OUT_R[3];
`elsif GL
  assign st_g = {DUT_GOLDEN.\STATO[3] , DUT_GOLDEN.\STATO[2] , DUT_GOLDEN.\STATO[0] };
  assign st_f = {DUT_FAULTY.\STATO[3] , DUT_FAULTY.\STATO[2] , DUT_FAULTY.\STATO[0] };
  assign mapped_regs_g[0] = DUT_GOLDEN.\STATO[0] ;
  assign mapped_regs_f[0] = DUT_FAULTY.\STATO[0] ;
  assign mapped_regs_g[1] = DUT_GOLDEN.\STATO[2] ;
  assign mapped_regs_f[1] = DUT_FAULTY.\STATO[2] ;
  assign mapped_regs_g[2] = DUT_GOLDEN.\STATO[3] ;
  assign mapped_regs_f[2] = DUT_FAULTY.\STATO[3] ;
  assign mapped_regs_g[3] = DUT_GOLDEN.\MAR[0] ;
  assign mapped_regs_f[3] = DUT_FAULTY.\MAR[0] ;
  assign mapped_regs_g[4] = DUT_GOLDEN.\MAR[1] ;
  assign mapped_regs_f[4] = DUT_FAULTY.\MAR[1] ;
  assign mapped_regs_g[5] = DUT_GOLDEN.\MAR[2] ;
  assign mapped_regs_f[5] = DUT_FAULTY.\MAR[2] ;
  assign mapped_regs_g[6] = DUT_GOLDEN.O[0];
  assign mapped_regs_f[6] = DUT_FAULTY.O[0];
  assign mapped_regs_g[7] = DUT_GOLDEN.O[1];
  assign mapped_regs_f[7] = DUT_FAULTY.O[1];
  assign mapped_regs_g[8] = DUT_GOLDEN.O[2];
  assign mapped_regs_f[8] = DUT_FAULTY.O[2];
  assign mapped_regs_g[9] = DUT_GOLDEN.O[3];
  assign mapped_regs_f[9] = DUT_FAULTY.O[3];
  assign mapped_regs_g[10] = DUT_GOLDEN.\IN_R[0] ;
  assign mapped_regs_f[10] = DUT_FAULTY.\IN_R[0] ;
  assign mapped_regs_g[11] = DUT_GOLDEN.\IN_R[1] ;
  assign mapped_regs_f[11] = DUT_FAULTY.\IN_R[1] ;
  assign mapped_regs_g[12] = DUT_GOLDEN.\IN_R[2] ;
  assign mapped_regs_f[12] = DUT_FAULTY.\IN_R[2] ;
  assign mapped_regs_g[13] = DUT_GOLDEN.\IN_R[3] ;
  assign mapped_regs_f[13] = DUT_FAULTY.\IN_R[3] ;
  assign mapped_regs_g[14] = DUT_GOLDEN.\IN_R[4] ;
  assign mapped_regs_f[14] = DUT_FAULTY.\IN_R[4] ;
  assign mapped_regs_g[15] = DUT_GOLDEN.\IN_R[5] ;
  assign mapped_regs_f[15] = DUT_FAULTY.\IN_R[5] ;
  assign mapped_regs_g[16] = DUT_GOLDEN.\IN_R[6] ;
  assign mapped_regs_f[16] = DUT_FAULTY.\IN_R[6] ;
  assign mapped_regs_g[17] = DUT_GOLDEN.\IN_R[7] ;
  assign mapped_regs_f[17] = DUT_FAULTY.\IN_R[7] ;
  assign mapped_regs_g[18] = DUT_GOLDEN.\OUT_R[0] ;
  assign mapped_regs_f[18] = DUT_FAULTY.\OUT_R[0] ;
  assign mapped_regs_g[19] = DUT_GOLDEN.\OUT_R[1] ;
  assign mapped_regs_f[19] = DUT_FAULTY.\OUT_R[1] ;
  assign mapped_regs_g[20] = DUT_GOLDEN.\OUT_R[2] ;
  assign mapped_regs_f[20] = DUT_FAULTY.\OUT_R[2] ;
  assign mapped_regs_g[21] = DUT_GOLDEN.\OUT_R[3] ;
  assign mapped_regs_f[21] = DUT_FAULTY.\OUT_R[3] ;
`endif

  ////////////////////////////////////////////////////////////
  // Complete canonical fault target mapping
  ////////////////////////////////////////////////////////////
  // fault_en[0] = STATO[0] (RTL) -> _222_
  // fault_en[1] = STATO[2] (RTL) -> _224_
  // fault_en[2] = STATO[3] (GL_ONLY) -> _225_
  // fault_en[3] = MAR[0] (RTL) -> _226_
  // fault_en[4] = MAR[1] (RTL) -> _227_
  // fault_en[5] = MAR[2] (RTL) -> _228_
  // fault_en[6] = O[0] (RTL) -> _229_
  // fault_en[7] = O[1] (RTL) -> _230_
  // fault_en[8] = O[2] (RTL) -> _231_
  // fault_en[9] = O[3] (RTL) -> _232_
  // fault_en[10] = IN_R[0] (RTL) -> _233_
  // fault_en[11] = IN_R[1] (RTL) -> _234_
  // fault_en[12] = IN_R[2] (RTL) -> _235_
  // fault_en[13] = IN_R[3] (RTL) -> _236_
  // fault_en[14] = IN_R[4] (RTL) -> _237_
  // fault_en[15] = IN_R[5] (RTL) -> _238_
  // fault_en[16] = IN_R[6] (RTL) -> _239_
  // fault_en[17] = IN_R[7] (RTL) -> _240_
  // fault_en[18] = OUT_R[0] (RTL) -> _241_
  // fault_en[19] = OUT_R[1] (RTL) -> _242_
  // fault_en[20] = OUT_R[2] (RTL) -> _243_
  // fault_en[21] = OUT_R[3] (RTL) -> _244_

  localparam [21:0] FI_STATO_0 = 22'b0000000000000000000001;
  localparam [21:0] FI_STATO_2 = 22'b0000000000000000000010;
  localparam [21:0] FI_STATO_3 = 22'b0000000000000000000100;
  localparam [21:0] FI_MAR_0 = 22'b0000000000000000001000;
  localparam [21:0] FI_MAR_1 = 22'b0000000000000000010000;
  localparam [21:0] FI_MAR_2 = 22'b0000000000000000100000;
  localparam [21:0] FI_O_0 = 22'b0000000000000001000000;
  localparam [21:0] FI_O_1 = 22'b0000000000000010000000;
  localparam [21:0] FI_O_2 = 22'b0000000000000100000000;
  localparam [21:0] FI_O_3 = 22'b0000000000001000000000;
  localparam [21:0] FI_IN_R_0 = 22'b0000000000010000000000;
  localparam [21:0] FI_IN_R_1 = 22'b0000000000100000000000;
  localparam [21:0] FI_IN_R_2 = 22'b0000000001000000000000;
  localparam [21:0] FI_IN_R_3 = 22'b0000000010000000000000;
  localparam [21:0] FI_IN_R_4 = 22'b0000000100000000000000;
  localparam [21:0] FI_IN_R_5 = 22'b0000001000000000000000;
  localparam [21:0] FI_IN_R_6 = 22'b0000010000000000000000;
  localparam [21:0] FI_IN_R_7 = 22'b0000100000000000000000;
  localparam [21:0] FI_OUT_R_0 = 22'b0001000000000000000000;
  localparam [21:0] FI_OUT_R_1 = 22'b0010000000000000000000;
  localparam [21:0] FI_OUT_R_2 = 22'b0100000000000000000000;
  localparam [21:0] FI_OUT_R_3 = 22'b1000000000000000000000;
  localparam [21:0] FI_ALL_RTL_MAPPED = 22'b1111111111111111111011;
  localparam [21:0] FI_ALL_GL = {22{1'b1}};
  localparam [21:0] FI_NONE = 22'b0;

  `ifndef FI_MASK
  `define FI_MASK FI_STATO_0
  `endif
  `ifndef INJECT_CYCLE
  `define INJECT_CYCLE 30
  `endif
  localparam integer INJECT_AT = `INJECT_CYCLE;
  localparam [21:0] INJECT_MASK = `FI_MASK;

  initial begin
    $display("INJECT_CYCLE=%0d", INJECT_AT);
    $display("INJECT_MASK=%022b", INJECT_MASK);
`ifdef RTL
    if ((INJECT_MASK & 22'b0000000000000000000100) != 22'b0)
      $display("WARNING: GL_ONLY target bits are ignored in RTL mode");
`endif
  end

  integer cycle_count = 0;
  integer post_cycles = 0;
  reg injection_seen = 0;
  reg first_mismatch_seen = 0;
  always @(posedge CLOCK) begin
    cycle_count <= cycle_count + 1;
    if (fault_en != 22'b0) injection_seen <= 1;
    if (injection_seen) post_cycles <= post_cycles + 1;
    if (post_cycles == 20) begin $display("20 cycles post injection complete."); $finish; end
  end

  always @(negedge CLOCK) begin
    if (cycle_count == INJECT_AT) fault_en <= INJECT_MASK;
    else fault_en <= 22'b0;
  end

`ifdef RTL
  always @(posedge CLOCK) begin
    #0.2;
    if (!RESET) begin
      if (fault_en[0]) DUT_FAULTY.STATO[0] = ~DUT_FAULTY.STATO[0];
      if (fault_en[1]) DUT_FAULTY.STATO[2] = ~DUT_FAULTY.STATO[2];
      if (fault_en[3]) DUT_FAULTY.MAR[0] = ~DUT_FAULTY.MAR[0];
      if (fault_en[4]) DUT_FAULTY.MAR[1] = ~DUT_FAULTY.MAR[1];
      if (fault_en[5]) DUT_FAULTY.MAR[2] = ~DUT_FAULTY.MAR[2];
      if (fault_en[6]) DUT_FAULTY.O[0] = ~DUT_FAULTY.O[0];
      if (fault_en[7]) DUT_FAULTY.O[1] = ~DUT_FAULTY.O[1];
      if (fault_en[8]) DUT_FAULTY.O[2] = ~DUT_FAULTY.O[2];
      if (fault_en[9]) DUT_FAULTY.O[3] = ~DUT_FAULTY.O[3];
      if (fault_en[10]) DUT_FAULTY.IN_R[0] = ~DUT_FAULTY.IN_R[0];
      if (fault_en[11]) DUT_FAULTY.IN_R[1] = ~DUT_FAULTY.IN_R[1];
      if (fault_en[12]) DUT_FAULTY.IN_R[2] = ~DUT_FAULTY.IN_R[2];
      if (fault_en[13]) DUT_FAULTY.IN_R[3] = ~DUT_FAULTY.IN_R[3];
      if (fault_en[14]) DUT_FAULTY.IN_R[4] = ~DUT_FAULTY.IN_R[4];
      if (fault_en[15]) DUT_FAULTY.IN_R[5] = ~DUT_FAULTY.IN_R[5];
      if (fault_en[16]) DUT_FAULTY.IN_R[6] = ~DUT_FAULTY.IN_R[6];
      if (fault_en[17]) DUT_FAULTY.IN_R[7] = ~DUT_FAULTY.IN_R[7];
      if (fault_en[18]) DUT_FAULTY.OUT_R[0] = ~DUT_FAULTY.OUT_R[0];
      if (fault_en[19]) DUT_FAULTY.OUT_R[1] = ~DUT_FAULTY.OUT_R[1];
      if (fault_en[20]) DUT_FAULTY.OUT_R[2] = ~DUT_FAULTY.OUT_R[2];
      if (fault_en[21]) DUT_FAULTY.OUT_R[3] = ~DUT_FAULTY.OUT_R[3];
    end
  end
`endif

  always @(posedge CLOCK) begin
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
    input START_in;
    input I_in;
  begin
    @(negedge CLOCK);
    RESET = r;
    START = START_in;
    I = I_in;
    @(posedge CLOCK); #1;
    $display("CYCLE=%0d | rst=%0b START=%0b I=%0b fe=%022b | G:O=%0h F:O=%0h G:st=%0h F:st=%0h G:regs=%022b F:regs=%022b %s",
      cycle_count, RESET, START, I, fault_en, O_g, O_f, st_g, st_f, mapped_regs_g, mapped_regs_f, (mapped_regs_g !== mapped_regs_f) ? "<-- MISMATCH" : " ");
  end
  endtask

  integer i;
  initial begin
`ifdef RTL
    $dumpfile("b08_rtl_original_compare.vcd");
`elsif GL
    $dumpfile("b08_gl_faulty_compare.vcd");
`endif
    $dumpvars(0, tb_b08_fi);
    drive(1, 0, 0);
    drive(1, 0, 0);
    drive(0, 0, 0);
    for (i=0; i<50; i=i+1) drive(0, $random, $random);
    $display("Stimulus completed.");
    $finish;
  end
endmodule
