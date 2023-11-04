; vim:ft=nasm

; int itoa(Integer number)
; Ascii to integer function (atoi)
atoi:
  push ebx ; preserving stuff on the
  push ecx ; stack to be
  push edx ; restored after
  push esi ; function funs

  mov esi, eax ; push pointer in eax into esi (the number to convert)
  mov eax, 0   ; initilizing eax
  mov ecx, 0   ; and ecx

.multiplyLoop:
  xor ebx, ebx        ; resets both lower and upper butes of ebx to be 0
  mov bl, [esi + ecx] ; move a single byte into ebx register's lower half

  cmp bl, 48   ; compare ebx register's lower half value against ascii value 48 (char value 0)
  jl .finished ; jump if less than to the `.finished` label
  cmp bl, 57   ; compare ebx register's lower half value against ascii value 57 (char value 9)
  jg .finished ; jump if greater than to the `.finished` label

  sub bl, 48   ; convert the ebx register's lower half to decimal representation of ascii value
  add eax, ebx ; add ebx to our register value in eax
  mov ebx, 10  ; move decimal value 10 into ebx
  mul ebx      ; multiply eax by ebx to get place value
  inc ecx      ; increment ecx (our counter register)

  jmp .multiplyLoop

.finished:
  cmp ecx, 0   ; compare ecx register's value against decimal 0 (our counter register)
  je .restore  ; jump if equal to 0 (no integer args were passed to atoi)
  mov ebx, 10  ; mvoe decimal value 10 into ebx
  div ebx      ; divide by value in ebx (in this case 10)

.restore:
  pop esi
  pop edx
  pop ecx
  pop ebx
  ret

; void iprint(Integer number)
; Integer printing function (itoa)
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

; void iprintLF(Integer number)
; Integer printing function with linefeed (itoa)
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

; int slen(String message)
; String length calculation function
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

; void sprint(String message)
; String printing function
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

; void sprintLF(String message)
; String printing with linefeed function
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

; void exit()
; Exit program and restore resources
quit:
  mov ebx, 0
  mov eax, 1
  int 80h
  ret
