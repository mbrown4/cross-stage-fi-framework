# Cross-Layer Fault Injection Framework for RISC-V

## Overview

This repository presents a unified fault injection (FI) framework for analyzing reliability across multiple abstraction levels in digital systems, with a focus on RISC-V microarchitecture. The framework enables direct comparison between Register Transfer Level (RTL) and Gate-Level (GL) implementations to study fault propagation, masking behavior, and architectural vulnerability.

The primary objective is to bridge the gap between high-level functional models and physically realized gate-level designs by systematically injecting faults into state elements and observing their impact on system outputs.

---

## Motivation

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
├── rtl/                # RTL designs and FI wrappers
├── gl/                 # Gate-level netlists (synthesized)
├── tb/                 # Testbenches (RTL + GL)
├── scripts/            # Python tools (mapping, rewriting)
├── mappings/           # RTL-to-GL mapping files
├── results/            # Simulation outputs and logs
├── docs/               # Reports, figures, and diagrams
└── Makefile            # Build and simulation automation
