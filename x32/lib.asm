%define UINT32_MIN 0
%define UINT32_MAX 4294967295

%define INT32_MIN -2147483648
%define INT32_MAX 2147483647

section .data
    true  db "true", 0
    false db "false", 0

section .text

; --- Print ---

; fn print_uint32(n: eax uint32): void
; prints an unsigned 32-bit integer stored in eax.
print_uint32:
    push eax
    push ecx
    push edx
    push esi

    xor ecx, ecx

.divideLoop:
    inc ecx
    xor edx, edx

    mov esi, 10
    idiv esi
  
    add edx, 48
    push edx
  
    test eax, eax
    jnz .divideLoop

.printLoop:
    dec ecx
    mov eax, esp

    mov edx, 1
    call print_str_len

    pop eax
    test ecx, ecx
    jnz .printLoop

    pop esi
    pop edx
    pop ecx
    pop eax
    ret

; fn print_int32(n: eax int64): void
; prints a signed 32-bit integer (in two's complement format) stored in rax.
print_int32:
    push eax

    test eax, eax
    jns .positive

    push eax

    mov eax, '-'
    call print_char

    pop eax

    not eax
    inc eax

.positive:
    call println_uint32

    pop eax
    ret

; fn print_str(s: eax &str): void
; prints a string pointed by eax.
print_str:
    push eax
    call str_len

    mov edx, eax
    pop eax

    call print_str_len
    ret

; fn print_str_len(s: eax &str, len: edx uint32): void
; prints a string pointed by eax, with the length specified by edx.
print_str_len:
    push ebx
    push eax
    push ecx

    mov ecx, eax
    mov ebx, 1
    mov eax, 4
    int 80h 

    pop ecx
    pop eax
    pop ebx
    ret

; fn print_bool(b: eax bool): void
; prints a boolean (i.e. 0 or 1) stored in eax.
print_bool:
    push eax
    test eax, eax
    jnz .true

    mov eax, false
    jmp .endtrue
.true:
    mov eax, true
.endtrue:
    call print_str

    pop eax
    ret

; fn print_char(c: eax char): void
; prints a character stored in eax.
print_char:
    push eax
    mov eax, esp
    call print_str

    pop eax
    ret

; --- Println ---

; fn println_uint32(n: eax uint32): void
; prints an unsigned 32-bit integer stored in eax, and then a newline.
println_uint32:
    call print_uint32
    call println
    ret

; fn println_int32(n: eax int64): void
; prints a signed 32-bit integer (in two's complement format) stored in rax, and then a newline.
println_int32:
    call print_int32
    call println
    ret

; fn println_str(s: eax &str): void
; prints a string pointed by eax, and then a newline.
println_str:
    call print_str
    call println
    ret

; fn println_str_len(s: eax &str, len: edx uint32)
; prints a string pointed by eax, with the length specified by edx, and then a newline.
println_str_len:
    call print_str_len
    call println
    ret

; fn println_bool(b: eax bool): void
; prints a boolean (i.e. 0 or 1) stored in eax, and then a newline.
println_bool:
    call print_bool
    call println
    ret

; fn println_char(c: eax char): void
; prints a character stored in eax, and then a newline.
println_char:
    call print_char
    call println
    ret

; --- Helper Functions ---

; fn println(): void
; prints a newline character.
println:
    push eax
    mov eax, 0Ah
    call print_char

    pop eax
    ret

; fn str_len(s: eax &str): eax uint32
; calculates the length of a zero-terminated string pointed by eax, and then returns the result in eax.
str_len:
    push ebx
    mov ebx, eax

.nextchar:
    cmp byte [eax], 0
    jz .finished
    inc eax
    jmp .nextchar

.finished:
    sub eax, ebx
    pop ebx
    ret

; fn read_input(buffer: eax &mut str, len: edx uint32): void
; reads 'len' bytes from stdin and stores them in 'buffer'.

; help: use the bss section to reserve some space.
read_input:
    push ecx
    push ebx
    push eax

    mov ecx, eax
    mov eax, 3
    mov ebx, 0
    int 80h

    pop eax
    pop ebx
    pop ecx
    ret

; fn input(prompt: eax &str, buffer: ebx &mut str, len: edx uint32)
; syntactic sugar for printing a prompt and then reading 'len' bytes from stdin and storing them in 'buffer'.
input:
    push eax
    push ebx
    push edx

    call print_str

    mov eax, ebx
    call read_input

    pop edx
    pop ebx
    pop eax
    ret

; fn atoi(s: eax &str): eax uint32
; converts a number inside a string pointed by eax, and returns the number in eax.
atoi:
    push ebx
    push ecx
    push edx
    push esi

    mov esi, eax
    mov eax, 0
    mov ecx, 0

.multiplyLoop:
    xor ebx, ebx
    mov bl, [esi + ecx]

    cmp bl, 48
    jl .finished
    cmp bl, 57
    jg .finished

    sub bl, 48
    add eax, ebx
    mov ebx, 10
    mul ebx
    inc ecx

    jmp .multiplyLoop

.finished:
    cmp ecx, 0
    je .restore
    mov ebx, 10
    div ebx

.restore:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

; fn exit(status: eax uint32): never
; exits the program with the status code defined in eax.

; note: call this function with 'jmp', to save some space in memory; since this won't return.
exit:
    mov ebx, eax
    mov eax, 1
    int 80h
