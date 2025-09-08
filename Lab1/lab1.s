		.text
		.global _start
		.org	0x0000
	
_start:

		ldw	r2, A(r0)	#link memory to 
		ldw	r3, B(r0)
		ldw	r4, C(r0)
		ldw	r5, F(r0)
		ldw	r6, J(r0)
		ldw	r7, K(r0)
		ldw	r8, N(r0)
		ldw	r9, S(r0)
		
		
		addi	r5, r5, 2
		add		r4, r7, r5
		stw		r4, C(r0)		
		
		mul		r6, r3, r8
		stw		r6, J(r0)		
		
		sub		r6, r6, r2
		add		r9, r7, r6
		stw		r9, S(r0)		
		
_end:
		break

#--------


		.org 	0x1000
A:		.word 	1		#allocate memory and values
B:		.word 	2
C:		.skip 	4
F:		.word 	3
J:		.skip 	4
K:		.word 	4
N:		.word 	5
S:		.skip 	4
				.end
		

