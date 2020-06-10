module SM_pipelined (CLK, E2, RST, FETCH, EXEC1, EXEC2);

input CLK;
input E2;
input RST;
output FETCH;
output EXEC1;
output EXEC2;

reg [1:0]s = 2'b00;

assign FETCH = ~s[1] & ~s[0];
assign EXEC1 = ~s[1] &  s[0];
assign EXEC2 =  s[1] & ~s[0];

always @(posedge CLK) begin
	if(!RST)
		case(s)
			2'b00: s <= 2'b01;
			2'b01: begin
				if(E2)
					s <= 2'b10;
				else ;
			end
			2'b10: s <= 2'b01;
		endcase
	else
		s <= 2'b00;
end

endmodule
