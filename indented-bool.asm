section .data
    true  db "true", 0
    false db "false", 0

section .text
global _start

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

iprint:
  push eax
  push ecx
  push edx
  push esi

  mov ecx, 0

  .divideLoop:
    inc ecx
    mov edx, 0
    mov esi, 10
    idiv esi
    add edx, 48
    push edx
    cmp eax, 0
    jnz .divideLoop

  .printLoop:
    dec ecx
    mov eax, esp
    call sprint

    pop eax
    cmp ecx, 0
    jnz .printLoop

    pop esi
    pop edx
    pop ecx
    pop eax
    ret

iprintLF:
  call iprint

  push eax
  mov eax, 0Ah
  push eax
  mov eax, esp
  call sprint

  pop eax
  pop eax
  ret

slen:
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

sprint:
  push edx
  push ecx
  push ebx
  push eax
  call slen

  mov edx, eax
  pop eax

  mov ecx, eax
  mov ebx, 1
  mov eax, 4
  int 80h

  pop ebx
  pop ecx
  pop edx
  ret

sprintLF:
  call sprint

  push eax
  mov eax, 0Ah
  push eax
  mov eax, esp
  call sprint

  pop eax
  pop eax
  ret

bprint:
    push eax
    cmp eax, 1
    je .true
    
    lea eax, [false]
    jmp .endtrue
.true:
    lea eax, [true]
.endtrue:
    call sprint

    pop eax
    ret

bprintLF:
  call bprint

  push eax
  mov eax, 0Ah
  push eax
  mov eax, esp
  call sprint

  pop eax
  pop eax
  ret

quit:
  mov ebx, 0
  mov eax, 1
  int 80h
  ret

; ---

_start:
  call main
  call quit

main:
  push ebp
  mov ebp, esp
  
  .exit:
    leave
    ret
