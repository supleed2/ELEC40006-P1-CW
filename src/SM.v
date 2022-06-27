module SM
(
	input CLK,
	input E2,
	input RST, //resets state machine to FETCH
	output FETCH,
	output EXEC1,
	output EXEC2
);

reg [2:0]s = 3'b1; //current state initialised to 001

always @(posedge CLK) //Change on rising edge of clock
	begin
	case(s)
		3'b000: s =  3'b001; //if in 000, go to FETCH
		3'b001: begin
			if(!RST)
				s = 3'b010;
			else
				s = 3'b001;
		end
		3'b010: begin //if in EXEC1, go to EXEC2 if E2=1 or FETCH if E2=0
			if(!RST)
				if(E2)
					s = 3'b100;
				else
					s = 3'b001;
			else
				s = 3'b001;
		end
		3'b100: s = 3'b001; //if in EXEC2, go to FETCH
		default: s = 3'b001;
	endcase
end

	assign FETCH = s[0];
	assign EXEC1 = s[1];
	assign EXEC2 = s[2];
	
endmodule
