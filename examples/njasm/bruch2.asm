//
// version
//
	.vers	8

//
// execution framework
//
__start:
	call	_main
	call	_exit
__stop:
	jmp	__stop

//
// Integer readInteger()
//
_readInteger:
	asf	0
	rdint
	popr
	rsf
	ret

//
// void writeInteger(Integer)
//
_writeInteger:
	asf	0
	pushl	-3
	wrint
	rsf
	ret

//
// Character readCharacter()
//
_readCharacter:
	asf	0
	rdchr
	popr
	rsf
	ret

//
// void writeCharacter(Character)
//
_writeCharacter:
	asf	0
	pushl	-3
	wrchr
	rsf
	ret

//
// Integer char2int(Character)
//
_char2int:
	asf	0
	pushl	-3
	popr
	rsf
	ret

//
// Character int2char(Integer)
//
_int2char:
	asf	0
	pushl	-3
	popr
	rsf
	ret

//
// void exit()
//
_exit:
	asf	0
	halt
	rsf
	ret

//
// void writeString(String)
//
_writeString:
	asf	1
	pushc	0
	popl	0
	jmp	_writeString_L2
_writeString_L1:
	pushl	-3
	pushl	0
	getfa
	call	_writeCharacter
	drop	1
	pushl	0
	pushc	1
	add
	popl	0
_writeString_L2:
	pushl	0
	pushl	-3
	getsz
	lt
	brt	_writeString_L1
	rsf
	ret

//
// void main()
//
_main:
	asf	6
	new	2
	popg	0
	pushc	26
	newa
	dup
	pushc	0
	pushc	49
	putfa
	dup
	pushc	1
	pushc	47
	putfa
	dup
	pushc	2
	pushc	49
	putfa
	dup
	pushc	3
	pushc	32
	putfa
	dup
	pushc	4
	pushc	43
	putfa
	dup
	pushc	5
	pushc	32
	putfa
	dup
	pushc	6
	pushc	49
	putfa
	dup
	pushc	7
	pushc	47
	putfa
	dup
	pushc	8
	pushc	50
	putfa
	dup
	pushc	9
	pushc	32
	putfa
	dup
	pushc	10
	pushc	43
	putfa
	dup
	pushc	11
	pushc	32
	putfa
	dup
	pushc	12
	pushc	49
	putfa
	dup
	pushc	13
	pushc	47
	putfa
	dup
	pushc	14
	pushc	51
	putfa
	dup
	pushc	15
	pushc	32
	putfa
	dup
	pushc	16
	pushc	43
	putfa
	dup
	pushc	17
	pushc	32
	putfa
	dup
	pushc	18
	pushc	46
	putfa
	dup
	pushc	19
	pushc	46
	putfa
	dup
	pushc	20
	pushc	46
	putfa
	dup
	pushc	21
	pushc	32
	putfa
	dup
	pushc	22
	pushc	43
	putfa
	dup
	pushc	23
	pushc	32
	putfa
	dup
	pushc	24
	pushc	49
	putfa
	dup
	pushc	25
	pushc	47
	putfa
	call	_writeString
	drop	1
	call	_readInteger
	pushr
	popl	3
	pushc	10
	call	_writeCharacter
	drop	1
	pushc	1
	popl	0
	pushg	0
	pushc	1
	putf	0
	pushg	0
	pushc	1
	putf	1
	jmp	__2
__1:
	pushl	0
	pushc	1
	add
	popl	0
	pushg	0
	pushg	0
	getf	1
	pushl	0
	pushg	0
	getf	0
	mul
	add
	putf	0
	pushg	0
	pushg	0
	getf	1
	pushl	0
	mul
	putf	1
__2:
	pushl	0
	pushl	3
	lt
	brt	__1
__3:
	pushc	9
	newa
	dup
	pushc	0
	pushc	90
	putfa
	dup
	pushc	1
	pushc	-61
	putfa
	dup
	pushc	2
	pushc	-92
	putfa
	dup
	pushc	3
	pushc	104
	putfa
	dup
	pushc	4
	pushc	108
	putfa
	dup
	pushc	5
	pushc	101
	putfa
	dup
	pushc	6
	pushc	114
	putfa
	dup
	pushc	7
	pushc	58
	putfa
	dup
	pushc	8
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	10
	call	_writeCharacter
	drop	1
	pushc	8
	newa
	dup
	pushc	0
	pushc	78
	putfa
	dup
	pushc	1
	pushc	101
	putfa
	dup
	pushc	2
	pushc	110
	putfa
	dup
	pushc	3
	pushc	110
	putfa
	dup
	pushc	4
	pushc	101
	putfa
	dup
	pushc	5
	pushc	114
	putfa
	dup
	pushc	6
	pushc	58
	putfa
	dup
	pushc	7
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	10
	call	_writeCharacter
	drop	1
	pushc	10
	call	_writeCharacter
	drop	1
	pushg	0
	getf	0
	pushg	0
	getf	1
	call	_ggt
	drop	2
	pushr
	popl	1
	pushc	8
	newa
	dup
	pushc	0
	pushc	32
	putfa
	dup
	pushc	1
	pushc	32
	putfa
	dup
	pushc	2
	pushc	32
	putfa
	dup
	pushc	3
	pushc	71
	putfa
	dup
	pushc	4
	pushc	71
	putfa
	dup
	pushc	5
	pushc	84
	putfa
	dup
	pushc	6
	pushc	58
	putfa
	dup
	pushc	7
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	10
	call	_writeCharacter
	drop	1
	pushc	10
	call	_writeCharacter
	drop	1
	pushg	0
	pushg	0
	getf	0
	pushl	1
	div
	putf	0
	pushg	0
	pushg	0
	getf	1
	pushl	1
	div
	putf	1
	pushc	9
	newa
	dup
	pushc	0
	pushc	90
	putfa
	dup
	pushc	1
	pushc	-61
	putfa
	dup
	pushc	2
	pushc	-92
	putfa
	dup
	pushc	3
	pushc	104
	putfa
	dup
	pushc	4
	pushc	108
	putfa
	dup
	pushc	5
	pushc	101
	putfa
	dup
	pushc	6
	pushc	114
	putfa
	dup
	pushc	7
	pushc	58
	putfa
	dup
	pushc	8
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	10
	call	_writeCharacter
	drop	1
	pushc	8
	newa
	dup
	pushc	0
	pushc	78
	putfa
	dup
	pushc	1
	pushc	101
	putfa
	dup
	pushc	2
	pushc	110
	putfa
	dup
	pushc	3
	pushc	110
	putfa
	dup
	pushc	4
	pushc	101
	putfa
	dup
	pushc	5
	pushc	114
	putfa
	dup
	pushc	6
	pushc	58
	putfa
	dup
	pushc	7
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushc	10
	call	_writeCharacter
	drop	1
	pushc	10
	call	_writeCharacter
	drop	1
	pushc	18
	newa
	dup
	pushc	0
	pushc	78
	putfa
	dup
	pushc	1
	pushc	97
	putfa
	dup
	pushc	2
	pushc	99
	putfa
	dup
	pushc	3
	pushc	104
	putfa
	dup
	pushc	4
	pushc	107
	putfa
	dup
	pushc	5
	pushc	111
	putfa
	dup
	pushc	6
	pushc	109
	putfa
	dup
	pushc	7
	pushc	109
	putfa
	dup
	pushc	8
	pushc	97
	putfa
	dup
	pushc	9
	pushc	115
	putfa
	dup
	pushc	10
	pushc	116
	putfa
	dup
	pushc	11
	pushc	101
	putfa
	dup
	pushc	12
	pushc	108
	putfa
	dup
	pushc	13
	pushc	108
	putfa
	dup
	pushc	14
	pushc	101
	putfa
	dup
	pushc	15
	pushc	110
	putfa
	dup
	pushc	16
	pushc	58
	putfa
	dup
	pushc	17
	pushc	32
	putfa
	call	_writeString
	drop	1
	call	_readInteger
	pushr
	popl	5
	pushc	10
	call	_writeCharacter
	drop	1
	pushg	0
	getf	0
	pushg	0
	getf	1
	div
	call	_writeInteger
	drop	1
	pushc	46
	call	_writeCharacter
	drop	1
	pushc	0
	popl	4
	pushg	0
	getf	0
	popl	2
	jmp	__5
__4:
	pushl	2
	pushg	0
	getf	1
	mod
	pushc	10
	mul
	popl	2
	pushl	2
	pushg	0
	getf	1
	div
	call	_writeInteger
	drop	1
	pushl	4
	pushc	1
	add
	popl	4
__5:
	pushl	4
	pushl	5
	lt
	brt	__4
__6:
	pushc	10
	call	_writeCharacter
	drop	1
__0:
	rsf
	ret

//
// Integer ggt(Integer, Integer)
//
_ggt:
	asf	2
	pushl	-4
	popl	0
	pushl	-3
	popl	1
	jmp	__9
__8:
	pushl	0
	pushl	1
	gt
	brf	__11
	pushl	0
	pushl	1
	sub
	popl	0
	jmp	__12
__11:
	pushl	1
	pushl	0
	sub
	popl	1
__12:
__9:
	pushl	0
	pushl	1
	ne
	brt	__8
__10:
	pushl	0
	popr
	jmp	__7
__7:
	rsf
	ret
