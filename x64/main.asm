%include "lib.asm"

; note: to load a pointer to some data here into a register, use the 'lea' instruction: 'lea rax, [msg]',
; or just a 'mov' instruction: 'mov rax, msg'.

; note: make sure all strings are zero-terminated.
section .data
  msg db "Hello, World!", 0

section .text
  global _start

; the entry point of the program; this calls the main function and then exits with the status code set to 0.
; note: don't write your program here, write it in 'main'.
_start:
  call main

  xor rax, rax
  jmp exit

; the main function. make sure the last instruction is a 'ret'.
main:
  mov rax, msg
  call println_str
  
  ret