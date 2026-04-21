#!/usr/bin/env python3
import re
from pathlib import Path

MAPPING_FILE = "mapping.txt"
NETLIST_IN   = "b02_gl.v"
NETLIST_OUT  = "b02_gl_faulty.v"

DFF_RE = re.compile(
    r'(?P<indent>^[ \t]*)'
    r'(?P<cell>sky130_fd_sc_hd__dfrtp_\d+)\s+'
    r'(?P<inst>[_A-Za-z0-9\\\[\]\.]+)\s*'
    r'\((?P<ports>.*?)\)\s*;\s*',
    re.S | re.M
)

MODULE_RE = re.compile(
    r'(?P<head>module\s+(?P<name>\w+)\s*\()(?P<ports>.*?)(?P<tail>\);\s*)',
    re.S
)

def load_mapping(mapping_path):
    entries = []
    with open(mapping_path, "r") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            parts = line.split()
            if len(parts) != 3:
                continue
            rtl_name, bit, inst = parts
            entries.append((rtl_name, int(bit), inst))
    return entries

def fix_signal(sig):
    if sig is None:
        return None
    sig = sig.strip()
    if sig.startswith("\\"):
        sig += " "
    return sig

def parse_ports(port_blob):
    ports = {}
    for m in re.finditer(r'\.(\w+)\s*\(\s*(.*?)\)', port_blob, re.S):
        ports[m.group(1)] = fix_signal(m.group(2))
    return ports

def add_fault_port_to_module(text, width):
    m = MODULE_RE.search(text)
    if not m:
        raise RuntimeError("Could not find module header")

    ports = m.group("ports").strip()

    if "fault_en" not in ports:
        if ports.endswith(","):
            new_ports = ports + " fault_en"
        else:
            new_ports = ports + ", fault_en"
        text = text[:m.start("ports")] + new_ports + text[m.end("ports"):]

    m = MODULE_RE.search(text)
    if not m:
        raise RuntimeError("Could not find updated module header")

    insert_point = m.end()
    decl = f"  input [{width-1}:0] fault_en;\n"
    text = text[:insert_point] + decl + text[insert_point:]

    return text

def rewrite_netlist(netlist_text, mapping_entries):
    idx_to_desc = []
    replacements = 0
    new_text = netlist_text

    for idx, (rtl_name, bit, inst) in enumerate(mapping_entries):
        idx_to_desc.append((idx, rtl_name, bit, inst))

        # Match exactly one named instance block
        inst_re = re.compile(
            rf'(?P<indent>^[ \t]*)'
            rf'(?P<cell>sky130_fd_sc_hd__dfrtp_\d+)\s+'
            rf'(?P<inst>{re.escape(inst)})\s*'
            rf'\((?P<ports>.*?)\)\s*;\s*',
            re.S | re.M
        )

        m = inst_re.search(new_text)
        if not m:
            print(f"WARNING: could not find instance {inst}")
            continue

        indent = m.group("indent")
        ports  = m.group("ports")
        p = parse_ports(ports)

        clk = fix_signal(p.get("CLK"))
        d   = fix_signal(p.get("D"))
        q   = fix_signal(p.get("Q"))
        rb  = fix_signal(p.get("RESET_B"))

        if not all([clk, d, q, rb]):
            raise RuntimeError(f"Instance {inst} missing one of CLK/D/Q/RESET_B")

        replacement = (
            f"{indent}FI_DFF_DFRTP_FAULTY {inst} (\n"
            f"{indent}  .CLK({clk}),\n"
            f"{indent}  .D({d}),\n"
            f"{indent}  .RESET_B({rb}),\n"
            f"{indent}  .fault_en(fault_en[{idx}]),\n"
            f"{indent}  .Q({q})\n"
            f"{indent});\n"
        )

        new_text = new_text[:m.start()] + replacement + new_text[m.end():]
        replacements += 1

    new_text = add_fault_port_to_module(new_text, len(mapping_entries))

    banner = ["// Auto-generated mapped fault enables:"]
    for idx, rtl_name, bit, inst in idx_to_desc:
        banner.append(f"//   fault_en[{idx}] -> {inst} -> {rtl_name}[{bit}]")
    banner.append("")

    return "\n".join(banner) + "\n" + new_text, replacements, idx_to_desc

def main():
    mapping_entries = load_mapping(MAPPING_FILE)
    if not mapping_entries:
        raise RuntimeError("No valid entries found in mapping.txt")

    netlist_text = Path(NETLIST_IN).read_text()
    new_text, replacements, idx_to_desc = rewrite_netlist(netlist_text, mapping_entries)
    Path(NETLIST_OUT).write_text(new_text)

    print(f"Wrote: {NETLIST_OUT}")
    print(f"Replaced {replacements} DFF instance(s)\n")
    print("Fault-enable map:")
    for idx, rtl_name, bit, inst in idx_to_desc:
        print(f"  fault_en[{idx}] -> {inst} -> {rtl_name}[{bit}]")

if __name__ == "__main__":
    main()