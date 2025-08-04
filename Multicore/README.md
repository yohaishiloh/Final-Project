# **Multicore DLX (Dual-Core) + MESI – Verilog**

This folder holds the multicore top-level and the cache/bus/coherence logic.

## Modules (typical)
- `multicore_top.v` – two DLX cores, shared bus, main memory interface
- `cache_controller.v` – MESI FSM (M/E/S/I), invalidations & flush
- `cache_datapath.v` – tag/data arrays, data mux, write enable, etc.
- `tag_memory.v` – tags + MESI state per line, snoop handling
- `address_calculator.v` – addresses for burst/block transfers
- `bus_control.v` – arbitration, routing, ack, bus commands
- `imem.v` – per-core instruction/data memory (as configured)

---

## Build & Sim
1. Include all `.v` files from this folder.
2. Compile with your preferred simulator.
3. Use testbenches from `Assembly codes/` to drive memory ops and observe MESI state transitions.

---

## Notes
- Block size: 16 words (burst transfers of 16 cycles)
- Coherence: write-invalidate (MESI), cache-to-cache transfer on modified line when needed
- Bus snooping: tag-memory listens & updates states accordingly
