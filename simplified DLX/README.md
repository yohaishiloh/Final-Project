# Simplified DLX – Baseline Core (Verilog)

This folder contains the single-core DLX baseline used as a reference.

---

## What’s Here
- A simplified DLX CPU (as implemented in ACSL course)
- Minimal instruction set subset compatible with provided assembly samples
- Ready to be integrated as a single core or as the building block for the multicore system

---

## Usage
- Simulate standalone to validate the ISA behavior
- Compare performance vs. `Multicore/` design
- Helpful for unit tests of instruction fetch/execute without coherence logic

---

## Notes
- The design was made during of the *Advanced Computer Structure Lab(ACSL)* Course the 2024 spring semester, checked and validated by both the course stuff and us.
- Only the main blocks' schemes/source codes were attached. For more detailed elaboration see the report about the design, in the PDF file named *'ACSL Handout 7 PostLab B2 B24'*
- Since some modules used in the design was provided as black boxes and are not belongs to us, they only appears in the schemes but no further details (such as inner srtuctures) will be provided
- Additional files (assembly codes, testbenches, documentation etc.) were omitted.
