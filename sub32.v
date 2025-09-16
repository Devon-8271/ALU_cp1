// sub32.v
module sub32 (
  input  [31:0] A,
  input  [31:0] B,
  output [31:0] S,
  output        cout
);
  wire [31:0] Bx;
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin : gen_invert
      xor x_inv (Bx[i], B[i], 1'b1);
    end
  endgenerate

  add32 u_add32 (
    .A(A),
    .B(Bx),
    .cin(1'b1),
    .S(S),
    .cout(cout)
  );

endmodule
