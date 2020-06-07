module DECODE
(
	input [15:0] instr,
	input EXEC1,
	input EXEC2,
	input COND_result,
	output R0_count,
	output R0_en,
	output R1_en,
	output R2_en,
	output R3_en,
	output R4_en,
	output R5_en,
	output R6_en,
	output R7_en,
	output [2:0] s1,
	output [2:0] s2,
	output [2:0] s3,
	output s4,
	output RAMd_wren,
	output RAMd_en,
	output RAMi_en,
	output ALU_en,
	output E2,
	output stack_en,
	output stack_rst,
	output stack_rw
);

	wire msb = instr[15];					//MSB of the instruction word
	wire ls = instr[14];						//LOAD or STORE bit
	wire [2:0] Rls = instr[13:11];		//Register in the LOAD/STORE operation
	wire [10:0] addr = instr[10:0];		//Memory address in the LOAD/STORE operation
	wire [5:0] op = instr[14:9];			//Opcode in regular instructions
	wire [2:0] Rd = instr[8:6];			//Destination register in command
	wire [2:0] Rs1 = instr[5:3];			//Source register 1 in command
	wire [2:0] Rs2 = instr[2:0];			//Source register 2 in command
	
	//Different opcodes (refer to documentation):
	wire LOAD = msb & ~ls;
	wire STORE = msb & ls;
	wire UJMP = ~op[5] & ~op[4] & ~op[3] & ~op[2];
	wire JMP = (~op[5] & ~op[4] & ~op[3] & op[2]) | (~op[5] & ~op[4] & op[3] & ~op[2]);
	wire MUL = ~op[5] &  op[4] &  op[3] &  op[2] & ~op[1] & ~op[0];
	wire MLA = ~op[5] &  op[4] &  op[3] &  op[2] & ~op[1] &  op[0];
	wire MLS = ~op[5] &  op[4] &  op[3] &  op[2] &  op[1] & ~op[0];
	wire PSH =  op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0];
	wire POP =  op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] &  op[0];
	wire NOP =  op[5] &  op[4] &  op[3] &  op[2] &  op[1] & ~op[0];
	wire STP =  op[5] &  op[4] &  op[3] &  op[2] &  op[1] &  op[0];
	
	assign R0_count = EXEC1 & (~(UJMP | JMP | STP));
	assign R0_en = EXEC1 & (~(STORE | NOP | STP) & ~Rd[2] & ~Rd[1] & ~Rd[0] | UJMP | JMP & COND_result) | EXEC2 & LOAD & ~Rls[2] & ~Rls[1] & ~Rls[0] | EXEC2 & (MUL | MLA | MLS | POP) & ~Rd[2] & ~Rd[1] & ~Rd[0];
	assign R1_en = EXEC1 & ~(UJMP | JMP | STORE | LOAD | MUL | MLA | MLS | NOP | STP | POP) & ~Rd[2] & ~Rd[1] &  Rd[0] | EXEC2 & LOAD & ~Rls[2] & ~Rls[1] &  Rls[0] | EXEC2 & (MUL | MLA | MLS | POP) & ~Rd[2] & ~Rd[1] &  Rd[0];
	assign R2_en = EXEC1 & ~(UJMP | JMP | STORE | LOAD | MUL | MLA | MLS | NOP | STP | POP) & ~Rd[2] &  Rd[1] & ~Rd[0] | EXEC2 & LOAD & ~Rls[2] &  Rls[1] & ~Rls[0] | EXEC2 & (MUL | MLA | MLS | POP) & ~Rd[2] &  Rd[1] & ~Rd[0];
	assign R3_en = EXEC1 & ~(UJMP | JMP | STORE | LOAD | MUL | MLA | MLS | NOP | STP | POP) & ~Rd[2] &  Rd[1] &  Rd[0] | EXEC2 & LOAD & ~Rls[2] &  Rls[1] &  Rls[0] | EXEC2 & (MUL | MLA | MLS | POP) & ~Rd[2] &  Rd[1] &  Rd[0];
	assign R4_en = EXEC1 & ~(UJMP | JMP | STORE | LOAD | MUL | MLA | MLS | NOP | STP | POP) &  Rd[2] & ~Rd[1] & ~Rd[0] | EXEC2 & LOAD &  Rls[2] & ~Rls[1] & ~Rls[0] | EXEC2 & (MUL | MLA | MLS | POP) &  Rd[2] & ~Rd[1] & ~Rd[0];
	assign R5_en = EXEC1 & ~(UJMP | JMP | STORE | LOAD | MUL | MLA | MLS | NOP | STP | POP) &  Rd[2] & ~Rd[1] &  Rd[0] | EXEC2 & LOAD &  Rls[2] & ~Rls[1] &  Rls[0] | EXEC2 & (MUL | MLA | MLS | POP) &  Rd[2] & ~Rd[1] &  Rd[0];
	assign R6_en = EXEC1 & ~(UJMP | JMP | STORE | LOAD | MUL | MLA | MLS | NOP | STP | POP) &  Rd[2] &  Rd[1] & ~Rd[0] | EXEC2 & LOAD &  Rls[2] &  Rls[1] & ~Rls[0] | EXEC2 & (MUL | MLA | MLS | POP) &  Rd[2] &  Rd[1] & ~Rd[0];
	assign R7_en = EXEC1 & ~(UJMP | JMP | STORE | LOAD | MUL | MLA | MLS | NOP | STP | POP) &  Rd[2] &  Rd[1] &  Rd[0] | EXEC2 & LOAD &  Rls[2] &  Rls[1] &  Rls[0] | EXEC2 & (MUL | MLA | MLS | POP) &  Rd[2] &  Rd[1] &  Rd[0];
	assign s1[2] = EXEC1 & ((~(UJMP | JMP | STORE | LOAD | NOP | STP | PSH | POP) & Rs1[2]) | (STORE & Rls[2]) | (PSH & Rs1[2]));
	assign s1[1] = EXEC1 & ((~(UJMP | JMP | STORE | LOAD | NOP | STP | PSH | POP) & Rs1[1]) | (STORE & Rls[1]) | (PSH & Rs1[1]));
	assign s1[0] = EXEC1 & ((~(UJMP | JMP | STORE | LOAD | NOP | STP | PSH | POP) & Rs1[0]) | (STORE & Rls[0]) | (PSH & Rs1[0]));
	assign s2[2] = EXEC1 & ((~(UJMP | JMP | STORE | LOAD | NOP | STP | PSH | POP)) & Rs2[2]);
	assign s2[1] = EXEC1 & ((~(UJMP | JMP | STORE | LOAD | NOP | STP | PSH | POP)) & Rs2[1]);
	assign s2[0] = EXEC1 & ((~(UJMP | JMP | STORE | LOAD | NOP | STP | PSH | POP)) & Rs2[0]);
	assign s3[2] = EXEC1 & ((~(UJMP | JMP | STORE | LOAD | NOP | STP | PSH | POP)) & Rd[2]);
	assign s3[1] = EXEC1 & ((~(UJMP | JMP | STORE | LOAD | NOP | STP | PSH | POP)) & Rd[1]);
	assign s3[0] = EXEC1 & ((~(UJMP | JMP | STORE | LOAD | NOP | STP | PSH | POP)) & Rd[0]);
	assign s4 = EXEC1 & ~(LOAD | STORE);
	assign RAMd_wren = EXEC1 & STORE;
	assign RAMd_en = EXEC1 & (STORE | LOAD);
	assign RAMi_en = EXEC1 & ~STP | EXEC2 & (LOAD | MUL | MLA | MLS);
	assign ALU_en = LOAD | STORE;
	assign E2 = EXEC1 & (LOAD | MUL | MLA | MLS | POP);
	assign stack_en = (EXEC1 & PSH) | POP;
	assign stack_rst = STP;
	assign stack_rw = POP;
	
endmodule
	