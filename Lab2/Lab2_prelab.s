.global _start
_start:
	
.global main
.global PrintChar

.equ JTAG_UART_BASE, 0x10001000		#address of first JTAG UART register
.equ DATA_OFFSET, 0  				#offset of JTAG UART data resgister
.equ STATUS_OFFSET, 4  				#offset of JTAG UART status reegister
.equ WSPACE_MASK, 0xFFFF  			#used in AND operation to check status

main:
    movi r2, '\n'	#new line in r2
    call PrintChar
    
    movi r2, '2'	#2 into r2
    call PrintChar  
    
    movi r2, '7'   	#7 into r2
    call PrintChar  
    
    movi r2, '4'   	#4 into r2
    call PrintChar
    
    movi r2, '\n'	#new line in r2
    call PrintChar
_end:
		br _end

PrintChar:
    subi	sp, sp, 8			#adjust stack pointer down to reserve space
	stw		r3, 4(sp)			#save value of register r3 so it can be a temp
	stw 	r4, 0(sp)			#^						r4 	^
	movia 	r3, JTAG_UART_BASE	#point to first memory-mapped I/O register
pc_loop:
	ldwio	r4, STATUS_OFFSET(r3)	#read bits from status register
	andhi	r4, r4, WSPACE_MASK		#mask off lower bits to isolate upper bits
	beq		r4, r0, pc_loop			#if upper bits are zero, loop again
	
	stwio	r2, DATA_OFFSET(r3)		#otherwise, write character to data register
	ldw		r3, 4(sp)			#restore value of r3 from stack
	ldw		r4, 0(sp)			#restoer value of r4 from stack
	addi	sp, sp, 8			#readjust stack pointer up to deallocate space
	ret