# Vector Addition – DLX Assembly Program

This folder contains the **Vector Addition** workload for the DLX processor.

---

## Description
- Adds pairs of elements from two arrays and stores the results in a third array.  
- Designed to test **shared-memory read–modify–write** behavior.  
- Validates correctness under single-core and multicore runs.

---

## Files
- `simple_dlx.txt` — single-core baseline version.  
- `imem0.txt`, `imem1.txt` — per-core streams for multicore.  
- `Imem0.data`, `Imem1.data` — assembled instruction images.  
- `single cache/` — files and RESA artifacts (`.cod`, `.lst`, etc.) for single-core-with-cache configuration.

---

## Expected outcome
The output array contains the element-wise sum of the two input arrays.  
The program is useful for verifying correct memory access ordering and coherence under multicore MESI.
