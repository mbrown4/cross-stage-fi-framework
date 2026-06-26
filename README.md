# Cross-Layer Fault Injection Framework for RISC-V

## Overview

This repository presents a unified fault injection (FI) framework for analyzing reliability across multiple abstraction levels in digital systems, with a focus on RISC-V microarchitecture. The framework enables direct comparison between Register Transfer Level (RTL) and Gate-Level (GL) implementations to study fault propagation, masking behavior, and architectural vulnerability.

The primary objective is to bridge the gap between high-level functional models and physically realized gate-level designs by systematically injecting faults into state elements and observing their impact on system outputs.
C

Traditional reliability analysis often focuses on a single abstraction level, which can lead to inaccurate estimations of system vulnerability. However, synthesis, optimization, and physical design transformations introduce structural and timing changes that significantly affect how faults propagate.

This project addresses these challenges by:
- Enabling cross-stage fault injection at RTL and Gate-Level
- Quantifying discrepancies in fault behavior between abstraction levels
- Providing a framework for Architectural Vulnerability Factor (AVF) estimation
- Supporting deterministic and randomized fault injection campaigns

---

## Key Features

- 🔁 **Cross-Layer Analysis**  
  Direct comparison between RTL and Gate-Level fault behavior

- ⚡ **DFF-Level Fault Injection**  
  Single-cycle bit-flip faults injected into flip-flops (state elements)

- 🧠 **AVF & SDC Measurement**  
  Classification of faults into masked, detected, and Silent Data Corruption (SDC)

- 🔗 **RTL ↔ GL Mapping**  
  Automated mapping of RTL registers to synthesized gate-level flip-flops

- 🛠️ **GL Netlist Rewriting**  
  Python-based tool to instrument synthesized netlists with fault injection logic

- 📊 **Deterministic & Randomized Testing**  
  Controlled stimulus for reproducibility + random campaigns for coverage

---

## Architecture

The framework consists of the following core components:

- **RTL Fault Injection Modules**  
  Custom DFF wrappers for golden and faulty behavior

- **Gate-Level Injection Engine**  
  Modified netlists with fault-enable control signals

- **Mapping Infrastructure**  
  Links architectural registers to physical flip-flops

- **Testbench Environment**  
  Dual-instance (golden vs faulty) simulation with mismatch detection

- **Analysis Pipeline**  
  Cycle-by-cycle comparison and fault classification

---

## Target Platforms

- **RISC-V Core:** PicoRV32  
- **Benchmark Circuits:** ITC-99 (e.g., b01, b08, b10)  
- **Technology:** SkyWater 130nm (sky130_fd_sc_hd)  
- **Toolchain:** OpenLane, Yosys, Icarus Verilog, GTKWave  

---

## Fault Model

- **Type:** Single Event Upset (SEU)  
- **Injection Point:** Flip-Flop outputs (DFFs)  
- **Behavior:** Single-cycle bit flip  
- **Timing:** Deterministic (e.g., cycle-specific) or randomized  

---

## Repository Structure

```bash
cross-stage-fi-framework/
│
├── examples/
│   └── b02/                         # Complete working example
│       ├── config.json
│       ├── pin_order.cfg
│       └── src/
│           ├── b02.v                # Original RTL
│           ├── b02_gl.v             # OpenLane synthesized netlist
│           ├── b02_gl_faulty.v      # Fault-instrumented GL netlist
│           ├── tb_b02_fi.v          # Generated fault injection testbench
│           ├── Makefile             # RTL/GL simulation automation
│           ├── FI_DFF.v             # Fault injection flip-flops
│           ├── mapping.txt          # RTL-to-GL register mapping
│           ├── mapping_report.txt   # Mapping summary
│           └── ...
│
├── tools/                           # Reusable framework scripts
│   ├── rtl_gl_mapper.py             # Maps RTL registers to GL flip-flops
│   ├── gl_rewriter.py               # Rewrites GL netlists for FI
|   ├── gen_tb_fi.py                 #
|   ├── FI_DIFF                      # Fault injection flip-flops
│   └── mapping_loader.v             #
│
├── user_designs/                    # Add your own designs here
│   └── <your_design>/
│       ├── config.json
│       ├── pin_order.cfg
│       └── src/
│           ├── <design>.v
│           ├── Makefile
│           └── ...
│
└── README.md
```

---

# Running the Example (b02)

The examples/b02 directory contains a fully working fault injection example.

### 1. Generate the synthesized gate-level netlist
Navigate to the example design and run the OpenLane synthesis flow.

```bash
cd examples/b02
flow.tcl -design .
```

This generates the synthesized gate-level netlist:

```
b02_gl.v
```

---

### 2. Generate the RTL-to-Gate-Level mapping

From the design's `src` directory, run:

```bash
python3 ../../tools/rtl_gl_mapper.py
```

This produces:

```
mapping.txt
mapping_report.txt
```

These files describe how RTL registers map to synthesized gate-level flip-flops.

---

### 3. Rewrite the gate-level netlist

Run:

```bash
python3 ../../tools/gl_rewriter.py
```

This generates:

```
b02_gl_faulty.v
```

The rewritten netlist replaces each mapped flip-flop with a fault-injectable version that includes a `fault_en` input.

---

### 4. Run the simulations

RTL simulation:

```bash
make rtl
```

Gate-Level simulation:

```bash
make gl
```

The testbench simultaneously simulates a **golden** and **faulty** design, injects a single-cycle bit flip, and reports the first behavioral mismatch.

---

# Running Your Own Design

The framework is intended to support any synthesizable sequential Verilog design.

## Step 1 — Create a new design

Create a new directory under `user_designs`:

```text
user_designs/
└── my_design/
    ├── config.json
    ├── pin_order.cfg
    └── src/
        ├── my_design.v
        ├── Makefile
        └── ...
```

Your directory structure should mirror the provided **b02** example.

---

## Step 2 — Run OpenLane synthesis

Navigate to your design directory and run:

```bash
flow.tcl -design .
```

This generates the synthesized gate-level netlist:

```
my_design_gl.v
```

---

## Step 3 — Generate the RTL-to-Gate-Level mapping

Run:

```bash
python3 ../../tools/rtl_gl_mapper.py
```

This creates:

```
mapping.txt
mapping_report.txt
```

---

## Step 4 — Rewrite the gate-level netlist

Run:

```bash
python3 ../../tools/gl_rewriter.py
```

This produces:

```
my_design_gl_faulty.v
```

The rewritten netlist contains fault-injectable flip-flops controlled by a `fault_en` input.

---

## Step 5 — Generate the fault injection testbench

Run:

```bash
python3 gen_tb_fi.py my_design.v my_design_gl_faulty.v
```

The generated testbench automatically:

- Instantiates golden and faulty DUTs
- Generates fault-enable masks
- Exposes internal state registers
- Injects single-cycle bit flips
- Compares RTL and Gate-Level behavior cycle-by-cycle
- Produces waveform (`.vcd`) files for analysis

---

## Step 6 — Simulate

RTL simulation:

```bash
make rtl
```

Gate-Level simulation:

```bash
make gl
```

Simulation output includes:

- Injected fault location
- Cycle-by-cycle comparison
- First mismatch detection
- Golden vs. faulty output comparison
- Waveform generation for GTKWave
