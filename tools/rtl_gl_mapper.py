#!/usr/bin/env python3
import re
import sys
from collections import OrderedDict
from pathlib import Path

DECL_RE = re.compile(r'\b(?P<kind>input|output|reg)\b(?P<body>[^;]*);', re.S)
FF_RE = re.compile(r'(?P<cell>sky130_fd_sc_hd__df[rs]tp_\d+)\s+(?P<inst>\S+)\s*\((?P<ports>.*?)\)\s*;', re.S)
PORT_RE = re.compile(r'\.(\w+)\s*\(\s*(.*?)\s*\)', re.S)

def strip_comments(text):
    text = re.sub(r'/\*.*?\*/', '', text, flags=re.S)
    return re.sub(r'//.*', '', text)

def width_size(width):
    if not width:
        return 1
    nums = [int(x) for x in re.findall(r'\d+', width)]
    return abs(nums[0] - nums[1]) + 1

def parse_rtl_storage(text):
    clean = strip_comments(text)
    items = OrderedDict()
    output_regs = set()
    for m in DECL_RE.finditer(clean):
        kind, body = m.group('kind'), m.group('body').strip()
        is_reg_output = kind == 'output' and re.search(r'\breg\b', body)
        body = re.sub(r'\b(?:wire|reg|signed|logic)\b', ' ', body)
        wm = re.search(r'(\[[^\]]+\])', body)
        width = wm.group(1) if wm else ''
        if wm:
            body = body.replace(width, ' ')
        names = [re.sub(r'=.*$', '', p).strip() for p in body.split(',')]
        names = [n for n in names if re.fullmatch(r'[A-Za-z_]\w*', n)]
        if is_reg_output:
            for name in names:
                items.setdefault(name, width_size(width))
                output_regs.add(name)
        elif kind == 'reg':
            for name in names:
                if name not in output_regs:
                    items.setdefault(name, width_size(width))
    return items

def clean_signal(sig):
    return sig.replace('\\', '').strip()

def split_q(q):
    q = clean_signal(q)
    m = re.fullmatch(r'(\w+)\[(\d+)\]', q)
    return (m.group(1), int(m.group(2))) if m else (q, 0)

def parse_ffs(text):
    ffs = []
    for m in FF_RE.finditer(text):
        ports = {p: s.strip() for p, s in PORT_RE.findall(m.group('ports'))}
        q = ports.get('Q')
        if not q:
            continue
        reg, bit = split_q(q)
        ffs.append({
            'cell': m.group('cell'),
            'instance': m.group('inst'),
            'ports': ports,
            'reg': reg,
            'bit': bit,
        })
    return ffs

def main():
    if len(sys.argv) != 4:
        print('Usage: python3 rtl_gl_mapper.py rtl.v gl.v mapping.txt')
        raise SystemExit(1)

    rtl_path, gl_path, map_path = map(Path, sys.argv[1:])
    rtl_regs = parse_rtl_storage(rtl_path.read_text())
    ffs = parse_ffs(gl_path.read_text())
    rtl_bits = {(r, b) for r, w in rtl_regs.items() for b in range(w)}

    with map_path.open('w') as f:
        f.write('# index logical_name bit instance cell origin\n')
        for idx, ff in enumerate(ffs):
            origin = 'RTL' if (ff['reg'], ff['bit']) in rtl_bits else 'GL_ONLY'
            f.write(f"{idx} {ff['reg']} {ff['bit']} {ff['instance']} {ff['cell']} {origin}\n")

    report = map_path.with_name(map_path.stem + '_report.txt')
    with report.open('w') as f:
        f.write('RTL → Gate-Level Bit-Level Mapping\n')
        f.write('==================================\n\n')
        f.write(f'RTL storage bits: {sum(rtl_regs.values())}\n')
        f.write(f'Gate-level flip-flops: {len(ffs)}\n')
        f.write(f'GL-only synthesized bits: {sum((x["reg"], x["bit"]) not in rtl_bits for x in ffs)}\n\n')
        f.write('RTL Registers Found:\n')
        for r, w in rtl_regs.items():
            f.write(f'   {r} ({w} bits)\n')
        f.write('\nFault-enable Mapping:\n')
        for idx, ff in enumerate(ffs):
            origin = 'RTL' if (ff['reg'], ff['bit']) in rtl_bits else 'GL_ONLY'
            f.write(f"   fault_en[{idx}] -> {ff['instance']} -> {ff['reg']}[{ff['bit']}] ({origin})\n")
        f.write('\nDetailed Flip-Flop Information\n')
        f.write('--------------------------------\n\n')
        for idx, ff in enumerate(ffs):
            origin = 'RTL' if (ff['reg'], ff['bit']) in rtl_bits else 'GL_ONLY'
            f.write(f"fault_en[{idx}] {ff['reg']}[{ff['bit']}] -> {ff['instance']} ({ff['cell']}, {origin})\n")
            for p, s in ff['ports'].items():
                f.write(f'    .{p}({s})\n')
            f.write('\n')

    print(f'RTL storage bits: {sum(rtl_regs.values())}')
    print(f'Gate-level flip-flops: {len(ffs)}')
    print(f'Generated {map_path}')
    print(f'Generated {report}')

if __name__ == '__main__':
    main()