// rc4.v
// 4-bit ripple adder block built from 4 x fa
// Also outputs block propagate P_block and generate G_block (structural)

module rc4 (
  input  [3:0] a,
  input  [3:0] b,
  input        cin,
  output [3:0] sum,
  output       cout,    // carry out of this 4-bit block (carry from bit3)
  output       P_block, // propagate = p3 & p2 & p1 & p0
  output       G_block  // generate  = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0)
);

  // per-bit propagate and generate (structural)
  wire p0, p1, p2, p3;
  wire g0, g1, g2, g3;

  xor xp0 (p0, a[0], b[0]);
  xor xp1 (p1, a[1], b[1]);
  xor xp2 (p2, a[2], b[2]);
  xor xp3 (p3, a[3], b[3]);

  and ag0 (g0, a[0], b[0]);
  and ag1 (g1, a[1], b[1]);
  and ag2 (g2, a[2], b[2]);
  and ag3 (g3, a[3], b[3]);

  // compute block P = p3 & p2 & p1 & p0
  and andP (P_block, p3, p2, p1, p0);

  // compute block G using gate tree:
  // G_block = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0)
  wire t1, t2, t3;
  and a_t1 (t1, p3, g2);               // p3 & g2
  and a_t2 (t2, p3, p2, g1);           // p3 & p2 & g1
  and a_t3 (t3, p3, p2, p1, g0);       // p3 & p2 & p1 & g0
  or  orG  (G_block, g3, t1, t2, t3);

  // internal carries inside block (ripple)
  wire c0, c1, c2; // carry into bit1,2,3 respectively
  // bit0
  fa fa0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c0));
  // bit1
  fa fa1 (.a(a[1]), .b(b[1]), .cin(c0), .sum(sum[1]), .cout(c1));
  // bit2
  fa fa2 (.a(a[2]), .b(b[2]), .cin(c1), .sum(sum[2]), .cout(c2));
  // bit3
  fa fa3 (.a(a[3]), .b(b[3]), .cin(c2), .sum(sum[3]), .cout(cout));

endmodule
