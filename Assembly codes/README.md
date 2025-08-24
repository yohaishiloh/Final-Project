# Assembly Programs (DLX)

This folder contains the assembly workloads used to **functionally verify** and **benchmark** the DLX-based designs in this repository (single-core “simplified DLX”, single-core with cache, and multicore with MESI).

---

## Directory map

- **`bubble sort/`**  
  Bubble-sort workload. Includes:  
  - `simple_dlx.txt` — single-core baseline version.  
  - `imem0.txt`, `imem1.txt` — per-core instruction streams for multicore runs.  
  - Pre-built `.data` images (assembled output).  
  - `single cache/` subfolder with pre-built images for the single-core-with-cache flow.  
  - `.png` files — screenshots from the RESA tool showing program execution and memory state.

- **`vector addition/`**  
  Vector addition workload. Includes:  
  - `simple_dlx.txt` — single-core baseline version.  
  - `imem0.txt`, `imem1.txt` — per-core instruction streams for multicore runs.  
  - Pre-built `.data` images.  
  - `single cache/` subfolder with single-cache variants and assembler artifacts (`.cod`, `.lst`, etc.).

- **`image_processing/`**  
  Simple image/thresholding workload. Includes:  
  - `simple_dlx.txt` — single-core baseline version.  
  - `single_with_cache.txt` — single-core with cache.  
  - `imem0.txt`, `imem1.txt` — multicore instruction streams.  
  - Pre-built `.data` images.  

- **`functional verification codes/`**  
  Small targeted programs for bring-up and feature testing:  
  - `basic_arithmetic.txt`, `basic_arithmetic_with_flush.txt`, `halt.txt`.  
  - `MESI_tests/` — multicore coherence tests (`MESI_test_imem0.txt`, `MESI_test_imem1.txt`) and pre-built `.data` images.  

---

## File types

- `.txt` — **assembly source** (DLX ISA).  
  - `simple_dlx.txt` → single-core baseline.  
  - `imem0.txt`, `imem1.txt` → per-core instruction streams for multicore.  
  - `single_with_cache.txt` or files inside `single cache/` → single-core with cache.  

- `.data` — **assembled instruction images** ready to be loaded into instruction memory for simulation/FPGA.  

- `.cod`, `.lst`, `.s` — **RESA assembler artifacts/logs** (in some folders for reference).  

- `.png` — **execution screenshots** from the RESA assembler/simulator (used as visual evidence of correct program execution).  

---

## Build (assemble) instructions

If you modify a `.txt` program and need to regenerate the instruction images:

1. **Assemble** the `.txt` source with the **RESA** DLX assembler (examples and screenshots are included in some folders).  
2. **Produce** the corresponding `.data` image(s).  
   - Single-core: one image (e.g., `simple_dlx.data`).  
   - Multicore: one image per core (`Imem0.data`, `Imem1.data`).  
3. **Load** the resulting `.data` files into your simulator/FPGA build according to the top-level project’s memory initialization flow.  

---

## How to run

1. Choose the configuration you are testing:  
   - **Simplified single-core DLX** → use `simple_dlx.txt` (or its assembled `.data`).  
   - **Single-core with cache** → use `single_with_cache.txt` or the `single cache/` subfolder.  
   - **Multicore with MESI** → use `imem0.txt` and `imem1.txt` (or their `.data` outputs) and assign per core.  

2. Initialize **instruction memory** with the generated `.data` files.  
3. If required by your environment, initialize **main memory** with the provided `.cod` / `.sram.data` files.  
4. Run the design and validate:  
   - Correct results (sorted array, summed vectors, thresholded image).  
   - MESI protocol activity where applicable.  
   - Match against `.png` execution screenshots if available.  

---

## Purpose

These programs cover:
- **Bring-up** (HALT, basic arithmetic).  
- **Cache/MESI validation** (MESI tests with shared-memory traffic).  
- **Performance benchmarks** (bubble sort, vector addition, image processing).  

They form the **canonical workloads** used in simulation and FPGA testing for the project.
