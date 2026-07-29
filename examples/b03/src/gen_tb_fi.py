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

# Select a safe default fault target. For B02 this matches the reference
# testbench: inject stato[0] unless FI_MASK is overridden at compile time.
if gl_text and gl_state_bits and module == "b02":
    default_fault_macro = "FI_STATO_0"
elif len(fault_targets) > 1:
    default_fault_macro = f"FI_{clean_fault_name(fault_targets[1])}"
else:
    default_fault_macro = f"FI_{clean_fault_name(fault_targets[0])}"

tb += f"""
  `ifndef FI_MASK
  `define FI_MASK {default_fault_macro}
  `endif

  localparam integer INJECT_CYCLE = 30;
  localparam [{final_fault_width-1}:0] INJECT_MASK = `FI_MASK;

  ////////////////////////////////////////////////////////////
  // Report selected mask
  ////////////////////////////////////////////////////////////

  initial begin
    $display("INJECT_CYCLE=%0d", INJECT_CYCLE);
    $display("INJECT_MASK=%0{final_fault_width}b", INJECT_MASK);
  end

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
        print(f"  fault_en[{i+1}] -> stato[{i}]")#!/usr/bin/env python3
import re
import sys
from pathlib import Path


def width_from_range(rng):
    if not rng:
        return 1
    a, b = map(int, re.findall(r"\d+", rng)[:2])
    return abs(a-b)+1


def parse_decls(text, kind):
    # Supports: input a; output reg [3:0] x; reg ru1, ru2, ru3;
    pat = re.compile(rf"\b{kind}\b\s*(?:wire\s+|reg\s+)?(\[[^\]]+\])?\s*([^;]+);", re.M)
    out = {}
    for rng, names in pat.findall(text):
        w = width_from_range(rng)
        for raw in names.split(','):
            name = raw.strip().split('=')[0].strip()
            if re.fullmatch(r"[A-Za-z_]\w*", name):
                out[name] = w
    return out


def macro_name(logical, bit):
    return f"FI_{logical.upper()}_{bit}"


def rtl_expr(prefix, logical, bit, widths):
    if widths.get(logical, 1) == 1:
        return f"{prefix}.{logical}"
    return f"{prefix}.{logical}[{bit}]"


def gl_hier_expr(prefix, qsignal):
    qsignal = qsignal.strip()
    if qsignal.startswith('\\'):
        # Escaped identifiers require whitespace termination.
        return f"{prefix}.{qsignal} "
    return f"{prefix}.{qsignal}"


def main():
    if len(sys.argv) != 3:
        print("Usage: python3 gen_tb_fi.py <rtl.v> <gl_faulty.v>")
        return 1

    rtl_path = Path(sys.argv[1])
    gl_path = Path(sys.argv[2])
    rtl = rtl_path.read_text()
    gl = gl_path.read_text()

    mm = re.search(r"\bmodule\s+(\w+)\s*\((.*?)\)\s*;", rtl, re.S)
    if not mm:
        raise RuntimeError("Could not find RTL module declaration")
    module = mm.group(1)
    ports = [x.strip() for x in mm.group(2).replace('\n',' ').split(',') if x.strip()]

    inputs = parse_decls(rtl, 'input')
    outputs = parse_decls(rtl, 'output')
    regs = parse_decls(rtl, 'reg')
    widths = {**outputs, **regs}

    clock = 'clock' if 'clock' in inputs else 'clk'
    reset = 'reset' if 'reset' in inputs else 'rst'
    stim_inputs = [p for p in ports if p in inputs and p not in (clock, reset)]

    # Canonical mapping comes from the rewriter banner.
    map_re = re.compile(
        r"^//\s*fault_en\[(\d+)\]\s*->\s*(\S+)\s*->\s*"
        r"([A-Za-z_]\w*)\[(\d+)\]\s*\((RTL|GL_ONLY)\)\s*$", re.M)
    mapping = []
    for idx, inst, logical, bit, origin in map_re.findall(gl):
        mapping.append({
            'idx': int(idx), 'inst': inst, 'logical': logical,
            'bit': int(bit), 'origin': origin
        })
    mapping.sort(key=lambda x: x['idx'])
    if not mapping:
        raise RuntimeError("No // fault_en[index] -> instance -> logical[bit] mapping banner found")
    if [x['idx'] for x in mapping] != list(range(len(mapping))):
        raise RuntimeError("Fault mapping indices are not contiguous from zero")

    # Get the actual Q signal for every mapped GL DFF.
    for item in mapping:
        inst = re.escape(item['inst'])
        bm = re.search(rf"\b(?:FI_DFF_\w+|sky130_fd_sc_hd__df\w+)\s+{inst}\s*\((.*?)\);", gl, re.S)
        if not bm:
            raise RuntimeError(f"Could not find mapped instance {item['inst']} in GL netlist")
        qm = re.search(r"\.Q\s*\(\s*([^\)]+?)\s*\)", bm.group(1), re.S)
        if not qm:
            raise RuntimeError(f"Could not find .Q() for {item['inst']}")
        item['q'] = qm.group(1).strip()

    fw = len(mapping)
    rtl_count = sum(x['origin'] == 'RTL' for x in mapping)
    state_rtl_width = widths.get('stato', 1)
    gl_state_items = [x for x in mapping if x['logical'] == 'stato']
    gl_state_width = max((x['bit'] for x in gl_state_items), default=state_rtl_width-1)+1

    def conns(suffix, gl_mode):
        lines=[]
        for p in ports:
            if p in outputs:
                lines.append(f"    .{p}({p}_{suffix})")
            else:
                lines.append(f"    .{p}({p})")
        if gl_mode:
            lines.append(f"    .fault_en({fw}'b0)" if suffix == 'g' else "    .fault_en(fault_en)")
        return ',\n'.join(lines)

    tb=[]
    A=tb.append
    A('`timescale 1ns/1ps\n')
    A(f'module tb_{module}_fi;\n')
    A(f'  reg {clock} = 0;\n  always #5 {clock} = ~{clock};\n')
    A(f'  reg {reset} = 0;')
    for p in stim_inputs: A(f'  reg {p} = 0;')
    A(f"  reg [{fw-1}:0] fault_en = {fw}'b0;\n")

    for p,w in outputs.items():
        rng = '' if w == 1 else f'[{w-1}:0] '
        A(f'  wire {rng}{p}_g, {p}_f;')
    A('')
    A('`ifdef RTL')
    A(f'  wire [{state_rtl_width-1}:0] st_g, st_f;')
    A('`elsif GL')
    A(f'  wire [{gl_state_width-1}:0] st_g, st_f;')
    A('`endif')
    A(f'  wire [{fw-1}:0] mapped_regs_g, mapped_regs_f;\n')

    A('`ifdef RTL')
    A(f'  {module} DUT_GOLDEN (\n{conns("g", False)}\n  );')
    A(f'  {module} DUT_FAULTY (\n{conns("f", False)}\n  );')
    A('`elsif GL')
    A(f'  {module} DUT_GOLDEN (\n{conns("g", True)}\n  );')
    A(f'  {module} DUT_FAULTY (\n{conns("f", True)}\n  );')
    A('`else\n  initial begin $display("ERROR: Compile with -DRTL or -DGL"); $finish; end\n`endif\n')

    # State and all-register visibility.
    A('`ifdef RTL')
    A('  assign st_g = DUT_GOLDEN.stato;')
    A('  assign st_f = DUT_FAULTY.stato;')
    for x in mapping:
        if x['origin'] == 'RTL':
            A(f"  assign mapped_regs_g[{x['idx']}] = {rtl_expr('DUT_GOLDEN', x['logical'], x['bit'], widths)};")
            A(f"  assign mapped_regs_f[{x['idx']}] = {rtl_expr('DUT_FAULTY', x['logical'], x['bit'], widths)};")
        else:
            A(f"  assign mapped_regs_g[{x['idx']}] = 1'b0; // GL_ONLY")
            A(f"  assign mapped_regs_f[{x['idx']}] = 1'b0; // GL_ONLY")
    A('`elsif GL')
    state_g = ', '.join(gl_hier_expr('DUT_GOLDEN', x['q']) for x in sorted(gl_state_items, key=lambda z:z['bit'], reverse=True))
    state_f = ', '.join(gl_hier_expr('DUT_FAULTY', x['q']) for x in sorted(gl_state_items, key=lambda z:z['bit'], reverse=True))
    A(f'  assign st_g = {{{state_g}}};')
    A(f'  assign st_f = {{{state_f}}};')
    for x in mapping:
        A(f"  assign mapped_regs_g[{x['idx']}] = {gl_hier_expr('DUT_GOLDEN', x['q'])};")
        A(f"  assign mapped_regs_f[{x['idx']}] = {gl_hier_expr('DUT_FAULTY', x['q'])};")
    A('`endif\n')

    A('  ////////////////////////////////////////////////////////////')
    A('  // Complete canonical fault target mapping')
    A('  ////////////////////////////////////////////////////////////')
    for x in mapping:
        A(f"  // fault_en[{x['idx']}] = {x['logical']}[{x['bit']}] ({x['origin']}) -> {x['inst']}")
    A('')
    for x in mapping:
        val = 1 << x['idx']
        A(f"  localparam [{fw-1}:0] {macro_name(x['logical'],x['bit'])} = {fw}'b{val:0{fw}b};")
    rtl_mask = sum(1 << x['idx'] for x in mapping if x['origin']=='RTL')
    A(f"  localparam [{fw-1}:0] FI_ALL_RTL_MAPPED = {fw}'b{rtl_mask:0{fw}b};")
    A(f"  localparam [{fw-1}:0] FI_ALL_GL = {{{fw}{{1'b1}}}};")
    A(f"  localparam [{fw-1}:0] FI_NONE = {fw}'b0;\n")

    default = next((macro_name(x['logical'],x['bit']) for x in mapping if x['origin']=='RTL'), 'FI_NONE')
    A('  `ifndef FI_MASK')
    A(f'  `define FI_MASK {default}')
    A('  `endif')
    A('  `ifndef INJECT_CYCLE')
    A('  `define INJECT_CYCLE 30')
    A('  `endif')
    A('  localparam integer INJECT_AT = `INJECT_CYCLE;')
    A(f'  localparam [{fw-1}:0] INJECT_MASK = `FI_MASK;\n')

    A('  initial begin')
    A('    $display("INJECT_CYCLE=%0d", INJECT_AT);')
    A(f'    $display("INJECT_MASK=%0{fw}b", INJECT_MASK);')
    A('`ifdef RTL')
    gl_only_mask = sum(1 << x['idx'] for x in mapping if x['origin']=='GL_ONLY')
    A(f"    if ((INJECT_MASK & {fw}'b{gl_only_mask:0{fw}b}) != {fw}'b0)")
    A('      $display("WARNING: GL_ONLY target bits are ignored in RTL mode");')
    A('`endif')
    A('  end\n')

    A('  integer cycle_count = 0;')
    A('  integer post_cycles = 0;')
    A('  reg injection_seen = 0;')
    A('  reg first_mismatch_seen = 0;')
    A(f'  always @(posedge {clock}) begin')
    A('    cycle_count <= cycle_count + 1;')
    A(f"    if (fault_en != {fw}'b0) injection_seen <= 1;")
    A('    if (injection_seen) post_cycles <= post_cycles + 1;')
    A('    if (post_cycles == 20) begin $display("20 cycles post injection complete."); $finish; end')
    A('  end\n')
    A(f'  always @(negedge {clock}) begin')
    A('    if (cycle_count == INJECT_AT) fault_en <= INJECT_MASK;')
    A(f"    else fault_en <= {fw}'b0;")
    A('  end\n')

    A('`ifdef RTL')
    A(f'  always @(posedge {clock}) begin')
    A('    #0.2;')
    A(f'    if (!{reset}) begin')
    for x in mapping:
        if x['origin']=='RTL':
            expr=rtl_expr('DUT_FAULTY',x['logical'],x['bit'],widths)
            A(f"      if (fault_en[{x['idx']}]) {expr} = ~{expr};")
    A('    end')
    A('  end')
    A('`endif\n')

    A(f'  always @(posedge {clock}) begin')
    A('    #0.5;')
    A('    if (mapped_regs_g !== mapped_regs_f) begin')
    A('      if (!first_mismatch_seen) begin')
    A('        $display("***** FIRST MISMATCH at cycle %0d *****", cycle_count);')
    A('        first_mismatch_seen <= 1;')
    A('      end')
    A('    end')
    A('  end\n')

    A('  task drive;')
    A('    input r;')
    for p in stim_inputs: A(f'    input {p}_in;')
    A('  begin')
    A(f'    @(negedge {clock});')
    A(f'    {reset} = r;')
    for p in stim_inputs: A(f'    {p} = {p}_in;')
    A(f'    @(posedge {clock}); #1;')
    fmt_inputs=' '.join(f'{p}=%0b' for p in stim_inputs)
    args_inputs=', '.join(stim_inputs)
    outfmt=' '.join(f'G:{p}=%0h F:{p}=%0h' for p in outputs)
    outargs=', '.join(v for p in outputs for v in (f'{p}_g',f'{p}_f'))
    A(f'    $display("CYCLE=%0d | rst=%0b {fmt_inputs} fe=%0{fw}b | {outfmt} G:st=%0h F:st=%0h G:regs=%0{fw}b F:regs=%0{fw}b %s",')
    args=['cycle_count',reset]+stim_inputs+['fault_en']+[v for p in outputs for v in (f'{p}_g',f'{p}_f')]+['st_g','st_f','mapped_regs_g','mapped_regs_f','(mapped_regs_g !== mapped_regs_f) ? "<-- MISMATCH" : " "']
    A('      '+', '.join(args)+');')
    A('  end')
    A('  endtask\n')

    A('  integer i;')
    A('  initial begin')
    A('`ifdef RTL')
    A(f'    $dumpfile("{module}_rtl_original_compare.vcd");')
    A('`elsif GL')
    A(f'    $dumpfile("{module}_gl_faulty_compare.vcd");')
    A('`endif')
    A(f'    $dumpvars(0, tb_{module}_fi);')
    zeros=', '.join(['0']*(1+len(stim_inputs)))
    A(f'    drive({zeros});')
    A(f'    drive({zeros});')
    A(f'    drive({zeros});')
    randargs=', '.join(['0']+['$random']*len(stim_inputs))
    A(f'    for (i=0; i<50; i=i+1) drive({randargs});')
    A('    $display("Stimulus completed.");')
    A('    $finish;')
    A('  end')
    A('endmodule')

    out=Path(f'tb_{module}_fi.v')
    out.write_text('\n'.join(tb)+'\n')
    print(f'Generated {out}')
    print(f'Canonical GL fault targets: {fw}')
    print(f'RTL-mapped fault targets: {rtl_count}')
    print(f'GL-only fault targets: {fw-rtl_count}')
    for x in mapping:
        print(f"  fault_en[{x['idx']}] -> {x['logical']}[{x['bit']}] ({x['origin']})")
    return 0


if __name__ == '__main__':
    raise SystemExit(main())