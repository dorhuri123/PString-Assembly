#Dor huri - 209409218
.data
  .align	   8

  .section  .rodata
#setting string for printing in fun_select
case_5060_str1: .string "first pstring length: %d, "
case_5060_str2: .string "second pstring length: %d\n"
case_52_old: .string "old char: %c, "
case_52_new: .string "new char: %c, "
case_52_str1: .string "first string: %s, "
case_52_str2: .string "second string: %s\n"
case_53_54_len: .string "length: %d, "
case_53_54_str: .string "string: %s\n"
case_55_str: .string "compare result: %d\n"
case_invalid_str: .string "invalid option!\n"
#string for getting input
format_d: .string "%d"
format_s:  .string "%s"

#jump table for all cases of func_select
.jump_table:
  .quad .case_50_60
  .quad .exit
  .quad .case_52
  .quad .case_53
  .quad .case_54
  .quad .case_55
  .quad .invalid_option

  .text
  .globl run_func
  .extern pstrlen,replaceChar, pstrijcpy, swapCase, pstrijcmp
  .type run_func, @function
run_func:
    pushq   %r15                    #pushing calle register                      
    movq    %rdi, %r15              #%r15 get option
    cmp     $60, %r15               #if (%r15 == 60)
    je      .case_50_60             #go to .case_50_60
    cmp     $50, %r15               #if (%r15 == 50)
    je      .case_50_60             #go to .case_50_60
    cmp     $51, %r15               #if (%r15 == 51)
    je      .invalid_option         #go to .invalid_option
    cmp     $60, %r15               #check if %r15 > 60
    ja      .invalid_option         #go to .invalid_option
    cmp     $50, %r15               #check if %r15 < 50
    jl      .invalid_option         #go to .invalid_option
    cmp     $56, %r15               #if (%r15 > 56)
    ja      .invalid_option         #go to .invalid_option
    subq    $50, %r15               #%r15 = %r15 - 50
    jmp     *.jump_table(,%r15,8)   # %r15<6 so we go to jump table in align 8 so we jump to right case
    
.case_50_60:
    #getting first pstring length
    movq    %rsi, %rdi              #%rdi=&pstring1
    call    pstrlen                 
    movq    %rax, %rsi              #%rsi get pstring1 length
    
    #getting second pstring length
    movq    %rdx, %rdi              #%rdi=&pstring2
    call    pstrlen
    movq    %rax, %r15              #%r15 get pstring2 length
    
    #printing first pstring
    movq    $case_5060_str1, %rdi   #setting first parameter for printf(%rsi already has pstring1 length)    
    xorq    %rax, %rax              #convention setting %rax = 0
    call    printf
    
    #printing second pstring
    movq    $case_5060_str2, %rdi   #setting first parameter for printf    
    movq    %r15, %rsi              #setting second parameter for printf
    xorq    %rax, %rax              #convention setting %rax = 0
    call    printf
    jmp     .exit                   #jump to exit program

.case_52:
    #setting program
    subq    $16, %rsp               #allocating stack memory for variabels
    push    %rbx                    #pushing to stack callee register
    push    %r12                    
    push    %r13
    push    %r14
    movq    %rsi, %rbx              #%rbx get pstring1    
    movq    %rdx, %r12              #%r12 get pstring2
    
    #getting old char
    movq    $format_s, %rdi         #setting first parameter for scanf
    leaq    -8(%rbp), %rsi          #setting second parameter for scanf 
    xor    %rax, %rax               #convention setting %rax = 0
    call    scanf
    movzbq  -8(%rbp), %r13          #saving the old char in 1 byte in %r13
   
    #getting new char
    movq    $format_s, %rdi         #setting first parameter for scanf
    leaq    -16(%rbp), %rsi         #setting second parameter for scanf    
    xorq    %rax, %rax              #convention setting %rax = 0
    call    scanf
    movzbq  -16(%rbp), %r14         #saving the new char in 1 byte in %r14
    
    #calling replaceChar for first pstring
    movq    %rbx, %rdi              #setting %rdi with pstring1
    movq    %r13, %rsi              #setting %rsi with old char
    movq    %r14, %rdx              #setting %rdx with new char
    call    replaceChar
    movq    %rax, %rbx              #saving the updated pstring1 in %rbx
    
    #calling replaceChar for second pstring
    movq    %r12, %rdi              #setting %rdi with pstring2
    movq    %r13, %rsi              #setting %rsi with old char
    movq    %r14, %rdx              #setting %rdx with new char
    call    replaceChar
    movq    %rax, %r12              #saving the updated pstring2 in %r12
    
    #printing old char
    movq    $case_52_old, %rdi      #setting first parameter for printf
    movq    %r13, %rsi              #setting second parameter for scanf
    xorq    %rax, %rax              #convention setting %rax = 0
    call    printf
    
    #printing new char
    movq    $case_52_new, %rdi      #setting first parameter for printf
    movq    %r14, %rsi              #setting second parameter for scanf
    xorq    %rax, %rax              #convention setting %rax = 0
    call    printf
   
    #printing first updated pstring
    movq    $case_52_str1, %rdi     #setting first parameter for printf
    addq    $1, %rbx                #adding 1 so we don't print the first byte of pstring(which contain his length)
    movq    %rbx, %rsi              #setting second parameter for scanf
    xorq    %rax, %rax              #convention setting %rax = 0
    call    printf
   
    #printing first updated pstring
    movq    $case_52_str2, %rdi     #setting first parameter for printf
    addq    $1, %r12                #adding 1 so we don't print the first byte of pstring(which contain his length)
    movq    %r12, %rsi              #setting second parameter for scanf    
    xorq    %rax, %rax              #convention setting %rax = 0
    call    printf
   
    #finishing program
    pop     %r14                    #popping all the register we push in reverse order
    pop     %r13
    pop     %r12
    pop     %rbx
    addq    $16, %rsp               #returning stack memory
    jmp     .exit

.case_53:
    #setting program
    subq    $16, %rsp               #allocating stack memory for variabels
    push    %rbx                    #pushing to stack callee register
    push    %r12
    push    %r13
    push    %r14
    movq    %rsi, %rbx              #%rbx get pstring1
    movq    %rdx, %r12              #%rbx get pstring2
    
    #getting first pstring length
    movq    %rsi, %rdi              #%rdi get first pstring
    call    pstrlen
    movq    %rax, %r13              #%r13 get first pstring length
    
    #getting second pstring length
    movq    %rdx, %rdi              #%rdi get second pstring
    call    pstrlen
    movq    %rax, %r14              #%r13 get second pstring length
    
    #getting the start index
    movq    $format_d, %rdi         #setting first parameter for scanf
    leaq    -8(%rbp), %rsi          #setting second parameter for scanf
    xorq    %rax, %rax              #convention setting %rax = 0
    call    scanf
    
    #getting the finish index
    movq    $format_d, %rdi         #setting first parameter for scanf
    leaq    -24(%rbp), %rsi         #setting second parameter for scanf
    xorq    %rax, %rax              #convention setting %rax = 0
    call    scanf
    
    #setting parameter and calling pstrijcpy
    movq     %rbx, %rdi             #%rdi get pstring1
    movq     %r12, %rsi             #%rsi get pstring2
    movq     -8(%rbp), %rdx         #%rdx get the start index
    movq     -24(%rbp), %rcx        #%rcx get the finish index
    xorq     %rax, %rax             #convention setting %rax = 0
    call     pstrijcpy              
    movq     %rax, %rbx             #%rbx get updated pstring1
   
    #printing first pstring length
    movq     $case_53_54_len, %rdi  #setting first parameter for printf        
    movq     %r13, %rsi             #setting second parameter for printf
    xorq     %rax, %rax             #convention setting %rax = 0
    call     printf
   
    #printing first pstring
    movq     $case_53_54_str, %rdi  #setting first parameter for printf
    addq     $1, %rbx               #adding 1 so we don't print the first byte of pstring(which contain his length)
    movq     %rbx, %rsi             #setting second parameter for printf
    xorq     %rax, %rax             #convention setting %rax = 0
    call     printf
   
    #printing second pstring length
    movq     $case_53_54_len, %rdi  #setting first parameter for printf
    movq     %r14, %rsi             #setting second parameter for printf
    xorq     %rax, %rax             #convention setting %rax = 0
    call     printf
    
    #printing second pstring
    movq     $case_53_54_str, %rdi  #setting first parameter for printf
    addq     $1, %r12               #adding 1 so we don't print the first byte of pstring(which contain his length)
    movq     %r12, %rsi             #setting second parameter for printf
    xorq     %rax, %rax             #convention setting %rax = 0
    call     printf
    
    #finishing program
    pop      %r14                   #popping all the register we push in reverse order
    pop      %r13
    pop      %r12
    pop      %rbx
    addq    $16, %rsp               #returning stack memory
    jmp      .exit
   
.case_54:
    #setting program
    push    %rbx                    #pushing to stack callee register     
    push    %r12
    push    %r13
    push    %r14
    movq    %rsi, %rbx              #%rbx get pstring1
    movq    %rdx, %r12              #%r12 get pstring2
    
    #getting first pstring length
    movq    %rbx, %rdi              #%rdi get first pstring 
    call    pstrlen
    movq    %rax, %r13              #%r13 get first pstring length
    
    #getting second pstring length
    movq    %r12, %rdi              #rdi get second pstring             
    call    pstrlen
    movq    %rax, %r14              #%r14 get second pstring length
    
    #calling swapCase for first pstring
    movq    %rbx, %rdi              #%rdi get first pstring
    call    swapCase
    movq    %rax, %rbx              #%rbx get the updated first pstring
    
    #calling swapCase for first pstring
    movq    %r12, %rdi              #%rdi get second pstring
    call    swapCase
    movq    %rax, %r12              #%r12 get the updated second pstring
    
    #printing first pstring length
    movq    $case_53_54_len, %rdi   #setting first parameter for printf
    movq    %r13, %rsi              #setting second parameter for printf
    xorq    %rax, %rax              #convention setting %rax = 0
    call    printf
    
    #printing first updated pstring
    movq    $case_53_54_str, %rdi   #setting first parameter for printf
    addq    $1, %rbx                #adding 1 so we don't print the first byte of pstring(which contain his length)
    movq    %rbx, %rsi              #setting second parameter for printf
    xorq    %rax, %rax              #convention setting %rax = 0
    call    printf
    
    #printing second pstring length
    movq    $case_53_54_len, %rdi   #setting first parameter for printf
    movq    %r14, %rsi              #setting second parameter for printf
    xorq    %rax, %rax              #convention setting %rax = 0
    call    printf
    
    #printing second updated pstring
    movq    $case_53_54_str, %rdi   #setting first parameter for printf
    addq    $1, %r12                #adding 1 so we don't print the first byte of pstring(which contain his length)
    movq    %r12, %rsi              #setting second parameter for printf
    xorq    %rax, %rax              #convention setting %rax = 0
    call    printf
    
    #finishing program
    pop      %r14                   #popping all the register we push in reverse order
    pop      %r13
    pop      %r12
    pop      %rbx
    jmp      .exit
    
.case_55:
    #setting program
    subq    $16, %rsp               #allocating stack memory for variabels
    push    %rbx                    #pushing to stack callee register                 
    push    %r12                    
    push    %r13
    push    %r14
    movq    %rsi, %rbx              #%rbx get pstring1
    movq    %rdx, %r12              #%r12 get pstring2
    
    #getting start index
    movq    $format_d, %rdi         #setting first parameter for scanf    
    leaq    -8(%rbp), %rsi          #setting second parameter for scanf
    xorq    %rax, %rax              #convention setting %rax = 0
    call    scanf
    movq    -8(%rbp), %r13          #%r13 get the start index 
    
    #getting finish index
    movq    $format_d, %rdi         #setting first parameter for scanf 
    leaq    -24(%rbp), %rsi         #setting second parameter for scanf
    xorq    %rax, %rax              #convention setting %rax = 0
    call    scanf
    movq    -24(%rbp), %r14         #%r14 get the start index 
    
    #setting parameter and calling pstrijcmp
    movq    %rbx, %rdi              #%rdi get pstring1
    movq    %r12, %rsi              #%rsi get pstring2
    movq    %r13, %rdx              #%rdx get start index
    movq    %r14, %rcx              #%rcx get finish index
    call    pstrijcmp
    
    #printing compare result
    movq    $case_55_str, %rdi      #setting first parameter for printf
    movq    %rax, %rsi              #setting second parameter for scanf 
    xorq    %rax, %rax              #convention setting %rax = 0
    call    printf
    
    #finishing program
    pop      %r14                   #popping all the register we push in reverse order
    pop      %r13
    pop      %r12
    pop      %rbx
    addq    $16, %rsp               #returning stack memory
    jmp      .exit
 
.invalid_option:
    #printing invalid message
    movq    $case_invalid_str, %rdi #setting first parameter for printf
    xorq    %rax, %rax              #convention setting %rax = 0
    call    printf
    
.exit:
    pop     %r15                    #popping %r15 from stack
    ret
