# REQUIRES: x86
# RUN: llvm-mc -filetype=obj -triple=x86_64-unknown-linux %s -o %t.o
# RUN: llvm-mc -filetype=obj -triple=x86_64-pc-linux %S/Inputs/gotpc-relax-und-dso.s -o %tdso.o
# RUN: ld.lld -shared %tdso.o -soname=t.so -o %t.so
# RUN: ld.lld --hash-style=sysv -shared %t.o %t.so -o %t
# RUN: llvm-readobj -r -S %t | FileCheck --check-prefix=RELOC %s
# RUN: llvm-objdump --no-print-imm-hex -d %t | FileCheck --check-prefix=DISASM %s

# RELOC:      Relocations [
# RELOC-NEXT:   Section ({{.*}}) .rela.dyn {
# RELOC-NEXT:     R_X86_64_GLOB_DAT foo 0x0
# RELOC-NEXT:     R_X86_64_GLOB_DAT und 0x0
# RELOC-NEXT:     R_X86_64_GLOB_DAT dsofoo 0x0
# RELOC-NEXT:   }
# RELOC-NEXT: ]

# 0x101e + 7 - 36 = 0x1001
# 0x1025 + 7 - 43 = 0x1001
# DISASM:      Disassembly of section .text:
# DISASM-EMPTY:
# DISASM-NEXT: <foo>:
# DISASM-NEXT:     nop
# DISASM:      <hid>:
# DISASM-NEXT:     nop
# DISASM:      <_start>:
# DISASM-NEXT:    movq    4375(%rip), %rax
# DISASM-NEXT:    movq    4368(%rip), %rax
# DISASM-NEXT:    movq    4369(%rip), %rax
# DISASM-NEXT:    movq    4362(%rip), %rax
# DISASM-NEXT:    leaq    -36(%rip), %rax
# DISASM-NEXT:    leaq    -43(%rip), %rax
# DISASM-NEXT:    movq    4325(%rip), %rax
# DISASM-NEXT:    movq    4318(%rip), %rax
# DISASM-NEXT:    movq    4319(%rip), %rax
# DISASM-NEXT:    movq    4312(%rip), %rax
# DISASM-NEXT:    movq    4313(%rip), %rax
# DISASM-NEXT:    movq    4306(%rip), %rax
# DISASM-NEXT:    leaq    -92(%rip), %rax
# DISASM-NEXT:    leaq    -99(%rip), %rax
# DISASM-NEXT:    movq    4269(%rip), %rax
# DISASM-NEXT:    movq    4262(%rip), %rax

.text
.globl foo
.type foo, @function
foo:
 nop

.globl hid
.hidden hid
.type hid, @function
hid:
 nop

.globl _start
.type _start, @function
_start:
 movq und@GOTPCREL(%rip), %rax
 movq und@GOTPCREL(%rip), %rax
 movq dsofoo@GOTPCREL(%rip), %rax
 movq dsofoo@GOTPCREL(%rip), %rax
 movq hid@GOTPCREL(%rip), %rax
 movq hid@GOTPCREL(%rip), %rax
 movq foo@GOTPCREL(%rip), %rax
 movq foo@GOTPCREL(%rip), %rax
 movq und@GOTPCREL(%rip), %rax
 movq und@GOTPCREL(%rip), %rax
 movq dsofoo@GOTPCREL(%rip), %rax
 movq dsofoo@GOTPCREL(%rip), %rax
 movq hid@GOTPCREL(%rip), %rax
 movq hid@GOTPCREL(%rip), %rax
 movq foo@GOTPCREL(%rip), %rax
 movq foo@GOTPCREL(%rip), %rax
