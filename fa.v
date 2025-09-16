// fa.v
// 1-bit full adder implemented with gate primitives
module fa (
  input  a,
  input  b,
  input  cin,
  output sum,
  output cout
);
  wire s1, c1, c2;
  xor xor1 (s1, a, b);       // s1 = a ^ b
  xor xor2 (sum, s1, cin);   // sum = s1 ^ cin
  and and1 (c1, a, b);       // c1 = a & b
  and and2 (c2, s1, cin);    // c2 = s1 & cin
  or  or1  (cout, c1, c2);   // cout = c1 | c2
endmodule
