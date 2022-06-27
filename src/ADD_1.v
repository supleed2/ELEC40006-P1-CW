module ADD_1 (enable, in, out);

input [15:0] in;
input enable;
output reg [15:0] out;

always @(*) begin
	if(enable)
		out = in + 1'b1;
	else
		out = in;
end

endmodule