# Bubble Sort – DLX Assembly Program

This folder contains the **Bubble Sort** workload for the DLX processor.

---

## Description
- Implements the **Bubble Sort algorithm** in DLX assembly.  
- In the multicore version, the array is split into halves and sorted by two cores in parallel.  
- Used to measure speedup and validate **cache coherence** with the MESI protocol.

---

## Files
- `simple_dlx.txt` — single-core baseline version.  
- `imem0.txt`, `imem1.txt` — per-core instruction streams for multicore.  
- `Imem0.data`, `Imem1.data`, `simple_dlx.data` — pre-built assembled images.  
- `single cache/` — files for single-core-with-cache configuration.  
- `.png` screenshots — RESA execution examples showing program and memory state.

---

## Expected outcome
The input array is sorted in ascending order.  
In the multicore configuration, workload is split across cores, enabling performance evaluation and MESI validation.
