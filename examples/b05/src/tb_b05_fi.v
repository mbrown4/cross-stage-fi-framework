`timescale 1ns/1ps

module tb_b05_fi;

  reg CLOCK = 0;
  always #5 CLOCK = ~CLOCK;

  reg RESET = 0;
  reg START = 0;
  reg [87:0] fault_en = 88'b0;

  wire SIGN_g, SIGN_f;
  wire [6:0] DISPMAX1_g, DISPMAX1_f;
  wire [6:0] DISPMAX2_g, DISPMAX2_f;
  wire [6:0] DISPMAX3_g, DISPMAX3_f;
  wire [6:0] DISPNUM1_g, DISPNUM1_f;
  wire [6:0] DISPNUM2_g, DISPNUM2_f;

`ifdef RTL
  wire [2:0] st_g, st_f;
`elsif GL
  wire [2:0] st_g, st_f;
`endif
  wire [87:0] mapped_regs_g, mapped_regs_f;

`ifdef RTL
  b05 DUT_GOLDEN (
    .CLOCK(CLOCK),
    .RESET(RESET),
    .START(START),
    .SIGN(SIGN_g),
    .DISPMAX1(DISPMAX1_g),
    .DISPMAX2(DISPMAX2_g),
    .DISPMAX3(DISPMAX3_g),
    .DISPNUM1(DISPNUM1_g),
    .DISPNUM2(DISPNUM2_g)
  );
  b05 DUT_FAULTY (
    .CLOCK(CLOCK),
    .RESET(RESET),
    .START(START),
    .SIGN(SIGN_f),
    .DISPMAX1(DISPMAX1_f),
    .DISPMAX2(DISPMAX2_f),
    .DISPMAX3(DISPMAX3_f),
    .DISPNUM1(DISPNUM1_f),
    .DISPNUM2(DISPNUM2_f)
  );
`elsif GL
  b05 DUT_GOLDEN (
    .CLOCK(CLOCK),
    .RESET(RESET),
    .START(START),
    .SIGN(SIGN_g),
    .DISPMAX1(DISPMAX1_g),
    .DISPMAX2(DISPMAX2_g),
    .DISPMAX3(DISPMAX3_g),
    .DISPNUM1(DISPNUM1_g),
    .DISPNUM2(DISPNUM2_g),
    .fault_en(88'b0)
  );
  b05 DUT_FAULTY (
    .CLOCK(CLOCK),
    .RESET(RESET),
    .START(START),
    .SIGN(SIGN_f),
    .DISPMAX1(DISPMAX1_f),
    .DISPMAX2(DISPMAX2_f),
    .DISPMAX3(DISPMAX3_f),
    .DISPNUM1(DISPNUM1_f),
    .DISPNUM2(DISPNUM2_f),
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
  assign mapped_regs_g[1] = DUT_GOLDEN.STATO[1];
  assign mapped_regs_f[1] = DUT_FAULTY.STATO[1];
  assign mapped_regs_g[2] = DUT_GOLDEN.STATO[2];
  assign mapped_regs_f[2] = DUT_FAULTY.STATO[2];
  assign mapped_regs_g[3] = DUT_GOLDEN.NUM[0];
  assign mapped_regs_f[3] = DUT_FAULTY.NUM[0];
  assign mapped_regs_g[4] = DUT_GOLDEN.NUM[1];
  assign mapped_regs_f[4] = DUT_FAULTY.NUM[1];
  assign mapped_regs_g[5] = DUT_GOLDEN.NUM[2];
  assign mapped_regs_f[5] = DUT_FAULTY.NUM[2];
  assign mapped_regs_g[6] = DUT_GOLDEN.NUM[3];
  assign mapped_regs_f[6] = DUT_FAULTY.NUM[3];
  assign mapped_regs_g[7] = DUT_GOLDEN.NUM[4];
  assign mapped_regs_f[7] = DUT_FAULTY.NUM[4];
  assign mapped_regs_g[8] = DUT_GOLDEN.NUM[5];
  assign mapped_regs_f[8] = DUT_FAULTY.NUM[5];
  assign mapped_regs_g[9] = DUT_GOLDEN.NUM[6];
  assign mapped_regs_f[9] = DUT_FAULTY.NUM[6];
  assign mapped_regs_g[10] = DUT_GOLDEN.NUM[7];
  assign mapped_regs_f[10] = DUT_FAULTY.NUM[7];
  assign mapped_regs_g[11] = DUT_GOLDEN.NUM[8];
  assign mapped_regs_f[11] = DUT_FAULTY.NUM[8];
  assign mapped_regs_g[12] = DUT_GOLDEN.NUM[9];
  assign mapped_regs_f[12] = DUT_FAULTY.NUM[9];
  assign mapped_regs_g[13] = DUT_GOLDEN.NUM[10];
  assign mapped_regs_f[13] = DUT_FAULTY.NUM[10];
  assign mapped_regs_g[14] = DUT_GOLDEN.NUM[11];
  assign mapped_regs_f[14] = DUT_FAULTY.NUM[11];
  assign mapped_regs_g[15] = DUT_GOLDEN.NUM[12];
  assign mapped_regs_f[15] = DUT_FAULTY.NUM[12];
  assign mapped_regs_g[16] = DUT_GOLDEN.NUM[13];
  assign mapped_regs_f[16] = DUT_FAULTY.NUM[13];
  assign mapped_regs_g[17] = DUT_GOLDEN.NUM[14];
  assign mapped_regs_f[17] = DUT_FAULTY.NUM[14];
  assign mapped_regs_g[18] = DUT_GOLDEN.NUM[15];
  assign mapped_regs_f[18] = DUT_FAULTY.NUM[15];
  assign mapped_regs_g[19] = DUT_GOLDEN.NUM[16];
  assign mapped_regs_f[19] = DUT_FAULTY.NUM[16];
  assign mapped_regs_g[20] = DUT_GOLDEN.NUM[17];
  assign mapped_regs_f[20] = DUT_FAULTY.NUM[17];
  assign mapped_regs_g[21] = DUT_GOLDEN.NUM[18];
  assign mapped_regs_f[21] = DUT_FAULTY.NUM[18];
  assign mapped_regs_g[22] = DUT_GOLDEN.NUM[19];
  assign mapped_regs_f[22] = DUT_FAULTY.NUM[19];
  assign mapped_regs_g[23] = DUT_GOLDEN.NUM[20];
  assign mapped_regs_f[23] = DUT_FAULTY.NUM[20];
  assign mapped_regs_g[24] = DUT_GOLDEN.NUM[21];
  assign mapped_regs_f[24] = DUT_FAULTY.NUM[21];
  assign mapped_regs_g[25] = DUT_GOLDEN.NUM[22];
  assign mapped_regs_f[25] = DUT_FAULTY.NUM[22];
  assign mapped_regs_g[26] = DUT_GOLDEN.NUM[23];
  assign mapped_regs_f[26] = DUT_FAULTY.NUM[23];
  assign mapped_regs_g[27] = DUT_GOLDEN.NUM[24];
  assign mapped_regs_f[27] = DUT_FAULTY.NUM[24];
  assign mapped_regs_g[28] = DUT_GOLDEN.NUM[25];
  assign mapped_regs_f[28] = DUT_FAULTY.NUM[25];
  assign mapped_regs_g[29] = DUT_GOLDEN.NUM[26];
  assign mapped_regs_f[29] = DUT_FAULTY.NUM[26];
  assign mapped_regs_g[30] = DUT_GOLDEN.NUM[27];
  assign mapped_regs_f[30] = DUT_FAULTY.NUM[27];
  assign mapped_regs_g[31] = DUT_GOLDEN.NUM[28];
  assign mapped_regs_f[31] = DUT_FAULTY.NUM[28];
  assign mapped_regs_g[32] = DUT_GOLDEN.NUM[29];
  assign mapped_regs_f[32] = DUT_FAULTY.NUM[29];
  assign mapped_regs_g[33] = DUT_GOLDEN.NUM[30];
  assign mapped_regs_f[33] = DUT_FAULTY.NUM[30];
  assign mapped_regs_g[34] = DUT_GOLDEN.NUM[31];
  assign mapped_regs_f[34] = DUT_FAULTY.NUM[31];
  assign mapped_regs_g[35] = DUT_GOLDEN.MAR[0];
  assign mapped_regs_f[35] = DUT_FAULTY.MAR[0];
  assign mapped_regs_g[36] = DUT_GOLDEN.MAR[1];
  assign mapped_regs_f[36] = DUT_FAULTY.MAR[1];
  assign mapped_regs_g[37] = DUT_GOLDEN.MAR[2];
  assign mapped_regs_f[37] = DUT_FAULTY.MAR[2];
  assign mapped_regs_g[38] = DUT_GOLDEN.MAR[3];
  assign mapped_regs_f[38] = DUT_FAULTY.MAR[3];
  assign mapped_regs_g[39] = DUT_GOLDEN.MAR[4];
  assign mapped_regs_f[39] = DUT_FAULTY.MAR[4];
  assign mapped_regs_g[40] = DUT_GOLDEN.MAR[5];
  assign mapped_regs_f[40] = DUT_FAULTY.MAR[5];
  assign mapped_regs_g[41] = DUT_GOLDEN.MAR[6];
  assign mapped_regs_f[41] = DUT_FAULTY.MAR[6];
  assign mapped_regs_g[42] = DUT_GOLDEN.MAR[7];
  assign mapped_regs_f[42] = DUT_FAULTY.MAR[7];
  assign mapped_regs_g[43] = DUT_GOLDEN.MAR[8];
  assign mapped_regs_f[43] = DUT_FAULTY.MAR[8];
  assign mapped_regs_g[44] = DUT_GOLDEN.MAR[9];
  assign mapped_regs_f[44] = DUT_FAULTY.MAR[9];
  assign mapped_regs_g[45] = DUT_GOLDEN.MAR[10];
  assign mapped_regs_f[45] = DUT_FAULTY.MAR[10];
  assign mapped_regs_g[46] = DUT_GOLDEN.MAR[11];
  assign mapped_regs_f[46] = DUT_FAULTY.MAR[11];
  assign mapped_regs_g[47] = DUT_GOLDEN.MAR[12];
  assign mapped_regs_f[47] = DUT_FAULTY.MAR[12];
  assign mapped_regs_g[48] = DUT_GOLDEN.MAR[13];
  assign mapped_regs_f[48] = DUT_FAULTY.MAR[13];
  assign mapped_regs_g[49] = DUT_GOLDEN.MAR[14];
  assign mapped_regs_f[49] = DUT_FAULTY.MAR[14];
  assign mapped_regs_g[50] = DUT_GOLDEN.MAR[15];
  assign mapped_regs_f[50] = DUT_FAULTY.MAR[15];
  assign mapped_regs_g[51] = DUT_GOLDEN.MAR[16];
  assign mapped_regs_f[51] = DUT_FAULTY.MAR[16];
  assign mapped_regs_g[52] = DUT_GOLDEN.MAR[17];
  assign mapped_regs_f[52] = DUT_FAULTY.MAR[17];
  assign mapped_regs_g[53] = DUT_GOLDEN.MAR[18];
  assign mapped_regs_f[53] = DUT_FAULTY.MAR[18];
  assign mapped_regs_g[54] = DUT_GOLDEN.MAR[19];
  assign mapped_regs_f[54] = DUT_FAULTY.MAR[19];
  assign mapped_regs_g[55] = DUT_GOLDEN.MAR[20];
  assign mapped_regs_f[55] = DUT_FAULTY.MAR[20];
  assign mapped_regs_g[56] = DUT_GOLDEN.MAR[21];
  assign mapped_regs_f[56] = DUT_FAULTY.MAR[21];
  assign mapped_regs_g[57] = DUT_GOLDEN.MAR[22];
  assign mapped_regs_f[57] = DUT_FAULTY.MAR[22];
  assign mapped_regs_g[58] = DUT_GOLDEN.MAR[23];
  assign mapped_regs_f[58] = DUT_FAULTY.MAR[23];
  assign mapped_regs_g[59] = DUT_GOLDEN.MAR[24];
  assign mapped_regs_f[59] = DUT_FAULTY.MAR[24];
  assign mapped_regs_g[60] = DUT_GOLDEN.MAR[25];
  assign mapped_regs_f[60] = DUT_FAULTY.MAR[25];
  assign mapped_regs_g[61] = DUT_GOLDEN.MAR[26];
  assign mapped_regs_f[61] = DUT_FAULTY.MAR[26];
  assign mapped_regs_g[62] = DUT_GOLDEN.MAR[27];
  assign mapped_regs_f[62] = DUT_FAULTY.MAR[27];
  assign mapped_regs_g[63] = DUT_GOLDEN.MAR[28];
  assign mapped_regs_f[63] = DUT_FAULTY.MAR[28];
  assign mapped_regs_g[64] = DUT_GOLDEN.MAR[29];
  assign mapped_regs_f[64] = DUT_FAULTY.MAR[29];
  assign mapped_regs_g[65] = DUT_GOLDEN.MAR[30];
  assign mapped_regs_f[65] = DUT_FAULTY.MAR[30];
  assign mapped_regs_g[66] = DUT_GOLDEN.MAR[31];
  assign mapped_regs_f[66] = DUT_FAULTY.MAR[31];
  assign mapped_regs_g[67] = DUT_GOLDEN.TEMP[0];
  assign mapped_regs_f[67] = DUT_FAULTY.TEMP[0];
  assign mapped_regs_g[68] = DUT_GOLDEN.TEMP[1];
  assign mapped_regs_f[68] = DUT_FAULTY.TEMP[1];
  assign mapped_regs_g[69] = DUT_GOLDEN.TEMP[2];
  assign mapped_regs_f[69] = DUT_FAULTY.TEMP[2];
  assign mapped_regs_g[70] = DUT_GOLDEN.TEMP[3];
  assign mapped_regs_f[70] = DUT_FAULTY.TEMP[3];
  assign mapped_regs_g[71] = DUT_GOLDEN.TEMP[4];
  assign mapped_regs_f[71] = DUT_FAULTY.TEMP[4];
  assign mapped_regs_g[72] = DUT_GOLDEN.TEMP[5];
  assign mapped_regs_f[72] = DUT_FAULTY.TEMP[5];
  assign mapped_regs_g[73] = DUT_GOLDEN.TEMP[6];
  assign mapped_regs_f[73] = DUT_FAULTY.TEMP[6];
  assign mapped_regs_g[74] = DUT_GOLDEN.TEMP[7];
  assign mapped_regs_f[74] = DUT_FAULTY.TEMP[7];
  assign mapped_regs_g[75] = DUT_GOLDEN.TEMP[10];
  assign mapped_regs_f[75] = DUT_FAULTY.TEMP[10];
  assign mapped_regs_g[76] = DUT_GOLDEN.MAX[0];
  assign mapped_regs_f[76] = DUT_FAULTY.MAX[0];
  assign mapped_regs_g[77] = DUT_GOLDEN.MAX[1];
  assign mapped_regs_f[77] = DUT_FAULTY.MAX[1];
  assign mapped_regs_g[78] = DUT_GOLDEN.MAX[2];
  assign mapped_regs_f[78] = DUT_FAULTY.MAX[2];
  assign mapped_regs_g[79] = DUT_GOLDEN.MAX[3];
  assign mapped_regs_f[79] = DUT_FAULTY.MAX[3];
  assign mapped_regs_g[80] = DUT_GOLDEN.MAX[4];
  assign mapped_regs_f[80] = DUT_FAULTY.MAX[4];
  assign mapped_regs_g[81] = DUT_GOLDEN.MAX[5];
  assign mapped_regs_f[81] = DUT_FAULTY.MAX[5];
  assign mapped_regs_g[82] = DUT_GOLDEN.MAX[6];
  assign mapped_regs_f[82] = DUT_FAULTY.MAX[6];
  assign mapped_regs_g[83] = DUT_GOLDEN.MAX[7];
  assign mapped_regs_f[83] = DUT_FAULTY.MAX[7];
  assign mapped_regs_g[84] = DUT_GOLDEN.MAX[10];
  assign mapped_regs_f[84] = DUT_FAULTY.MAX[10];
  assign mapped_regs_g[85] = DUT_GOLDEN.FLAG;
  assign mapped_regs_f[85] = DUT_FAULTY.FLAG;
  assign mapped_regs_g[86] = DUT_GOLDEN.EN_DISP;
  assign mapped_regs_f[86] = DUT_FAULTY.EN_DISP;
  assign mapped_regs_g[87] = DUT_GOLDEN.RES_DISP;
  assign mapped_regs_f[87] = DUT_FAULTY.RES_DISP;
`elsif GL
  assign st_g = {DUT_GOLDEN.\STATO[2] , DUT_GOLDEN.\STATO[1] , DUT_GOLDEN.\STATO[0] };
  assign st_f = {DUT_FAULTY.\STATO[2] , DUT_FAULTY.\STATO[1] , DUT_FAULTY.\STATO[0] };
  assign mapped_regs_g[0] = DUT_GOLDEN.\STATO[0] ;
  assign mapped_regs_f[0] = DUT_FAULTY.\STATO[0] ;
  assign mapped_regs_g[1] = DUT_GOLDEN.\STATO[1] ;
  assign mapped_regs_f[1] = DUT_FAULTY.\STATO[1] ;
  assign mapped_regs_g[2] = DUT_GOLDEN.\STATO[2] ;
  assign mapped_regs_f[2] = DUT_FAULTY.\STATO[2] ;
  assign mapped_regs_g[3] = DUT_GOLDEN.\NUM[0] ;
  assign mapped_regs_f[3] = DUT_FAULTY.\NUM[0] ;
  assign mapped_regs_g[4] = DUT_GOLDEN.\NUM[1] ;
  assign mapped_regs_f[4] = DUT_FAULTY.\NUM[1] ;
  assign mapped_regs_g[5] = DUT_GOLDEN.\NUM[2] ;
  assign mapped_regs_f[5] = DUT_FAULTY.\NUM[2] ;
  assign mapped_regs_g[6] = DUT_GOLDEN.\NUM[3] ;
  assign mapped_regs_f[6] = DUT_FAULTY.\NUM[3] ;
  assign mapped_regs_g[7] = DUT_GOLDEN.\NUM[4] ;
  assign mapped_regs_f[7] = DUT_FAULTY.\NUM[4] ;
  assign mapped_regs_g[8] = DUT_GOLDEN.\NUM[5] ;
  assign mapped_regs_f[8] = DUT_FAULTY.\NUM[5] ;
  assign mapped_regs_g[9] = DUT_GOLDEN.\NUM[6] ;
  assign mapped_regs_f[9] = DUT_FAULTY.\NUM[6] ;
  assign mapped_regs_g[10] = DUT_GOLDEN.\NUM[7] ;
  assign mapped_regs_f[10] = DUT_FAULTY.\NUM[7] ;
  assign mapped_regs_g[11] = DUT_GOLDEN.\NUM[8] ;
  assign mapped_regs_f[11] = DUT_FAULTY.\NUM[8] ;
  assign mapped_regs_g[12] = DUT_GOLDEN.\NUM[9] ;
  assign mapped_regs_f[12] = DUT_FAULTY.\NUM[9] ;
  assign mapped_regs_g[13] = DUT_GOLDEN.\NUM[10] ;
  assign mapped_regs_f[13] = DUT_FAULTY.\NUM[10] ;
  assign mapped_regs_g[14] = DUT_GOLDEN.\NUM[11] ;
  assign mapped_regs_f[14] = DUT_FAULTY.\NUM[11] ;
  assign mapped_regs_g[15] = DUT_GOLDEN.\NUM[12] ;
  assign mapped_regs_f[15] = DUT_FAULTY.\NUM[12] ;
  assign mapped_regs_g[16] = DUT_GOLDEN.\NUM[13] ;
  assign mapped_regs_f[16] = DUT_FAULTY.\NUM[13] ;
  assign mapped_regs_g[17] = DUT_GOLDEN.\NUM[14] ;
  assign mapped_regs_f[17] = DUT_FAULTY.\NUM[14] ;
  assign mapped_regs_g[18] = DUT_GOLDEN.\NUM[15] ;
  assign mapped_regs_f[18] = DUT_FAULTY.\NUM[15] ;
  assign mapped_regs_g[19] = DUT_GOLDEN.\NUM[16] ;
  assign mapped_regs_f[19] = DUT_FAULTY.\NUM[16] ;
  assign mapped_regs_g[20] = DUT_GOLDEN.\NUM[17] ;
  assign mapped_regs_f[20] = DUT_FAULTY.\NUM[17] ;
  assign mapped_regs_g[21] = DUT_GOLDEN.\NUM[18] ;
  assign mapped_regs_f[21] = DUT_FAULTY.\NUM[18] ;
  assign mapped_regs_g[22] = DUT_GOLDEN.\NUM[19] ;
  assign mapped_regs_f[22] = DUT_FAULTY.\NUM[19] ;
  assign mapped_regs_g[23] = DUT_GOLDEN.\NUM[20] ;
  assign mapped_regs_f[23] = DUT_FAULTY.\NUM[20] ;
  assign mapped_regs_g[24] = DUT_GOLDEN.\NUM[21] ;
  assign mapped_regs_f[24] = DUT_FAULTY.\NUM[21] ;
  assign mapped_regs_g[25] = DUT_GOLDEN.\NUM[22] ;
  assign mapped_regs_f[25] = DUT_FAULTY.\NUM[22] ;
  assign mapped_regs_g[26] = DUT_GOLDEN.\NUM[23] ;
  assign mapped_regs_f[26] = DUT_FAULTY.\NUM[23] ;
  assign mapped_regs_g[27] = DUT_GOLDEN.\NUM[24] ;
  assign mapped_regs_f[27] = DUT_FAULTY.\NUM[24] ;
  assign mapped_regs_g[28] = DUT_GOLDEN.\NUM[25] ;
  assign mapped_regs_f[28] = DUT_FAULTY.\NUM[25] ;
  assign mapped_regs_g[29] = DUT_GOLDEN.\NUM[26] ;
  assign mapped_regs_f[29] = DUT_FAULTY.\NUM[26] ;
  assign mapped_regs_g[30] = DUT_GOLDEN.\NUM[27] ;
  assign mapped_regs_f[30] = DUT_FAULTY.\NUM[27] ;
  assign mapped_regs_g[31] = DUT_GOLDEN.\NUM[28] ;
  assign mapped_regs_f[31] = DUT_FAULTY.\NUM[28] ;
  assign mapped_regs_g[32] = DUT_GOLDEN.\NUM[29] ;
  assign mapped_regs_f[32] = DUT_FAULTY.\NUM[29] ;
  assign mapped_regs_g[33] = DUT_GOLDEN.\NUM[30] ;
  assign mapped_regs_f[33] = DUT_FAULTY.\NUM[30] ;
  assign mapped_regs_g[34] = DUT_GOLDEN.\NUM[31] ;
  assign mapped_regs_f[34] = DUT_FAULTY.\NUM[31] ;
  assign mapped_regs_g[35] = DUT_GOLDEN.\MAR[0] ;
  assign mapped_regs_f[35] = DUT_FAULTY.\MAR[0] ;
  assign mapped_regs_g[36] = DUT_GOLDEN.\MAR[1] ;
  assign mapped_regs_f[36] = DUT_FAULTY.\MAR[1] ;
  assign mapped_regs_g[37] = DUT_GOLDEN.\MAR[2] ;
  assign mapped_regs_f[37] = DUT_FAULTY.\MAR[2] ;
  assign mapped_regs_g[38] = DUT_GOLDEN.\MAR[3] ;
  assign mapped_regs_f[38] = DUT_FAULTY.\MAR[3] ;
  assign mapped_regs_g[39] = DUT_GOLDEN.\MAR[4] ;
  assign mapped_regs_f[39] = DUT_FAULTY.\MAR[4] ;
  assign mapped_regs_g[40] = DUT_GOLDEN.\MAR[5] ;
  assign mapped_regs_f[40] = DUT_FAULTY.\MAR[5] ;
  assign mapped_regs_g[41] = DUT_GOLDEN.\MAR[6] ;
  assign mapped_regs_f[41] = DUT_FAULTY.\MAR[6] ;
  assign mapped_regs_g[42] = DUT_GOLDEN.\MAR[7] ;
  assign mapped_regs_f[42] = DUT_FAULTY.\MAR[7] ;
  assign mapped_regs_g[43] = DUT_GOLDEN.\MAR[8] ;
  assign mapped_regs_f[43] = DUT_FAULTY.\MAR[8] ;
  assign mapped_regs_g[44] = DUT_GOLDEN.\MAR[9] ;
  assign mapped_regs_f[44] = DUT_FAULTY.\MAR[9] ;
  assign mapped_regs_g[45] = DUT_GOLDEN.\MAR[10] ;
  assign mapped_regs_f[45] = DUT_FAULTY.\MAR[10] ;
  assign mapped_regs_g[46] = DUT_GOLDEN.\MAR[11] ;
  assign mapped_regs_f[46] = DUT_FAULTY.\MAR[11] ;
  assign mapped_regs_g[47] = DUT_GOLDEN.\MAR[12] ;
  assign mapped_regs_f[47] = DUT_FAULTY.\MAR[12] ;
  assign mapped_regs_g[48] = DUT_GOLDEN.\MAR[13] ;
  assign mapped_regs_f[48] = DUT_FAULTY.\MAR[13] ;
  assign mapped_regs_g[49] = DUT_GOLDEN.\MAR[14] ;
  assign mapped_regs_f[49] = DUT_FAULTY.\MAR[14] ;
  assign mapped_regs_g[50] = DUT_GOLDEN.\MAR[15] ;
  assign mapped_regs_f[50] = DUT_FAULTY.\MAR[15] ;
  assign mapped_regs_g[51] = DUT_GOLDEN.\MAR[16] ;
  assign mapped_regs_f[51] = DUT_FAULTY.\MAR[16] ;
  assign mapped_regs_g[52] = DUT_GOLDEN.\MAR[17] ;
  assign mapped_regs_f[52] = DUT_FAULTY.\MAR[17] ;
  assign mapped_regs_g[53] = DUT_GOLDEN.\MAR[18] ;
  assign mapped_regs_f[53] = DUT_FAULTY.\MAR[18] ;
  assign mapped_regs_g[54] = DUT_GOLDEN.\MAR[19] ;
  assign mapped_regs_f[54] = DUT_FAULTY.\MAR[19] ;
  assign mapped_regs_g[55] = DUT_GOLDEN.\MAR[20] ;
  assign mapped_regs_f[55] = DUT_FAULTY.\MAR[20] ;
  assign mapped_regs_g[56] = DUT_GOLDEN.\MAR[21] ;
  assign mapped_regs_f[56] = DUT_FAULTY.\MAR[21] ;
  assign mapped_regs_g[57] = DUT_GOLDEN.\MAR[22] ;
  assign mapped_regs_f[57] = DUT_FAULTY.\MAR[22] ;
  assign mapped_regs_g[58] = DUT_GOLDEN.\MAR[23] ;
  assign mapped_regs_f[58] = DUT_FAULTY.\MAR[23] ;
  assign mapped_regs_g[59] = DUT_GOLDEN.\MAR[24] ;
  assign mapped_regs_f[59] = DUT_FAULTY.\MAR[24] ;
  assign mapped_regs_g[60] = DUT_GOLDEN.\MAR[25] ;
  assign mapped_regs_f[60] = DUT_FAULTY.\MAR[25] ;
  assign mapped_regs_g[61] = DUT_GOLDEN.\MAR[26] ;
  assign mapped_regs_f[61] = DUT_FAULTY.\MAR[26] ;
  assign mapped_regs_g[62] = DUT_GOLDEN.\MAR[27] ;
  assign mapped_regs_f[62] = DUT_FAULTY.\MAR[27] ;
  assign mapped_regs_g[63] = DUT_GOLDEN.\MAR[28] ;
  assign mapped_regs_f[63] = DUT_FAULTY.\MAR[28] ;
  assign mapped_regs_g[64] = DUT_GOLDEN.\MAR[29] ;
  assign mapped_regs_f[64] = DUT_FAULTY.\MAR[29] ;
  assign mapped_regs_g[65] = DUT_GOLDEN.\MAR[30] ;
  assign mapped_regs_f[65] = DUT_FAULTY.\MAR[30] ;
  assign mapped_regs_g[66] = DUT_GOLDEN.\MAR[31] ;
  assign mapped_regs_f[66] = DUT_FAULTY.\MAR[31] ;
  assign mapped_regs_g[67] = DUT_GOLDEN.\TEMP[0] ;
  assign mapped_regs_f[67] = DUT_FAULTY.\TEMP[0] ;
  assign mapped_regs_g[68] = DUT_GOLDEN.\TEMP[1] ;
  assign mapped_regs_f[68] = DUT_FAULTY.\TEMP[1] ;
  assign mapped_regs_g[69] = DUT_GOLDEN.\TEMP[2] ;
  assign mapped_regs_f[69] = DUT_FAULTY.\TEMP[2] ;
  assign mapped_regs_g[70] = DUT_GOLDEN.\TEMP[3] ;
  assign mapped_regs_f[70] = DUT_FAULTY.\TEMP[3] ;
  assign mapped_regs_g[71] = DUT_GOLDEN.\TEMP[4] ;
  assign mapped_regs_f[71] = DUT_FAULTY.\TEMP[4] ;
  assign mapped_regs_g[72] = DUT_GOLDEN.\TEMP[5] ;
  assign mapped_regs_f[72] = DUT_FAULTY.\TEMP[5] ;
  assign mapped_regs_g[73] = DUT_GOLDEN.\TEMP[6] ;
  assign mapped_regs_f[73] = DUT_FAULTY.\TEMP[6] ;
  assign mapped_regs_g[74] = DUT_GOLDEN.\TEMP[7] ;
  assign mapped_regs_f[74] = DUT_FAULTY.\TEMP[7] ;
  assign mapped_regs_g[75] = DUT_GOLDEN.\TEMP[10] ;
  assign mapped_regs_f[75] = DUT_FAULTY.\TEMP[10] ;
  assign mapped_regs_g[76] = DUT_GOLDEN.\MAX[0] ;
  assign mapped_regs_f[76] = DUT_FAULTY.\MAX[0] ;
  assign mapped_regs_g[77] = DUT_GOLDEN.\MAX[1] ;
  assign mapped_regs_f[77] = DUT_FAULTY.\MAX[1] ;
  assign mapped_regs_g[78] = DUT_GOLDEN.\MAX[2] ;
  assign mapped_regs_f[78] = DUT_FAULTY.\MAX[2] ;
  assign mapped_regs_g[79] = DUT_GOLDEN.\MAX[3] ;
  assign mapped_regs_f[79] = DUT_FAULTY.\MAX[3] ;
  assign mapped_regs_g[80] = DUT_GOLDEN.\MAX[4] ;
  assign mapped_regs_f[80] = DUT_FAULTY.\MAX[4] ;
  assign mapped_regs_g[81] = DUT_GOLDEN.\MAX[5] ;
  assign mapped_regs_f[81] = DUT_FAULTY.\MAX[5] ;
  assign mapped_regs_g[82] = DUT_GOLDEN.\MAX[6] ;
  assign mapped_regs_f[82] = DUT_FAULTY.\MAX[6] ;
  assign mapped_regs_g[83] = DUT_GOLDEN.\MAX[7] ;
  assign mapped_regs_f[83] = DUT_FAULTY.\MAX[7] ;
  assign mapped_regs_g[84] = DUT_GOLDEN.\MAX[10] ;
  assign mapped_regs_f[84] = DUT_FAULTY.\MAX[10] ;
  assign mapped_regs_g[85] = DUT_GOLDEN.FLAG;
  assign mapped_regs_f[85] = DUT_FAULTY.FLAG;
  assign mapped_regs_g[86] = DUT_GOLDEN.EN_DISP;
  assign mapped_regs_f[86] = DUT_FAULTY.EN_DISP;
  assign mapped_regs_g[87] = DUT_GOLDEN.RES_DISP;
  assign mapped_regs_f[87] = DUT_FAULTY.RES_DISP;
`endif

  ////////////////////////////////////////////////////////////
  // Complete canonical fault target mapping
  ////////////////////////////////////////////////////////////
  // fault_en[0] = STATO[0] (RTL) -> _1276_
  // fault_en[1] = STATO[1] (RTL) -> _1277_
  // fault_en[2] = STATO[2] (RTL) -> _1278_
  // fault_en[3] = NUM[0] (RTL) -> _1279_
  // fault_en[4] = NUM[1] (RTL) -> _1280_
  // fault_en[5] = NUM[2] (RTL) -> _1281_
  // fault_en[6] = NUM[3] (RTL) -> _1282_
  // fault_en[7] = NUM[4] (RTL) -> _1283_
  // fault_en[8] = NUM[5] (RTL) -> _1284_
  // fault_en[9] = NUM[6] (RTL) -> _1285_
  // fault_en[10] = NUM[7] (RTL) -> _1286_
  // fault_en[11] = NUM[8] (RTL) -> _1287_
  // fault_en[12] = NUM[9] (RTL) -> _1288_
  // fault_en[13] = NUM[10] (RTL) -> _1289_
  // fault_en[14] = NUM[11] (RTL) -> _1290_
  // fault_en[15] = NUM[12] (RTL) -> _1291_
  // fault_en[16] = NUM[13] (RTL) -> _1292_
  // fault_en[17] = NUM[14] (RTL) -> _1293_
  // fault_en[18] = NUM[15] (RTL) -> _1294_
  // fault_en[19] = NUM[16] (RTL) -> _1295_
  // fault_en[20] = NUM[17] (RTL) -> _1296_
  // fault_en[21] = NUM[18] (RTL) -> _1297_
  // fault_en[22] = NUM[19] (RTL) -> _1298_
  // fault_en[23] = NUM[20] (RTL) -> _1299_
  // fault_en[24] = NUM[21] (RTL) -> _1300_
  // fault_en[25] = NUM[22] (RTL) -> _1301_
  // fault_en[26] = NUM[23] (RTL) -> _1302_
  // fault_en[27] = NUM[24] (RTL) -> _1303_
  // fault_en[28] = NUM[25] (RTL) -> _1304_
  // fault_en[29] = NUM[26] (RTL) -> _1305_
  // fault_en[30] = NUM[27] (RTL) -> _1306_
  // fault_en[31] = NUM[28] (RTL) -> _1307_
  // fault_en[32] = NUM[29] (RTL) -> _1308_
  // fault_en[33] = NUM[30] (RTL) -> _1309_
  // fault_en[34] = NUM[31] (RTL) -> _1310_
  // fault_en[35] = MAR[0] (RTL) -> _1311_
  // fault_en[36] = MAR[1] (RTL) -> _1312_
  // fault_en[37] = MAR[2] (RTL) -> _1313_
  // fault_en[38] = MAR[3] (RTL) -> _1314_
  // fault_en[39] = MAR[4] (RTL) -> _1315_
  // fault_en[40] = MAR[5] (RTL) -> _1316_
  // fault_en[41] = MAR[6] (RTL) -> _1317_
  // fault_en[42] = MAR[7] (RTL) -> _1318_
  // fault_en[43] = MAR[8] (RTL) -> _1319_
  // fault_en[44] = MAR[9] (RTL) -> _1320_
  // fault_en[45] = MAR[10] (RTL) -> _1321_
  // fault_en[46] = MAR[11] (RTL) -> _1322_
  // fault_en[47] = MAR[12] (RTL) -> _1323_
  // fault_en[48] = MAR[13] (RTL) -> _1324_
  // fault_en[49] = MAR[14] (RTL) -> _1325_
  // fault_en[50] = MAR[15] (RTL) -> _1326_
  // fault_en[51] = MAR[16] (RTL) -> _1327_
  // fault_en[52] = MAR[17] (RTL) -> _1328_
  // fault_en[53] = MAR[18] (RTL) -> _1329_
  // fault_en[54] = MAR[19] (RTL) -> _1330_
  // fault_en[55] = MAR[20] (RTL) -> _1331_
  // fault_en[56] = MAR[21] (RTL) -> _1332_
  // fault_en[57] = MAR[22] (RTL) -> _1333_
  // fault_en[58] = MAR[23] (RTL) -> _1334_
  // fault_en[59] = MAR[24] (RTL) -> _1335_
  // fault_en[60] = MAR[25] (RTL) -> _1336_
  // fault_en[61] = MAR[26] (RTL) -> _1337_
  // fault_en[62] = MAR[27] (RTL) -> _1338_
  // fault_en[63] = MAR[28] (RTL) -> _1339_
  // fault_en[64] = MAR[29] (RTL) -> _1340_
  // fault_en[65] = MAR[30] (RTL) -> _1341_
  // fault_en[66] = MAR[31] (RTL) -> _1342_
  // fault_en[67] = TEMP[0] (RTL) -> _1343_
  // fault_en[68] = TEMP[1] (RTL) -> _1344_
  // fault_en[69] = TEMP[2] (RTL) -> _1345_
  // fault_en[70] = TEMP[3] (RTL) -> _1346_
  // fault_en[71] = TEMP[4] (RTL) -> _1347_
  // fault_en[72] = TEMP[5] (RTL) -> _1348_
  // fault_en[73] = TEMP[6] (RTL) -> _1349_
  // fault_en[74] = TEMP[7] (RTL) -> _1350_
  // fault_en[75] = TEMP[10] (RTL) -> _1351_
  // fault_en[76] = MAX[0] (RTL) -> _1352_
  // fault_en[77] = MAX[1] (RTL) -> _1353_
  // fault_en[78] = MAX[2] (RTL) -> _1354_
  // fault_en[79] = MAX[3] (RTL) -> _1355_
  // fault_en[80] = MAX[4] (RTL) -> _1356_
  // fault_en[81] = MAX[5] (RTL) -> _1357_
  // fault_en[82] = MAX[6] (RTL) -> _1358_
  // fault_en[83] = MAX[7] (RTL) -> _1359_
  // fault_en[84] = MAX[10] (RTL) -> _1360_
  // fault_en[85] = FLAG[0] (RTL) -> _1361_
  // fault_en[86] = EN_DISP[0] (RTL) -> _1362_
  // fault_en[87] = RES_DISP[0] (RTL) -> _1363_

  localparam [87:0] FI_STATO_0 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
  localparam [87:0] FI_STATO_1 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000010;
  localparam [87:0] FI_STATO_2 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000100;
  localparam [87:0] FI_NUM_0 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000001000;
  localparam [87:0] FI_NUM_1 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000010000;
  localparam [87:0] FI_NUM_2 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000100000;
  localparam [87:0] FI_NUM_3 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000000000000001000000;
  localparam [87:0] FI_NUM_4 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000000000000010000000;
  localparam [87:0] FI_NUM_5 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000000000000100000000;
  localparam [87:0] FI_NUM_6 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000000000001000000000;
  localparam [87:0] FI_NUM_7 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000000000010000000000;
  localparam [87:0] FI_NUM_8 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000000000100000000000;
  localparam [87:0] FI_NUM_9 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000000001000000000000;
  localparam [87:0] FI_NUM_10 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000000010000000000000;
  localparam [87:0] FI_NUM_11 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000000100000000000000;
  localparam [87:0] FI_NUM_12 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000001000000000000000;
  localparam [87:0] FI_NUM_13 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000010000000000000000;
  localparam [87:0] FI_NUM_14 = 88'b0000000000000000000000000000000000000000000000000000000000000000000000100000000000000000;
  localparam [87:0] FI_NUM_15 = 88'b0000000000000000000000000000000000000000000000000000000000000000000001000000000000000000;
  localparam [87:0] FI_NUM_16 = 88'b0000000000000000000000000000000000000000000000000000000000000000000010000000000000000000;
  localparam [87:0] FI_NUM_17 = 88'b0000000000000000000000000000000000000000000000000000000000000000000100000000000000000000;
  localparam [87:0] FI_NUM_18 = 88'b0000000000000000000000000000000000000000000000000000000000000000001000000000000000000000;
  localparam [87:0] FI_NUM_19 = 88'b0000000000000000000000000000000000000000000000000000000000000000010000000000000000000000;
  localparam [87:0] FI_NUM_20 = 88'b0000000000000000000000000000000000000000000000000000000000000000100000000000000000000000;
  localparam [87:0] FI_NUM_21 = 88'b0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000;
  localparam [87:0] FI_NUM_22 = 88'b0000000000000000000000000000000000000000000000000000000000000010000000000000000000000000;
  localparam [87:0] FI_NUM_23 = 88'b0000000000000000000000000000000000000000000000000000000000000100000000000000000000000000;
  localparam [87:0] FI_NUM_24 = 88'b0000000000000000000000000000000000000000000000000000000000001000000000000000000000000000;
  localparam [87:0] FI_NUM_25 = 88'b0000000000000000000000000000000000000000000000000000000000010000000000000000000000000000;
  localparam [87:0] FI_NUM_26 = 88'b0000000000000000000000000000000000000000000000000000000000100000000000000000000000000000;
  localparam [87:0] FI_NUM_27 = 88'b0000000000000000000000000000000000000000000000000000000001000000000000000000000000000000;
  localparam [87:0] FI_NUM_28 = 88'b0000000000000000000000000000000000000000000000000000000010000000000000000000000000000000;
  localparam [87:0] FI_NUM_29 = 88'b0000000000000000000000000000000000000000000000000000000100000000000000000000000000000000;
  localparam [87:0] FI_NUM_30 = 88'b0000000000000000000000000000000000000000000000000000001000000000000000000000000000000000;
  localparam [87:0] FI_NUM_31 = 88'b0000000000000000000000000000000000000000000000000000010000000000000000000000000000000000;
  localparam [87:0] FI_MAR_0 = 88'b0000000000000000000000000000000000000000000000000000100000000000000000000000000000000000;
  localparam [87:0] FI_MAR_1 = 88'b0000000000000000000000000000000000000000000000000001000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_2 = 88'b0000000000000000000000000000000000000000000000000010000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_3 = 88'b0000000000000000000000000000000000000000000000000100000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_4 = 88'b0000000000000000000000000000000000000000000000001000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_5 = 88'b0000000000000000000000000000000000000000000000010000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_6 = 88'b0000000000000000000000000000000000000000000000100000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_7 = 88'b0000000000000000000000000000000000000000000001000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_8 = 88'b0000000000000000000000000000000000000000000010000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_9 = 88'b0000000000000000000000000000000000000000000100000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_10 = 88'b0000000000000000000000000000000000000000001000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_11 = 88'b0000000000000000000000000000000000000000010000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_12 = 88'b0000000000000000000000000000000000000000100000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_13 = 88'b0000000000000000000000000000000000000001000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_14 = 88'b0000000000000000000000000000000000000010000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_15 = 88'b0000000000000000000000000000000000000100000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_16 = 88'b0000000000000000000000000000000000001000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_17 = 88'b0000000000000000000000000000000000010000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_18 = 88'b0000000000000000000000000000000000100000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_19 = 88'b0000000000000000000000000000000001000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_20 = 88'b0000000000000000000000000000000010000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_21 = 88'b0000000000000000000000000000000100000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_22 = 88'b0000000000000000000000000000001000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_23 = 88'b0000000000000000000000000000010000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_24 = 88'b0000000000000000000000000000100000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_25 = 88'b0000000000000000000000000001000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_26 = 88'b0000000000000000000000000010000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_27 = 88'b0000000000000000000000000100000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_28 = 88'b0000000000000000000000001000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_29 = 88'b0000000000000000000000010000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_30 = 88'b0000000000000000000000100000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAR_31 = 88'b0000000000000000000001000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_TEMP_0 = 88'b0000000000000000000010000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_TEMP_1 = 88'b0000000000000000000100000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_TEMP_2 = 88'b0000000000000000001000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_TEMP_3 = 88'b0000000000000000010000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_TEMP_4 = 88'b0000000000000000100000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_TEMP_5 = 88'b0000000000000001000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_TEMP_6 = 88'b0000000000000010000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_TEMP_7 = 88'b0000000000000100000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_TEMP_10 = 88'b0000000000001000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAX_0 = 88'b0000000000010000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAX_1 = 88'b0000000000100000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAX_2 = 88'b0000000001000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAX_3 = 88'b0000000010000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAX_4 = 88'b0000000100000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAX_5 = 88'b0000001000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAX_6 = 88'b0000010000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAX_7 = 88'b0000100000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_MAX_10 = 88'b0001000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_FLAG_0 = 88'b0010000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_EN_DISP_0 = 88'b0100000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_RES_DISP_0 = 88'b1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [87:0] FI_ALL_RTL_MAPPED = 88'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
  localparam [87:0] FI_ALL_GL = {88{1'b1}};
  localparam [87:0] FI_NONE = 88'b0;

  `ifndef FI_MASK
  `define FI_MASK FI_STATO_0
  `endif
  `ifndef INJECT_CYCLE
  `define INJECT_CYCLE 30
  `endif
  localparam integer INJECT_AT = `INJECT_CYCLE;
  localparam [87:0] INJECT_MASK = `FI_MASK;

  initial begin
    $display("INJECT_CYCLE=%0d", INJECT_AT);
    $display("INJECT_MASK=%088b", INJECT_MASK);
`ifdef RTL
    if ((INJECT_MASK & 88'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000) != 88'b0)
      $display("WARNING: GL_ONLY target bits are ignored in RTL mode");
`endif
  end

  integer cycle_count = 0;
  integer post_cycles = 0;
  reg injection_seen = 0;
  reg first_mismatch_seen = 0;
  always @(posedge CLOCK) begin
    cycle_count <= cycle_count + 1;
    if (fault_en != 88'b0) injection_seen <= 1;
    if (injection_seen) post_cycles <= post_cycles + 1;
    if (post_cycles == 20) begin $display("20 cycles post injection complete."); $finish; end
  end

  always @(negedge CLOCK) begin
    if (cycle_count == INJECT_AT) fault_en <= INJECT_MASK;
    else fault_en <= 88'b0;
  end

`ifdef RTL
  always @(posedge CLOCK) begin
    #0.2;
    if (!RESET) begin
      if (fault_en[0]) DUT_FAULTY.STATO[0] = ~DUT_FAULTY.STATO[0];
      if (fault_en[1]) DUT_FAULTY.STATO[1] = ~DUT_FAULTY.STATO[1];
      if (fault_en[2]) DUT_FAULTY.STATO[2] = ~DUT_FAULTY.STATO[2];
      if (fault_en[3]) DUT_FAULTY.NUM[0] = ~DUT_FAULTY.NUM[0];
      if (fault_en[4]) DUT_FAULTY.NUM[1] = ~DUT_FAULTY.NUM[1];
      if (fault_en[5]) DUT_FAULTY.NUM[2] = ~DUT_FAULTY.NUM[2];
      if (fault_en[6]) DUT_FAULTY.NUM[3] = ~DUT_FAULTY.NUM[3];
      if (fault_en[7]) DUT_FAULTY.NUM[4] = ~DUT_FAULTY.NUM[4];
      if (fault_en[8]) DUT_FAULTY.NUM[5] = ~DUT_FAULTY.NUM[5];
      if (fault_en[9]) DUT_FAULTY.NUM[6] = ~DUT_FAULTY.NUM[6];
      if (fault_en[10]) DUT_FAULTY.NUM[7] = ~DUT_FAULTY.NUM[7];
      if (fault_en[11]) DUT_FAULTY.NUM[8] = ~DUT_FAULTY.NUM[8];
      if (fault_en[12]) DUT_FAULTY.NUM[9] = ~DUT_FAULTY.NUM[9];
      if (fault_en[13]) DUT_FAULTY.NUM[10] = ~DUT_FAULTY.NUM[10];
      if (fault_en[14]) DUT_FAULTY.NUM[11] = ~DUT_FAULTY.NUM[11];
      if (fault_en[15]) DUT_FAULTY.NUM[12] = ~DUT_FAULTY.NUM[12];
      if (fault_en[16]) DUT_FAULTY.NUM[13] = ~DUT_FAULTY.NUM[13];
      if (fault_en[17]) DUT_FAULTY.NUM[14] = ~DUT_FAULTY.NUM[14];
      if (fault_en[18]) DUT_FAULTY.NUM[15] = ~DUT_FAULTY.NUM[15];
      if (fault_en[19]) DUT_FAULTY.NUM[16] = ~DUT_FAULTY.NUM[16];
      if (fault_en[20]) DUT_FAULTY.NUM[17] = ~DUT_FAULTY.NUM[17];
      if (fault_en[21]) DUT_FAULTY.NUM[18] = ~DUT_FAULTY.NUM[18];
      if (fault_en[22]) DUT_FAULTY.NUM[19] = ~DUT_FAULTY.NUM[19];
      if (fault_en[23]) DUT_FAULTY.NUM[20] = ~DUT_FAULTY.NUM[20];
      if (fault_en[24]) DUT_FAULTY.NUM[21] = ~DUT_FAULTY.NUM[21];
      if (fault_en[25]) DUT_FAULTY.NUM[22] = ~DUT_FAULTY.NUM[22];
      if (fault_en[26]) DUT_FAULTY.NUM[23] = ~DUT_FAULTY.NUM[23];
      if (fault_en[27]) DUT_FAULTY.NUM[24] = ~DUT_FAULTY.NUM[24];
      if (fault_en[28]) DUT_FAULTY.NUM[25] = ~DUT_FAULTY.NUM[25];
      if (fault_en[29]) DUT_FAULTY.NUM[26] = ~DUT_FAULTY.NUM[26];
      if (fault_en[30]) DUT_FAULTY.NUM[27] = ~DUT_FAULTY.NUM[27];
      if (fault_en[31]) DUT_FAULTY.NUM[28] = ~DUT_FAULTY.NUM[28];
      if (fault_en[32]) DUT_FAULTY.NUM[29] = ~DUT_FAULTY.NUM[29];
      if (fault_en[33]) DUT_FAULTY.NUM[30] = ~DUT_FAULTY.NUM[30];
      if (fault_en[34]) DUT_FAULTY.NUM[31] = ~DUT_FAULTY.NUM[31];
      if (fault_en[35]) DUT_FAULTY.MAR[0] = ~DUT_FAULTY.MAR[0];
      if (fault_en[36]) DUT_FAULTY.MAR[1] = ~DUT_FAULTY.MAR[1];
      if (fault_en[37]) DUT_FAULTY.MAR[2] = ~DUT_FAULTY.MAR[2];
      if (fault_en[38]) DUT_FAULTY.MAR[3] = ~DUT_FAULTY.MAR[3];
      if (fault_en[39]) DUT_FAULTY.MAR[4] = ~DUT_FAULTY.MAR[4];
      if (fault_en[40]) DUT_FAULTY.MAR[5] = ~DUT_FAULTY.MAR[5];
      if (fault_en[41]) DUT_FAULTY.MAR[6] = ~DUT_FAULTY.MAR[6];
      if (fault_en[42]) DUT_FAULTY.MAR[7] = ~DUT_FAULTY.MAR[7];
      if (fault_en[43]) DUT_FAULTY.MAR[8] = ~DUT_FAULTY.MAR[8];
      if (fault_en[44]) DUT_FAULTY.MAR[9] = ~DUT_FAULTY.MAR[9];
      if (fault_en[45]) DUT_FAULTY.MAR[10] = ~DUT_FAULTY.MAR[10];
      if (fault_en[46]) DUT_FAULTY.MAR[11] = ~DUT_FAULTY.MAR[11];
      if (fault_en[47]) DUT_FAULTY.MAR[12] = ~DUT_FAULTY.MAR[12];
      if (fault_en[48]) DUT_FAULTY.MAR[13] = ~DUT_FAULTY.MAR[13];
      if (fault_en[49]) DUT_FAULTY.MAR[14] = ~DUT_FAULTY.MAR[14];
      if (fault_en[50]) DUT_FAULTY.MAR[15] = ~DUT_FAULTY.MAR[15];
      if (fault_en[51]) DUT_FAULTY.MAR[16] = ~DUT_FAULTY.MAR[16];
      if (fault_en[52]) DUT_FAULTY.MAR[17] = ~DUT_FAULTY.MAR[17];
      if (fault_en[53]) DUT_FAULTY.MAR[18] = ~DUT_FAULTY.MAR[18];
      if (fault_en[54]) DUT_FAULTY.MAR[19] = ~DUT_FAULTY.MAR[19];
      if (fault_en[55]) DUT_FAULTY.MAR[20] = ~DUT_FAULTY.MAR[20];
      if (fault_en[56]) DUT_FAULTY.MAR[21] = ~DUT_FAULTY.MAR[21];
      if (fault_en[57]) DUT_FAULTY.MAR[22] = ~DUT_FAULTY.MAR[22];
      if (fault_en[58]) DUT_FAULTY.MAR[23] = ~DUT_FAULTY.MAR[23];
      if (fault_en[59]) DUT_FAULTY.MAR[24] = ~DUT_FAULTY.MAR[24];
      if (fault_en[60]) DUT_FAULTY.MAR[25] = ~DUT_FAULTY.MAR[25];
      if (fault_en[61]) DUT_FAULTY.MAR[26] = ~DUT_FAULTY.MAR[26];
      if (fault_en[62]) DUT_FAULTY.MAR[27] = ~DUT_FAULTY.MAR[27];
      if (fault_en[63]) DUT_FAULTY.MAR[28] = ~DUT_FAULTY.MAR[28];
      if (fault_en[64]) DUT_FAULTY.MAR[29] = ~DUT_FAULTY.MAR[29];
      if (fault_en[65]) DUT_FAULTY.MAR[30] = ~DUT_FAULTY.MAR[30];
      if (fault_en[66]) DUT_FAULTY.MAR[31] = ~DUT_FAULTY.MAR[31];
      if (fault_en[67]) DUT_FAULTY.TEMP[0] = ~DUT_FAULTY.TEMP[0];
      if (fault_en[68]) DUT_FAULTY.TEMP[1] = ~DUT_FAULTY.TEMP[1];
      if (fault_en[69]) DUT_FAULTY.TEMP[2] = ~DUT_FAULTY.TEMP[2];
      if (fault_en[70]) DUT_FAULTY.TEMP[3] = ~DUT_FAULTY.TEMP[3];
      if (fault_en[71]) DUT_FAULTY.TEMP[4] = ~DUT_FAULTY.TEMP[4];
      if (fault_en[72]) DUT_FAULTY.TEMP[5] = ~DUT_FAULTY.TEMP[5];
      if (fault_en[73]) DUT_FAULTY.TEMP[6] = ~DUT_FAULTY.TEMP[6];
      if (fault_en[74]) DUT_FAULTY.TEMP[7] = ~DUT_FAULTY.TEMP[7];
      if (fault_en[75]) DUT_FAULTY.TEMP[10] = ~DUT_FAULTY.TEMP[10];
      if (fault_en[76]) DUT_FAULTY.MAX[0] = ~DUT_FAULTY.MAX[0];
      if (fault_en[77]) DUT_FAULTY.MAX[1] = ~DUT_FAULTY.MAX[1];
      if (fault_en[78]) DUT_FAULTY.MAX[2] = ~DUT_FAULTY.MAX[2];
      if (fault_en[79]) DUT_FAULTY.MAX[3] = ~DUT_FAULTY.MAX[3];
      if (fault_en[80]) DUT_FAULTY.MAX[4] = ~DUT_FAULTY.MAX[4];
      if (fault_en[81]) DUT_FAULTY.MAX[5] = ~DUT_FAULTY.MAX[5];
      if (fault_en[82]) DUT_FAULTY.MAX[6] = ~DUT_FAULTY.MAX[6];
      if (fault_en[83]) DUT_FAULTY.MAX[7] = ~DUT_FAULTY.MAX[7];
      if (fault_en[84]) DUT_FAULTY.MAX[10] = ~DUT_FAULTY.MAX[10];
      if (fault_en[85]) DUT_FAULTY.FLAG = ~DUT_FAULTY.FLAG;
      if (fault_en[86]) DUT_FAULTY.EN_DISP = ~DUT_FAULTY.EN_DISP;
      if (fault_en[87]) DUT_FAULTY.RES_DISP = ~DUT_FAULTY.RES_DISP;
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
  begin
    @(negedge CLOCK);
    RESET = r;
    START = START_in;
    @(posedge CLOCK); #1;
    $display("CYCLE=%0d | rst=%0b START=%0b fe=%088b | G:SIGN=%0h F:SIGN=%0h G:DISPMAX1=%0h F:DISPMAX1=%0h G:DISPMAX2=%0h F:DISPMAX2=%0h G:DISPMAX3=%0h F:DISPMAX3=%0h G:DISPNUM1=%0h F:DISPNUM1=%0h G:DISPNUM2=%0h F:DISPNUM2=%0h G:st=%0h F:st=%0h G:regs=%088b F:regs=%088b %s",
      cycle_count, RESET, START, fault_en, SIGN_g, SIGN_f, DISPMAX1_g, DISPMAX1_f, DISPMAX2_g, DISPMAX2_f, DISPMAX3_g, DISPMAX3_f, DISPNUM1_g, DISPNUM1_f, DISPNUM2_g, DISPNUM2_f, st_g, st_f, mapped_regs_g, mapped_regs_f, (mapped_regs_g !== mapped_regs_f) ? "<-- MISMATCH" : " ");
  end
  endtask

  integer i;
  initial begin
`ifdef RTL
    $dumpfile("b05_rtl_original_compare.vcd");
`elsif GL
    $dumpfile("b05_gl_faulty_compare.vcd");
`endif
    $dumpvars(0, tb_b05_fi);
    drive(1, 0);
    drive(1, 0);
    drive(0, 0);
    for (i=0; i<50; i=i+1) drive(0, $random);
    $display("Stimulus completed.");
    $finish;
  end
endmodule
