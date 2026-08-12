`timescale 1ns/1ps

module tb_b07_fi;

  reg clock = 0;
  always #5 clock = ~clock;

  reg reset = 0;
  reg start = 0;
  reg [44:0] fault_en = 45'b0;

  wire [7:0] punti_retta_g, punti_retta_f;

`ifdef RTL
  wire [2:0] st_g, st_f;
`elsif GL
  wire [6:0] st_g, st_f;
`endif
  wire [44:0] mapped_regs_g, mapped_regs_f;

`ifdef RTL
  b07 DUT_GOLDEN (
    .punti_retta(punti_retta_g),
    .start(start),
    .reset(reset),
    .clock(clock)
  );
  b07 DUT_FAULTY (
    .punti_retta(punti_retta_f),
    .start(start),
    .reset(reset),
    .clock(clock)
  );
`elsif GL
  b07 DUT_GOLDEN (
    .punti_retta(punti_retta_g),
    .start(start),
    .reset(reset),
    .clock(clock),
    .fault_en(45'b0)
  );
  b07 DUT_FAULTY (
    .punti_retta(punti_retta_f),
    .start(start),
    .reset(reset),
    .clock(clock),
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
  assign mapped_regs_g[3] = 1'b0; // GL_ONLY
  assign mapped_regs_f[3] = 1'b0; // GL_ONLY
  assign mapped_regs_g[4] = 1'b0; // GL_ONLY
  assign mapped_regs_f[4] = 1'b0; // GL_ONLY
  assign mapped_regs_g[5] = 1'b0; // GL_ONLY
  assign mapped_regs_f[5] = 1'b0; // GL_ONLY
  assign mapped_regs_g[6] = 1'b0; // GL_ONLY
  assign mapped_regs_f[6] = 1'b0; // GL_ONLY
  assign mapped_regs_g[7] = DUT_GOLDEN.mar[0];
  assign mapped_regs_f[7] = DUT_FAULTY.mar[0];
  assign mapped_regs_g[8] = DUT_GOLDEN.mar[1];
  assign mapped_regs_f[8] = DUT_FAULTY.mar[1];
  assign mapped_regs_g[9] = DUT_GOLDEN.mar[2];
  assign mapped_regs_f[9] = DUT_FAULTY.mar[2];
  assign mapped_regs_g[10] = DUT_GOLDEN.mar[3];
  assign mapped_regs_f[10] = DUT_FAULTY.mar[3];
  assign mapped_regs_g[11] = DUT_GOLDEN.punti_retta[0];
  assign mapped_regs_f[11] = DUT_FAULTY.punti_retta[0];
  assign mapped_regs_g[12] = DUT_GOLDEN.punti_retta[1];
  assign mapped_regs_f[12] = DUT_FAULTY.punti_retta[1];
  assign mapped_regs_g[13] = DUT_GOLDEN.punti_retta[2];
  assign mapped_regs_f[13] = DUT_FAULTY.punti_retta[2];
  assign mapped_regs_g[14] = DUT_GOLDEN.punti_retta[3];
  assign mapped_regs_f[14] = DUT_FAULTY.punti_retta[3];
  assign mapped_regs_g[15] = DUT_GOLDEN.punti_retta[4];
  assign mapped_regs_f[15] = DUT_FAULTY.punti_retta[4];
  assign mapped_regs_g[16] = DUT_GOLDEN.punti_retta[5];
  assign mapped_regs_f[16] = DUT_FAULTY.punti_retta[5];
  assign mapped_regs_g[17] = DUT_GOLDEN.punti_retta[6];
  assign mapped_regs_f[17] = DUT_FAULTY.punti_retta[6];
  assign mapped_regs_g[18] = DUT_GOLDEN.punti_retta[7];
  assign mapped_regs_f[18] = DUT_FAULTY.punti_retta[7];
  assign mapped_regs_g[19] = DUT_GOLDEN.cont[0];
  assign mapped_regs_f[19] = DUT_FAULTY.cont[0];
  assign mapped_regs_g[20] = DUT_GOLDEN.cont[1];
  assign mapped_regs_f[20] = DUT_FAULTY.cont[1];
  assign mapped_regs_g[21] = DUT_GOLDEN.cont[2];
  assign mapped_regs_f[21] = DUT_FAULTY.cont[2];
  assign mapped_regs_g[22] = DUT_GOLDEN.cont[3];
  assign mapped_regs_f[22] = DUT_FAULTY.cont[3];
  assign mapped_regs_g[23] = DUT_GOLDEN.cont[4];
  assign mapped_regs_f[23] = DUT_FAULTY.cont[4];
  assign mapped_regs_g[24] = DUT_GOLDEN.cont[5];
  assign mapped_regs_f[24] = DUT_FAULTY.cont[5];
  assign mapped_regs_g[25] = DUT_GOLDEN.cont[6];
  assign mapped_regs_f[25] = DUT_FAULTY.cont[6];
  assign mapped_regs_g[26] = DUT_GOLDEN.cont[7];
  assign mapped_regs_f[26] = DUT_FAULTY.cont[7];
  assign mapped_regs_g[27] = DUT_GOLDEN.x[0];
  assign mapped_regs_f[27] = DUT_FAULTY.x[0];
  assign mapped_regs_g[28] = DUT_GOLDEN.x[1];
  assign mapped_regs_f[28] = DUT_FAULTY.x[1];
  assign mapped_regs_g[29] = DUT_GOLDEN.x[2];
  assign mapped_regs_f[29] = DUT_FAULTY.x[2];
  assign mapped_regs_g[30] = DUT_GOLDEN.x[3];
  assign mapped_regs_f[30] = DUT_FAULTY.x[3];
  assign mapped_regs_g[31] = DUT_GOLDEN.x[4];
  assign mapped_regs_f[31] = DUT_FAULTY.x[4];
  assign mapped_regs_g[32] = DUT_GOLDEN.x[5];
  assign mapped_regs_f[32] = DUT_FAULTY.x[5];
  assign mapped_regs_g[33] = DUT_GOLDEN.x[6];
  assign mapped_regs_f[33] = DUT_FAULTY.x[6];
  assign mapped_regs_g[34] = DUT_GOLDEN.x[7];
  assign mapped_regs_f[34] = DUT_FAULTY.x[7];
  assign mapped_regs_g[35] = DUT_GOLDEN.y[0];
  assign mapped_regs_f[35] = DUT_FAULTY.y[0];
  assign mapped_regs_g[36] = DUT_GOLDEN.y[1];
  assign mapped_regs_f[36] = DUT_FAULTY.y[1];
  assign mapped_regs_g[37] = DUT_GOLDEN.y[2];
  assign mapped_regs_f[37] = DUT_FAULTY.y[2];
  assign mapped_regs_g[38] = DUT_GOLDEN.y[3];
  assign mapped_regs_f[38] = DUT_FAULTY.y[3];
  assign mapped_regs_g[39] = DUT_GOLDEN.t[1];
  assign mapped_regs_f[39] = DUT_FAULTY.t[1];
  assign mapped_regs_g[40] = DUT_GOLDEN.t[2];
  assign mapped_regs_f[40] = DUT_FAULTY.t[2];
  assign mapped_regs_g[41] = DUT_GOLDEN.t[3];
  assign mapped_regs_f[41] = DUT_FAULTY.t[3];
  assign mapped_regs_g[42] = DUT_GOLDEN.t[4];
  assign mapped_regs_f[42] = DUT_FAULTY.t[4];
  assign mapped_regs_g[43] = DUT_GOLDEN.t[5];
  assign mapped_regs_f[43] = DUT_FAULTY.t[5];
  assign mapped_regs_g[44] = DUT_GOLDEN.t[6];
  assign mapped_regs_f[44] = DUT_FAULTY.t[6];
`elsif GL
  assign st_g = {DUT_GOLDEN.\stato[6] , DUT_GOLDEN.\stato[5] , DUT_GOLDEN.\stato[4] , DUT_GOLDEN.\stato[3] , DUT_GOLDEN.\stato[2] , DUT_GOLDEN.\stato[1] , DUT_GOLDEN.\stato[0] };
  assign st_f = {DUT_FAULTY.\stato[6] , DUT_FAULTY.\stato[5] , DUT_FAULTY.\stato[4] , DUT_FAULTY.\stato[3] , DUT_FAULTY.\stato[2] , DUT_FAULTY.\stato[1] , DUT_FAULTY.\stato[0] };
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
  assign mapped_regs_g[7] = DUT_GOLDEN.\mar[0] ;
  assign mapped_regs_f[7] = DUT_FAULTY.\mar[0] ;
  assign mapped_regs_g[8] = DUT_GOLDEN.\mar[1] ;
  assign mapped_regs_f[8] = DUT_FAULTY.\mar[1] ;
  assign mapped_regs_g[9] = DUT_GOLDEN.\mar[2] ;
  assign mapped_regs_f[9] = DUT_FAULTY.\mar[2] ;
  assign mapped_regs_g[10] = DUT_GOLDEN.\mar[3] ;
  assign mapped_regs_f[10] = DUT_FAULTY.\mar[3] ;
  assign mapped_regs_g[11] = DUT_GOLDEN.punti_retta[0];
  assign mapped_regs_f[11] = DUT_FAULTY.punti_retta[0];
  assign mapped_regs_g[12] = DUT_GOLDEN.punti_retta[1];
  assign mapped_regs_f[12] = DUT_FAULTY.punti_retta[1];
  assign mapped_regs_g[13] = DUT_GOLDEN.punti_retta[2];
  assign mapped_regs_f[13] = DUT_FAULTY.punti_retta[2];
  assign mapped_regs_g[14] = DUT_GOLDEN.punti_retta[3];
  assign mapped_regs_f[14] = DUT_FAULTY.punti_retta[3];
  assign mapped_regs_g[15] = DUT_GOLDEN.punti_retta[4];
  assign mapped_regs_f[15] = DUT_FAULTY.punti_retta[4];
  assign mapped_regs_g[16] = DUT_GOLDEN.punti_retta[5];
  assign mapped_regs_f[16] = DUT_FAULTY.punti_retta[5];
  assign mapped_regs_g[17] = DUT_GOLDEN.punti_retta[6];
  assign mapped_regs_f[17] = DUT_FAULTY.punti_retta[6];
  assign mapped_regs_g[18] = DUT_GOLDEN.punti_retta[7];
  assign mapped_regs_f[18] = DUT_FAULTY.punti_retta[7];
  assign mapped_regs_g[19] = DUT_GOLDEN.\cont[0] ;
  assign mapped_regs_f[19] = DUT_FAULTY.\cont[0] ;
  assign mapped_regs_g[20] = DUT_GOLDEN.\cont[1] ;
  assign mapped_regs_f[20] = DUT_FAULTY.\cont[1] ;
  assign mapped_regs_g[21] = DUT_GOLDEN.\cont[2] ;
  assign mapped_regs_f[21] = DUT_FAULTY.\cont[2] ;
  assign mapped_regs_g[22] = DUT_GOLDEN.\cont[3] ;
  assign mapped_regs_f[22] = DUT_FAULTY.\cont[3] ;
  assign mapped_regs_g[23] = DUT_GOLDEN.\cont[4] ;
  assign mapped_regs_f[23] = DUT_FAULTY.\cont[4] ;
  assign mapped_regs_g[24] = DUT_GOLDEN.\cont[5] ;
  assign mapped_regs_f[24] = DUT_FAULTY.\cont[5] ;
  assign mapped_regs_g[25] = DUT_GOLDEN.\cont[6] ;
  assign mapped_regs_f[25] = DUT_FAULTY.\cont[6] ;
  assign mapped_regs_g[26] = DUT_GOLDEN.\cont[7] ;
  assign mapped_regs_f[26] = DUT_FAULTY.\cont[7] ;
  assign mapped_regs_g[27] = DUT_GOLDEN.\x[0] ;
  assign mapped_regs_f[27] = DUT_FAULTY.\x[0] ;
  assign mapped_regs_g[28] = DUT_GOLDEN.\x[1] ;
  assign mapped_regs_f[28] = DUT_FAULTY.\x[1] ;
  assign mapped_regs_g[29] = DUT_GOLDEN.\x[2] ;
  assign mapped_regs_f[29] = DUT_FAULTY.\x[2] ;
  assign mapped_regs_g[30] = DUT_GOLDEN.\x[3] ;
  assign mapped_regs_f[30] = DUT_FAULTY.\x[3] ;
  assign mapped_regs_g[31] = DUT_GOLDEN.\x[4] ;
  assign mapped_regs_f[31] = DUT_FAULTY.\x[4] ;
  assign mapped_regs_g[32] = DUT_GOLDEN.\x[5] ;
  assign mapped_regs_f[32] = DUT_FAULTY.\x[5] ;
  assign mapped_regs_g[33] = DUT_GOLDEN.\x[6] ;
  assign mapped_regs_f[33] = DUT_FAULTY.\x[6] ;
  assign mapped_regs_g[34] = DUT_GOLDEN.\x[7] ;
  assign mapped_regs_f[34] = DUT_FAULTY.\x[7] ;
  assign mapped_regs_g[35] = DUT_GOLDEN.\y[0] ;
  assign mapped_regs_f[35] = DUT_FAULTY.\y[0] ;
  assign mapped_regs_g[36] = DUT_GOLDEN.\y[1] ;
  assign mapped_regs_f[36] = DUT_FAULTY.\y[1] ;
  assign mapped_regs_g[37] = DUT_GOLDEN.\y[2] ;
  assign mapped_regs_f[37] = DUT_FAULTY.\y[2] ;
  assign mapped_regs_g[38] = DUT_GOLDEN.\y[3] ;
  assign mapped_regs_f[38] = DUT_FAULTY.\y[3] ;
  assign mapped_regs_g[39] = DUT_GOLDEN.\t[1] ;
  assign mapped_regs_f[39] = DUT_FAULTY.\t[1] ;
  assign mapped_regs_g[40] = DUT_GOLDEN.\t[2] ;
  assign mapped_regs_f[40] = DUT_FAULTY.\t[2] ;
  assign mapped_regs_g[41] = DUT_GOLDEN.\t[3] ;
  assign mapped_regs_f[41] = DUT_FAULTY.\t[3] ;
  assign mapped_regs_g[42] = DUT_GOLDEN.\t[4] ;
  assign mapped_regs_f[42] = DUT_FAULTY.\t[4] ;
  assign mapped_regs_g[43] = DUT_GOLDEN.\t[5] ;
  assign mapped_regs_f[43] = DUT_FAULTY.\t[5] ;
  assign mapped_regs_g[44] = DUT_GOLDEN.\t[6] ;
  assign mapped_regs_f[44] = DUT_FAULTY.\t[6] ;
`endif

  ////////////////////////////////////////////////////////////
  // Complete canonical fault target mapping
  ////////////////////////////////////////////////////////////
  // fault_en[0] = stato[0] (RTL) -> _467_
  // fault_en[1] = stato[1] (RTL) -> _468_
  // fault_en[2] = stato[2] (RTL) -> _469_
  // fault_en[3] = stato[3] (GL_ONLY) -> _470_
  // fault_en[4] = stato[4] (GL_ONLY) -> _471_
  // fault_en[5] = stato[5] (GL_ONLY) -> _472_
  // fault_en[6] = stato[6] (GL_ONLY) -> _473_
  // fault_en[7] = mar[0] (RTL) -> _474_
  // fault_en[8] = mar[1] (RTL) -> _475_
  // fault_en[9] = mar[2] (RTL) -> _476_
  // fault_en[10] = mar[3] (RTL) -> _477_
  // fault_en[11] = punti_retta[0] (RTL) -> _478_
  // fault_en[12] = punti_retta[1] (RTL) -> _479_
  // fault_en[13] = punti_retta[2] (RTL) -> _480_
  // fault_en[14] = punti_retta[3] (RTL) -> _481_
  // fault_en[15] = punti_retta[4] (RTL) -> _482_
  // fault_en[16] = punti_retta[5] (RTL) -> _483_
  // fault_en[17] = punti_retta[6] (RTL) -> _484_
  // fault_en[18] = punti_retta[7] (RTL) -> _485_
  // fault_en[19] = cont[0] (RTL) -> _486_
  // fault_en[20] = cont[1] (RTL) -> _487_
  // fault_en[21] = cont[2] (RTL) -> _488_
  // fault_en[22] = cont[3] (RTL) -> _489_
  // fault_en[23] = cont[4] (RTL) -> _490_
  // fault_en[24] = cont[5] (RTL) -> _491_
  // fault_en[25] = cont[6] (RTL) -> _492_
  // fault_en[26] = cont[7] (RTL) -> _493_
  // fault_en[27] = x[0] (RTL) -> _494_
  // fault_en[28] = x[1] (RTL) -> _495_
  // fault_en[29] = x[2] (RTL) -> _496_
  // fault_en[30] = x[3] (RTL) -> _497_
  // fault_en[31] = x[4] (RTL) -> _498_
  // fault_en[32] = x[5] (RTL) -> _499_
  // fault_en[33] = x[6] (RTL) -> _500_
  // fault_en[34] = x[7] (RTL) -> _501_
  // fault_en[35] = y[0] (RTL) -> _502_
  // fault_en[36] = y[1] (RTL) -> _503_
  // fault_en[37] = y[2] (RTL) -> _504_
  // fault_en[38] = y[3] (RTL) -> _505_
  // fault_en[39] = t[1] (RTL) -> _506_
  // fault_en[40] = t[2] (RTL) -> _507_
  // fault_en[41] = t[3] (RTL) -> _508_
  // fault_en[42] = t[4] (RTL) -> _509_
  // fault_en[43] = t[5] (RTL) -> _510_
  // fault_en[44] = t[6] (RTL) -> _511_

  localparam [44:0] FI_STATO_0 = 45'b000000000000000000000000000000000000000000001;
  localparam [44:0] FI_STATO_1 = 45'b000000000000000000000000000000000000000000010;
  localparam [44:0] FI_STATO_2 = 45'b000000000000000000000000000000000000000000100;
  localparam [44:0] FI_STATO_3 = 45'b000000000000000000000000000000000000000001000;
  localparam [44:0] FI_STATO_4 = 45'b000000000000000000000000000000000000000010000;
  localparam [44:0] FI_STATO_5 = 45'b000000000000000000000000000000000000000100000;
  localparam [44:0] FI_STATO_6 = 45'b000000000000000000000000000000000000001000000;
  localparam [44:0] FI_MAR_0 = 45'b000000000000000000000000000000000000010000000;
  localparam [44:0] FI_MAR_1 = 45'b000000000000000000000000000000000000100000000;
  localparam [44:0] FI_MAR_2 = 45'b000000000000000000000000000000000001000000000;
  localparam [44:0] FI_MAR_3 = 45'b000000000000000000000000000000000010000000000;
  localparam [44:0] FI_PUNTI_RETTA_0 = 45'b000000000000000000000000000000000100000000000;
  localparam [44:0] FI_PUNTI_RETTA_1 = 45'b000000000000000000000000000000001000000000000;
  localparam [44:0] FI_PUNTI_RETTA_2 = 45'b000000000000000000000000000000010000000000000;
  localparam [44:0] FI_PUNTI_RETTA_3 = 45'b000000000000000000000000000000100000000000000;
  localparam [44:0] FI_PUNTI_RETTA_4 = 45'b000000000000000000000000000001000000000000000;
  localparam [44:0] FI_PUNTI_RETTA_5 = 45'b000000000000000000000000000010000000000000000;
  localparam [44:0] FI_PUNTI_RETTA_6 = 45'b000000000000000000000000000100000000000000000;
  localparam [44:0] FI_PUNTI_RETTA_7 = 45'b000000000000000000000000001000000000000000000;
  localparam [44:0] FI_CONT_0 = 45'b000000000000000000000000010000000000000000000;
  localparam [44:0] FI_CONT_1 = 45'b000000000000000000000000100000000000000000000;
  localparam [44:0] FI_CONT_2 = 45'b000000000000000000000001000000000000000000000;
  localparam [44:0] FI_CONT_3 = 45'b000000000000000000000010000000000000000000000;
  localparam [44:0] FI_CONT_4 = 45'b000000000000000000000100000000000000000000000;
  localparam [44:0] FI_CONT_5 = 45'b000000000000000000001000000000000000000000000;
  localparam [44:0] FI_CONT_6 = 45'b000000000000000000010000000000000000000000000;
  localparam [44:0] FI_CONT_7 = 45'b000000000000000000100000000000000000000000000;
  localparam [44:0] FI_X_0 = 45'b000000000000000001000000000000000000000000000;
  localparam [44:0] FI_X_1 = 45'b000000000000000010000000000000000000000000000;
  localparam [44:0] FI_X_2 = 45'b000000000000000100000000000000000000000000000;
  localparam [44:0] FI_X_3 = 45'b000000000000001000000000000000000000000000000;
  localparam [44:0] FI_X_4 = 45'b000000000000010000000000000000000000000000000;
  localparam [44:0] FI_X_5 = 45'b000000000000100000000000000000000000000000000;
  localparam [44:0] FI_X_6 = 45'b000000000001000000000000000000000000000000000;
  localparam [44:0] FI_X_7 = 45'b000000000010000000000000000000000000000000000;
  localparam [44:0] FI_Y_0 = 45'b000000000100000000000000000000000000000000000;
  localparam [44:0] FI_Y_1 = 45'b000000001000000000000000000000000000000000000;
  localparam [44:0] FI_Y_2 = 45'b000000010000000000000000000000000000000000000;
  localparam [44:0] FI_Y_3 = 45'b000000100000000000000000000000000000000000000;
  localparam [44:0] FI_T_1 = 45'b000001000000000000000000000000000000000000000;
  localparam [44:0] FI_T_2 = 45'b000010000000000000000000000000000000000000000;
  localparam [44:0] FI_T_3 = 45'b000100000000000000000000000000000000000000000;
  localparam [44:0] FI_T_4 = 45'b001000000000000000000000000000000000000000000;
  localparam [44:0] FI_T_5 = 45'b010000000000000000000000000000000000000000000;
  localparam [44:0] FI_T_6 = 45'b100000000000000000000000000000000000000000000;
  localparam [44:0] FI_ALL_RTL_MAPPED = 45'b111111111111111111111111111111111111110000111;
  localparam [44:0] FI_ALL_GL = {45{1'b1}};
  localparam [44:0] FI_NONE = 45'b0;

  `ifndef FI_MASK
  `define FI_MASK FI_STATO_0
  `endif
  `ifndef INJECT_CYCLE
  `define INJECT_CYCLE 30
  `endif
  localparam integer INJECT_AT = `INJECT_CYCLE;
  localparam [44:0] INJECT_MASK = `FI_MASK;

  initial begin
    $display("INJECT_CYCLE=%0d", INJECT_AT);
    $display("INJECT_MASK=%045b", INJECT_MASK);
`ifdef RTL
    if ((INJECT_MASK & 45'b000000000000000000000000000000000000001111000) != 45'b0)
      $display("WARNING: GL_ONLY target bits are ignored in RTL mode");
`endif
  end

  integer cycle_count = 0;
  integer post_cycles = 0;
  reg injection_seen = 0;
  reg first_mismatch_seen = 0;
  always @(posedge clock) begin
    cycle_count <= cycle_count + 1;
    if (fault_en != 45'b0) injection_seen <= 1;
    if (injection_seen) post_cycles <= post_cycles + 1;
    if (post_cycles == 20) begin $display("20 cycles post injection complete."); $finish; end
  end

  always @(negedge clock) begin
    if (cycle_count == INJECT_AT) fault_en <= INJECT_MASK;
    else fault_en <= 45'b0;
  end

`ifdef RTL
  always @(posedge clock) begin
    #0.2;
    if (!reset) begin
      if (fault_en[0]) DUT_FAULTY.stato[0] = ~DUT_FAULTY.stato[0];
      if (fault_en[1]) DUT_FAULTY.stato[1] = ~DUT_FAULTY.stato[1];
      if (fault_en[2]) DUT_FAULTY.stato[2] = ~DUT_FAULTY.stato[2];
      if (fault_en[7]) DUT_FAULTY.mar[0] = ~DUT_FAULTY.mar[0];
      if (fault_en[8]) DUT_FAULTY.mar[1] = ~DUT_FAULTY.mar[1];
      if (fault_en[9]) DUT_FAULTY.mar[2] = ~DUT_FAULTY.mar[2];
      if (fault_en[10]) DUT_FAULTY.mar[3] = ~DUT_FAULTY.mar[3];
      if (fault_en[11]) DUT_FAULTY.punti_retta[0] = ~DUT_FAULTY.punti_retta[0];
      if (fault_en[12]) DUT_FAULTY.punti_retta[1] = ~DUT_FAULTY.punti_retta[1];
      if (fault_en[13]) DUT_FAULTY.punti_retta[2] = ~DUT_FAULTY.punti_retta[2];
      if (fault_en[14]) DUT_FAULTY.punti_retta[3] = ~DUT_FAULTY.punti_retta[3];
      if (fault_en[15]) DUT_FAULTY.punti_retta[4] = ~DUT_FAULTY.punti_retta[4];
      if (fault_en[16]) DUT_FAULTY.punti_retta[5] = ~DUT_FAULTY.punti_retta[5];
      if (fault_en[17]) DUT_FAULTY.punti_retta[6] = ~DUT_FAULTY.punti_retta[6];
      if (fault_en[18]) DUT_FAULTY.punti_retta[7] = ~DUT_FAULTY.punti_retta[7];
      if (fault_en[19]) DUT_FAULTY.cont[0] = ~DUT_FAULTY.cont[0];
      if (fault_en[20]) DUT_FAULTY.cont[1] = ~DUT_FAULTY.cont[1];
      if (fault_en[21]) DUT_FAULTY.cont[2] = ~DUT_FAULTY.cont[2];
      if (fault_en[22]) DUT_FAULTY.cont[3] = ~DUT_FAULTY.cont[3];
      if (fault_en[23]) DUT_FAULTY.cont[4] = ~DUT_FAULTY.cont[4];
      if (fault_en[24]) DUT_FAULTY.cont[5] = ~DUT_FAULTY.cont[5];
      if (fault_en[25]) DUT_FAULTY.cont[6] = ~DUT_FAULTY.cont[6];
      if (fault_en[26]) DUT_FAULTY.cont[7] = ~DUT_FAULTY.cont[7];
      if (fault_en[27]) DUT_FAULTY.x[0] = ~DUT_FAULTY.x[0];
      if (fault_en[28]) DUT_FAULTY.x[1] = ~DUT_FAULTY.x[1];
      if (fault_en[29]) DUT_FAULTY.x[2] = ~DUT_FAULTY.x[2];
      if (fault_en[30]) DUT_FAULTY.x[3] = ~DUT_FAULTY.x[3];
      if (fault_en[31]) DUT_FAULTY.x[4] = ~DUT_FAULTY.x[4];
      if (fault_en[32]) DUT_FAULTY.x[5] = ~DUT_FAULTY.x[5];
      if (fault_en[33]) DUT_FAULTY.x[6] = ~DUT_FAULTY.x[6];
      if (fault_en[34]) DUT_FAULTY.x[7] = ~DUT_FAULTY.x[7];
      if (fault_en[35]) DUT_FAULTY.y[0] = ~DUT_FAULTY.y[0];
      if (fault_en[36]) DUT_FAULTY.y[1] = ~DUT_FAULTY.y[1];
      if (fault_en[37]) DUT_FAULTY.y[2] = ~DUT_FAULTY.y[2];
      if (fault_en[38]) DUT_FAULTY.y[3] = ~DUT_FAULTY.y[3];
      if (fault_en[39]) DUT_FAULTY.t[1] = ~DUT_FAULTY.t[1];
      if (fault_en[40]) DUT_FAULTY.t[2] = ~DUT_FAULTY.t[2];
      if (fault_en[41]) DUT_FAULTY.t[3] = ~DUT_FAULTY.t[3];
      if (fault_en[42]) DUT_FAULTY.t[4] = ~DUT_FAULTY.t[4];
      if (fault_en[43]) DUT_FAULTY.t[5] = ~DUT_FAULTY.t[5];
      if (fault_en[44]) DUT_FAULTY.t[6] = ~DUT_FAULTY.t[6];
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
    input start_in;
  begin
    @(negedge clock);
    reset = r;
    start = start_in;
    @(posedge clock); #1;
    $display("CYCLE=%0d | rst=%0b start=%0b fe=%045b | G:punti_retta=%0h F:punti_retta=%0h G:st=%0h F:st=%0h G:regs=%045b F:regs=%045b %s",
      cycle_count, reset, start, fault_en, punti_retta_g, punti_retta_f, st_g, st_f, mapped_regs_g, mapped_regs_f, (mapped_regs_g !== mapped_regs_f) ? "<-- MISMATCH" : " ");
  end
  endtask

  integer i;
  initial begin
`ifdef RTL
    $dumpfile("b07_rtl_original_compare.vcd");
`elsif GL
    $dumpfile("b07_gl_faulty_compare.vcd");
`endif
    $dumpvars(0, tb_b07_fi);
    drive(1, 0);
    drive(1, 0);
    drive(0, 0);
    for (i=0; i<50; i=i+1) drive(0, $random);
    $display("Stimulus completed.");
    $finish;
  end
endmodule
