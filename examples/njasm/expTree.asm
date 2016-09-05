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
// record { Boolean isLeaf; ExpTree left; ExpTree right; Character op; Integer value; } newInnerNode(Character, record { Boolean isLeaf; ExpTree left; ExpTree right; Character op; Integer value; }, record { Boolean isLeaf; ExpTree left; ExpTree right; Character op; Integer value; })
//
_newInnerNode:
	asf	1
	new	5
	popl	0
	pushl	0
	pushc	0
	putf	0
	pushl	0
	pushl	-4
	putf	1
	pushl	0
	pushl	-3
	putf	2
	pushl	0
	pushl	-5
	putf	3
	pushl	0
	popr
	jmp	__0
__0:
	rsf
	ret

//
// record { Boolean isLeaf; ExpTree left; ExpTree right; Character op; Integer value; } newLeafNode(Integer)
//
_newLeafNode:
	asf	1
	new	5
	popl	0
	pushl	0
	pushc	1
	putf	0
	pushl	0
	pushl	-3
	putf	4
	pushl	0
	popr
	jmp	__1
__1:
	rsf
	ret

//
// void print(record { Boolean isLeaf; ExpTree left; ExpTree right; Character op; Integer value; })
//
_print:
	asf	0
	pushl	-3
	getf	0
	brf	__3
	pushl	-3
	getf	4
	call	_writeInteger
	drop	1
	jmp	__4
__3:
	pushc	1
	newa
	dup
	pushc	0
	pushc	40
	putfa
	call	_writeString
	drop	1
	pushl	-3
	getf	3
	pushc	43
	eq
	brf	__5
	pushl	-3
	getf	1
	call	_print
	drop	1
	pushc	3
	newa
	dup
	pushc	0
	pushc	32
	putfa
	dup
	pushc	1
	pushc	43
	putfa
	dup
	pushc	2
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	-3
	getf	2
	call	_print
	drop	1
__5:
	pushl	-3
	getf	3
	pushc	45
	eq
	brf	__6
	pushl	-3
	getf	1
	call	_print
	drop	1
	pushc	3
	newa
	dup
	pushc	0
	pushc	32
	putfa
	dup
	pushc	1
	pushc	45
	putfa
	dup
	pushc	2
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	-3
	getf	2
	call	_print
	drop	1
__6:
	pushl	-3
	getf	3
	pushc	42
	eq
	brf	__7
	pushl	-3
	getf	1
	call	_print
	drop	1
	pushc	3
	newa
	dup
	pushc	0
	pushc	32
	putfa
	dup
	pushc	1
	pushc	42
	putfa
	dup
	pushc	2
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	-3
	getf	2
	call	_print
	drop	1
__7:
	pushl	-3
	getf	3
	pushc	47
	eq
	brf	__8
	pushl	-3
	getf	1
	call	_print
	drop	1
	pushc	3
	newa
	dup
	pushc	0
	pushc	32
	putfa
	dup
	pushc	1
	pushc	47
	putfa
	dup
	pushc	2
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	-3
	getf	2
	call	_print
	drop	1
__8:
	pushc	1
	newa
	dup
	pushc	0
	pushc	41
	putfa
	call	_writeString
	drop	1
__4:
__2:
	rsf
	ret

//
// void printSpace(Integer)
//
_printSpace:
	asf	1
	pushc	0
	popl	0
	jmp	__11
__10:
	pushl	0
	pushc	1
	add
	popl	0
	pushc	6
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
	pushc	32
	putfa
	dup
	pushc	4
	pushc	32
	putfa
	dup
	pushc	5
	pushc	32
	putfa
	call	_writeString
	drop	1
__11:
	pushl	0
	pushl	-3
	lt
	brt	__10
__12:
__9:
	rsf
	ret

//
// void print2(record { Boolean isLeaf; ExpTree left; ExpTree right; Character op; Integer value; }, Integer)
//
_print2:
	asf	0
	pushl	-4
	getf	0
	brf	__14
	pushc	12
	newa
	dup
	pushc	0
	pushc	110
	putfa
	dup
	pushc	1
	pushc	101
	putfa
	dup
	pushc	2
	pushc	119
	putfa
	dup
	pushc	3
	pushc	76
	putfa
	dup
	pushc	4
	pushc	101
	putfa
	dup
	pushc	5
	pushc	97
	putfa
	dup
	pushc	6
	pushc	102
	putfa
	dup
	pushc	7
	pushc	78
	putfa
	dup
	pushc	8
	pushc	111
	putfa
	dup
	pushc	9
	pushc	100
	putfa
	dup
	pushc	10
	pushc	101
	putfa
	dup
	pushc	11
	pushc	40
	putfa
	call	_writeString
	drop	1
	pushl	-4
	getf	4
	call	_writeInteger
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	41
	putfa
	call	_writeString
	drop	1
	jmp	__15
__14:
	pushc	13
	newa
	dup
	pushc	0
	pushc	110
	putfa
	dup
	pushc	1
	pushc	101
	putfa
	dup
	pushc	2
	pushc	119
	putfa
	dup
	pushc	3
	pushc	73
	putfa
	dup
	pushc	4
	pushc	110
	putfa
	dup
	pushc	5
	pushc	110
	putfa
	dup
	pushc	6
	pushc	101
	putfa
	dup
	pushc	7
	pushc	114
	putfa
	dup
	pushc	8
	pushc	78
	putfa
	dup
	pushc	9
	pushc	111
	putfa
	dup
	pushc	10
	pushc	100
	putfa
	dup
	pushc	11
	pushc	101
	putfa
	dup
	pushc	12
	pushc	40
	putfa
	call	_writeString
	drop	1
	pushl	-3
	pushc	1
	add
	popl	-3
	pushc	10
	call	_writeCharacter
	drop	1
	pushl	-3
	call	_printSpace
	drop	1
	pushc	1
	newa
	dup
	pushc	0
	pushc	39
	putfa
	call	_writeString
	drop	1
	pushl	-4
	getf	3
	call	_writeCharacter
	drop	1
	pushc	2
	newa
	dup
	pushc	0
	pushc	39
	putfa
	dup
	pushc	1
	pushc	44
	putfa
	call	_writeString
	drop	1
	pushc	10
	call	_writeCharacter
	drop	1
	pushl	-3
	call	_printSpace
	drop	1
	pushl	-4
	getf	1
	pushl	-3
	call	_print2
	drop	2
	pushc	1
	newa
	dup
	pushc	0
	pushc	44
	putfa
	call	_writeString
	drop	1
	pushc	10
	call	_writeCharacter
	drop	1
	pushl	-3
	call	_printSpace
	drop	1
	pushl	-4
	getf	2
	pushl	-3
	call	_print2
	drop	2
	pushc	1
	newa
	dup
	pushc	0
	pushc	41
	putfa
	call	_writeString
	drop	1
__15:
__13:
	rsf
	ret

//
// Integer eval(record { Boolean isLeaf; ExpTree left; ExpTree right; Character op; Integer value; })
//
_eval:
	asf	0
	pushl	-3
	getf	0
	brf	__17
	pushl	-3
	getf	4
	popr
	jmp	__16
	jmp	__18
__17:
	pushl	-3
	getf	3
	pushc	43
	eq
	brf	__19
	pushl	-3
	getf	1
	call	_eval
	drop	1
	pushr
	pushl	-3
	getf	2
	call	_eval
	drop	1
	pushr
	add
	popr
	jmp	__16
__19:
	pushl	-3
	getf	3
	pushc	45
	eq
	brf	__20
	pushl	-3
	getf	1
	call	_eval
	drop	1
	pushr
	pushl	-3
	getf	2
	call	_eval
	drop	1
	pushr
	sub
	popr
	jmp	__16
__20:
	pushl	-3
	getf	3
	pushc	42
	eq
	brf	__21
	pushl	-3
	getf	1
	call	_eval
	drop	1
	pushr
	pushl	-3
	getf	2
	call	_eval
	drop	1
	pushr
	mul
	popr
	jmp	__16
__21:
	pushl	-3
	getf	3
	pushc	47
	eq
	brf	__22
	pushl	-3
	getf	1
	call	_eval
	drop	1
	pushr
	pushl	-3
	getf	2
	call	_eval
	drop	1
	pushr
	div
	popr
	jmp	__16
__22:
__18:
__16:
	rsf
	ret

//
// void main()
//
_main:
	asf	1
	pushc	14
	newa
	dup
	pushc	0
	pushc	69
	putfa
	dup
	pushc	1
	pushc	120
	putfa
	dup
	pushc	2
	pushc	112
	putfa
	dup
	pushc	3
	pushc	84
	putfa
	dup
	pushc	4
	pushc	114
	putfa
	dup
	pushc	5
	pushc	101
	putfa
	dup
	pushc	6
	pushc	101
	putfa
	dup
	pushc	7
	pushc	32
	putfa
	dup
	pushc	8
	pushc	83
	putfa
	dup
	pushc	9
	pushc	116
	putfa
	dup
	pushc	10
	pushc	97
	putfa
	dup
	pushc	11
	pushc	114
	putfa
	dup
	pushc	12
	pushc	116
	putfa
	dup
	pushc	13
	pushc	10
	putfa
	call	_writeString
	drop	1
	pushc	45
	pushc	5
	call	_newLeafNode
	drop	1
	pushr
	pushc	42
	pushc	43
	pushc	1
	call	_newLeafNode
	drop	1
	pushr
	pushc	3
	call	_newLeafNode
	drop	1
	pushr
	call	_newInnerNode
	drop	3
	pushr
	pushc	45
	pushc	4
	call	_newLeafNode
	drop	1
	pushr
	pushc	7
	call	_newLeafNode
	drop	1
	pushr
	call	_newInnerNode
	drop	3
	pushr
	call	_newInnerNode
	drop	3
	pushr
	call	_newInnerNode
	drop	3
	pushr
	popl	0
	pushl	0
	call	_print
	drop	1
	pushc	3
	newa
	dup
	pushc	0
	pushc	32
	putfa
	dup
	pushc	1
	pushc	61
	putfa
	dup
	pushc	2
	pushc	32
	putfa
	call	_writeString
	drop	1
	pushl	0
	call	_eval
	drop	1
	pushr
	call	_writeInteger
	drop	1
	pushc	10
	call	_writeCharacter
	drop	1
	pushl	0
	pushc	0
	call	_print2
	drop	2
	pushc	10
	call	_writeCharacter
	drop	1
__23:
	rsf
	ret
