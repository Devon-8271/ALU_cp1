// add32.v
module add32 (
  input  [31:0] A,
  input  [31:0] B,
  input         cin,
  output [31:0] S,
  output        cout
);
  wire [7:0] P_block;
  wire [7:0] G_block;
  wire [7:0] block_cin;
  wire [3:0] sum_block [7:0];

  assign block_cin[0] = cin;

  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : gen_rc4
      wire [3:0] a_slice;
      wire [3:0] b_slice;
      assign a_slice = A[i*4 +: 4];
      assign b_slice = B[i*4 +: 4];
      rc4 u_rc4 (
        .a(a_slice),
        .b(b_slice),
        .cin(block_cin[i]),
        .sum(sum_block[i]),
        .cout(), 
        .P_block(P_block[i]),
        .G_block(G_block[i])
      );
    end
  endgenerate

  genvar j;
  generate
    for (j = 0; j < 7; j = j + 1) begin : gen_carry
      wire t_and;
      and a_and (t_and, P_block[j], block_cin[j]);
      or  a_or  (block_cin[j+1], G_block[j], t_and);
    end
  endgenerate

  wire t_and_last;
  and a_and_last (t_and_last, P_block[7], block_cin[7]);
  or  a_or_last  (cout, G_block[7], t_and_last);

  generate
    for (i = 0; i < 8; i = i + 1) begin : gen_result
      assign S[i*4 +: 4] = sum_block[i];
    end
  endgenerate

endmodule
