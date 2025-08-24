# Image Processing – DLX Assembly Program

This folder contains a simple **image thresholding** workload for the DLX processor.

---

## Description
- Processes 256 memory words, each representing a pixel.  
- Applies a threshold at **128 (0x80)**:  
  - Values ≤ 127 → set to 0.  
  - Values > 127 → set to 255.  
- Provides versions for single-core and multicore runs.

---

## Files
- `simple_dlx.txt` — single-core baseline version.  
- `single_with_cache.txt` — single-core with cache.  
- `imem0.txt`, `imem1.txt` — per-core multicore streams.  
- `.data` images for execution.

---

## Expected outcome
The input "image" is binarized: all values below threshold are set to **0**, others set to **255**.  
Multicore versions split the pixel range between the two cores.
