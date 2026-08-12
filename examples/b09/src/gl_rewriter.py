#!/usr/bin/env python3
import argparse
import re
from pathlib import Path

FF_RE_TEMPLATE = (
    r'(?P<indent>^[ \t]*)'
    r'(?P<cell>sky130_fd_sc_hd__df[rs]tp_\d+)\s+'
    r'(?P<inst>{inst})\s*'
    r'\((?P<ports>.*?)\)\s*;\s*'
)
PORT_RE = re.compile(r'\.(\w+)\s*\(\s*(.*?)\s*\)', re.S)
MODULE_RE = re.compile(
    r'(?P<head>module\s+(?P<name>\w+)\s*\()(?P<ports>.*?)(?P<tail>\)\s*;)',
    re.S,
)

def fix_signal(sig):
    if sig is None:
        return None
    sig = sig.strip()
    if sig.startswith('\\') and not sig.endswith(' '):
        sig += ' '
    return sig

def parse_ports(blob):
    return {p: fix_signal(s) for p, s in PORT_RE.findall(blob)}

def load_mapping(path):
    entries = []
    for line in Path(path).read_text().splitlines():
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        parts = line.split()
        if len(parts) < 4:
            raise RuntimeError(f'Bad mapping line: {line}')
        idx, name, bit, inst = int(parts[0]), parts[1], int(parts[2]), parts[3]
        cell = parts[4] if len(parts) > 4 else ''
        origin = parts[5] if len(parts) > 5 else 'RTL'
        entries.append((idx, name, bit, inst, cell, origin))
    entries.sort(key=lambda x: x[0])
    if [x[0] for x in entries] != list(range(len(entries))):
        raise RuntimeError('Mapping indices must be contiguous from zero')
    return entries

def add_fault_port(text, width):
    m = MODULE_RE.search(text)
    if not m:
        raise RuntimeError('Could not find module header')
    ports = m.group('ports').strip()
    if not re.search(r'\bfault_en\b', ports):
        new_ports = ports + ('' if ports.endswith(',') else ',') + ' fault_en'
        text = text[:m.start('ports')] + new_ports + text[m.end('ports'):]
    m = MODULE_RE.search(text)
    insert = m.end()
    text = text[:insert] + f'\n  input [{width-1}:0] fault_en;' + text[insert:]
    return text

def rewrite(text, entries):
    replacements = 0
    for idx, name, bit, inst, expected_cell, origin in entries:
        pattern = re.compile(
            FF_RE_TEMPLATE.format(inst=re.escape(inst)),
            re.S | re.M,
        )
        m = pattern.search(text)
        if not m:
            raise RuntimeError(f'Could not find mapped flip-flop {inst}')
        cell = m.group('cell')
        p = parse_ports(m.group('ports'))
        clk, d, q = p.get('CLK'), p.get('D'), p.get('Q')
        indent = m.group('indent')
        if '__dfrtp_' in cell:
            ctrl = p.get('RESET_B')
            if not all([clk, d, q, ctrl]):
                raise RuntimeError(f'{inst} missing CLK/D/Q/RESET_B')
            repl = (
                f'{indent}FI_DFF_DFRTP_FAULTY {inst} (\n'
                f'{indent}  .CLK({clk}),\n'
                f'{indent}  .D({d}),\n'
                f'{indent}  .RESET_B({ctrl}),\n'
                f'{indent}  .fault_en(fault_en[{idx}]),\n'
                f'{indent}  .Q({q})\n'
                f'{indent});\n'
            )
        elif '__dfstp_' in cell:
            ctrl = p.get('SET_B')
            if not all([clk, d, q, ctrl]):
                raise RuntimeError(f'{inst} missing CLK/D/Q/SET_B')
            repl = (
                f'{indent}FI_DFF_DFSTP_FAULTY {inst} (\n'
                f'{indent}  .CLK({clk}),\n'
                f'{indent}  .D({d}),\n'
                f'{indent}  .SET_B({ctrl}),\n'
                f'{indent}  .fault_en(fault_en[{idx}]),\n'
                f'{indent}  .Q({q})\n'
                f'{indent});\n'
            )
        else:
            raise RuntimeError(f'Unsupported mapped cell {cell}')
        text = text[:m.start()] + repl + text[m.end():]
        replacements += 1

    text = add_fault_port(text, len(entries))
    banner = ['// Auto-generated mapped fault enables:']
    for idx, name, bit, inst, cell, origin in entries:
        banner.append(f'//   fault_en[{idx}] -> {inst} -> {name}[{bit}] ({origin})')
    return '\n'.join(banner) + '\n\n' + text, replacements

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('mapping', nargs='?', default='mapping.txt')
    ap.add_argument('netlist_in', nargs='?', default='b09_gl.v')
    ap.add_argument('netlist_out', nargs='?', default='b09_gl_faulty.v')
    args = ap.parse_args()

    entries = load_mapping(args.mapping)
    text, count = rewrite(Path(args.netlist_in).read_text(), entries)
    Path(args.netlist_out).write_text(text)
    print(f'Wrote: {args.netlist_out}')
    print(f'Fault width: {len(entries)}')
    print(f'Replaced {count} DFF instance(s)')

if __name__ == '__main__':
    main()