.equ	JTAG_UART_BASE,	0x10001000
.equ	DATA_OFFSET,	0
.equ	STATUS_OFFSET,	4
.equ	WSPACE_MASK,	0xFFFF


.text

.global _start
.org 0x0000
_start:

	
	movia 	sp, 0x7FFFFC
	ldw		r4, N(r0)
	movia	r5, LIST
	movia	r2, STRING
	call 	PrintString				# print "Lab 4\n"
	
	call	ShowByteList			# print elements in list		

_end:
	br _end

GetChar:
	subi	sp, sp, 8
	stw		r3, 0(sp)
	stw		r4, 4(sp)

gc_loop:
	movia	r3, JTAG_UART_BASE
	ldwio	r2, DATA_OFFSET(r3)
	andi	r4, r2, 0x8000
	
	beq		r4, r0, gc_loop

	ldw		r3, 0(sp)
	ldw		r4, 4(sp)
	addi	sp, sp, 8
	ret

PrintChar:
	subi	sp, sp, 8				#adjust stack and save r3 and r4 so we can use them
	stw		r3, 4(sp)
	stw		r4, 0(sp)
	movia	r3, JTAG_UART_BASE		#make r4 point to first memory-mapper I/O register
pc_loop:
	ldwio	r4, STATUS_OFFSET(r3)	#read bits from status register
	andhi	r4, r4, WSPACE_MASK		#mask off lower bits to isolate upper bits
	beq		r4, r0, pc_loop			#if upper bits are zero, loop again
	stwio	r2, DATA_OFFSET(r3)		#else, write char to data register
	ldw		r3, 4(sp)				#restore r3 and r4
	ldw		r4, 0(sp)
	addi	sp, sp, 8				#fix stack
	ret								#return to calling subroutine


PrintString:
    subi	sp, sp, 8
    stw		r2, 8(sp)			# save r4 on the stack
	stw		r3, 4(sp)
	stw		ra, 0(sp)
	
	mov		r3, r2
	#br ps_end_loop

ps_loop:
	ldb 	r2, 0(r3)
ps_loop_if:
	bne		r2, r0, ps_loop_end_if
ps_loop_then:
	br		ps_end_loop
ps_loop_end_if:
	call 	PrintChar
	addi 	r3, r3, 1
	
	br		ps_loop
ps_end_loop:
	ldw		r2, 8(sp)
	ldw		r3, 4(sp)
	ldw		ra, 0(sp)
	addi	sp, sp, 8
	
	ret

PrintHexDigit:
	subi	sp, sp, 12
	stw		r2, 8(sp)
	stw		r3, 4(sp)
	stw		ra, 0(sp)
	
	mov		r3, r2
pnd_if:
	movi	r2, 9
	ble		r3, r2, pnd_else
pnd_then:
	subi	r2, r3, 10
	addi	r2, r2, 'A'
	br		pnd_end_if
pnd_else:
	addi	r2, r3, '0'
pnd_end_if:
	call	PrintChar
	ldw		r2, 8(sp)
	ldw		r3, 4(sp)
	ldw		ra, 0(sp)
	addi	sp, sp, 12
	ret
	

PrintHexByte:
	subi	sp, sp, 12
	stw		r2, 8(sp)
	stw		r3, 4(sp)
	stw		ra, 0(sp)
	
    mov		r3, r2
    srli	r2, r3, 4
    call	PrintHexDigit
    andi	r2, r3, 0xF
    call	PrintHexDigit
    
	ldw		r2, 8(sp)
	ldw		r3, 4(sp)
	ldw		ra, 0(sp)
	addi	sp, sp, 8

	
	ret
	
	
ShowByteList:
	subi	sp, sp, 24
	stw		r4, 12(sp)
	stw		r5, 8(sp)
	stw		r6, 4(sp)
	stw		ra, 0(sp)
	stw		r2, 16(sp)
	stw		r7, 20(sp)
	
LOOP:
	ldbu	r2, 0(r5)		# load first element in list into r2
	call	PrintHexByte	# print current element
	movi	r2, '?'
	call	PrintChar		# Call to print '?'
	movi	r2, ' '
	call	PrintChar		# Call to print blank space
	call	GetChar
	mov		r7, r2			# store value of r2 in r7 before it's changed
	call	PrintChar
	movi	r2, '\n'
	call 	PrintChar		# print '\n'
	movi	r6, 'Z'
	bne		r6, r7, neq_z
	stb		r0, 0(r5)		# store 0 into current list element
	
neq_z:	
	addi	r5, r5, 1		# increment to r5 to point to next element in list
	subi	r4, r4, 1		# decrement n - used for branch condition
	bgt		r4, r0, LOOP	# keep looping if n > 0
	
	ldw		r4, 12(sp)
	ldw		r5, 8(sp)
	ldw		r6, 4(sp)
	ldw		ra, 0(sp)
	ldw		r2, 16(sp)
	ldw		r7, 20(sp)
	addi	sp, sp, 20
	
	ret


#----------------

				.org 0x1000
N: 				.word 4
STRING:			.asciz "Lab 4\n"
LIST: 			.byte 0x88, 0xA3, 0xF2, 0x1C

				.end

	
