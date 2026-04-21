module mapping_loader;

////////////////////////////////////////////////////////////
// PARAMETERS
////////////////////////////////////////////////////////////

parameter MAX_ENTRIES = 100;

////////////////////////////////////////////////////////////
// STORAGE ARRAYS
////////////////////////////////////////////////////////////

reg [127:0] rtl_reg   [0:MAX_ENTRIES-1];
reg [127:0] gl_ff     [0:MAX_ENTRIES-1];
integer     bit_index [0:MAX_ENTRIES-1];

integer mapping_size;

////////////////////////////////////////////////////////////
// FILE VARIABLES
////////////////////////////////////////////////////////////

integer file;
reg [255:0] line;
integer i;
reg duplicate;
integer j;

////////////////////////////////////////////////////////////
// PARSE VARIABLES
////////////////////////////////////////////////////////////

reg [127:0] rtl;
reg [127:0] ff;
integer bit_idx;
integer status;

////////////////////////////////////////////////////////////
// RANDOM SEED
////////////////////////////////////////////////////////////

integer seed;

////////////////////////////////////////////////////////////
// LOAD MAPPING FILE
////////////////////////////////////////////////////////////

task load_mapping;
begin

    mapping_size = 0;

    file = $fopen("mapping.txt","r");

    if(file == 0) begin
        $display("ERROR: Cannot open mapping file");
        $finish;
    end

    while(!$feof(file)) begin

        status = $fgets(line,file);

        status = $sscanf(line,"%s %d %s",rtl,bit_idx,ff);

        if(status == 3) begin

            // -------------------------------
            // Duplicate check
            // -------------------------------
            duplicate = 0;

            for(i = 0; i < mapping_size; i = i + 1) begin
                if((rtl_reg[i] == rtl) &&
                   (bit_index[i] == bit_idx) &&
                   (gl_ff[i] == ff)) begin
                    duplicate = 1;
                end
            end

            // -------------------------------
            // Insert if not duplicate
            // -------------------------------
            if(!duplicate) begin

                rtl_reg[mapping_size]   = rtl;
                bit_index[mapping_size] = bit_idx;
                gl_ff[mapping_size]     = ff;

                $display("Loaded: %s[%0d] -> %s",rtl,bit_idx,ff);

                mapping_size = mapping_size + 1;

            end
           // else begin
             //   $display("Skipped duplicate: %s[%0d] -> %s",rtl,bit_idx,ff);
           // end

        end   // ✅ THIS WAS MISSING

    end

    $fclose(file);

end
endtask

////////////////////////////////////////////////////////////
// RANDOM SELECTION
////////////////////////////////////////////////////////////

task choose_random_mapping;

integer idx;

begin

    if(mapping_size == 0) begin
        $display("ERROR: Mapping table empty");
        disable choose_random_mapping;
    end

    idx = $random % mapping_size;

    if(idx < 0)
        idx = -idx;

    $display("");
    $display("Random Mapping Selected:");
    $display("-----------------------");

    $display("RTL Register : %s", rtl_reg[idx]);
    $display("Bit Index    : %0d", bit_index[idx]);
    $display("GL FlipFlop  : %s", gl_ff[idx]);

end
endtask

////////////////////////////////////////////////////////////
// MAIN
////////////////////////////////////////////////////////////

initial begin

    // Scramble the RNG (THIS is the fix)
    for(j = 0; j < 10; j = j + 1) begin
        seed = $random;
    end

    $display("");
    $display("Loading Mapping File...");
    $display("");

    load_mapping;

    $display("");
    $display("Total entries loaded = %0d",mapping_size);
    $display("");

    choose_random_mapping;

end

endmodule