module ha (
  input  a,
  input  b,
  output sum,
  output cout
);
  // half-adder:
  // sum = a ^ b
  // cout = a & b

  xor xor1 (sum, a, b);   // sum = a ^ b
  and and1 (cout, a, b);   // cout = a & b
endmodule
