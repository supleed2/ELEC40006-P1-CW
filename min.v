module min(sign, a, b, num);
	input sign;
	input [7:0] a;
	input [7:0] b;
	output [7:0] num;
	assign num = sign ? a[7:0]:b[7:0];
endmodule
