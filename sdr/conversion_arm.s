
TEXT ·Ui8toi16b(SB),7,$0
	MOVW	input+0(FP), R1
	MOVW	input_len+4(FP), R2
	MOVW	output+12(FP), R3
	MOVW	output_len+12(FP), R4
	// Choose the shortest length
	MOVW	R4>>1, R4
	CMP	R2, R4
	MOVW.LT	R4, R2
	// If no input then skip loop
	CMP	$0, R2
	BEQ	ui8toi16b_done
	// Calculate end of input
	ADD	R1, R2
ui8toi16b_loop:
	MOVBU	0(R1), R0
	ADD	$1, R1

	SUB	$128, R0

	MOVBU  	R0, 0(R3)
	MOVBU  	R0, 1(R3)
	ADD	$2, R3

	CMP	R2, R1
	BLT	ui8toi16b_loop
ui8toi16b_done:
	RET

TEXT ·Ui8toc64(SB),7,$0
	MOVW	input+0(FP), R1
	MOVW	input_len+4(FP), R2
	MOVW	output+12(FP), R3
	MOVW	output_len+16(FP), R0
	// Choose the shortest length
	MOVW	R0<<1, R0
	CMP	R2, R0
	MOVW.LT	R0, R2
	// If no input then skip loop
	CMP	$0, R2
	BEQ	ui8toc64_done
	ADD	R1, R2
ui8toc64_loop:
	MOVBU	0(R1), R4	// real
	MOVBU	1(R1), R5	// imag
	ADD	$2, R1

	SUB	$128, R4
	SUB	$128, R5
	MOVW	R4, F0
	MOVWF	F0, F0
	MOVW	R5, F1
	MOVWF	F1, F1

	MOVF	F0, 0(R3)	// real
	MOVF	F1, 4(R3)	// imag
	ADD	$8, R3

	CMP	R2, R1
	BLT	ui8toc64_loop
ui8toc64_done:
	RET