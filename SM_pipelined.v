module SM_pipelined (CLK, RST, E2, EXEC1, EXEC2);

input CLK;
input RST;
input E2;
output EXEC1;
output EXEC2;

reg s = 0;

assign EXEC1 = ~s;
assign EXEC2 = s;

always @(posedge CLK) begin
	if(!RST)
		if(!s)
			if(E2)
				s <= 1;
			else
				s <= 0;
		else
			s <= 0;
	else
		s <= 0;
end

endmodule
