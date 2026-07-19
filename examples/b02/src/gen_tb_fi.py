#!/usr/bin/env python3
import re
import sys
from pathlib import Path

if len(sys.argv) not in [2, 3]:
    print("Usage:")
    print("  python3 gen_tb_fi.py b02.v")
    print("  python3 gen_tb_fi.py b02.v b02_gl_faulty.v")
    sys.exit(1)

rtl_file = Path(sys.argv[1])
text = rtl_file.read_text()

gl_text = None
if len(sys.argv) == 3:
    gl_file = Path(sys.argv[2])
    gl_text = gl_file.read_text()

m = re.search(r"module\s+(\w+)\s*\((.*?)\)\s*;", text, re.S)
if not m:
    raise RuntimeError("Could not find module declaration")

module = m.group(1)
ports = [p.strip() for p in m.group(2).replace("\n", " ").split(",")]

inputs = re.findall(r"input\s+(?:wire|reg)?\s*(?:\[[^\]]+\])?\s*(\w+)\s*;", text)
outputs_reg = re.findall(r"output\s+reg\s+(?:\[[^\]]+\])?\s*(\w+)\s*;", text)
outputs_wire = re.findall(r"output\s+(?!reg)(?:wire)?\s*(?:\[[^\]]+\])?\s*(\w+)\s*;", text)
outputs = outputs_reg + outputs_wire

regs = []
for width, name in re.findall(r"reg\s*(\[[^\]]+\])?\s*(\w+)\s*;", text):
    if name not in outputs:
        regs.append((name, width.strip()))

clock = "clock" if "clock" in inputs else "clk"
reset = "reset" if "reset" in inputs else "rst"
stim_inputs = [x for x in inputs if x not in [clock, reset]]

fault_targets = []
for o in outputs:
    fault_targets.append(o)

for name, width in regs:
    if width:
        nums = re.findall(r"\d+", width)
        msb, lsb = int(nums[0]), int(nums[1])
        width_n = abs(msb - lsb) + 1
    else:
        width_n = 1

    for bit in range(width_n):
        fault_targets.append(f"{name}[{bit}]")

rtl_fault_width = len(fault_targets)

state_reg = regs[0][0] if regs else None
state_width = 1

if regs:
    width = regs[0][1]
    if width:
        nums = re.findall(r"\d+", width)
        state_width = abs(int(nums[0]) - int(nums[1])) + 1

gl_fault_width = rtl_fault_width
gl_state_bits = []

if gl_text:
    m_fault = re.search(r"input\s+\[(\d+):0\]\s+fault_en\s*;", gl_text)
    if m_fault:
        gl_fault_width = int(m_fault.group(1)) + 1

    gl_state_bits = sorted(
        set(int(x) for x in re.findall(r"wire\s+\\stato\[(\d+)\]\s*;", gl_text))
    )

final_fault_width = gl_fault_width if gl_text else rtl_fault_width

tb_name = f"tb_{module}_fi"
out_file = Path(f"{tb_name}.v")

def conn_list(prefix, use_gl=False):
    lines = []

    for p in ports:
        if p in outputs:
            lines.append(f"    .{p}({p}_{prefix})")
        else:
            lines.append(f"    .{p}({p})")

    if use_gl:
        if prefix == "g":
            fault_conn = f"{final_fault_width}'b0"
        else:
            fault_conn = "fault_en"
        lines.append(f"    .fault_en({fault_conn})")

    return ",\n".join(lines)

def clean_fault_name(target):
    return target.replace("[", "_").replace("]", "").upper()

# B02-specific one-hot GL decode table.
# Raw GL one-hot state -> RTL state number.
b02_decode = {
    1: 0,
    16: 1,
    4: 2,
    64: 3,
    2: 4,
    32: 5,
    8: 6,
}

use_gl_decode = gl_text and gl_state_bits and module == "b02"

tb = f"""`timescale 1ns/1ps

module {tb_name};

  ////////////////////////////////////////////////////////////
  // Clock
  ////////////////////////////////////////////////////////////

  reg {clock} = 0;
  always #5 {clock} = ~{clock};

  ////////////////////////////////////////////////////////////
  // Inputs
  ////////////////////////////////////////////////////////////

  reg {reset} = 0;
"""

for inp in stim_inputs:
    tb += f"  reg {inp} = 0;\n"

tb += f"  reg [{final_fault_width-1}:0] fault_en = {final_fault_width}'b0;\n\n"

tb += """  ////////////////////////////////////////////////////////////
  // Outputs
  ////////////////////////////////////////////////////////////

"""

for o in outputs:
    tb += f"  wire {o}_g, {o}_f;\n"

tb += "\n"

if state_reg:
    if gl_text and gl_state_bits:
        gl_state_width = max(gl_state_bits) + 1
        tb += "`ifdef RTL\n"
        tb += f"  wire [{state_width-1}:0] st_g, st_f;\n"
        tb += "`elsif GL\n"
        tb += f"  wire [{gl_state_width-1}:0] st_g, st_f;\n"
        if use_gl_decode:
            tb += f"  reg  [{state_width-1}:0] st_g_decoded, st_f_decoded;\n"
        tb += "`endif\n\n"
    else:
        tb += f"  wire [{state_width-1}:0] st_g, st_f;\n\n"

tb += """  ////////////////////////////////////////////////////////////
  // DUTs
  ////////////////////////////////////////////////////////////

`ifdef RTL

"""

tb += f"""  {module} DUT_GOLDEN (
{conn_list("g", use_gl=False)}
  );

  {module} DUT_FAULTY (
{conn_list("f", use_gl=False)}
  );

"""

if gl_text:
    tb += """`elsif GL

"""
    tb += f"""  {module} DUT_GOLDEN (
{conn_list("g", use_gl=True)}
  );

  {module} DUT_FAULTY (
{conn_list("f", use_gl=True)}
  );

"""

tb += """`else
  initial begin
    $display("ERROR: Compile with either -DRTL or -DGL");
    $finish;
  end
`endif

"""

if state_reg:
    tb += """  ////////////////////////////////////////////////////////////
  // State visibility
  ////////////////////////////////////////////////////////////

`ifdef RTL
"""

    tb += f"""  assign st_g = DUT_GOLDEN.{state_reg};
  assign st_f = DUT_FAULTY.{state_reg};

"""

    if gl_text and gl_state_bits:
        gl_state_concat_g = ",\n                 ".join(
            [f"DUT_GOLDEN.\\stato[{i}] " for i in reversed(gl_state_bits)]
        )
        gl_state_concat_f = ",\n                 ".join(
            [f"DUT_FAULTY.\\stato[{i}] " for i in reversed(gl_state_bits)]
        )

        tb += f"""`elsif GL
  assign st_g = {{{gl_state_concat_g}}};
  assign st_f = {{{gl_state_concat_f}}};

"""

        if use_gl_decode:
            tb += """  always @(*) begin
    case (st_g)
"""
            for raw, decoded in b02_decode.items():
                tb += f"      {len(gl_state_bits)}'d{raw}: st_g_decoded = {state_width}'d{decoded};\n"
            tb += f"""      default: st_g_decoded = {state_width}'b{'x' * state_width};
    endcase
  end

  always @(*) begin
    case (st_f)
"""
            for raw, decoded in b02_decode.items():
                tb += f"      {len(gl_state_bits)}'d{raw}: st_f_decoded = {state_width}'d{decoded};\n"
            tb += f"""      default: st_f_decoded = {state_width}'b{'x' * state_width};
    endcase
  end

"""

    tb += "`endif\n\n"

tb += """  ////////////////////////////////////////////////////////////
  // Fault target mapping
  ////////////////////////////////////////////////////////////

"""

if gl_text and gl_state_bits:
    tb += f"  // fault_en[0] = {outputs[0]}\n"

    for i in gl_state_bits:
        tb += f"  // fault_en[{i+1}] = stato[{i}]\n"

    tb += "\n"

    mask = 1
    tb += f"  localparam [{final_fault_width-1}:0] FI_{outputs[0].upper()} = {final_fault_width}'b{format(mask, f'0{final_fault_width}b')};\n"

    for i in gl_state_bits:
        mask = 1 << (i + 1)
        tb += f"  localparam [{final_fault_width-1}:0] FI_STATO_{i} = {final_fault_width}'b{format(mask, f'0{final_fault_width}b')};\n"

else:
    for i, target in enumerate(fault_targets):
        tb += f"  // fault_en[{i}] = {target}\n"

    tb += "\n"

    for i, target in enumerate(fault_targets):
        mask = 1 << i
        tb += f"  localparam [{final_fault_width-1}:0] FI_{clean_fault_name(target)} = {final_fault_width}'b{format(mask, f'0{final_fault_width}b')};\n"

tb += f"""
  localparam integer INJECT_CYCLE = 30;
  localparam [{final_fault_width-1}:0] INJECT_MASK = `INJECT_MASK;

"""

tb += f"""  ////////////////////////////////////////////////////////////
  // Cycle counter
  ////////////////////////////////////////////////////////////

  integer cycle_count = 0;
  integer post_cycles = 0;
  reg injection_seen = 0;
  reg first_mismatch_seen = 0;

  always @(posedge {clock}) begin
    cycle_count <= cycle_count + 1;

    if (fault_en != {final_fault_width}'b0)
      injection_seen <= 1;

    if (injection_seen)
      post_cycles <= post_cycles + 1;

    if (post_cycles == 20) begin
      $display("20 cycles post injection complete.");
      $finish;
    end
  end

  ////////////////////////////////////////////////////////////
  // Fault enable pulse
  ////////////////////////////////////////////////////////////

  always @(negedge {clock}) begin
    if (cycle_count == INJECT_CYCLE)
      fault_en <= INJECT_MASK;
    else
      fault_en <= {final_fault_width}'b0;
  end

"""

tb += f"""  ////////////////////////////////////////////////////////////
  // RTL-only testbench fault injection
  ////////////////////////////////////////////////////////////

`ifdef RTL
  always @(posedge {clock}) begin
    #0.2;

    if (!{reset}) begin
"""

for i, target in enumerate(fault_targets):
    tb += f"      if (fault_en[{i}]) DUT_FAULTY.{target} = ~DUT_FAULTY.{target};\n"

tb += """    end
  end
`endif

"""

checks = []

for o in outputs:
    checks.append(f"        ({o}_g !== {o}_f)")

if state_reg:
    checks.append("        (st_g !== st_f)")

check_expr = " ||\n".join(checks)

tb += f"""  ////////////////////////////////////////////////////////////
  // Mismatch tracker
  ////////////////////////////////////////////////////////////

  always @(posedge {clock}) begin
    #0.5;

    if (
{check_expr}
    ) begin
      if (!first_mismatch_seen) begin
        $display("***** FIRST MISMATCH at cycle %0d *****", cycle_count);
        first_mismatch_seen <= 1;
      end
    end
  end

"""

# ------------------------------------------------------------
# Drive task
# ------------------------------------------------------------

tb += """  ////////////////////////////////////////////////////////////
  // Drive Task
  ////////////////////////////////////////////////////////////

  task drive;
    input r;
"""

for inp in stim_inputs:
    tb += f"    input {inp}_in;\n"

tb += "  begin\n"
tb += f"    @(negedge {clock});\n"
tb += f"    {reset} = r;\n"

for inp in stim_inputs:
    tb += f"    {inp} = {inp}_in;\n"

tb += f"""
    @(posedge {clock});
    #1;

"""

if state_reg and use_gl_decode:
    tb += f"""`ifdef GL
    $display("CYCLE=%0d | rst=%0b"""

    for inp in stim_inputs:
        tb += f" {inp}=%0b"

    tb += f" fe=%0{final_fault_width}b | "

    for o in outputs:
        tb += f"G:{o}=%0b F:{o}=%0b "

    tb += f"""G:st_dec=%0d F:st_dec=%0d G:raw=%0{gl_state_width}b F:raw=%0{gl_state_width}b %s",
      cycle_count, reset,"""

    for inp in stim_inputs:
        tb += f" {inp},"

    tb += " fault_en,"

    for o in outputs:
        tb += f" {o}_g, {o}_f,"

    tb += f""" st_g_decoded, st_f_decoded, st_g, st_f,
      (
{check_expr}
      ) ? "<-- MISMATCH" : " "
    );
`else
    $display("CYCLE=%0d | rst=%0b"""

    for inp in stim_inputs:
        tb += f" {inp}=%0b"

    tb += f" fe=%0{final_fault_width}b | "

    for o in outputs:
        tb += f"G:{o}=%0b F:{o}=%0b "

    tb += """G:st=%0d F:st=%0d %s",
      cycle_count, reset,"""

    for inp in stim_inputs:
        tb += f" {inp},"

    tb += " fault_en,"

    for o in outputs:
        tb += f" {o}_g, {o}_f,"

    tb += f""" st_g, st_f,
      (
{check_expr}
      ) ? "<-- MISMATCH" : " "
    );
`endif
"""
else:
    tb += f"""    $display("CYCLE=%0d | rst=%0b"""

    for inp in stim_inputs:
        tb += f" {inp}=%0b"

    tb += f" fe=%0{final_fault_width}b | "

    for o in outputs:
        tb += f"G:{o}=%0b F:{o}=%0b "

    if state_reg:
        tb += "G:st=%0d F:st=%0d "

    tb += """%s",
      cycle_count, reset,"""

    for inp in stim_inputs:
        tb += f" {inp},"

    tb += " fault_en,"

    for o in outputs:
        tb += f" {o}_g, {o}_f,"

    if state_reg:
        tb += " st_g, st_f,"

    tb += f"""
      (
{check_expr}
      ) ? "<-- MISMATCH" : " "
    );
"""

tb += """  end
  endtask

"""

tb += f"""  ////////////////////////////////////////////////////////////
  // Stimulus
  ////////////////////////////////////////////////////////////

  integer i;

  initial begin

`ifdef RTL
    $dumpfile("{module}_rtl_original_compare.vcd");
`elsif GL
    $dumpfile("{module}_gl_faulty_compare.vcd");
`endif

    $dumpvars(0, {tb_name});

    drive(1"""

for inp in stim_inputs:
    tb += ", 0"

tb += ");\n"

tb += "    drive(1"
for inp in stim_inputs:
    tb += ", 0"
tb += ");\n"

tb += "    drive(0"
for inp in stim_inputs:
    tb += ", 0"
tb += ");\n\n"

tb += "    for (i = 0; i < 50; i = i + 1) begin\n"
tb += "      drive(0"

for inp in stim_inputs:
    tb += ", $random"

tb += """);
    end

    $display("Stimulus completed.");
    $finish;
  end

endmodule
"""

out_file.write_text(tb)

print(f"Generated {out_file}")
print(f"Top module: {tb_name}")
print(f"Fault width: {final_fault_width}")
print("RTL fault targets:")

for i, target in enumerate(fault_targets):
    print(f"  fault_en[{i}] -> {target}")

if gl_text and gl_state_bits:
    print("GL fault targets:")
    print(f"  fault_en[0] -> {outputs[0]}")
    for i in gl_state_bits:
        print(f"  fault_en[{i+1}] -> stato[{i}]")