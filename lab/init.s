	.file	"init.c"
	.stabs	"kern/init.c",100,0,2,.Ltext0
	.text
.Ltext0:
	.stabs	"gcc2_compiled.",60,0,0,0
	.stabs	"int:t(0,1)=r(0,1);-2147483648;2147483647;",128,0,0,0
	.stabs	"char:t(0,2)=r(0,2);0;127;",128,0,0,0
	.stabs	"long int:t(0,3)=r(0,3);-2147483648;2147483647;",128,0,0,0
	.stabs	"unsigned int:t(0,4)=r(0,4);0;4294967295;",128,0,0,0
	.stabs	"long unsigned int:t(0,5)=r(0,5);0;4294967295;",128,0,0,0
	.stabs	"long long int:t(0,6)=r(0,6);-0;4294967295;",128,0,0,0
	.stabs	"long long unsigned int:t(0,7)=r(0,7);0;-1;",128,0,0,0
	.stabs	"short int:t(0,8)=r(0,8);-32768;32767;",128,0,0,0
	.stabs	"short unsigned int:t(0,9)=r(0,9);0;65535;",128,0,0,0
	.stabs	"signed char:t(0,10)=r(0,10);-128;127;",128,0,0,0
	.stabs	"unsigned char:t(0,11)=r(0,11);0;255;",128,0,0,0
	.stabs	"float:t(0,12)=r(0,1);4;0;",128,0,0,0
	.stabs	"double:t(0,13)=r(0,1);8;0;",128,0,0,0
	.stabs	"long double:t(0,14)=r(0,1);12;0;",128,0,0,0
	.stabs	"_Decimal32:t(0,15)=r(0,1);4;0;",128,0,0,0
	.stabs	"_Decimal64:t(0,16)=r(0,1);8;0;",128,0,0,0
	.stabs	"_Decimal128:t(0,17)=r(0,1);16;0;",128,0,0,0
	.stabs	"void:t(0,18)=(0,18)",128,0,0,0
	.stabs	"./inc/stdio.h",130,0,0,0
	.stabs	"./inc/stdarg.h",130,0,0,0
	.stabs	"va_list:t(2,1)=(2,2)=*(0,2)",128,0,0,0
	.stabn	162,0,0,0
	.stabn	162,0,0,0
	.stabs	"./inc/string.h",130,0,0,0
	.stabs	"./inc/types.h",130,0,0,0
	.stabs	"bool:t(4,1)=(4,2)=eFalse:0,True:1,;",128,0,0,0
	.stabs	" :T(4,3)=efalse:0,true:1,;",128,0,0,0
	.stabs	"int8_t:t(4,4)=(0,10)",128,0,0,0
	.stabs	"uint8_t:t(4,5)=(0,11)",128,0,0,0
	.stabs	"int16_t:t(4,6)=(0,8)",128,0,0,0
	.stabs	"uint16_t:t(4,7)=(0,9)",128,0,0,0
	.stabs	"int32_t:t(4,8)=(0,1)",128,0,0,0
	.stabs	"uint32_t:t(4,9)=(0,4)",128,0,0,0
	.stabs	"int64_t:t(4,10)=(0,6)",128,0,0,0
	.stabs	"uint64_t:t(4,11)=(0,7)",128,0,0,0
	.stabs	"intptr_t:t(4,12)=(4,8)",128,0,0,0
	.stabs	"uintptr_t:t(4,13)=(4,9)",128,0,0,0
	.stabs	"physaddr_t:t(4,14)=(4,9)",128,0,0,0
	.stabs	"ppn_t:t(4,15)=(4,9)",128,0,0,0
	.stabs	"size_t:t(4,16)=(4,9)",128,0,0,0
	.stabs	"ssize_t:t(4,17)=(4,8)",128,0,0,0
	.stabs	"off_t:t(4,18)=(4,8)",128,0,0,0
	.stabn	162,0,0,0
	.stabn	162,0,0,0
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"entering test_backtrace %d\n"
.LC1:
	.string	"leaving test_backtrace %d\n"
	.text
	.p2align 4,,15
	.stabs	"test_backtrace:F(0,18)",36,0,0,test_backtrace
	.stabs	"x:p(0,1)",160,0,0,32
	.globl	test_backtrace
	.type	test_backtrace, @function
test_backtrace:
	.stabn	68,0,13,.LM0-.LFBB1
.LM0:
.LFBB1:
.LFB0:
	.cfi_startproc
	pushl	%ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	subl	$24, %esp
	.cfi_def_cfa_offset 32
	.stabn	68,0,13,.LM1-.LFBB1
.LM1:
	movl	32(%esp), %ebx
	.stabn	68,0,14,.LM2-.LFBB1
.LM2:
	movl	$.LC0, (%esp)
	movl	%ebx, 4(%esp)
	call	cprintf
	.stabn	68,0,15,.LM3-.LFBB1
.LM3:
	testl	%ebx, %ebx
	jle	.L2
	.stabn	68,0,16,.LM4-.LFBB1
.LM4:
	leal	-1(%ebx), %eax
	movl	%eax, (%esp)
	call	test_backtrace
.L3:
	.stabn	68,0,19,.LM5-.LFBB1
.LM5:
	movl	%ebx, 4(%esp)
	movl	$.LC1, (%esp)
	call	cprintf
	.stabn	68,0,20,.LM6-.LFBB1
.LM6:
	addl	$24, %esp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	popl	%ebx
	.cfi_def_cfa_offset 4
	.cfi_restore 3
	ret
	.p2align 4,,7
	.p2align 3
.L2:
	.cfi_restore_state
	.stabn	68,0,18,.LM7-.LFBB1
.LM7:
	movl	$0, 8(%esp)
	movl	$0, 4(%esp)
	movl	$0, (%esp)
	call	mon_backtrace
	jmp	.L3
	.cfi_endproc
.LFE0:
	.size	test_backtrace, .-test_backtrace
	.stabs	"x:r(0,1)",64,0,0,3
.Lscope1:
	.section	.rodata.str1.1
.LC2:
	.string	"6828 decimal is %o octal!\n"
	.text
	.p2align 4,,15
	.stabs	"i386_init:F(0,18)",36,0,0,i386_init
	.globl	i386_init
	.type	i386_init, @function
i386_init:
	.stabn	68,0,24,.LM8-.LFBB2
.LM8:
.LFBB2:
.LFB1:
	.cfi_startproc
	.stabn	68,0,30,.LM9-.LFBB2
.LM9:
	movl	$end, %eax
	.stabn	68,0,24,.LM10-.LFBB2
.LM10:
	subl	$28, %esp
	.cfi_def_cfa_offset 32
	.stabn	68,0,30,.LM11-.LFBB2
.LM11:
	subl	$edata, %eax
	movl	%eax, 8(%esp)
	movl	$0, 4(%esp)
	movl	$edata, (%esp)
	call	memset
	.stabn	68,0,34,.LM12-.LFBB2
.LM12:
	call	cons_init
	.stabn	68,0,36,.LM13-.LFBB2
.LM13:
	movl	$6828, 4(%esp)
	movl	$.LC2, (%esp)
	call	cprintf
	.stabn	68,0,39,.LM14-.LFBB2
.LM14:
	movl	$5, (%esp)
	call	test_backtrace
	.p2align 4,,7
	.p2align 3
.L6:
	.stabn	68,0,43,.LM15-.LFBB2
.LM15:
	movl	$0, (%esp)
	call	monitor
	jmp	.L6
	.cfi_endproc
.LFE1:
	.size	i386_init, .-i386_init
.Lscope2:
	.section	.rodata.str1.1
.LC3:
	.string	"kernel panic at %s:%d: "
.LC4:
	.string	"\n"
	.text
	.p2align 4,,15
	.stabs	"_panic:F(0,18)",36,0,0,_panic
	.stabs	"file:p(0,19)=*(0,2)",160,0,0,32
	.stabs	"line:p(0,1)",160,0,0,36
	.stabs	"fmt:p(0,19)",160,0,0,40
	.globl	_panic
	.type	_panic, @function
_panic:
	.stabn	68,0,59,.LM16-.LFBB3
.LM16:
.LFBB3:
.LFB2:
	.cfi_startproc
	pushl	%esi
	.cfi_def_cfa_offset 8
	.cfi_offset 6, -8
	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset 3, -12
	subl	$20, %esp
	.cfi_def_cfa_offset 32
	.stabn	68,0,62,.LM17-.LFBB3
.LM17:
	movl	panicstr, %eax
	.stabn	68,0,59,.LM18-.LFBB3
.LM18:
	movl	40(%esp), %ebx
	.stabn	68,0,62,.LM19-.LFBB3
.LM19:
	testl	%eax, %eax
	je	.L11
	.p2align 4,,7
	.p2align 3
.L10:
	.stabn	68,0,78,.LM20-.LFBB3
.LM20:
	movl	$0, (%esp)
	call	monitor
	jmp	.L10
.L11:
	.stabn	68,0,64,.LM21-.LFBB3
.LM21:
	movl	%ebx, panicstr
	.stabn	68,0,67,.LM22-.LFBB3
.LM22:
#APP
# 67 "kern/init.c" 1
	cli; cld
# 0 "" 2
	.stabn	68,0,70,.LM23-.LFBB3
.LM23:
#NO_APP
	movl	36(%esp), %eax
	.stabn	68,0,69,.LM24-.LFBB3
.LM24:
	leal	44(%esp), %esi
	.stabn	68,0,70,.LM25-.LFBB3
.LM25:
	movl	$.LC3, (%esp)
	movl	%eax, 8(%esp)
	movl	32(%esp), %eax
	movl	%eax, 4(%esp)
	call	cprintf
	.stabn	68,0,71,.LM26-.LFBB3
.LM26:
	movl	%esi, 4(%esp)
	movl	%ebx, (%esp)
	call	vcprintf
	.stabn	68,0,72,.LM27-.LFBB3
.LM27:
	movl	$.LC4, (%esp)
	call	cprintf
	jmp	.L10
	.cfi_endproc
.LFE2:
	.size	_panic, .-_panic
	.stabs	"file:r(0,19)",64,0,0,0
	.stabs	"line:r(0,1)",64,0,0,0
	.stabs	"fmt:r(0,19)",64,0,0,3
.Lscope3:
	.section	.rodata.str1.1
.LC5:
	.string	"kernel warning at %s:%d: "
	.text
	.p2align 4,,15
	.stabs	"_warn:F(0,18)",36,0,0,_warn
	.stabs	"file:p(0,19)",160,0,0,32
	.stabs	"line:p(0,1)",160,0,0,36
	.stabs	"fmt:p(0,19)",160,0,0,40
	.globl	_warn
	.type	_warn, @function
_warn:
	.stabn	68,0,84,.LM28-.LFBB4
.LM28:
.LFBB4:
.LFB3:
	.cfi_startproc
	pushl	%ebx
	.cfi_def_cfa_offset 8
	.cfi_offset 3, -8
	subl	$24, %esp
	.cfi_def_cfa_offset 32
	.stabn	68,0,88,.LM29-.LFBB4
.LM29:
	movl	36(%esp), %eax
	.stabn	68,0,87,.LM30-.LFBB4
.LM30:
	leal	44(%esp), %ebx
	.stabn	68,0,88,.LM31-.LFBB4
.LM31:
	movl	$.LC5, (%esp)
	movl	%eax, 8(%esp)
	movl	32(%esp), %eax
	movl	%eax, 4(%esp)
	call	cprintf
	.stabn	68,0,89,.LM32-.LFBB4
.LM32:
	movl	40(%esp), %eax
	movl	%ebx, 4(%esp)
	movl	%eax, (%esp)
	call	vcprintf
	.stabn	68,0,90,.LM33-.LFBB4
.LM33:
	movl	$.LC4, (%esp)
	call	cprintf
	.stabn	68,0,92,.LM34-.LFBB4
.LM34:
	addl	$24, %esp
	.cfi_def_cfa_offset 8
	popl	%ebx
	.cfi_def_cfa_offset 4
	.cfi_restore 3
	ret
	.cfi_endproc
.LFE3:
	.size	_warn, .-_warn
	.stabs	"file:r(0,19)",64,0,0,0
	.stabs	"line:r(0,1)",64,0,0,0
	.stabs	"fmt:r(0,19)",64,0,0,0
.Lscope4:
	.comm	panicstr,4,4
	.stabs	"panicstr:G(0,19)",32,0,0,0
	.stabs	"",100,0,0,.Letext0
.Letext0:
	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
	.section	.note.GNU-stack,"",@progbits
