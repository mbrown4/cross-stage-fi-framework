#!/usr/bin/env python3
import re
import sys
from pathlib import Path

def width_from_range(rng):
    if not rng:
        return 1
    a, b = map(int, re.findall(r"\d+", rng)[:2])
    return abs(a-b)+1


def parse_decls(text, kind):
    pattern = re.compile(
        rf"\b{kind}\b\s+"
        rf"(?P<storage>(?:wire|reg|logic)\s+)?"
        rf"(?P<signed>signed\s+)?"
        rf"(?P<width>\[[^\]]+\]\s+)?"
        rf"(?P<names>[^;]+);",
        re.M,
    )

    result = {}
    for match in pattern.finditer(text):
        width_text = match.group("width").strip() if match.group("width") else ""
        width_n = width_from_range(width_text)
        signed = bool(match.group("signed"))

        for raw_name in match.group("names").split(","):
            name = raw_name.strip().split("=")[0].strip()
            if re.fullmatch(r"[A-Za-z_]\w*", name):
                result[name] = {
                    "width": width_n,
                    "range": width_text,
                    "signed": signed,
                }
    return result


def find_port_case_insensitive(names, candidates):
    for candidate in candidates:
        for name in names:
            if name.lower() == candidate.lower():
                return name
    return None

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
    widths = {name: info['width'] for name, info in {**outputs, **regs}.items()}

    clock = find_port_case_insensitive(inputs, ['clock', 'clk'])
    reset = find_port_case_insensitive(inputs, ['reset', 'rst'])
    if clock is None:
        raise RuntimeError(f'Could not identify clock input from: {list(inputs)}')
    if reset is None:
        raise RuntimeError(f'Could not identify reset input from: {list(inputs)}')
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
    state_rtl_width = widths.get('STATO', 1)
    gl_state_items = [x for x in mapping if x['logical'] == 'STATO']
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
    for p in stim_inputs:
        info = inputs[p]
        signed = 'signed ' if info['signed'] else ''
        rng = f"{info['range']} " if info['range'] else ''
        A(f'  reg {signed}{rng}{p} = 0;')
    A(f"  reg [{fw-1}:0] fault_en = {fw}'b0;\n")

    for p, info in outputs.items():
        signed = 'signed ' if info['signed'] else ''
        rng = f"{info['range']} " if info['range'] else ''
        A(f'  wire {signed}{rng}{p}_g, {p}_f;')
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
    A('  assign st_g = DUT_GOLDEN.STATO;')
    A('  assign st_f = DUT_FAULTY.STATO;')
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
    reset_args_1 = ', '.join(['1'] + ['0']*len(stim_inputs))
    reset_args_0 = ', '.join(['0'] + ['0']*len(stim_inputs))
    A(f'    drive({reset_args_1});')
    A(f'    drive({reset_args_1});')
    A(f'    drive({reset_args_0});')
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