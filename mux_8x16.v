module mux_8x16 (s, in0, in1, in2, in3, in4, in5, in6, in7, result);

input [2:0]s;
input [15:0]in0; 
input [15:0]in1;
input [15:0]in2;
input [15:0]in3;
input [15:0]in4;
input [15:0]in5;
input [15:0]in6;
input [15:0]in7;

output reg [15:0]result;

always @(*) begin
	case(s)
		3'b000: result = in0;
		3'b001: result = in1;
		3'b010: result = in2;
		3'b011: result = in3;
		3'b100: result = in4;
		3'b101: result = in5;
		3'b110: result = in6;
		3'b111: result = in7;
		default: result = in0;
	endcase
end

endmodule
