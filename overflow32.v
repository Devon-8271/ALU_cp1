// overflow32.v
module overflow32 (
  input  A31,
  input  Bx31,
  input  S31,
  output overflow
);
  wire nA, nBx, nS;
  not n1(nA, A31);
  not n2(nBx, Bx31);
  not n3(nS, S31);
  wire t0, t1;
  and a0(t0, A31, Bx31, nS);
  and a1(t1, nA, nBx, S31);
  or  o1(overflow, t0, t1);
endmodule
