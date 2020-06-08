module mux_3x16 (s, in0, in1, in2, result);

input [1:0]s;
input [15:0]in0;
input [15:0]in1;
input [15:0]in2;

output reg [15:0]result;

always @(*) begin
	case(s)
		2'b00: result = in0;
		2'b01: result = in1;
		2'b10: result = in2;
	endcase
end

endmodule
