`timescale 1ns/1ps

module tb_b03_fi;

  reg clock = 0;
  always #5 clock = ~clock;

  reg reset = 0;
  reg request1 = 0;
  reg request2 = 0;
  reg request3 = 0;
  reg request4 = 0;
  reg [30:0] fault_en = 31'b0;

  wire [3:0] grant_o_g, grant_o_f;

`ifdef RTL
  wire [1:0] st_g, st_f;
`elsif GL
  wire [2:0] st_g, st_f;
`endif
  wire [30:0] mapped_regs_g, mapped_regs_f;

`ifdef RTL
  b03 DUT_GOLDEN (
    .clock(clock),
    .reset(reset),
    .request1(request1),
    .request2(request2),
    .request3(request3),
    .request4(request4),
    .grant_o(grant_o_g)
  );
  b03 DUT_FAULTY (
    .clock(clock),
    .reset(reset),
    .request1(request1),
    .request2(request2),
    .request3(request3),
    .request4(request4),
    .grant_o(grant_o_f)
  );
`elsif GL
  b03 DUT_GOLDEN (
    .clock(clock),
    .reset(reset),
    .request1(request1),
    .request2(request2),
    .request3(request3),
    .request4(request4),
    .grant_o(grant_o_g),
    .fault_en(31'b0)
  );
  b03 DUT_FAULTY (
    .clock(clock),
    .reset(reset),
    .request1(request1),
    .request2(request2),
    .request3(request3),
    .request4(request4),
    .grant_o(grant_o_f),
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
  assign mapped_regs_g[2] = 1'b0; // GL_ONLY
  assign mapped_regs_f[2] = 1'b0; // GL_ONLY
  assign mapped_regs_g[3] = DUT_GOLDEN.grant_o[0];
  assign mapped_regs_f[3] = DUT_FAULTY.grant_o[0];
  assign mapped_regs_g[4] = DUT_GOLDEN.grant_o[1];
  assign mapped_regs_f[4] = DUT_FAULTY.grant_o[1];
  assign mapped_regs_g[5] = DUT_GOLDEN.grant_o[2];
  assign mapped_regs_f[5] = DUT_FAULTY.grant_o[2];
  assign mapped_regs_g[6] = DUT_GOLDEN.grant_o[3];
  assign mapped_regs_f[6] = DUT_FAULTY.grant_o[3];
  assign mapped_regs_g[7] = DUT_GOLDEN.coda0[0];
  assign mapped_regs_f[7] = DUT_FAULTY.coda0[0];
  assign mapped_regs_g[8] = DUT_GOLDEN.coda0[1];
  assign mapped_regs_f[8] = DUT_FAULTY.coda0[1];
  assign mapped_regs_g[9] = DUT_GOLDEN.coda0[2];
  assign mapped_regs_f[9] = DUT_FAULTY.coda0[2];
  assign mapped_regs_g[10] = DUT_GOLDEN.coda1[0];
  assign mapped_regs_f[10] = DUT_FAULTY.coda1[0];
  assign mapped_regs_g[11] = DUT_GOLDEN.coda1[1];
  assign mapped_regs_f[11] = DUT_FAULTY.coda1[1];
  assign mapped_regs_g[12] = DUT_GOLDEN.coda1[2];
  assign mapped_regs_f[12] = DUT_FAULTY.coda1[2];
  assign mapped_regs_g[13] = DUT_GOLDEN.coda2[0];
  assign mapped_regs_f[13] = DUT_FAULTY.coda2[0];
  assign mapped_regs_g[14] = DUT_GOLDEN.coda2[1];
  assign mapped_regs_f[14] = DUT_FAULTY.coda2[1];
  assign mapped_regs_g[15] = DUT_GOLDEN.coda2[2];
  assign mapped_regs_f[15] = DUT_FAULTY.coda2[2];
  assign mapped_regs_g[16] = DUT_GOLDEN.grant[0];
  assign mapped_regs_f[16] = DUT_FAULTY.grant[0];
  assign mapped_regs_g[17] = DUT_GOLDEN.grant[1];
  assign mapped_regs_f[17] = DUT_FAULTY.grant[1];
  assign mapped_regs_g[18] = DUT_GOLDEN.grant[2];
  assign mapped_regs_f[18] = DUT_FAULTY.grant[2];
  assign mapped_regs_g[19] = DUT_GOLDEN.grant[3];
  assign mapped_regs_f[19] = DUT_FAULTY.grant[3];
  assign mapped_regs_g[20] = DUT_GOLDEN.coda3[0];
  assign mapped_regs_f[20] = DUT_FAULTY.coda3[0];
  assign mapped_regs_g[21] = DUT_GOLDEN.coda3[1];
  assign mapped_regs_f[21] = DUT_FAULTY.coda3[1];
  assign mapped_regs_g[22] = DUT_GOLDEN.coda3[2];
  assign mapped_regs_f[22] = DUT_FAULTY.coda3[2];
  assign mapped_regs_g[23] = DUT_GOLDEN.ru1;
  assign mapped_regs_f[23] = DUT_FAULTY.ru1;
  assign mapped_regs_g[24] = DUT_GOLDEN.ru2;
  assign mapped_regs_f[24] = DUT_FAULTY.ru2;
  assign mapped_regs_g[25] = DUT_GOLDEN.ru3;
  assign mapped_regs_f[25] = DUT_FAULTY.ru3;
  assign mapped_regs_g[26] = DUT_GOLDEN.ru4;
  assign mapped_regs_f[26] = DUT_FAULTY.ru4;
  assign mapped_regs_g[27] = DUT_GOLDEN.fu1;
  assign mapped_regs_f[27] = DUT_FAULTY.fu1;
  assign mapped_regs_g[28] = DUT_GOLDEN.fu2;
  assign mapped_regs_f[28] = DUT_FAULTY.fu2;
  assign mapped_regs_g[29] = DUT_GOLDEN.fu3;
  assign mapped_regs_f[29] = DUT_FAULTY.fu3;
  assign mapped_regs_g[30] = DUT_GOLDEN.fu4;
  assign mapped_regs_f[30] = DUT_FAULTY.fu4;
`elsif GL
  assign st_g = {DUT_GOLDEN.\stato[2] , DUT_GOLDEN.\stato[1] , DUT_GOLDEN.\stato[0] };
  assign st_f = {DUT_FAULTY.\stato[2] , DUT_FAULTY.\stato[1] , DUT_FAULTY.\stato[0] };
  assign mapped_regs_g[0] = DUT_GOLDEN.\stato[0] ;
  assign mapped_regs_f[0] = DUT_FAULTY.\stato[0] ;
  assign mapped_regs_g[1] = DUT_GOLDEN.\stato[1] ;
  assign mapped_regs_f[1] = DUT_FAULTY.\stato[1] ;
  assign mapped_regs_g[2] = DUT_GOLDEN.\stato[2] ;
  assign mapped_regs_f[2] = DUT_FAULTY.\stato[2] ;
  assign mapped_regs_g[3] = DUT_GOLDEN.grant_o[0];
  assign mapped_regs_f[3] = DUT_FAULTY.grant_o[0];
  assign mapped_regs_g[4] = DUT_GOLDEN.grant_o[1];
  assign mapped_regs_f[4] = DUT_FAULTY.grant_o[1];
  assign mapped_regs_g[5] = DUT_GOLDEN.grant_o[2];
  assign mapped_regs_f[5] = DUT_FAULTY.grant_o[2];
  assign mapped_regs_g[6] = DUT_GOLDEN.grant_o[3];
  assign mapped_regs_f[6] = DUT_FAULTY.grant_o[3];
  assign mapped_regs_g[7] = DUT_GOLDEN.\coda0[0] ;
  assign mapped_regs_f[7] = DUT_FAULTY.\coda0[0] ;
  assign mapped_regs_g[8] = DUT_GOLDEN.\coda0[1] ;
  assign mapped_regs_f[8] = DUT_FAULTY.\coda0[1] ;
  assign mapped_regs_g[9] = DUT_GOLDEN.\coda0[2] ;
  assign mapped_regs_f[9] = DUT_FAULTY.\coda0[2] ;
  assign mapped_regs_g[10] = DUT_GOLDEN.\coda1[0] ;
  assign mapped_regs_f[10] = DUT_FAULTY.\coda1[0] ;
  assign mapped_regs_g[11] = DUT_GOLDEN.\coda1[1] ;
  assign mapped_regs_f[11] = DUT_FAULTY.\coda1[1] ;
  assign mapped_regs_g[12] = DUT_GOLDEN.\coda1[2] ;
  assign mapped_regs_f[12] = DUT_FAULTY.\coda1[2] ;
  assign mapped_regs_g[13] = DUT_GOLDEN.\coda2[0] ;
  assign mapped_regs_f[13] = DUT_FAULTY.\coda2[0] ;
  assign mapped_regs_g[14] = DUT_GOLDEN.\coda2[1] ;
  assign mapped_regs_f[14] = DUT_FAULTY.\coda2[1] ;
  assign mapped_regs_g[15] = DUT_GOLDEN.\coda2[2] ;
  assign mapped_regs_f[15] = DUT_FAULTY.\coda2[2] ;
  assign mapped_regs_g[16] = DUT_GOLDEN.\grant[0] ;
  assign mapped_regs_f[16] = DUT_FAULTY.\grant[0] ;
  assign mapped_regs_g[17] = DUT_GOLDEN.\grant[1] ;
  assign mapped_regs_f[17] = DUT_FAULTY.\grant[1] ;
  assign mapped_regs_g[18] = DUT_GOLDEN.\grant[2] ;
  assign mapped_regs_f[18] = DUT_FAULTY.\grant[2] ;
  assign mapped_regs_g[19] = DUT_GOLDEN.\grant[3] ;
  assign mapped_regs_f[19] = DUT_FAULTY.\grant[3] ;
  assign mapped_regs_g[20] = DUT_GOLDEN.\coda3[0] ;
  assign mapped_regs_f[20] = DUT_FAULTY.\coda3[0] ;
  assign mapped_regs_g[21] = DUT_GOLDEN.\coda3[1] ;
  assign mapped_regs_f[21] = DUT_FAULTY.\coda3[1] ;
  assign mapped_regs_g[22] = DUT_GOLDEN.\coda3[2] ;
  assign mapped_regs_f[22] = DUT_FAULTY.\coda3[2] ;
  assign mapped_regs_g[23] = DUT_GOLDEN.ru1;
  assign mapped_regs_f[23] = DUT_FAULTY.ru1;
  assign mapped_regs_g[24] = DUT_GOLDEN.ru2;
  assign mapped_regs_f[24] = DUT_FAULTY.ru2;
  assign mapped_regs_g[25] = DUT_GOLDEN.ru3;
  assign mapped_regs_f[25] = DUT_FAULTY.ru3;
  assign mapped_regs_g[26] = DUT_GOLDEN.ru4;
  assign mapped_regs_f[26] = DUT_FAULTY.ru4;
  assign mapped_regs_g[27] = DUT_GOLDEN.fu1;
  assign mapped_regs_f[27] = DUT_FAULTY.fu1;
  assign mapped_regs_g[28] = DUT_GOLDEN.fu2;
  assign mapped_regs_f[28] = DUT_FAULTY.fu2;
  assign mapped_regs_g[29] = DUT_GOLDEN.fu3;
  assign mapped_regs_f[29] = DUT_FAULTY.fu3;
  assign mapped_regs_g[30] = DUT_GOLDEN.fu4;
  assign mapped_regs_f[30] = DUT_FAULTY.fu4;
`endif

  ////////////////////////////////////////////////////////////
  // Complete canonical fault target mapping
  ////////////////////////////////////////////////////////////
  // fault_en[0] = stato[0] (RTL) -> _243_
  // fault_en[1] = stato[1] (RTL) -> _244_
  // fault_en[2] = stato[2] (GL_ONLY) -> _245_
  // fault_en[3] = grant_o[0] (RTL) -> _246_
  // fault_en[4] = grant_o[1] (RTL) -> _247_
  // fault_en[5] = grant_o[2] (RTL) -> _248_
  // fault_en[6] = grant_o[3] (RTL) -> _249_
  // fault_en[7] = coda0[0] (RTL) -> _250_
  // fault_en[8] = coda0[1] (RTL) -> _251_
  // fault_en[9] = coda0[2] (RTL) -> _252_
  // fault_en[10] = coda1[0] (RTL) -> _253_
  // fault_en[11] = coda1[1] (RTL) -> _254_
  // fault_en[12] = coda1[2] (RTL) -> _255_
  // fault_en[13] = coda2[0] (RTL) -> _256_
  // fault_en[14] = coda2[1] (RTL) -> _257_
  // fault_en[15] = coda2[2] (RTL) -> _258_
  // fault_en[16] = grant[0] (RTL) -> _259_
  // fault_en[17] = grant[1] (RTL) -> _260_
  // fault_en[18] = grant[2] (RTL) -> _261_
  // fault_en[19] = grant[3] (RTL) -> _262_
  // fault_en[20] = coda3[0] (RTL) -> _263_
  // fault_en[21] = coda3[1] (RTL) -> _264_
  // fault_en[22] = coda3[2] (RTL) -> _265_
  // fault_en[23] = ru1[0] (RTL) -> _266_
  // fault_en[24] = ru2[0] (RTL) -> _267_
  // fault_en[25] = ru3[0] (RTL) -> _268_
  // fault_en[26] = ru4[0] (RTL) -> _269_
  // fault_en[27] = fu1[0] (RTL) -> _270_
  // fault_en[28] = fu2[0] (RTL) -> _271_
  // fault_en[29] = fu3[0] (RTL) -> _272_
  // fault_en[30] = fu4[0] (RTL) -> _273_

  localparam [30:0] FI_STATO_0 = 31'b0000000000000000000000000000001;
  localparam [30:0] FI_STATO_1 = 31'b0000000000000000000000000000010;
  localparam [30:0] FI_STATO_2 = 31'b0000000000000000000000000000100;
  localparam [30:0] FI_GRANT_O_0 = 31'b0000000000000000000000000001000;
  localparam [30:0] FI_GRANT_O_1 = 31'b0000000000000000000000000010000;
  localparam [30:0] FI_GRANT_O_2 = 31'b0000000000000000000000000100000;
  localparam [30:0] FI_GRANT_O_3 = 31'b0000000000000000000000001000000;
  localparam [30:0] FI_CODA0_0 = 31'b0000000000000000000000010000000;
  localparam [30:0] FI_CODA0_1 = 31'b0000000000000000000000100000000;
  localparam [30:0] FI_CODA0_2 = 31'b0000000000000000000001000000000;
  localparam [30:0] FI_CODA1_0 = 31'b0000000000000000000010000000000;
  localparam [30:0] FI_CODA1_1 = 31'b0000000000000000000100000000000;
  localparam [30:0] FI_CODA1_2 = 31'b0000000000000000001000000000000;
  localparam [30:0] FI_CODA2_0 = 31'b0000000000000000010000000000000;
  localparam [30:0] FI_CODA2_1 = 31'b0000000000000000100000000000000;
  localparam [30:0] FI_CODA2_2 = 31'b0000000000000001000000000000000;
  localparam [30:0] FI_GRANT_0 = 31'b0000000000000010000000000000000;
  localparam [30:0] FI_GRANT_1 = 31'b0000000000000100000000000000000;
  localparam [30:0] FI_GRANT_2 = 31'b0000000000001000000000000000000;
  localparam [30:0] FI_GRANT_3 = 31'b0000000000010000000000000000000;
  localparam [30:0] FI_CODA3_0 = 31'b0000000000100000000000000000000;
  localparam [30:0] FI_CODA3_1 = 31'b0000000001000000000000000000000;
  localparam [30:0] FI_CODA3_2 = 31'b0000000010000000000000000000000;
  localparam [30:0] FI_RU1_0 = 31'b0000000100000000000000000000000;
  localparam [30:0] FI_RU2_0 = 31'b0000001000000000000000000000000;
  localparam [30:0] FI_RU3_0 = 31'b0000010000000000000000000000000;
  localparam [30:0] FI_RU4_0 = 31'b0000100000000000000000000000000;
  localparam [30:0] FI_FU1_0 = 31'b0001000000000000000000000000000;
  localparam [30:0] FI_FU2_0 = 31'b0010000000000000000000000000000;
  localparam [30:0] FI_FU3_0 = 31'b0100000000000000000000000000000;
  localparam [30:0] FI_FU4_0 = 31'b1000000000000000000000000000000;
  localparam [30:0] FI_ALL_RTL_MAPPED = 31'b1111111111111111111111111111011;
  localparam [30:0] FI_ALL_GL = {31{1'b1}};
  localparam [30:0] FI_NONE = 31'b0;

  `ifndef FI_MASK
  `define FI_MASK FI_STATO_0
  `endif
  `ifndef INJECT_CYCLE
  `define INJECT_CYCLE 30
  `endif
  localparam integer INJECT_AT = `INJECT_CYCLE;
  localparam [30:0] INJECT_MASK = `FI_MASK;

  initial begin
    $display("INJECT_CYCLE=%0d", INJECT_AT);
    $display("INJECT_MASK=%031b", INJECT_MASK);
`ifdef RTL
    if ((INJECT_MASK & 31'b0000000000000000000000000000100) != 31'b0)
      $display("WARNING: GL_ONLY target bits are ignored in RTL mode");
`endif
  end

  integer cycle_count = 0;
  integer post_cycles = 0;
  reg injection_seen = 0;
  reg first_mismatch_seen = 0;
  always @(posedge clock) begin
    cycle_count <= cycle_count + 1;
    if (fault_en != 31'b0) injection_seen <= 1;
    if (injection_seen) post_cycles <= post_cycles + 1;
    if (post_cycles == 20) begin $display("20 cycles post injection complete."); $finish; end
  end

  always @(negedge clock) begin
    if (cycle_count == INJECT_AT) fault_en <= INJECT_MASK;
    else fault_en <= 31'b0;
  end

`ifdef RTL
  always @(posedge clock) begin
    #0.2;
    if (!reset) begin
      if (fault_en[0]) DUT_FAULTY.stato[0] = ~DUT_FAULTY.stato[0];
      if (fault_en[1]) DUT_FAULTY.stato[1] = ~DUT_FAULTY.stato[1];
      if (fault_en[3]) DUT_FAULTY.grant_o[0] = ~DUT_FAULTY.grant_o[0];
      if (fault_en[4]) DUT_FAULTY.grant_o[1] = ~DUT_FAULTY.grant_o[1];
      if (fault_en[5]) DUT_FAULTY.grant_o[2] = ~DUT_FAULTY.grant_o[2];
      if (fault_en[6]) DUT_FAULTY.grant_o[3] = ~DUT_FAULTY.grant_o[3];
      if (fault_en[7]) DUT_FAULTY.coda0[0] = ~DUT_FAULTY.coda0[0];
      if (fault_en[8]) DUT_FAULTY.coda0[1] = ~DUT_FAULTY.coda0[1];
      if (fault_en[9]) DUT_FAULTY.coda0[2] = ~DUT_FAULTY.coda0[2];
      if (fault_en[10]) DUT_FAULTY.coda1[0] = ~DUT_FAULTY.coda1[0];
      if (fault_en[11]) DUT_FAULTY.coda1[1] = ~DUT_FAULTY.coda1[1];
      if (fault_en[12]) DUT_FAULTY.coda1[2] = ~DUT_FAULTY.coda1[2];
      if (fault_en[13]) DUT_FAULTY.coda2[0] = ~DUT_FAULTY.coda2[0];
      if (fault_en[14]) DUT_FAULTY.coda2[1] = ~DUT_FAULTY.coda2[1];
      if (fault_en[15]) DUT_FAULTY.coda2[2] = ~DUT_FAULTY.coda2[2];
      if (fault_en[16]) DUT_FAULTY.grant[0] = ~DUT_FAULTY.grant[0];
      if (fault_en[17]) DUT_FAULTY.grant[1] = ~DUT_FAULTY.grant[1];
      if (fault_en[18]) DUT_FAULTY.grant[2] = ~DUT_FAULTY.grant[2];
      if (fault_en[19]) DUT_FAULTY.grant[3] = ~DUT_FAULTY.grant[3];
      if (fault_en[20]) DUT_FAULTY.coda3[0] = ~DUT_FAULTY.coda3[0];
      if (fault_en[21]) DUT_FAULTY.coda3[1] = ~DUT_FAULTY.coda3[1];
      if (fault_en[22]) DUT_FAULTY.coda3[2] = ~DUT_FAULTY.coda3[2];
      if (fault_en[23]) DUT_FAULTY.ru1 = ~DUT_FAULTY.ru1;
      if (fault_en[24]) DUT_FAULTY.ru2 = ~DUT_FAULTY.ru2;
      if (fault_en[25]) DUT_FAULTY.ru3 = ~DUT_FAULTY.ru3;
      if (fault_en[26]) DUT_FAULTY.ru4 = ~DUT_FAULTY.ru4;
      if (fault_en[27]) DUT_FAULTY.fu1 = ~DUT_FAULTY.fu1;
      if (fault_en[28]) DUT_FAULTY.fu2 = ~DUT_FAULTY.fu2;
      if (fault_en[29]) DUT_FAULTY.fu3 = ~DUT_FAULTY.fu3;
      if (fault_en[30]) DUT_FAULTY.fu4 = ~DUT_FAULTY.fu4;
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
    input request1_in;
    input request2_in;
    input request3_in;
    input request4_in;
  begin
    @(negedge clock);
    reset = r;
    request1 = request1_in;
    request2 = request2_in;
    request3 = request3_in;
    request4 = request4_in;
    @(posedge clock); #1;
    $display("CYCLE=%0d | rst=%0b request1=%0b request2=%0b request3=%0b request4=%0b fe=%031b | G:grant_o=%0h F:grant_o=%0h G:st=%0h F:st=%0h G:regs=%031b F:regs=%031b %s",
      cycle_count, reset, request1, request2, request3, request4, fault_en, grant_o_g, grant_o_f, st_g, st_f, mapped_regs_g, mapped_regs_f, (mapped_regs_g !== mapped_regs_f) ? "<-- MISMATCH" : " ");
  end
  endtask

  integer i;
  initial begin
`ifdef RTL
    $dumpfile("b03_rtl_original_compare.vcd");
`elsif GL
    $dumpfile("b03_gl_faulty_compare.vcd");
`endif
    $dumpvars(0, tb_b03_fi);
    drive(1, 0, 0, 0, 0);
    drive(1, 0, 0, 0, 0);
    drive(0, 0, 0, 0, 0);
    for (i=0; i<50; i=i+1) drive(0, $random, $random, $random, $random);
    $display("Stimulus completed.");
    $finish;
  end
endmodule
