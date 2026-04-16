import re
import sys
from collections import defaultdict


############################################################
# RTL ANALYZER
############################################################

class RTLAnalyzer:

    def __init__(self, filename):

        self.text = open(filename).read()
        self.registers = {}

        self.extract_registers()

    def extract_registers(self):

        # Match registers with optional width
        pattern = r"reg\s*(\[[^\]]+\])?\s*(\w+)"

        matches = re.findall(pattern, self.text)

        for width, name in matches:

            if width:
                msb, lsb = re.findall(r"\d+", width)
                msb = int(msb)
                lsb = int(lsb)
                size = abs(msb - lsb) + 1
            else:
                size = 1

            self.registers[name] = size


############################################################
# GATE-LEVEL ANALYZER
############################################################

class GLAnalyzer:

    def __init__(self, filename):

        self.text = open(filename).read()
        self.flipflops = []

        self.extract_flipflops()

    def extract_flipflops(self):

        # Match flip-flop cells (dfrtp, dfstp, etc.)
        ff_pattern = r"(sky130_fd_sc_hd__df\w+_\d+)\s+(\S+)\s*\((.*?)\);"

        matches = re.findall(ff_pattern, self.text, re.S)

        for cell, inst, ports in matches:

            port_map = {}

            port_pattern = r"\.(\w+)\((.*?)\)"

            for p, s in re.findall(port_pattern, ports):
                port_map[p] = s.strip()

            self.flipflops.append({
                "cell": cell,
                "instance": inst,
                "ports": port_map
            })


############################################################
# MAPPER
############################################################

class Mapper:

    def __init__(self, rtl, gl):

        self.rtl = rtl
        self.gl = gl

        self.mapping = defaultdict(dict)

        self.build_mapping()

    def build_mapping(self):

        for ff in self.gl.flipflops:

            q_signal = ff["ports"].get("Q")

            if not q_signal:
                continue

            # Remove escape characters like \stato[0]
            q_signal = q_signal.replace("\\", "").strip()

            # Detect indexed register (e.g., stato[1])
            match = re.match(r"(\w+)\[(\d+)\]", q_signal)

            if match:
                reg = match.group(1)
                bit = int(match.group(2))
            else:
                reg = q_signal
                bit = 0

            # Only map if it exists in RTL
            if reg in self.rtl.registers:
                if bit in self.mapping[reg]:
                    print(f"Duplicate detected: {reg}[{bit}] -> {ff['instance']}")
                else:
                    self.mapping[reg][bit] = ff


    ########################################################
    # WRITE OUTPUT FILES
    ########################################################

    def write_outputs(self, base_filename):

        ####################################################
        # 1. CLEAN FILE (for Verilog simulation)
        ####################################################
        clean_file = base_filename

        with open(clean_file, "w") as f:

            for reg in self.mapping:
                for bit in sorted(self.mapping[reg]):
                    ff = self.mapping[reg][bit]
                    f.write(f"{reg} {bit} {ff['instance']}\n")

        ####################################################
        # 2. FULL REPORT (for documentation)
        ####################################################
        report_file = base_filename.replace(".txt", "_report.txt")

        with open(report_file, "w") as f:

            f.write("RTL → Gate-Level Bit-Level Mapping\n")
            f.write("==================================\n\n")

            # RTL Registers
            f.write("RTL Registers Found:\n")
            for r, size in self.rtl.registers.items():
                f.write(f"   {r} ({size} bits)\n")

            # GL Flip-Flops
            f.write("\nGate-Level Flip-Flops Found:\n")
            for ff in self.gl.flipflops:
                f.write(f"   {ff['instance']} ( {ff['cell']} )\n")

            f.write("\n\n")

            # Mapping Summary
            for reg in self.mapping:
                f.write(f"{reg}:\n")
                for bit in sorted(self.mapping[reg]):
                    ff = self.mapping[reg][bit]
                    f.write(f"   bit[{bit}] -> {ff['instance']}\n")
                f.write("\n")

            # Detailed Section
            f.write("Detailed Flip-Flop Information\n")
            f.write("--------------------------------\n\n")

            for reg in self.mapping:
                for bit in sorted(self.mapping[reg]):
                    ff = self.mapping[reg][bit]

                    f.write(f"{reg}[{bit}] -> {ff['instance']} ({ff['cell']})\n")

                    for p, s in ff["ports"].items():
                        f.write(f"    .{p}({s})\n")

                    f.write("\n")


############################################################
# MAIN
############################################################

def main():

    if len(sys.argv) != 4:
        print("Usage:")
        print("python rtl_gl_mapper.py rtl.v gl.v mapping.txt")
        sys.exit(1)

    rtl_file = sys.argv[1]
    gl_file = sys.argv[2]
    out_file = sys.argv[3]

    rtl = RTLAnalyzer(rtl_file)
    gl = GLAnalyzer(gl_file)

    mapper = Mapper(rtl, gl)

    mapper.write_outputs(out_file)

    print("Files generated:")
    print(" -", out_file)
    print(" -", out_file.replace(".txt", "_report.txt"))


if __name__ == "__main__":
    main()