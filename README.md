# ALU_cp1
ALU Checkpoint 1 — Structural Verilog implementation of a 32-bit ALU (ADD/SUB), with block-level CLA.

Devon Sun
Net id: ys507

Design description:
This ALU is implemented structurally in Verilog using gate primitives and small hierarchical modules. A 1-bit full adder (`fa.v`) is the basic building block; four of them form a 4-bit block adder (`rc4.v`) which produces block propagate/generate signals. The 32-bit adder (`add32.v`) instantiates eight `rc4` blocks and computes block carries with block-level lookahead (`C[k+1] = G[k] | (P[k] & C[k])`). Subtraction (`sub32.v`) is implemented as `A + (~B) + 1` by bitwise XOR of B and adding with carry-in=1. Overflow detection is done with sign-bit logic in `overflow32.v`. `isNotEqual` is implemented as an OR-reduction of the result bits; `isLessThan` is `result[31] ^ overflow`. Top-level module is `alu.v`.

