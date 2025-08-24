# Functional Verification Codes – DLX Assembly

This folder contains small programs used for **bring-up** and **functional validation** of the DLX processor designs.

---

## Programs
- `basic_arithmetic.txt` — simple add/subtract/store test.  
- `basic_arithmetic_with_flush.txt` — extended arithmetic test with additional memory operations.  
- `halt.txt` — minimal program to test HALT functionality.  
- `MESI_tests/` — multicore coherence workloads, including:  
  - `MESI_test_imem0.txt`  
  - `MESI_test_imem1.txt`  
  - Corresponding `.data` images.

---

## Purpose
These workloads are used during bring-up and debugging to:
- Verify instruction execution.  
- Test memory access correctness.  
- Validate the behavior of the **MESI protocol** under shared-memory conditions.
