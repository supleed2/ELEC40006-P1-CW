module DECODE
(
	input [15:0] instr,
	input FETCH,
	input EXEC,
	input COND_result,
	output R0_count,
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
	output RAMi_en
);
	wire msb, ls, [reg_ls, addr, op, Rd, Rs1, Rs2;
	assign msb = instr[15];		//MSB of the instruction word
	assign ls = instr[14];		//LOAD or STORE bit
	assign reg_ls = instr
	
	wire LOAD, STORE, UJMP, JMP, AND, OR, XOR, NOT, NND, NOR, XNR, MOV, ADD, ADC, ADO, SUB, SBC, SBO, MUL, MLA, MLS, MRT, LSL, LSR, ASR, ROR, RRC, NOP, STP;
	assign LOAD = 

endmodule
	