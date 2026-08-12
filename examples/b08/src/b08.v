module b08(CLOCK, RESET, START, I, O);

input        CLOCK;
input        RESET;
input        START;
input  [7:0] I;

output reg [3:0] O;

reg [19:0] ROM [0:7];

parameter start_st = 0;
parameter init     = 1;
parameter loop_st  = 2;
parameter the_end  = 3;

reg [7:0] IN_R;
reg [3:0] OUT_R;
reg [2:0] MAR;          // <-- FIX: only 3 bits needed for ROM[0:7]
reg [2:0] STATO;

// Combinational decode from current ROM word
wire [7:0] ROM_1  = ROM[MAR][19:12];
wire [7:0] ROM_2  = ROM[MAR][11:4];
wire [3:0] ROM_OR = ROM[MAR][3:0];

initial begin
    ROM[0] = 20'b01111111100101111010;
    ROM[1] = 20'b00111001110101100010;
    ROM[2] = 20'b10101000111111111111;
    ROM[3] = 20'b11111111011010111010;
    ROM[4] = 20'b11111111111101101110;
    ROM[5] = 20'b11111111101110101000;
    ROM[6] = 20'b11001010011101011011;
    ROM[7] = 20'b00101111111111110100;
end

always @(posedge CLOCK or posedge RESET) begin
    if (RESET) begin
        STATO <= start_st;
        MAR   <= 3'b000;
        IN_R  <= 8'b00000000;
        OUT_R <= 4'b0000;
        O     <= 4'b0000;
    end else begin
        case (STATO)
            start_st: begin
                if (START) begin
                    STATO <= init;
                end
            end

            init: begin
                IN_R  <= I;
                OUT_R <= 4'b0000;
                MAR   <= 3'b000;
                STATO <= loop_st;
            end

            loop_st: begin
                // Use ROM_1/ROM_2/ROM_OR wires (no blocking assignments!)
                if (((ROM_2 & ~IN_R) | (ROM_1 & IN_R) | (ROM_2 & ROM_1)) == 8'hFF) begin
                    OUT_R <= OUT_R | ROM_OR;
                end
                STATO <= the_end;
            end

            the_end: begin
                if (MAR != 3'd7) begin
                    MAR   <= MAR + 3'd1;
                    STATO <= loop_st;
                end else if (!START) begin
                    O     <= OUT_R;
                    STATO <= start_st;
                end
            end
        endcase
    end
end

endmodule
