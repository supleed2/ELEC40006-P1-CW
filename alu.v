module alu (enable, Rs1, Rs2, Rd, opcode, mulresult, exec2, mul1, mul2, Rout, jump, carry);

input enable; // active LOW, disables the ALU during load/store operations so that undefined behaviour does not occur
input signed [15:0] Rd; // input destination register
input signed [15:0] Rs1; // input source register 1
input signed [15:0] Rs2; // input source register 2
input [5:0] opcode; // opcode is fed in from instruction using wires outside ALU
input signed [31:0] mulresult; // 32-bit result from multiplier
input exec2; // Input from state machine to indicate when to take in result from multiplication

output reg signed [15:0] mul1; // first number to be multiplied
output reg signed [15:0] mul2; // second number to be multiplied
output signed [15:0] Rout; // value to be saved to destination register
output jump; // tells decoder whether Jump condition is true
output reg carry; // Internal carry register that is updated during appropriate opcodes, also provides output for debugging

reg signed [16:0] alusum; // extra bit to hold carry from operations other than Multiply
assign Rout = alusum [15:0];
assign jump = (alusum[16] && ((opcode[5:2] == 4'b0000) | (opcode[5:2] == 4'b0001) | (opcode[5:2] == 4'b0010)));
reg [15:0] mulextra;

//Jump Conditionals:
wire JC1, JC2, JC3, JC4, JC5, JC6, JC7, JC8;
assign JC1 = (Rs1 < Rs2);
assign JC2 = (Rs1 > Rs2);
assign JC3 = (Rs1 == Rs2);
assign JC4 = (Rs1 == 0);
assign JC5 = (Rs1 >= Rs2);
assign JC6 = (Rs1 <= Rs2);
assign JC7 = (Rs1 != Rs2);
assign JC8 = (Rs1 < 0);

always @(*)
	begin
		if(!enable) begin
			case (opcode)
				6'b000000: alusum = {1'b1, Rd}; // JMP Unconditional Jump, first bit high to indicate jump and passes through Rd
				
				6'b000100: alusum = {JC1, Rd}; // JC1 Conditional Jump A < B
				6'b000101: alusum = {JC2, Rd}; // JC2 Conditional Jump A > B
				6'b000110: alusum = {JC3, Rd}; // JC3 Conditional Jump A = B
				6'b000111: alusum = {JC4, Rd}; // JC4 Conditional Jump A = 0
				
				6'b001000: alusum = {JC5, Rd}; // JC5 Conditional Jump A >= B / A !< B
				6'b001001: alusum = {JC6, Rd}; // JC6 Conditional Jump A <= B / A !> B
				6'b001010: alusum = {JC7, Rd}; // JC7 Conditional Jump A != B
				6'b001011: alusum = {JC8, Rd}; // JC8 Conditional Jump A < 0
				
				6'b001100: alusum = {1'b0, Rs1 & Rs2}; // AND Bitwise AND
				6'b001101: alusum = {1'b0, Rs1 | Rs2}; // OR Bitwise OR
				6'b001110: alusum = {1'b0, Rs1 ^ Rs2}; // XOR Bitwise XOR
				6'b001111: alusum = {1'b0, ~Rs1}; // NOT Bitwise NOT
				
				6'b010000: alusum = {1'b0, ~Rs1 | ~Rs2}; // NND Bitwise NAND
				6'b010001: alusum = {1'b0, ~Rs1 & ~Rs2}; // NOR Bitwise NOR
				6'b010010: alusum = {1'b0, Rs1 ~^ Rs2}; // XNR Bitwise XNOR
				6'b010011: alusum = {1'b0, Rs1}; // MOV Move (Rd = Rs1)
				
				6'b010100: begin
						alusum = {1'b0, Rs1} + {1'b0, Rs2}; // ADD Add (Rd = Rs1 + Rs2)
						carry = alusum[16];
					end
				6'b010101: begin
						alusum = {1'b0, Rs1} + {1'b0, Rs2} + carry; // ADC Add w/ Carry (Rd = Rs1 + Rs2 + C)
						carry = alusum[16];
					end
				6'b010110: begin
						alusum = {1'b0, Rs1} + {17'b00000000000000001}; // ADO Add 1 (Rd = Rd + 1)
						carry = alusum[16];
					end
				6'b010111: ;
				
				6'b011000: begin
						alusum = {1'b0, Rs1} - {1'b0, Rs2}; // SUB Subtract (Rd = Rs1 - Rs2)
						carry = alusum[16];
					end
				6'b011001: begin
						alusum = {1'b0, Rs1} - {1'b0, Rs2} + carry - {17'b00000000000000001}; // SBC Subtract w/ Carry (Rd = Rs1 - Rs2 + C - 1)
						carry = alusum[16];
					end
				6'b011010: begin
						alusum = {1'b0, Rs1} - {17'b00000000000000001}; // SBO Subtract 1 (Rd = Rd - 1)
						carry = alusum[16];
					end
				6'b011011: ;
				
				6'b011100: begin // MUL Multiply (Rd = Rs1 * Rs2)
						if(!exec2) begin
								mul1 = Rs1;
								mul2 = Rs2;
							end
						else begin
								alusum[16] = 1'b0;
								{mulextra, alusum[15:0]} = mulresult;
							end
					end
				6'b011101: begin // MLA Multiply and Add  (Rd = Rs2 + (Rd * Rs1))
						if(!exec2) begin
								mul1 = Rs1;
								mul2 = Rs2;
							end
						else begin
								alusum[16] = 1'b0;
								{mulextra, alusum[15:0]} = mulresult + {16'h0000, Rs2};
							end
					end
				6'b011110: begin // MLS Multiply and Subtract (Rd = Rs2 - (Rd * Rs1)[15:0])
						if(!exec2) begin
								mul1 = Rs1;
								mul2 = Rs2;
							end
						else begin
								alusum = {1'b0, Rs2 - mulresult[15:0]};
							end
					end
				6'b011111: alusum = mulextra; // MRT Retrieve Multiply MSBs (Rd = MSBs)
				
				6'b100000: alusum = {1'b0, Rs1 << Rs2}; // LSL Logical Shift Left (Rd = Rs1 shifted left by value of Rs2)
				6'b100001: alusum = {1'b0, Rs1 >> Rs2}; // LSR Logical Shift Right (Rd = Rs1 shifted right by value of Rs2)
				6'b100010: alusum = {Rs1[15], Rs1 >>> Rs2}; // ASR Arithmetic Shift Right (Rd = Rs1 shifted right by value of Rs2, maintaining sign bit)
				6'b100011: ;
				
				6'b100100: alusum = {1'b0, (Rs1 >> Rs2[3:0]) | (Rs1 << (16 - Rs2[3:0]))}; // ROR Shift Right Loop (Rd = Rs1 shifted right by Rs2, but Rs1[0] -> Rs1[15])
				6'b100101: alusum = ({Rs1, carry} >> (Rs2 % 17)) | ({Rs1, carry} << (17 - (Rs2 % 17)));// RRC Shift Right Loop w/ Carry (Rd = Rs1 shifted right by Rs2, but Rs1[0] -> Carry & Carry -> Rs1[15])
				6'b100110: ;
				6'b100111: ;
				
				6'b111110: ; // NOP No Operation (Do Nothing for a cycle)
				6'b111111: alusum = {1'b0, 16'h0000}; // STP Stop (Program Ends)
				
				default: ; // During Load & Store as well as undefined opcodes
			endcase;
			end
		else begin
				alusum = {1'b0, 16'h0000}; // Bring output low during Load/Store so it does not interfere
			end
	end

endmodule