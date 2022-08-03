#Dor Huri - 209409218
                .data
    .section  .rodata
error_str: .string "invalid input!\n"

  .text
  .globl pstrlen,replaceChar, pstrijcpy, swapCase, pstrijcmp

  .type pstrlen @function
pstrlen:
    #return pstring length
    movzbq  (%rdi), %rax            #move first byte of pstring to reurn value(%rax)
    ret
    .type replaceChar @function
replaceChar:
    #setting program
    movq    %rdi, %rcx              #%rcx get pstring
    movq    %rsi, %r8               #%r8 get old char
    movq    %rdx, %r9               #%r9 get new char
    movq    $0, %r11                #int i = 0
    call    pstrlen                 
    movq    %rax, %r10              #%r10 get pstring length    
    addq    $1, %rcx                #adding 1 byte to %rcx so we start from the string(first byte his length)
    

.char_replace_loop:
    movzbq  (%rcx), %rax            #%rax get first char of %rcx
    cmp     %r8, %rax               #checking if current char is new char
    jne     .char_not_equal         #in case there not equal
    movb     %r9b, (%rcx)           #replacing old char in new char at memory where %rbx point to
    addq    $1, %rcx                #moving to next char
    incq     %r11                   #%i++
    cmp      %r10,%r11              #checking if i >= pstring->len
    jns      .exit_replace          #so we finish loop
    jmp      .char_replace_loop     #otherwise we go back to loop  

.char_not_equal:
    addq    $1, %rcx                #going to next char in pstring
    incq    %r11                    #%i++
    cmp     %r10, %r11              #checking if i >= pstring->len
    jns     .exit_replace           #so we finish loop
    jmp     .char_replace_loop      #otherwise we go back to loop  
    
.exit_replace:
    subq    %r10, %rcx              #going back to start of string
    subq    $1, %rcx                #subtract one byte so we get to real first byet of pstring 
    movq    %rcx, %rax              #moving updated pstring to return value
    ret

   .type pstrijcpy @function
pstrijcpy:
    #setting program
    push    %r12                    #pushing callee register to stack
    movq    %rdi, %r12              #%r12 get first pstring
    movq    %rsi, %r9               #%r9 get second pstring
    movq    %rdx, %r10              #%r10 get start index i
    movq    %rcx, %r11              #%r10 get finish index j
    
    #checking for wrong input
    movzbq  (%r12), %rax            #%rax get first pstring length
    addq    $1, %r11                #we add 1 for j
    cmp     %r11, %rax              #checking if j > pstring1->length
    js      .invalid_pstrijcpy      #jump to invalid case 
    movzbq  (%r9), %rax             #%rax get second pstring length
    cmp     %r11, %rax              #checking if j > pstring2->length
    js      .invalid_pstrijcpy      #jump to invalid case
    cmp     $0, %r10                #checking if i < 0
    js      .invalid_pstrijcpy      #jump to invalid case
    
    #getting to start position in pstrings
    addq    $1, %r12                #moving 1 byte for first pstring
    addq    $1, %r9                 #moving 1 byte for second pstring
    addq    %r10, %r12              #moving i bytes for first pstring
    addq    %r10, %r9               #moving i bytes for second pstring
       
.cmp_ij:
    cmp     %r11, %r10              #checking if i > j
    jns      .exit_pstrijcpy        #we jump to exit       

.copy_str_loop:
    movzbq   (%r9), %rax            #%rax get first char of first pstring
    movb    %al, (%r12)             #we replace the current char in pstring1 with current char in pstring2
    addq    $1, %r12                #going to nexr char in pstring2
    addq    $1, %r9                 #going to nexr char in pstring1
    incq    %r10                    #i++
    jmp     .cmp_ij                 #jumping to check condition
    
.invalid_pstrijcpy:
    movq     $error_str, %rdi       #setting first parameter for printf
    xor      %rax, %rax             #convention setting %rax = 0
    call     printf
    movq     %r12, %rax             #moving original pstring to return value
    popq    %r12                    #popping %r12 from stack
    ret
    
.exit_pstrijcpy:
    subq     %r11, %r12             #going back to start of string
    subq     $1, %r12               #subtract one byte so we get to real first byet of pstring
    movq     %r12, %rax             #moving pstring to return value    
    popq    %r12                    #popping %r12 from stack
    ret
    
    .type swapCase @function
swapCase:
    movq    %rdi, %r8               #%r8 get pstring
    call    pstrlen
    movq    %rax, %r9               #%r9 get pstring length
    addq    $1, %r8                 #adding 1 byte to %r8 so we start from the string
    movq    $0, %r10                #int i = 0 
    jmp     .swap_loop              #going to loop

.swap_loop:
    cmp     %r10, %r9               #checking if i < pstring->length    
    ja     .start_case              #we jump to start case
    subq    %r9, %r8                #going back to start of string            
    subq    $1, %r8                 #subtract one byte so we get to real first byet of pstring
    movq    %r8, %rax               #moving pstring to return value 
    ret                   

.start_case:
    #checking which case for current char
    movzbq  (%r8), %rax             #%rax get current char in pstring
    cmp     $122, %rax              #checking if char is bigger then 'z'
    jns     .not_letter             #jump to not letter
    cmp     $97, %rax               #checking if char is bigger then 'a'
    jns     .lower_case             #jump to not lower case
    cmp     $90, %rax               #checking if char is bigger then 'Z'
    jns     .not_letter             #jump to not letter
    cmp     $65, %rax               #checking if char is bigger then 'A'
    jns     .upper_case             #jump to not upper case
    jmp     .not_letter             #then char is smaller then 'A' so jump no letter
    
    
.lower_case:
    subq    $32,%rax                #removing 32 so we get the letter in upper case
    movb    %al, (%r8)              #replacing the current char with upper char
    addq    $1, %r8                 #going to next char
    incq    %r10                    #i++    
    jmp     .swap_loop              #going back to loop
            
.upper_case:
    addq    $32,%rax                #adding 32 so we get the letter in lower case
    movb    %al, (%r8)              #replacing the current char with lower char
    addq    $1, %r8                 #going to next char
    incq    %r10                    #i++
    jmp     .swap_loop              #going back to loop
    
.not_letter:
    addq    $1, %r8                 #going to next char
    incq    %r10                    #i++
    jmp     .swap_loop              #going back to loop
    
    .type pstrijcmp @function
pstrijcmp:
    #setting program
    movq    %rdi, %r8               #%r8 get first pstring
    movq    %rsi, %r9               #%r9 get second pstring    
    movq    %rdx, %r10              #%r10 get start index i  
    movq    %rcx, %r11              #%r11 get finish index j
    addq    $1, %r11                #adding 1 for j
    
    #checking for wrong input
    movzbq  (%rdi), %rax            #%rax get firs pstring length
    cmp     %r11, %rax              #checking if j > pstring1->length
    js      .invalid_pstrijcmp      #jump to invalid    
    movzbq  (%rsi), %rax            #%rax get second pstring length
    cmp     %r11, %rax              #checking if j > pstring2->length
    js      .invalid_pstrijcmp      #jump to invalid        
    cmp     $0, %r10                #checking if i < 0            
    js      .invalid_pstrijcmp      #jump to invalid    
    
    #getting to start position in pstrings
    addq    $1, %r8                 #adding 1 byte to %r8 so we start from the string
    addq    $1, %r9                 #adding 1 byte to %r9 so we start from the string
    addq    %r10, %r8               #adding i byte to %r8 so we start from the string in index i
    addq    %r10, %r9               #adding i byte to %r9 so we start from the string in index i
    
    
.comp_ij:
    cmp     %r11, %r10              #checking if i >= j
    jns      .equal_pstring         #jump to equal pstring
    movzbq  (%r8), %rax             #%rax get first pstring char
    movzbq  (%r9), %rdi             #%rdi get second pstring char
    cmpb    %al, %dil               #we check if first char is bigger
    js      .str1_bigger            #we jump to str1_bigger
    cmpb    %dil, %al               #we check if second char is bigger
    js      .str2_bigger            #we jump to str2_bigger    
    addq    $1, %r8                 #moving to next char in pstring1
    addq    $1, %r9                 #moving to next char in pstring2
    incq    %r10                    #i++
    jmp     .comp_ij                #going back to loop
    
.str1_bigger:
    movq    $1, %rax                #in case first pstring bigger    
    ret      
.str2_bigger:
    movq    $-1, %rax               #in case second pstring bigger
    ret      
.equal_pstring:
    movq    $0, %rax                #in case pstring equal
    ret   
.invalid_pstrijcmp:
    movq     $error_str, %rdi       #setting first parameter for printf
    xor      %rax, %rax             #convention setting %rax = 0
    call     printf
    movq     $-2, %rax              #in case we have wrong input
    ret
