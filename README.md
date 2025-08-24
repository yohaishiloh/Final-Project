# Multicore DLX with MESI Coherence Protocol

**Final Project – Tel Aviv University**  
Dual-core DLX-based processor with hardware cache coherence (MESI), implemented in Verilog, simulated and validated on FPGA.

---

## Overview
- **Goal:** extend a simplified DLX CPU into a **dual-core** system with **instruction/data caches** per core and a **MESI** coherence controller.
- **Why MESI?** to ensure cache coherence across cores while minimizing unnecessary memory traffic.
- **Baseline:** A simplified single-core DLX CPU.  
- **Extensions:**  
  - Added **instruction and data caches**.  
  - Built a **dual-core architecture**.  
  - Implemented **MESI protocol** for cache coherence.  
- **Validation:**  
  - Functional correctness verified with targeted assembly tests.  
  - Benchmarked with workloads such as bubble sort, vector addition, and image processing.  
  - Speedup of up to **3.78×** measured versus the baseline single-core system.

---

## Repository Structure
- **`simplified DLX/`** – baseline single-core DLX design.  
- **`Multicore/`** – dual-core DLX design with caches and MESI protocol.  
- **`Assembly codes/`** – workloads used for validation and performance testing.  
  - `bubble sort/` – array-sorting benchmark.  
  - `vector addition/` – memory-intensive workload.  
  - `image_processing/` – threshold-based image segmentation.  
  - `functional verification codes/` – small bring-up and coherence tests.  

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

## Authors
- **Yarin Koren**  
- **Yohai Shiloh**

**Instructor:** Oren Ganon, Tel Aviv University
