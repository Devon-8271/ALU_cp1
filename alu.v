// alu.v
`timescale 1ns/100ps
module alu(
  data_operandA, data_operandB,
  ctrl_ALUopcode, ctrl_shiftamt,
  data_result, isNotEqual, isLessThan, overflow
);
   input  [31:0] data_operandA, data_operandB;
   input  [4:0]  ctrl_ALUopcode, ctrl_shiftamt;
   output [31:0] data_result;
   output        isNotEqual, isLessThan, overflow;

   wire o0 = ctrl_ALUopcode[0];
   wire o1 = ctrl_ALUopcode[1];
   wire o2 = ctrl_ALUopcode[2];
   wire o3 = ctrl_ALUopcode[3];
   wire o4 = ctrl_ALUopcode[4];

   wire no0, no1, no2, no3, no4;
   not nn0(no0, o0);
   not nn1(no1, o1);
   not nn2(no2, o2);
   not nn3(no3, o3);
   not nn4(no4, o4);

   wire sub;
   and decode_sub (sub, no4, no3, no2, no1, o0);

   wire [31:0] add_sum;
   wire add_cout;
   add32 add_inst (
     .A(data_operandA),
     .B(data_operandB),
     .cin(1'b0),
     .S(add_sum),
     .cout(add_cout)
   );

   wire [31:0] sub_sum;
   wire sub_cout;
   sub32 sub_inst (
     .A(data_operandA),
     .B(data_operandB),
     .S(sub_sum),
     .cout(sub_cout)
   );

   assign data_result = sub ? sub_sum : add_sum;

   wire A31 = data_operandA[31];
   wire B31 = data_operandB[31];
   wire S_add31 = add_sum[31];
   wire S_sub31 = sub_sum[31];

   wire ov_add;
   wire ov_sub;
   overflow32 ov_add_inst (.A31(A31), .Bx31(B31), .S31(S_add31), .overflow(ov_add));
   wire B31_inv;
   not nb(B31_inv, B31);
   overflow32 ov_sub_inst (.A31(A31), .Bx31(B31_inv), .S31(S_sub31), .overflow(ov_sub));

   assign overflow = sub ? ov_sub : ov_add;

   wire [15:0] w1;
   genvar i;
   generate
     for (i = 0; i < 16; i = i + 1) begin : or1
       or o1 (w1[i], data_result[2*i], data_result[2*i+1]);
     end
   endgenerate
   wire [7:0] w2;
   generate
     for (i = 0; i < 8; i = i + 1) begin : or2
       or o2 (w2[i], w1[2*i], w1[2*i+1]);
     end
   endgenerate
   wire [3:0] w3;
   generate
     for (i = 0; i < 4; i = i + 1) begin : or3
       or o3 (w3[i], w2[2*i], w2[2*i+1]);
     end
   endgenerate
   wire [1:0] w4;
   genvar k;
   generate
     for (k = 0; k < 2; k = k + 1) begin : or4
       or o4 (w4[k], w3[2*k], w3[2*k+1]);
     end
   endgenerate
   or o_final (isNotEqual, w4[0], w4[1]);

   xor x_lt (isLessThan, data_result[31], overflow);

endmodule
