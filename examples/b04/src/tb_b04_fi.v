`timescale 1ns/1ps

module tb_b04_fi;

  reg CLOCK = 0;
  always #5 CLOCK = ~CLOCK;

  reg RESET = 0;
  reg RESTART = 0;
  reg AVERAGE = 0;
  reg ENABLE = 0;
  reg signed [7:0] DATA_IN = 0;
  reg [85:0] fault_en = 86'b0;

  wire signed [7:0] DATA_OUT_g, DATA_OUT_f;

`ifdef RTL
  wire [1:0] st_g, st_f;
`elsif GL
  wire [2:0] st_g, st_f;
`endif
  wire [85:0] mapped_regs_g, mapped_regs_f;

`ifdef RTL
  b04 DUT_GOLDEN (
    .RESTART(RESTART),
    .AVERAGE(AVERAGE),
    .ENABLE(ENABLE),
    .DATA_IN(DATA_IN),
    .DATA_OUT(DATA_OUT_g),
    .RESET(RESET),
    .CLOCK(CLOCK)
  );
  b04 DUT_FAULTY (
    .RESTART(RESTART),
    .AVERAGE(AVERAGE),
    .ENABLE(ENABLE),
    .DATA_IN(DATA_IN),
    .DATA_OUT(DATA_OUT_f),
    .RESET(RESET),
    .CLOCK(CLOCK)
  );
`elsif GL
  b04 DUT_GOLDEN (
    .RESTART(RESTART),
    .AVERAGE(AVERAGE),
    .ENABLE(ENABLE),
    .DATA_IN(DATA_IN),
    .DATA_OUT(DATA_OUT_g),
    .RESET(RESET),
    .CLOCK(CLOCK),
    .fault_en(86'b0)
  );
  b04 DUT_FAULTY (
    .RESTART(RESTART),
    .AVERAGE(AVERAGE),
    .ENABLE(ENABLE),
    .DATA_IN(DATA_IN),
    .DATA_OUT(DATA_OUT_f),
    .RESET(RESET),
    .CLOCK(CLOCK),
    .fault_en(fault_en)
  );
`else
  initial begin $display("ERROR: Compile with -DRTL or -DGL"); $finish; end
`endif

`ifdef RTL
  assign st_g = DUT_GOLDEN.stato;
  assign st_f = DUT_FAULTY.stato;
  assign mapped_regs_g[0] = DUT_GOLDEN.sum_in[0];
  assign mapped_regs_f[0] = DUT_FAULTY.sum_in[0];
  assign mapped_regs_g[1] = DUT_GOLDEN.sum_in[1];
  assign mapped_regs_f[1] = DUT_FAULTY.sum_in[1];
  assign mapped_regs_g[2] = DUT_GOLDEN.sum_in[2];
  assign mapped_regs_f[2] = DUT_FAULTY.sum_in[2];
  assign mapped_regs_g[3] = DUT_GOLDEN.sum_in[3];
  assign mapped_regs_f[3] = DUT_FAULTY.sum_in[3];
  assign mapped_regs_g[4] = DUT_GOLDEN.sum_in[4];
  assign mapped_regs_f[4] = DUT_FAULTY.sum_in[4];
  assign mapped_regs_g[5] = DUT_GOLDEN.sum_in[5];
  assign mapped_regs_f[5] = DUT_FAULTY.sum_in[5];
  assign mapped_regs_g[6] = DUT_GOLDEN.sum_in[6];
  assign mapped_regs_f[6] = DUT_FAULTY.sum_in[6];
  assign mapped_regs_g[7] = DUT_GOLDEN.sum_in[31];
  assign mapped_regs_f[7] = DUT_FAULTY.sum_in[31];
  assign mapped_regs_g[8] = DUT_GOLDEN.stato[0];
  assign mapped_regs_f[8] = DUT_FAULTY.stato[0];
  assign mapped_regs_g[9] = DUT_GOLDEN.stato[1];
  assign mapped_regs_f[9] = DUT_FAULTY.stato[1];
  assign mapped_regs_g[10] = 1'b0; // GL_ONLY
  assign mapped_regs_f[10] = 1'b0; // GL_ONLY
  assign mapped_regs_g[11] = DUT_GOLDEN.DATA_OUT[0];
  assign mapped_regs_f[11] = DUT_FAULTY.DATA_OUT[0];
  assign mapped_regs_g[12] = DUT_GOLDEN.DATA_OUT[1];
  assign mapped_regs_f[12] = DUT_FAULTY.DATA_OUT[1];
  assign mapped_regs_g[13] = DUT_GOLDEN.DATA_OUT[2];
  assign mapped_regs_f[13] = DUT_FAULTY.DATA_OUT[2];
  assign mapped_regs_g[14] = DUT_GOLDEN.DATA_OUT[3];
  assign mapped_regs_f[14] = DUT_FAULTY.DATA_OUT[3];
  assign mapped_regs_g[15] = DUT_GOLDEN.DATA_OUT[4];
  assign mapped_regs_f[15] = DUT_FAULTY.DATA_OUT[4];
  assign mapped_regs_g[16] = DUT_GOLDEN.DATA_OUT[5];
  assign mapped_regs_f[16] = DUT_FAULTY.DATA_OUT[5];
  assign mapped_regs_g[17] = DUT_GOLDEN.DATA_OUT[6];
  assign mapped_regs_f[17] = DUT_FAULTY.DATA_OUT[6];
  assign mapped_regs_g[18] = DUT_GOLDEN.DATA_OUT[7];
  assign mapped_regs_f[18] = DUT_FAULTY.DATA_OUT[7];
  assign mapped_regs_g[19] = DUT_GOLDEN.RMAX[0];
  assign mapped_regs_f[19] = DUT_FAULTY.RMAX[0];
  assign mapped_regs_g[20] = DUT_GOLDEN.RMAX[1];
  assign mapped_regs_f[20] = DUT_FAULTY.RMAX[1];
  assign mapped_regs_g[21] = DUT_GOLDEN.RMAX[2];
  assign mapped_regs_f[21] = DUT_FAULTY.RMAX[2];
  assign mapped_regs_g[22] = DUT_GOLDEN.RMAX[3];
  assign mapped_regs_f[22] = DUT_FAULTY.RMAX[3];
  assign mapped_regs_g[23] = DUT_GOLDEN.RMAX[4];
  assign mapped_regs_f[23] = DUT_FAULTY.RMAX[4];
  assign mapped_regs_g[24] = DUT_GOLDEN.RMAX[5];
  assign mapped_regs_f[24] = DUT_FAULTY.RMAX[5];
  assign mapped_regs_g[25] = DUT_GOLDEN.RMAX[6];
  assign mapped_regs_f[25] = DUT_FAULTY.RMAX[6];
  assign mapped_regs_g[26] = DUT_GOLDEN.RMAX[10];
  assign mapped_regs_f[26] = DUT_FAULTY.RMAX[10];
  assign mapped_regs_g[27] = DUT_GOLDEN.RMIN[0];
  assign mapped_regs_f[27] = DUT_FAULTY.RMIN[0];
  assign mapped_regs_g[28] = DUT_GOLDEN.RMIN[1];
  assign mapped_regs_f[28] = DUT_FAULTY.RMIN[1];
  assign mapped_regs_g[29] = DUT_GOLDEN.RMIN[2];
  assign mapped_regs_f[29] = DUT_FAULTY.RMIN[2];
  assign mapped_regs_g[30] = DUT_GOLDEN.RMIN[3];
  assign mapped_regs_f[30] = DUT_FAULTY.RMIN[3];
  assign mapped_regs_g[31] = DUT_GOLDEN.RMIN[4];
  assign mapped_regs_f[31] = DUT_FAULTY.RMIN[4];
  assign mapped_regs_g[32] = DUT_GOLDEN.RMIN[5];
  assign mapped_regs_f[32] = DUT_FAULTY.RMIN[5];
  assign mapped_regs_g[33] = DUT_GOLDEN.RMIN[6];
  assign mapped_regs_f[33] = DUT_FAULTY.RMIN[6];
  assign mapped_regs_g[34] = DUT_GOLDEN.RMIN[10];
  assign mapped_regs_f[34] = DUT_FAULTY.RMIN[10];
  assign mapped_regs_g[35] = DUT_GOLDEN.RLAST[0];
  assign mapped_regs_f[35] = DUT_FAULTY.RLAST[0];
  assign mapped_regs_g[36] = DUT_GOLDEN.RLAST[1];
  assign mapped_regs_f[36] = DUT_FAULTY.RLAST[1];
  assign mapped_regs_g[37] = DUT_GOLDEN.RLAST[2];
  assign mapped_regs_f[37] = DUT_FAULTY.RLAST[2];
  assign mapped_regs_g[38] = DUT_GOLDEN.RLAST[3];
  assign mapped_regs_f[38] = DUT_FAULTY.RLAST[3];
  assign mapped_regs_g[39] = DUT_GOLDEN.RLAST[4];
  assign mapped_regs_f[39] = DUT_FAULTY.RLAST[4];
  assign mapped_regs_g[40] = DUT_GOLDEN.RLAST[5];
  assign mapped_regs_f[40] = DUT_FAULTY.RLAST[5];
  assign mapped_regs_g[41] = DUT_GOLDEN.RLAST[6];
  assign mapped_regs_f[41] = DUT_FAULTY.RLAST[6];
  assign mapped_regs_g[42] = DUT_GOLDEN.RLAST[7];
  assign mapped_regs_f[42] = DUT_FAULTY.RLAST[7];
  assign mapped_regs_g[43] = DUT_GOLDEN.REG1[0];
  assign mapped_regs_f[43] = DUT_FAULTY.REG1[0];
  assign mapped_regs_g[44] = DUT_GOLDEN.REG1[1];
  assign mapped_regs_f[44] = DUT_FAULTY.REG1[1];
  assign mapped_regs_g[45] = DUT_GOLDEN.REG1[2];
  assign mapped_regs_f[45] = DUT_FAULTY.REG1[2];
  assign mapped_regs_g[46] = DUT_GOLDEN.REG1[3];
  assign mapped_regs_f[46] = DUT_FAULTY.REG1[3];
  assign mapped_regs_g[47] = DUT_GOLDEN.REG1[4];
  assign mapped_regs_f[47] = DUT_FAULTY.REG1[4];
  assign mapped_regs_g[48] = DUT_GOLDEN.REG1[5];
  assign mapped_regs_f[48] = DUT_FAULTY.REG1[5];
  assign mapped_regs_g[49] = DUT_GOLDEN.REG1[6];
  assign mapped_regs_f[49] = DUT_FAULTY.REG1[6];
  assign mapped_regs_g[50] = DUT_GOLDEN.REG1[10];
  assign mapped_regs_f[50] = DUT_FAULTY.REG1[10];
  assign mapped_regs_g[51] = DUT_GOLDEN.REG2[0];
  assign mapped_regs_f[51] = DUT_FAULTY.REG2[0];
  assign mapped_regs_g[52] = DUT_GOLDEN.REG2[1];
  assign mapped_regs_f[52] = DUT_FAULTY.REG2[1];
  assign mapped_regs_g[53] = DUT_GOLDEN.REG2[2];
  assign mapped_regs_f[53] = DUT_FAULTY.REG2[2];
  assign mapped_regs_g[54] = DUT_GOLDEN.REG2[3];
  assign mapped_regs_f[54] = DUT_FAULTY.REG2[3];
  assign mapped_regs_g[55] = DUT_GOLDEN.REG2[4];
  assign mapped_regs_f[55] = DUT_FAULTY.REG2[4];
  assign mapped_regs_g[56] = DUT_GOLDEN.REG2[5];
  assign mapped_regs_f[56] = DUT_FAULTY.REG2[5];
  assign mapped_regs_g[57] = DUT_GOLDEN.REG2[6];
  assign mapped_regs_f[57] = DUT_FAULTY.REG2[6];
  assign mapped_regs_g[58] = DUT_GOLDEN.REG2[10];
  assign mapped_regs_f[58] = DUT_FAULTY.REG2[10];
  assign mapped_regs_g[59] = DUT_GOLDEN.REG3[0];
  assign mapped_regs_f[59] = DUT_FAULTY.REG3[0];
  assign mapped_regs_g[60] = DUT_GOLDEN.REG3[1];
  assign mapped_regs_f[60] = DUT_FAULTY.REG3[1];
  assign mapped_regs_g[61] = DUT_GOLDEN.REG3[2];
  assign mapped_regs_f[61] = DUT_FAULTY.REG3[2];
  assign mapped_regs_g[62] = DUT_GOLDEN.REG3[3];
  assign mapped_regs_f[62] = DUT_FAULTY.REG3[3];
  assign mapped_regs_g[63] = DUT_GOLDEN.REG3[4];
  assign mapped_regs_f[63] = DUT_FAULTY.REG3[4];
  assign mapped_regs_g[64] = DUT_GOLDEN.REG3[5];
  assign mapped_regs_f[64] = DUT_FAULTY.REG3[5];
  assign mapped_regs_g[65] = DUT_GOLDEN.REG3[6];
  assign mapped_regs_f[65] = DUT_FAULTY.REG3[6];
  assign mapped_regs_g[66] = DUT_GOLDEN.REG3[10];
  assign mapped_regs_f[66] = DUT_FAULTY.REG3[10];
  assign mapped_regs_g[67] = DUT_GOLDEN.RES;
  assign mapped_regs_f[67] = DUT_FAULTY.RES;
  assign mapped_regs_g[68] = DUT_GOLDEN.AVE;
  assign mapped_regs_f[68] = DUT_FAULTY.AVE;
  assign mapped_regs_g[69] = DUT_GOLDEN.ENA;
  assign mapped_regs_f[69] = DUT_FAULTY.ENA;
  assign mapped_regs_g[70] = DUT_GOLDEN.REG4[0];
  assign mapped_regs_f[70] = DUT_FAULTY.REG4[0];
  assign mapped_regs_g[71] = DUT_GOLDEN.REG4[1];
  assign mapped_regs_f[71] = DUT_FAULTY.REG4[1];
  assign mapped_regs_g[72] = DUT_GOLDEN.REG4[2];
  assign mapped_regs_f[72] = DUT_FAULTY.REG4[2];
  assign mapped_regs_g[73] = DUT_GOLDEN.REG4[3];
  assign mapped_regs_f[73] = DUT_FAULTY.REG4[3];
  assign mapped_regs_g[74] = DUT_GOLDEN.REG4[4];
  assign mapped_regs_f[74] = DUT_FAULTY.REG4[4];
  assign mapped_regs_g[75] = DUT_GOLDEN.REG4[5];
  assign mapped_regs_f[75] = DUT_FAULTY.REG4[5];
  assign mapped_regs_g[76] = DUT_GOLDEN.REG4[6];
  assign mapped_regs_f[76] = DUT_FAULTY.REG4[6];
  assign mapped_regs_g[77] = DUT_GOLDEN.REG4[10];
  assign mapped_regs_f[77] = DUT_FAULTY.REG4[10];
  assign mapped_regs_g[78] = DUT_GOLDEN.sum_rm[0];
  assign mapped_regs_f[78] = DUT_FAULTY.sum_rm[0];
  assign mapped_regs_g[79] = DUT_GOLDEN.sum_rm[1];
  assign mapped_regs_f[79] = DUT_FAULTY.sum_rm[1];
  assign mapped_regs_g[80] = DUT_GOLDEN.sum_rm[2];
  assign mapped_regs_f[80] = DUT_FAULTY.sum_rm[2];
  assign mapped_regs_g[81] = DUT_GOLDEN.sum_rm[3];
  assign mapped_regs_f[81] = DUT_FAULTY.sum_rm[3];
  assign mapped_regs_g[82] = DUT_GOLDEN.sum_rm[4];
  assign mapped_regs_f[82] = DUT_FAULTY.sum_rm[4];
  assign mapped_regs_g[83] = DUT_GOLDEN.sum_rm[5];
  assign mapped_regs_f[83] = DUT_FAULTY.sum_rm[5];
  assign mapped_regs_g[84] = DUT_GOLDEN.sum_rm[6];
  assign mapped_regs_f[84] = DUT_FAULTY.sum_rm[6];
  assign mapped_regs_g[85] = DUT_GOLDEN.sum_rm[31];
  assign mapped_regs_f[85] = DUT_FAULTY.sum_rm[31];
`elsif GL
  assign st_g = {DUT_GOLDEN.\stato[2] , DUT_GOLDEN.\stato[1] , DUT_GOLDEN.\stato[0] };
  assign st_f = {DUT_FAULTY.\stato[2] , DUT_FAULTY.\stato[1] , DUT_FAULTY.\stato[0] };
  assign mapped_regs_g[0] = DUT_GOLDEN.\sum_in[0] ;
  assign mapped_regs_f[0] = DUT_FAULTY.\sum_in[0] ;
  assign mapped_regs_g[1] = DUT_GOLDEN.\sum_in[1] ;
  assign mapped_regs_f[1] = DUT_FAULTY.\sum_in[1] ;
  assign mapped_regs_g[2] = DUT_GOLDEN.\sum_in[2] ;
  assign mapped_regs_f[2] = DUT_FAULTY.\sum_in[2] ;
  assign mapped_regs_g[3] = DUT_GOLDEN.\sum_in[3] ;
  assign mapped_regs_f[3] = DUT_FAULTY.\sum_in[3] ;
  assign mapped_regs_g[4] = DUT_GOLDEN.\sum_in[4] ;
  assign mapped_regs_f[4] = DUT_FAULTY.\sum_in[4] ;
  assign mapped_regs_g[5] = DUT_GOLDEN.\sum_in[5] ;
  assign mapped_regs_f[5] = DUT_FAULTY.\sum_in[5] ;
  assign mapped_regs_g[6] = DUT_GOLDEN.\sum_in[6] ;
  assign mapped_regs_f[6] = DUT_FAULTY.\sum_in[6] ;
  assign mapped_regs_g[7] = DUT_GOLDEN.\sum_in[31] ;
  assign mapped_regs_f[7] = DUT_FAULTY.\sum_in[31] ;
  assign mapped_regs_g[8] = DUT_GOLDEN.\stato[0] ;
  assign mapped_regs_f[8] = DUT_FAULTY.\stato[0] ;
  assign mapped_regs_g[9] = DUT_GOLDEN.\stato[1] ;
  assign mapped_regs_f[9] = DUT_FAULTY.\stato[1] ;
  assign mapped_regs_g[10] = DUT_GOLDEN.\stato[2] ;
  assign mapped_regs_f[10] = DUT_FAULTY.\stato[2] ;
  assign mapped_regs_g[11] = DUT_GOLDEN.DATA_OUT[0];
  assign mapped_regs_f[11] = DUT_FAULTY.DATA_OUT[0];
  assign mapped_regs_g[12] = DUT_GOLDEN.DATA_OUT[1];
  assign mapped_regs_f[12] = DUT_FAULTY.DATA_OUT[1];
  assign mapped_regs_g[13] = DUT_GOLDEN.DATA_OUT[2];
  assign mapped_regs_f[13] = DUT_FAULTY.DATA_OUT[2];
  assign mapped_regs_g[14] = DUT_GOLDEN.DATA_OUT[3];
  assign mapped_regs_f[14] = DUT_FAULTY.DATA_OUT[3];
  assign mapped_regs_g[15] = DUT_GOLDEN.DATA_OUT[4];
  assign mapped_regs_f[15] = DUT_FAULTY.DATA_OUT[4];
  assign mapped_regs_g[16] = DUT_GOLDEN.DATA_OUT[5];
  assign mapped_regs_f[16] = DUT_FAULTY.DATA_OUT[5];
  assign mapped_regs_g[17] = DUT_GOLDEN.DATA_OUT[6];
  assign mapped_regs_f[17] = DUT_FAULTY.DATA_OUT[6];
  assign mapped_regs_g[18] = DUT_GOLDEN.DATA_OUT[7];
  assign mapped_regs_f[18] = DUT_FAULTY.DATA_OUT[7];
  assign mapped_regs_g[19] = DUT_GOLDEN.\RMAX[0] ;
  assign mapped_regs_f[19] = DUT_FAULTY.\RMAX[0] ;
  assign mapped_regs_g[20] = DUT_GOLDEN.\RMAX[1] ;
  assign mapped_regs_f[20] = DUT_FAULTY.\RMAX[1] ;
  assign mapped_regs_g[21] = DUT_GOLDEN.\RMAX[2] ;
  assign mapped_regs_f[21] = DUT_FAULTY.\RMAX[2] ;
  assign mapped_regs_g[22] = DUT_GOLDEN.\RMAX[3] ;
  assign mapped_regs_f[22] = DUT_FAULTY.\RMAX[3] ;
  assign mapped_regs_g[23] = DUT_GOLDEN.\RMAX[4] ;
  assign mapped_regs_f[23] = DUT_FAULTY.\RMAX[4] ;
  assign mapped_regs_g[24] = DUT_GOLDEN.\RMAX[5] ;
  assign mapped_regs_f[24] = DUT_FAULTY.\RMAX[5] ;
  assign mapped_regs_g[25] = DUT_GOLDEN.\RMAX[6] ;
  assign mapped_regs_f[25] = DUT_FAULTY.\RMAX[6] ;
  assign mapped_regs_g[26] = DUT_GOLDEN.\RMAX[10] ;
  assign mapped_regs_f[26] = DUT_FAULTY.\RMAX[10] ;
  assign mapped_regs_g[27] = DUT_GOLDEN.\RMIN[0] ;
  assign mapped_regs_f[27] = DUT_FAULTY.\RMIN[0] ;
  assign mapped_regs_g[28] = DUT_GOLDEN.\RMIN[1] ;
  assign mapped_regs_f[28] = DUT_FAULTY.\RMIN[1] ;
  assign mapped_regs_g[29] = DUT_GOLDEN.\RMIN[2] ;
  assign mapped_regs_f[29] = DUT_FAULTY.\RMIN[2] ;
  assign mapped_regs_g[30] = DUT_GOLDEN.\RMIN[3] ;
  assign mapped_regs_f[30] = DUT_FAULTY.\RMIN[3] ;
  assign mapped_regs_g[31] = DUT_GOLDEN.\RMIN[4] ;
  assign mapped_regs_f[31] = DUT_FAULTY.\RMIN[4] ;
  assign mapped_regs_g[32] = DUT_GOLDEN.\RMIN[5] ;
  assign mapped_regs_f[32] = DUT_FAULTY.\RMIN[5] ;
  assign mapped_regs_g[33] = DUT_GOLDEN.\RMIN[6] ;
  assign mapped_regs_f[33] = DUT_FAULTY.\RMIN[6] ;
  assign mapped_regs_g[34] = DUT_GOLDEN.\RMIN[10] ;
  assign mapped_regs_f[34] = DUT_FAULTY.\RMIN[10] ;
  assign mapped_regs_g[35] = DUT_GOLDEN.\RLAST[0] ;
  assign mapped_regs_f[35] = DUT_FAULTY.\RLAST[0] ;
  assign mapped_regs_g[36] = DUT_GOLDEN.\RLAST[1] ;
  assign mapped_regs_f[36] = DUT_FAULTY.\RLAST[1] ;
  assign mapped_regs_g[37] = DUT_GOLDEN.\RLAST[2] ;
  assign mapped_regs_f[37] = DUT_FAULTY.\RLAST[2] ;
  assign mapped_regs_g[38] = DUT_GOLDEN.\RLAST[3] ;
  assign mapped_regs_f[38] = DUT_FAULTY.\RLAST[3] ;
  assign mapped_regs_g[39] = DUT_GOLDEN.\RLAST[4] ;
  assign mapped_regs_f[39] = DUT_FAULTY.\RLAST[4] ;
  assign mapped_regs_g[40] = DUT_GOLDEN.\RLAST[5] ;
  assign mapped_regs_f[40] = DUT_FAULTY.\RLAST[5] ;
  assign mapped_regs_g[41] = DUT_GOLDEN.\RLAST[6] ;
  assign mapped_regs_f[41] = DUT_FAULTY.\RLAST[6] ;
  assign mapped_regs_g[42] = DUT_GOLDEN.\RLAST[7] ;
  assign mapped_regs_f[42] = DUT_FAULTY.\RLAST[7] ;
  assign mapped_regs_g[43] = DUT_GOLDEN.\REG1[0] ;
  assign mapped_regs_f[43] = DUT_FAULTY.\REG1[0] ;
  assign mapped_regs_g[44] = DUT_GOLDEN.\REG1[1] ;
  assign mapped_regs_f[44] = DUT_FAULTY.\REG1[1] ;
  assign mapped_regs_g[45] = DUT_GOLDEN.\REG1[2] ;
  assign mapped_regs_f[45] = DUT_FAULTY.\REG1[2] ;
  assign mapped_regs_g[46] = DUT_GOLDEN.\REG1[3] ;
  assign mapped_regs_f[46] = DUT_FAULTY.\REG1[3] ;
  assign mapped_regs_g[47] = DUT_GOLDEN.\REG1[4] ;
  assign mapped_regs_f[47] = DUT_FAULTY.\REG1[4] ;
  assign mapped_regs_g[48] = DUT_GOLDEN.\REG1[5] ;
  assign mapped_regs_f[48] = DUT_FAULTY.\REG1[5] ;
  assign mapped_regs_g[49] = DUT_GOLDEN.\REG1[6] ;
  assign mapped_regs_f[49] = DUT_FAULTY.\REG1[6] ;
  assign mapped_regs_g[50] = DUT_GOLDEN.\REG1[10] ;
  assign mapped_regs_f[50] = DUT_FAULTY.\REG1[10] ;
  assign mapped_regs_g[51] = DUT_GOLDEN.\REG2[0] ;
  assign mapped_regs_f[51] = DUT_FAULTY.\REG2[0] ;
  assign mapped_regs_g[52] = DUT_GOLDEN.\REG2[1] ;
  assign mapped_regs_f[52] = DUT_FAULTY.\REG2[1] ;
  assign mapped_regs_g[53] = DUT_GOLDEN.\REG2[2] ;
  assign mapped_regs_f[53] = DUT_FAULTY.\REG2[2] ;
  assign mapped_regs_g[54] = DUT_GOLDEN.\REG2[3] ;
  assign mapped_regs_f[54] = DUT_FAULTY.\REG2[3] ;
  assign mapped_regs_g[55] = DUT_GOLDEN.\REG2[4] ;
  assign mapped_regs_f[55] = DUT_FAULTY.\REG2[4] ;
  assign mapped_regs_g[56] = DUT_GOLDEN.\REG2[5] ;
  assign mapped_regs_f[56] = DUT_FAULTY.\REG2[5] ;
  assign mapped_regs_g[57] = DUT_GOLDEN.\REG2[6] ;
  assign mapped_regs_f[57] = DUT_FAULTY.\REG2[6] ;
  assign mapped_regs_g[58] = DUT_GOLDEN.\REG2[10] ;
  assign mapped_regs_f[58] = DUT_FAULTY.\REG2[10] ;
  assign mapped_regs_g[59] = DUT_GOLDEN.\REG3[0] ;
  assign mapped_regs_f[59] = DUT_FAULTY.\REG3[0] ;
  assign mapped_regs_g[60] = DUT_GOLDEN.\REG3[1] ;
  assign mapped_regs_f[60] = DUT_FAULTY.\REG3[1] ;
  assign mapped_regs_g[61] = DUT_GOLDEN.\REG3[2] ;
  assign mapped_regs_f[61] = DUT_FAULTY.\REG3[2] ;
  assign mapped_regs_g[62] = DUT_GOLDEN.\REG3[3] ;
  assign mapped_regs_f[62] = DUT_FAULTY.\REG3[3] ;
  assign mapped_regs_g[63] = DUT_GOLDEN.\REG3[4] ;
  assign mapped_regs_f[63] = DUT_FAULTY.\REG3[4] ;
  assign mapped_regs_g[64] = DUT_GOLDEN.\REG3[5] ;
  assign mapped_regs_f[64] = DUT_FAULTY.\REG3[5] ;
  assign mapped_regs_g[65] = DUT_GOLDEN.\REG3[6] ;
  assign mapped_regs_f[65] = DUT_FAULTY.\REG3[6] ;
  assign mapped_regs_g[66] = DUT_GOLDEN.\REG3[10] ;
  assign mapped_regs_f[66] = DUT_FAULTY.\REG3[10] ;
  assign mapped_regs_g[67] = DUT_GOLDEN.RES;
  assign mapped_regs_f[67] = DUT_FAULTY.RES;
  assign mapped_regs_g[68] = DUT_GOLDEN.AVE;
  assign mapped_regs_f[68] = DUT_FAULTY.AVE;
  assign mapped_regs_g[69] = DUT_GOLDEN.ENA;
  assign mapped_regs_f[69] = DUT_FAULTY.ENA;
  assign mapped_regs_g[70] = DUT_GOLDEN.\REG4[0] ;
  assign mapped_regs_f[70] = DUT_FAULTY.\REG4[0] ;
  assign mapped_regs_g[71] = DUT_GOLDEN.\REG4[1] ;
  assign mapped_regs_f[71] = DUT_FAULTY.\REG4[1] ;
  assign mapped_regs_g[72] = DUT_GOLDEN.\REG4[2] ;
  assign mapped_regs_f[72] = DUT_FAULTY.\REG4[2] ;
  assign mapped_regs_g[73] = DUT_GOLDEN.\REG4[3] ;
  assign mapped_regs_f[73] = DUT_FAULTY.\REG4[3] ;
  assign mapped_regs_g[74] = DUT_GOLDEN.\REG4[4] ;
  assign mapped_regs_f[74] = DUT_FAULTY.\REG4[4] ;
  assign mapped_regs_g[75] = DUT_GOLDEN.\REG4[5] ;
  assign mapped_regs_f[75] = DUT_FAULTY.\REG4[5] ;
  assign mapped_regs_g[76] = DUT_GOLDEN.\REG4[6] ;
  assign mapped_regs_f[76] = DUT_FAULTY.\REG4[6] ;
  assign mapped_regs_g[77] = DUT_GOLDEN.\REG4[10] ;
  assign mapped_regs_f[77] = DUT_FAULTY.\REG4[10] ;
  assign mapped_regs_g[78] = DUT_GOLDEN.\sum_rm[0] ;
  assign mapped_regs_f[78] = DUT_FAULTY.\sum_rm[0] ;
  assign mapped_regs_g[79] = DUT_GOLDEN.\sum_rm[1] ;
  assign mapped_regs_f[79] = DUT_FAULTY.\sum_rm[1] ;
  assign mapped_regs_g[80] = DUT_GOLDEN.\sum_rm[2] ;
  assign mapped_regs_f[80] = DUT_FAULTY.\sum_rm[2] ;
  assign mapped_regs_g[81] = DUT_GOLDEN.\sum_rm[3] ;
  assign mapped_regs_f[81] = DUT_FAULTY.\sum_rm[3] ;
  assign mapped_regs_g[82] = DUT_GOLDEN.\sum_rm[4] ;
  assign mapped_regs_f[82] = DUT_FAULTY.\sum_rm[4] ;
  assign mapped_regs_g[83] = DUT_GOLDEN.\sum_rm[5] ;
  assign mapped_regs_f[83] = DUT_FAULTY.\sum_rm[5] ;
  assign mapped_regs_g[84] = DUT_GOLDEN.\sum_rm[6] ;
  assign mapped_regs_f[84] = DUT_FAULTY.\sum_rm[6] ;
  assign mapped_regs_g[85] = DUT_GOLDEN.\sum_rm[31] ;
  assign mapped_regs_f[85] = DUT_FAULTY.\sum_rm[31] ;
`endif

  ////////////////////////////////////////////////////////////
  // Complete canonical fault target mapping
  ////////////////////////////////////////////////////////////
  // fault_en[0] = sum_in[0] (RTL) -> _819_
  // fault_en[1] = sum_in[1] (RTL) -> _820_
  // fault_en[2] = sum_in[2] (RTL) -> _821_
  // fault_en[3] = sum_in[3] (RTL) -> _822_
  // fault_en[4] = sum_in[4] (RTL) -> _823_
  // fault_en[5] = sum_in[5] (RTL) -> _824_
  // fault_en[6] = sum_in[6] (RTL) -> _825_
  // fault_en[7] = sum_in[31] (RTL) -> _826_
  // fault_en[8] = stato[0] (RTL) -> _827_
  // fault_en[9] = stato[1] (RTL) -> _828_
  // fault_en[10] = stato[2] (GL_ONLY) -> _829_
  // fault_en[11] = DATA_OUT[0] (RTL) -> _830_
  // fault_en[12] = DATA_OUT[1] (RTL) -> _831_
  // fault_en[13] = DATA_OUT[2] (RTL) -> _832_
  // fault_en[14] = DATA_OUT[3] (RTL) -> _833_
  // fault_en[15] = DATA_OUT[4] (RTL) -> _834_
  // fault_en[16] = DATA_OUT[5] (RTL) -> _835_
  // fault_en[17] = DATA_OUT[6] (RTL) -> _836_
  // fault_en[18] = DATA_OUT[7] (RTL) -> _837_
  // fault_en[19] = RMAX[0] (RTL) -> _838_
  // fault_en[20] = RMAX[1] (RTL) -> _839_
  // fault_en[21] = RMAX[2] (RTL) -> _840_
  // fault_en[22] = RMAX[3] (RTL) -> _841_
  // fault_en[23] = RMAX[4] (RTL) -> _842_
  // fault_en[24] = RMAX[5] (RTL) -> _843_
  // fault_en[25] = RMAX[6] (RTL) -> _844_
  // fault_en[26] = RMAX[10] (RTL) -> _845_
  // fault_en[27] = RMIN[0] (RTL) -> _846_
  // fault_en[28] = RMIN[1] (RTL) -> _847_
  // fault_en[29] = RMIN[2] (RTL) -> _848_
  // fault_en[30] = RMIN[3] (RTL) -> _849_
  // fault_en[31] = RMIN[4] (RTL) -> _850_
  // fault_en[32] = RMIN[5] (RTL) -> _851_
  // fault_en[33] = RMIN[6] (RTL) -> _852_
  // fault_en[34] = RMIN[10] (RTL) -> _853_
  // fault_en[35] = RLAST[0] (RTL) -> _854_
  // fault_en[36] = RLAST[1] (RTL) -> _855_
  // fault_en[37] = RLAST[2] (RTL) -> _856_
  // fault_en[38] = RLAST[3] (RTL) -> _857_
  // fault_en[39] = RLAST[4] (RTL) -> _858_
  // fault_en[40] = RLAST[5] (RTL) -> _859_
  // fault_en[41] = RLAST[6] (RTL) -> _860_
  // fault_en[42] = RLAST[7] (RTL) -> _861_
  // fault_en[43] = REG1[0] (RTL) -> _862_
  // fault_en[44] = REG1[1] (RTL) -> _863_
  // fault_en[45] = REG1[2] (RTL) -> _864_
  // fault_en[46] = REG1[3] (RTL) -> _865_
  // fault_en[47] = REG1[4] (RTL) -> _866_
  // fault_en[48] = REG1[5] (RTL) -> _867_
  // fault_en[49] = REG1[6] (RTL) -> _868_
  // fault_en[50] = REG1[10] (RTL) -> _869_
  // fault_en[51] = REG2[0] (RTL) -> _870_
  // fault_en[52] = REG2[1] (RTL) -> _871_
  // fault_en[53] = REG2[2] (RTL) -> _872_
  // fault_en[54] = REG2[3] (RTL) -> _873_
  // fault_en[55] = REG2[4] (RTL) -> _874_
  // fault_en[56] = REG2[5] (RTL) -> _875_
  // fault_en[57] = REG2[6] (RTL) -> _876_
  // fault_en[58] = REG2[10] (RTL) -> _877_
  // fault_en[59] = REG3[0] (RTL) -> _878_
  // fault_en[60] = REG3[1] (RTL) -> _879_
  // fault_en[61] = REG3[2] (RTL) -> _880_
  // fault_en[62] = REG3[3] (RTL) -> _881_
  // fault_en[63] = REG3[4] (RTL) -> _882_
  // fault_en[64] = REG3[5] (RTL) -> _883_
  // fault_en[65] = REG3[6] (RTL) -> _884_
  // fault_en[66] = REG3[10] (RTL) -> _885_
  // fault_en[67] = RES[0] (RTL) -> _886_
  // fault_en[68] = AVE[0] (RTL) -> _887_
  // fault_en[69] = ENA[0] (RTL) -> _888_
  // fault_en[70] = REG4[0] (RTL) -> _889_
  // fault_en[71] = REG4[1] (RTL) -> _890_
  // fault_en[72] = REG4[2] (RTL) -> _891_
  // fault_en[73] = REG4[3] (RTL) -> _892_
  // fault_en[74] = REG4[4] (RTL) -> _893_
  // fault_en[75] = REG4[5] (RTL) -> _894_
  // fault_en[76] = REG4[6] (RTL) -> _895_
  // fault_en[77] = REG4[10] (RTL) -> _896_
  // fault_en[78] = sum_rm[0] (RTL) -> _897_
  // fault_en[79] = sum_rm[1] (RTL) -> _898_
  // fault_en[80] = sum_rm[2] (RTL) -> _899_
  // fault_en[81] = sum_rm[3] (RTL) -> _900_
  // fault_en[82] = sum_rm[4] (RTL) -> _901_
  // fault_en[83] = sum_rm[5] (RTL) -> _902_
  // fault_en[84] = sum_rm[6] (RTL) -> _903_
  // fault_en[85] = sum_rm[31] (RTL) -> _904_

  localparam [85:0] FI_SUM_IN_0 = 86'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
  localparam [85:0] FI_SUM_IN_1 = 86'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000010;
  localparam [85:0] FI_SUM_IN_2 = 86'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000100;
  localparam [85:0] FI_SUM_IN_3 = 86'b00000000000000000000000000000000000000000000000000000000000000000000000000000000001000;
  localparam [85:0] FI_SUM_IN_4 = 86'b00000000000000000000000000000000000000000000000000000000000000000000000000000000010000;
  localparam [85:0] FI_SUM_IN_5 = 86'b00000000000000000000000000000000000000000000000000000000000000000000000000000000100000;
  localparam [85:0] FI_SUM_IN_6 = 86'b00000000000000000000000000000000000000000000000000000000000000000000000000000001000000;
  localparam [85:0] FI_SUM_IN_31 = 86'b00000000000000000000000000000000000000000000000000000000000000000000000000000010000000;
  localparam [85:0] FI_STATO_0 = 86'b00000000000000000000000000000000000000000000000000000000000000000000000000000100000000;
  localparam [85:0] FI_STATO_1 = 86'b00000000000000000000000000000000000000000000000000000000000000000000000000001000000000;
  localparam [85:0] FI_STATO_2 = 86'b00000000000000000000000000000000000000000000000000000000000000000000000000010000000000;
  localparam [85:0] FI_DATA_OUT_0 = 86'b00000000000000000000000000000000000000000000000000000000000000000000000000100000000000;
  localparam [85:0] FI_DATA_OUT_1 = 86'b00000000000000000000000000000000000000000000000000000000000000000000000001000000000000;
  localparam [85:0] FI_DATA_OUT_2 = 86'b00000000000000000000000000000000000000000000000000000000000000000000000010000000000000;
  localparam [85:0] FI_DATA_OUT_3 = 86'b00000000000000000000000000000000000000000000000000000000000000000000000100000000000000;
  localparam [85:0] FI_DATA_OUT_4 = 86'b00000000000000000000000000000000000000000000000000000000000000000000001000000000000000;
  localparam [85:0] FI_DATA_OUT_5 = 86'b00000000000000000000000000000000000000000000000000000000000000000000010000000000000000;
  localparam [85:0] FI_DATA_OUT_6 = 86'b00000000000000000000000000000000000000000000000000000000000000000000100000000000000000;
  localparam [85:0] FI_DATA_OUT_7 = 86'b00000000000000000000000000000000000000000000000000000000000000000001000000000000000000;
  localparam [85:0] FI_RMAX_0 = 86'b00000000000000000000000000000000000000000000000000000000000000000010000000000000000000;
  localparam [85:0] FI_RMAX_1 = 86'b00000000000000000000000000000000000000000000000000000000000000000100000000000000000000;
  localparam [85:0] FI_RMAX_2 = 86'b00000000000000000000000000000000000000000000000000000000000000001000000000000000000000;
  localparam [85:0] FI_RMAX_3 = 86'b00000000000000000000000000000000000000000000000000000000000000010000000000000000000000;
  localparam [85:0] FI_RMAX_4 = 86'b00000000000000000000000000000000000000000000000000000000000000100000000000000000000000;
  localparam [85:0] FI_RMAX_5 = 86'b00000000000000000000000000000000000000000000000000000000000001000000000000000000000000;
  localparam [85:0] FI_RMAX_6 = 86'b00000000000000000000000000000000000000000000000000000000000010000000000000000000000000;
  localparam [85:0] FI_RMAX_10 = 86'b00000000000000000000000000000000000000000000000000000000000100000000000000000000000000;
  localparam [85:0] FI_RMIN_0 = 86'b00000000000000000000000000000000000000000000000000000000001000000000000000000000000000;
  localparam [85:0] FI_RMIN_1 = 86'b00000000000000000000000000000000000000000000000000000000010000000000000000000000000000;
  localparam [85:0] FI_RMIN_2 = 86'b00000000000000000000000000000000000000000000000000000000100000000000000000000000000000;
  localparam [85:0] FI_RMIN_3 = 86'b00000000000000000000000000000000000000000000000000000001000000000000000000000000000000;
  localparam [85:0] FI_RMIN_4 = 86'b00000000000000000000000000000000000000000000000000000010000000000000000000000000000000;
  localparam [85:0] FI_RMIN_5 = 86'b00000000000000000000000000000000000000000000000000000100000000000000000000000000000000;
  localparam [85:0] FI_RMIN_6 = 86'b00000000000000000000000000000000000000000000000000001000000000000000000000000000000000;
  localparam [85:0] FI_RMIN_10 = 86'b00000000000000000000000000000000000000000000000000010000000000000000000000000000000000;
  localparam [85:0] FI_RLAST_0 = 86'b00000000000000000000000000000000000000000000000000100000000000000000000000000000000000;
  localparam [85:0] FI_RLAST_1 = 86'b00000000000000000000000000000000000000000000000001000000000000000000000000000000000000;
  localparam [85:0] FI_RLAST_2 = 86'b00000000000000000000000000000000000000000000000010000000000000000000000000000000000000;
  localparam [85:0] FI_RLAST_3 = 86'b00000000000000000000000000000000000000000000000100000000000000000000000000000000000000;
  localparam [85:0] FI_RLAST_4 = 86'b00000000000000000000000000000000000000000000001000000000000000000000000000000000000000;
  localparam [85:0] FI_RLAST_5 = 86'b00000000000000000000000000000000000000000000010000000000000000000000000000000000000000;
  localparam [85:0] FI_RLAST_6 = 86'b00000000000000000000000000000000000000000000100000000000000000000000000000000000000000;
  localparam [85:0] FI_RLAST_7 = 86'b00000000000000000000000000000000000000000001000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG1_0 = 86'b00000000000000000000000000000000000000000010000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG1_1 = 86'b00000000000000000000000000000000000000000100000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG1_2 = 86'b00000000000000000000000000000000000000001000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG1_3 = 86'b00000000000000000000000000000000000000010000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG1_4 = 86'b00000000000000000000000000000000000000100000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG1_5 = 86'b00000000000000000000000000000000000001000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG1_6 = 86'b00000000000000000000000000000000000010000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG1_10 = 86'b00000000000000000000000000000000000100000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG2_0 = 86'b00000000000000000000000000000000001000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG2_1 = 86'b00000000000000000000000000000000010000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG2_2 = 86'b00000000000000000000000000000000100000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG2_3 = 86'b00000000000000000000000000000001000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG2_4 = 86'b00000000000000000000000000000010000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG2_5 = 86'b00000000000000000000000000000100000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG2_6 = 86'b00000000000000000000000000001000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG2_10 = 86'b00000000000000000000000000010000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG3_0 = 86'b00000000000000000000000000100000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG3_1 = 86'b00000000000000000000000001000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG3_2 = 86'b00000000000000000000000010000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG3_3 = 86'b00000000000000000000000100000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG3_4 = 86'b00000000000000000000001000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG3_5 = 86'b00000000000000000000010000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG3_6 = 86'b00000000000000000000100000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG3_10 = 86'b00000000000000000001000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_RES_0 = 86'b00000000000000000010000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_AVE_0 = 86'b00000000000000000100000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_ENA_0 = 86'b00000000000000001000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG4_0 = 86'b00000000000000010000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG4_1 = 86'b00000000000000100000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG4_2 = 86'b00000000000001000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG4_3 = 86'b00000000000010000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG4_4 = 86'b00000000000100000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG4_5 = 86'b00000000001000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG4_6 = 86'b00000000010000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_REG4_10 = 86'b00000000100000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_SUM_RM_0 = 86'b00000001000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_SUM_RM_1 = 86'b00000010000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_SUM_RM_2 = 86'b00000100000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_SUM_RM_3 = 86'b00001000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_SUM_RM_4 = 86'b00010000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_SUM_RM_5 = 86'b00100000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_SUM_RM_6 = 86'b01000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_SUM_RM_31 = 86'b10000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  localparam [85:0] FI_ALL_RTL_MAPPED = 86'b11111111111111111111111111111111111111111111111111111111111111111111111111101111111111;
  localparam [85:0] FI_ALL_GL = {86{1'b1}};
  localparam [85:0] FI_NONE = 86'b0;

  `ifndef FI_MASK
  `define FI_MASK FI_SUM_IN_0
  `endif
  `ifndef INJECT_CYCLE
  `define INJECT_CYCLE 30
  `endif
  localparam integer INJECT_AT = `INJECT_CYCLE;
  localparam [85:0] INJECT_MASK = `FI_MASK;

  initial begin
    $display("INJECT_CYCLE=%0d", INJECT_AT);
    $display("INJECT_MASK=%086b", INJECT_MASK);
`ifdef RTL
    if ((INJECT_MASK & 86'b00000000000000000000000000000000000000000000000000000000000000000000000000010000000000) != 86'b0)
      $display("WARNING: GL_ONLY target bits are ignored in RTL mode");
`endif
  end

  integer cycle_count = 0;
  integer post_cycles = 0;
  reg injection_seen = 0;
  reg first_mismatch_seen = 0;
  always @(posedge CLOCK) begin
    cycle_count <= cycle_count + 1;
    if (fault_en != 86'b0) injection_seen <= 1;
    if (injection_seen) post_cycles <= post_cycles + 1;
    if (post_cycles == 20) begin $display("20 cycles post injection complete."); $finish; end
  end

  always @(negedge CLOCK) begin
    if (cycle_count == INJECT_AT) fault_en <= INJECT_MASK;
    else fault_en <= 86'b0;
  end

`ifdef RTL
  always @(posedge CLOCK) begin
    #0.2;
    if (!RESET) begin
      if (fault_en[0]) DUT_FAULTY.sum_in[0] = ~DUT_FAULTY.sum_in[0];
      if (fault_en[1]) DUT_FAULTY.sum_in[1] = ~DUT_FAULTY.sum_in[1];
      if (fault_en[2]) DUT_FAULTY.sum_in[2] = ~DUT_FAULTY.sum_in[2];
      if (fault_en[3]) DUT_FAULTY.sum_in[3] = ~DUT_FAULTY.sum_in[3];
      if (fault_en[4]) DUT_FAULTY.sum_in[4] = ~DUT_FAULTY.sum_in[4];
      if (fault_en[5]) DUT_FAULTY.sum_in[5] = ~DUT_FAULTY.sum_in[5];
      if (fault_en[6]) DUT_FAULTY.sum_in[6] = ~DUT_FAULTY.sum_in[6];
      if (fault_en[7]) DUT_FAULTY.sum_in[31] = ~DUT_FAULTY.sum_in[31];
      if (fault_en[8]) DUT_FAULTY.stato[0] = ~DUT_FAULTY.stato[0];
      if (fault_en[9]) DUT_FAULTY.stato[1] = ~DUT_FAULTY.stato[1];
      if (fault_en[11]) DUT_FAULTY.DATA_OUT[0] = ~DUT_FAULTY.DATA_OUT[0];
      if (fault_en[12]) DUT_FAULTY.DATA_OUT[1] = ~DUT_FAULTY.DATA_OUT[1];
      if (fault_en[13]) DUT_FAULTY.DATA_OUT[2] = ~DUT_FAULTY.DATA_OUT[2];
      if (fault_en[14]) DUT_FAULTY.DATA_OUT[3] = ~DUT_FAULTY.DATA_OUT[3];
      if (fault_en[15]) DUT_FAULTY.DATA_OUT[4] = ~DUT_FAULTY.DATA_OUT[4];
      if (fault_en[16]) DUT_FAULTY.DATA_OUT[5] = ~DUT_FAULTY.DATA_OUT[5];
      if (fault_en[17]) DUT_FAULTY.DATA_OUT[6] = ~DUT_FAULTY.DATA_OUT[6];
      if (fault_en[18]) DUT_FAULTY.DATA_OUT[7] = ~DUT_FAULTY.DATA_OUT[7];
      if (fault_en[19]) DUT_FAULTY.RMAX[0] = ~DUT_FAULTY.RMAX[0];
      if (fault_en[20]) DUT_FAULTY.RMAX[1] = ~DUT_FAULTY.RMAX[1];
      if (fault_en[21]) DUT_FAULTY.RMAX[2] = ~DUT_FAULTY.RMAX[2];
      if (fault_en[22]) DUT_FAULTY.RMAX[3] = ~DUT_FAULTY.RMAX[3];
      if (fault_en[23]) DUT_FAULTY.RMAX[4] = ~DUT_FAULTY.RMAX[4];
      if (fault_en[24]) DUT_FAULTY.RMAX[5] = ~DUT_FAULTY.RMAX[5];
      if (fault_en[25]) DUT_FAULTY.RMAX[6] = ~DUT_FAULTY.RMAX[6];
      if (fault_en[26]) DUT_FAULTY.RMAX[10] = ~DUT_FAULTY.RMAX[10];
      if (fault_en[27]) DUT_FAULTY.RMIN[0] = ~DUT_FAULTY.RMIN[0];
      if (fault_en[28]) DUT_FAULTY.RMIN[1] = ~DUT_FAULTY.RMIN[1];
      if (fault_en[29]) DUT_FAULTY.RMIN[2] = ~DUT_FAULTY.RMIN[2];
      if (fault_en[30]) DUT_FAULTY.RMIN[3] = ~DUT_FAULTY.RMIN[3];
      if (fault_en[31]) DUT_FAULTY.RMIN[4] = ~DUT_FAULTY.RMIN[4];
      if (fault_en[32]) DUT_FAULTY.RMIN[5] = ~DUT_FAULTY.RMIN[5];
      if (fault_en[33]) DUT_FAULTY.RMIN[6] = ~DUT_FAULTY.RMIN[6];
      if (fault_en[34]) DUT_FAULTY.RMIN[10] = ~DUT_FAULTY.RMIN[10];
      if (fault_en[35]) DUT_FAULTY.RLAST[0] = ~DUT_FAULTY.RLAST[0];
      if (fault_en[36]) DUT_FAULTY.RLAST[1] = ~DUT_FAULTY.RLAST[1];
      if (fault_en[37]) DUT_FAULTY.RLAST[2] = ~DUT_FAULTY.RLAST[2];
      if (fault_en[38]) DUT_FAULTY.RLAST[3] = ~DUT_FAULTY.RLAST[3];
      if (fault_en[39]) DUT_FAULTY.RLAST[4] = ~DUT_FAULTY.RLAST[4];
      if (fault_en[40]) DUT_FAULTY.RLAST[5] = ~DUT_FAULTY.RLAST[5];
      if (fault_en[41]) DUT_FAULTY.RLAST[6] = ~DUT_FAULTY.RLAST[6];
      if (fault_en[42]) DUT_FAULTY.RLAST[7] = ~DUT_FAULTY.RLAST[7];
      if (fault_en[43]) DUT_FAULTY.REG1[0] = ~DUT_FAULTY.REG1[0];
      if (fault_en[44]) DUT_FAULTY.REG1[1] = ~DUT_FAULTY.REG1[1];
      if (fault_en[45]) DUT_FAULTY.REG1[2] = ~DUT_FAULTY.REG1[2];
      if (fault_en[46]) DUT_FAULTY.REG1[3] = ~DUT_FAULTY.REG1[3];
      if (fault_en[47]) DUT_FAULTY.REG1[4] = ~DUT_FAULTY.REG1[4];
      if (fault_en[48]) DUT_FAULTY.REG1[5] = ~DUT_FAULTY.REG1[5];
      if (fault_en[49]) DUT_FAULTY.REG1[6] = ~DUT_FAULTY.REG1[6];
      if (fault_en[50]) DUT_FAULTY.REG1[10] = ~DUT_FAULTY.REG1[10];
      if (fault_en[51]) DUT_FAULTY.REG2[0] = ~DUT_FAULTY.REG2[0];
      if (fault_en[52]) DUT_FAULTY.REG2[1] = ~DUT_FAULTY.REG2[1];
      if (fault_en[53]) DUT_FAULTY.REG2[2] = ~DUT_FAULTY.REG2[2];
      if (fault_en[54]) DUT_FAULTY.REG2[3] = ~DUT_FAULTY.REG2[3];
      if (fault_en[55]) DUT_FAULTY.REG2[4] = ~DUT_FAULTY.REG2[4];
      if (fault_en[56]) DUT_FAULTY.REG2[5] = ~DUT_FAULTY.REG2[5];
      if (fault_en[57]) DUT_FAULTY.REG2[6] = ~DUT_FAULTY.REG2[6];
      if (fault_en[58]) DUT_FAULTY.REG2[10] = ~DUT_FAULTY.REG2[10];
      if (fault_en[59]) DUT_FAULTY.REG3[0] = ~DUT_FAULTY.REG3[0];
      if (fault_en[60]) DUT_FAULTY.REG3[1] = ~DUT_FAULTY.REG3[1];
      if (fault_en[61]) DUT_FAULTY.REG3[2] = ~DUT_FAULTY.REG3[2];
      if (fault_en[62]) DUT_FAULTY.REG3[3] = ~DUT_FAULTY.REG3[3];
      if (fault_en[63]) DUT_FAULTY.REG3[4] = ~DUT_FAULTY.REG3[4];
      if (fault_en[64]) DUT_FAULTY.REG3[5] = ~DUT_FAULTY.REG3[5];
      if (fault_en[65]) DUT_FAULTY.REG3[6] = ~DUT_FAULTY.REG3[6];
      if (fault_en[66]) DUT_FAULTY.REG3[10] = ~DUT_FAULTY.REG3[10];
      if (fault_en[67]) DUT_FAULTY.RES = ~DUT_FAULTY.RES;
      if (fault_en[68]) DUT_FAULTY.AVE = ~DUT_FAULTY.AVE;
      if (fault_en[69]) DUT_FAULTY.ENA = ~DUT_FAULTY.ENA;
      if (fault_en[70]) DUT_FAULTY.REG4[0] = ~DUT_FAULTY.REG4[0];
      if (fault_en[71]) DUT_FAULTY.REG4[1] = ~DUT_FAULTY.REG4[1];
      if (fault_en[72]) DUT_FAULTY.REG4[2] = ~DUT_FAULTY.REG4[2];
      if (fault_en[73]) DUT_FAULTY.REG4[3] = ~DUT_FAULTY.REG4[3];
      if (fault_en[74]) DUT_FAULTY.REG4[4] = ~DUT_FAULTY.REG4[4];
      if (fault_en[75]) DUT_FAULTY.REG4[5] = ~DUT_FAULTY.REG4[5];
      if (fault_en[76]) DUT_FAULTY.REG4[6] = ~DUT_FAULTY.REG4[6];
      if (fault_en[77]) DUT_FAULTY.REG4[10] = ~DUT_FAULTY.REG4[10];
      if (fault_en[78]) DUT_FAULTY.sum_rm[0] = ~DUT_FAULTY.sum_rm[0];
      if (fault_en[79]) DUT_FAULTY.sum_rm[1] = ~DUT_FAULTY.sum_rm[1];
      if (fault_en[80]) DUT_FAULTY.sum_rm[2] = ~DUT_FAULTY.sum_rm[2];
      if (fault_en[81]) DUT_FAULTY.sum_rm[3] = ~DUT_FAULTY.sum_rm[3];
      if (fault_en[82]) DUT_FAULTY.sum_rm[4] = ~DUT_FAULTY.sum_rm[4];
      if (fault_en[83]) DUT_FAULTY.sum_rm[5] = ~DUT_FAULTY.sum_rm[5];
      if (fault_en[84]) DUT_FAULTY.sum_rm[6] = ~DUT_FAULTY.sum_rm[6];
      if (fault_en[85]) DUT_FAULTY.sum_rm[31] = ~DUT_FAULTY.sum_rm[31];
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
    input RESTART_in;
    input AVERAGE_in;
    input ENABLE_in;
    input DATA_IN_in;
  begin
    @(negedge CLOCK);
    RESET = r;
    RESTART = RESTART_in;
    AVERAGE = AVERAGE_in;
    ENABLE = ENABLE_in;
    DATA_IN = DATA_IN_in;
    @(posedge CLOCK); #1;
    $display("CYCLE=%0d | rst=%0b RESTART=%0b AVERAGE=%0b ENABLE=%0b DATA_IN=%0b fe=%086b | G:DATA_OUT=%0h F:DATA_OUT=%0h G:st=%0h F:st=%0h G:regs=%086b F:regs=%086b %s",
      cycle_count, RESET, RESTART, AVERAGE, ENABLE, DATA_IN, fault_en, DATA_OUT_g, DATA_OUT_f, st_g, st_f, mapped_regs_g, mapped_regs_f, (mapped_regs_g !== mapped_regs_f) ? "<-- MISMATCH" : " ");
  end
  endtask

  integer i;
  initial begin
`ifdef RTL
    $dumpfile("b04_rtl_original_compare.vcd");
`elsif GL
    $dumpfile("b04_gl_faulty_compare.vcd");
`endif
    $dumpvars(0, tb_b04_fi);
    drive(1, 0, 0, 0, 0);
    drive(1, 0, 0, 0, 0);
    drive(0, 0, 0, 0, 0);
    for (i=0; i<50; i=i+1) drive(0, $random, $random, $random, $random);
    $display("Stimulus completed.");
    $finish;
  end
endmodule
