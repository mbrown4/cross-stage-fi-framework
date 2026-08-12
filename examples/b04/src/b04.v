module b04(RESTART,AVERAGE,ENABLE,DATA_IN,DATA_OUT,RESET,CLOCK);

input CLOCK;
input RESET;
input RESTART;
input AVERAGE;
input ENABLE;
input signed [7:0] DATA_IN;

output reg signed [7:0] DATA_OUT;

parameter sA = 0;
parameter sB = 1;
parameter sC = 2;

reg [1:0] stato;
reg signed [31:0] RMAX, RMIN, RLAST, REG1, REG2, REG3, REG4, REGD, test;
reg signed [31:0] temp;
reg RES, AVE, ENA;

// Sign-extend DATA_IN to 32-bit once (prevents WIDTHEXPAND)
wire signed [31:0] DATA_IN_32 = {{24{DATA_IN[7]}}, DATA_IN};

// ---- Added: intermediate sums so we can legally slice [6:0] in Verilog ----
reg signed [31:0] sum_rm;   // RMAX + RMIN
reg signed [31:0] sum_in;   // DATA_IN_32 + REG4

always @(posedge CLOCK or posedge RESET) begin
    if (RESET == 1'b1) begin
        // Use nonblocking assignments in sequential logic (prevents BLKSEQ)
        stato    <= sA;
        RMAX     <= 32'sd0;
        RMIN     <= 32'sd0;
        RLAST    <= 32'sd0;
        REG1     <= 32'sd0;
        REG2     <= 32'sd0;
        REG3     <= 32'sd0;
        REG4     <= 32'sd0;
        REGD     <= 32'sd127;
        test     <= 32'sd0;
        temp     <= 32'sd0;
        sum_rm   <= 32'sd0;
        sum_in   <= 32'sd0;
        DATA_OUT <= 8'sd0;
        RES      <= 1'b0;
        ENA      <= 1'b0;
        AVE      <= 1'b0;
    end else begin
        RES <= RESTART;
        ENA <= ENABLE;
        AVE <= AVERAGE;

        case (stato)
            sA: begin
                stato <= sB;
            end

            sB: begin
                RMAX     <= DATA_IN_32;
                RMIN     <= DATA_IN_32;
                REG1     <= 32'sd0;
                REG2     <= 32'sd0;
                REG3     <= 32'sd0;
                REG4     <= 32'sd0;
                RLAST    <= 32'sd0;
                DATA_OUT <= 8'sd0;
                stato    <= sC;
            end

            sC: begin
                if (ENA == 1'b1) begin
                    RLAST <= DATA_IN_32;
                end

                // Precompute sums into named regs so we can slice them legally
                sum_rm <= (RMAX + RMIN);
                sum_in <= (DATA_IN_32 + REG4);

                if (RES == 1'b1) begin
                    test <= (RMAX + RMIN);

                    // REGD = zero-extended 7-bit slice of sum_rm (Verilog-legal)
                    REGD <= {25'b0, sum_rm[6:0]};
                    temp <= sum_rm;

                    if (sum_rm >= 0) begin
                        // Explicit cast: take low 8 bits after shift
                        DATA_OUT <= ({25'b0, sum_rm[6:0]} >>> 1);
                    end else begin
                        DATA_OUT <= -(( -{25'b0, sum_rm[6:0]} ) >>> 1);
                    end
                end
                else if (ENA == 1'b1) begin
                    if (AVE == 1'b1) begin
                        DATA_OUT <= REG4[7:0];
                    end else begin
                        test <= sum_in;

                        REGD <= {25'b0, sum_in[6:0]};
                        temp <= sum_in;

                        if (sum_in >= 0) begin
                            DATA_OUT <= ({25'b0, sum_in[6:0]} >>> 1);
                        end else begin
                            DATA_OUT <= -(( -{25'b0, sum_in[6:0]} ) >>> 1);
                        end
                    end
                end
                else begin
                    DATA_OUT <= RLAST[7:0];
                end

                // Update max/min (32-bit compare)
                if (DATA_IN_32 > RMAX) begin
                    RMAX <= DATA_IN_32;
                end else if (DATA_IN_32 < RMIN) begin
                    RMIN <= DATA_IN_32;
                end

                // Shift regs
                REG4 <= REG3;
                REG3 <= REG2;
                REG2 <= REG1;
                REG1 <= DATA_IN_32;

                stato <= sC;
            end
        endcase
    end
end

endmodule
