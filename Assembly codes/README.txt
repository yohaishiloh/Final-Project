# Assembly Programs (DLX)

This folder contains assembly workloads used to validate correctness and measure performance.

## Programs
- `bubble_sort.asm` – splits the array work between two cores
- `vector_add.asm` – shared-memory test for read-modify-write
- `image_segmentation.asm` – simple 16×16 thresholding
- In addition, the  folder contains the assembly codes used for the validation of the design

## Build → Memory Init
1. Compile each `.asm` to machine code for the DLX ISA (RESA).
2. Generate `imem0.data` and `imem1.data` (one per core; max ~128 instructions כנהוג במעבדה).
3. Prepare `sram.data` / `.cod` for main memory initialization (1024 lines max, hex format).
4. Place the files where the simulator/FPGA flow expects them.

