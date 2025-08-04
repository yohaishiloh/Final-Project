# Multicore DLX with MESI Coherence Protocol

**Final Project – Tel Aviv University (ACSL)**  
Dual-core DLX-based processor with hardware cache coherence (MESI), implemented in Verilog, simulated and validated on FPGA.

---

## Overview
- **Goal:** extend a simplified DLX CPU into a **dual-core** system with **instruction/data caches** per core and a **MESI** coherence controller.
- **Why MESI?** to ensure cache coherence across cores while minimizing unnecessary memory traffic.
- **What we show:** functional correctness (simulation + FPGA) and **speedup up to ×3.78** on shared-memory workloads.

---

## Repository Structure
Final-Project/
├─ Assembly codes/ # Assembly workloads for validation and benchmarks
├─ Multicore/ # Multicore DLX top + cache/bus/coherence logic (Verilog)
├─ simplified DLX/ # The simplified single-core DLX baseline (Verilog)
├─ project final presentation.pdf
├─ Multicore DLX MESI Project Report.pdf
├─ Poster - Multicore with MESI.pdf
└─ README.md

---

## Quick Start

### Prerequisites
- Verilog simulator (e.g., **ModelSim/Questa** or **Icarus Verilog**)
- Xilinx **ISE** / **Vivado** (for FPGA synthesis)
- Memory initialization tooling (**RESA** / ISE), per the course setup

### Run – Simulation
1. Open the Verilog project (see the `Multicore` and `simplified DLX` subfolders).
2. Choose an appropriate testbench (e.g., **bubble sort** / **vector add**) from `Assembly codes/`.
3. Run the simulation.
4. Inspect the waveforms and verify MESI state transitions according to the stimulus.

### Run – FPGA (RESA)
1. Compile the assembly files to `.data` (for `imem0`/`imem1`) and generate the memory initialization file (`.cod` / `sram.data`) as specified.
2. Synthesize the project (ISE/Vivado) to produce a **bitstream**.
3. Load the bitstream and the memory init via **RESA/ISE**.
4. Run in continuous mode until halt and verify results (e.g., before/after **bubble sort**).

**Tip:** Use assembly variants that split the work across both cores to fully demonstrate coherence.

---

## Benchmarks
The system was evaluated with:
- **Bubble sort** (array split into two parts/blocks, one per core)
- **Vector summing** (shared-memory read/modify/write)
- **Simple image segmentation** (16×16)

**Key results:** Cumulative performance improvement up to **×3.78**, with the primary contribution coming from parallelism (caching adds a moderate additional gain).

---

## Main Components
- **Dual DLX cores** (baseline in `simplified DLX/`)
- **Instruction & data caches per core**
- **MESI controller (FSM)**
- **Bus control** with arbitration, snooping, and data routing
- **Main memory interface** (treated as a black box per the course framework)

---

## Roadmap / Further Work
- Scale beyond two cores
- Support advanced coherence protocols (e.g., **MOESI**, **Dragon**)
- **Pipeline / Out-of-Order / Branch prediction** for the DLX
- Dynamic cache replacement policies and **OS interrupt** support

---

## Authors
- **Yarin Koren**  
- **Yohai Shiloh**

**Instructor:** Oren Ganon, Tel Aviv University – ACSL Lab
