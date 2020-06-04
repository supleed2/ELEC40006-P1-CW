module LIFOstack (Din, clk, en, rst, rw, Dout, empty, full);

input [15:0] Din; // Data being fed to stack
input clk; // clock signal input
input en; // disable stack when not in use
input rst; // reset pin to clear and reinitialise stack
input rw; // 0: read, 1: write

output reg [15:0] Dout; // Data being pulled from stack
output reg empty; // goes high to indicate SP is at 0
output reg full; // goes high to indicate SP is at (slots)

reg [15:0] stack_mem [3:0];
reg [4:0] SP; // Points to slot to save next value to
integer i;

always @ (posedge clk) begin
		if (!en); // if not enabled, ignore this cycle
		else begin
				if (rst) begin // if rst is high, clear memory and reset pointers/outputs
						SP = 4'b0000;
						empty = 1'b1;
						Dout = 16'h0000;
						for (i = 0; i < 16; i = i + 1) begin
							stack_mem[i] = 16'h0000;
							end
					end
				else begin
						if (!full && rw) begin // Write when NOT full & Writing
								stack_mem[SP] = Din; // Store data into current slot
								SP = SP + 1'b1; // Increment stack pointer to next empty slot
								full = (SP == 5'b10000) ? 1 : 0; // Stack is full if SP is (slots)
								empty = 1'b0; // Stack is never empty after a push
							end
						else if (!empty && !rw) begin // Read when NOT empty & reading
								SP = SP - 1'b1; // Decrement stack pointer to last filled slot
								Dout = stack_mem[SP]; // Output data from last filled slot
								stack_mem[SP] = 16'h0000; // Clear slot after setting output
								full = 1'b0; // Stack is never full after a pop
								empty = (SP == 5'b00000) ? 1 : 0; // Stack is empty if SP is 0
							end
					end
			end
	end

endmodule
