%define UINT64_MIN 0
%define UINT64_MAX 18446744073709551615

%define INT64_MIN -9223372036854775808
%define INT64_MAX 9223372036854775807

section .data
    true  db "true", 0
    false db "false", 0

section .text

; --- Print ---

; fn print_uint64(n: rax uint64): void
; prints an unsigned 64-bit integer stored in rax.
print_uint64:
    push rax
    push rcx
    push rdx
    push rsi

    xor rcx, rcx

.divideLoop:
    inc rcx
    xor rdx, rdx

    mov rsi, 10
    idiv rsi

    add rdx, 48
    push rdx

    test rax, rax
    jnz .divideLoop

.printLoop:
    dec rcx
    mov rax, rsp

    mov rdx, 1
    call print_str_len

    pop rax
    test rcx, rcx
    jnz .printLoop

    pop rsi
    pop rdx
    pop rcx
    pop rax
    ret

; fn print_int64(n: rax int64): void
; prints a signed 64-bit integer (in two's complement format) stored in rax.
print_int64:
    push rax

    test rax, rax
    jns .positive

    push rax

    mov rax, '-'
    call print_char

    pop rax

    not rax
    inc rax

.positive:
    call println_uint64

    pop rax
    ret

; fn print_str(s: rax &str): void
; prints a string pointed by rax.
print_str:
    push rax
    call str_len

    mov rdx, rax
    pop rax

    call print_str_len
    ret

; fn print_str_len(s: rax &str, len: rdx uint64): void
; prints a string pointed by rax, with the length specified by rdx.
print_str_len:
    push rsi
    push rdi
    push rax
    push rcx

    mov rsi, rax
    mov rax, 1
    mov rdi, 1
    syscall

    pop rcx
    pop rax
    pop rdi
    pop rsi
    ret

; fn print_bool(b: rax bool): void
; prints a boolean (i.e. 0 or 1) stored in rax.
print_bool:
    push rax
    test rax, rax
    jnz .true

    mov rax, false
    jmp .endtrue
.true:
    mov rax, true
.endtrue:
    call print_str

    pop rax
    ret

; fn print_char(c: rax char): void
; prints a character stored in rax.
print_char:
    push rax
    mov rax, rsp
    call print_str

    pop rax
    ret

; --- Println ---

; fn println_uint64(n: rax uint64): void
; prints an unsigned 64-bit integer stored in rax, and then a newline.
println_uint64:
    call print_uint64
    call println
    ret

; fn println_int64(n: rax int64): void
; prints a signed 64-bit integer (in two's complement format) stored in rax, and then a newline.
println_int64:
    call print_int64
    call println
    ret

; fn println_str(s: rax &str): void
; prints a string pointed by rax, and then a newline.
println_str:
    call print_str
    call println
    ret

; fn println_str_len(s: rax &str, len: rdx uint64)
; prints 
println_str_len:
    call print_str_len
    call println
    ret

; fn println_bool(b: rax bool): void
; prints a boolean (i.e. 0 or 1) stored in rax, and then a newline.
println_bool:
    call print_bool
    call println
    ret

; fn println_char(c: rax char): void
; prints a character stored in rax, and then a newline.
println_char:
    call print_char
    call println
    ret

; --- Helper Functions ---

; fn println(): void
; prints a newline character.
println:
    push rax
    mov rax, 0Ah
    call print_char

    pop rax
    ret

; fn str_len(s: rax &str): rax uint64
; calculates the length of a zero-terminated string pointed by rax, and then returns the result in rax.
str_len:
  push rbx
  mov rbx, rax

  .nextchar:
    cmp byte [rax], 0
    jz .finished
    inc rax
    jmp .nextchar

  .finished:
    sub rax, rbx
    pop rbx
    ret

; fn read_input(buffer: rax &str, len: rdx uint64)
; reads 'len' bytes from stdin and stores them in 'buffer'.

; help: use the bss section to reserve some space.
read_input:
    push rsi
    push rdi
    push rax
    push rdx

    mov rsi, rax
    mov rax, 0
    mov rdi, 0
    syscall

    pop rdx
    pop rax
    pop rdi
    pop rsi
    ret

; fn input(prompt: rax &str, buffer: rbx &str, len: rdx uint64)
; syntactic sugar for printing a prompt and then reading 'len' bytes from stdin and storing them in 'buffer'.
input:
    push rax
    push rbx
    push rdx

    call print_str

    mov rax, rbx
    call read_input

    pop rdx
    pop rbx
    pop rax
    ret

; fn atoi(s: rax &str): rax uint64
; converts a number inside a string pointed by rax, and returns the number in rax.
atoi:
    push rbx
    push rcx
    push rdx
    push rsi

    mov rsi, rax
    mov rax, 0
    mov rcx, 0

.multiplyLoop:
    xor rbx, rbx
    mov bl, [rsi + rcx]

    cmp bl, 48
    jl .finished
    cmp bl, 57
    jg .finished

    sub bl, 48
    add rax, rbx
    mov rbx, 10
    mul rbx
    inc rcx

    jmp .multiplyLoop

.finished:
    cmp rcx, 0
    je .restore
    mov rbx, 10
    div rbx

.restore:
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    ret

; fn exit(status: rax uint64): never
; exits the program with the status code defined in rax.

; note: call this function with 'jmp', since this doesn't have a 'ret' instruction, to save some space in memory.
exit:
    mov rdi, rax
    mov rax, 60
    syscall
