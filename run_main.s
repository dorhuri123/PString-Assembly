#Dor Huri - 209409218    
    .data
    .section    .rodata
format_d:       .string "%d"
format_s:       .string "%s"

    .text
    .global run_main
    .extern run_func
    .type run_main, @function
run_main:
    pushq   %rbp                #setup program
    movq    %rsp, %rbp
    subq    $544, %rsp          #alloocating 544 byets for 2 pstring(2*256) and there length(2*8) and 8 for opt and rest for aligment
    #getting first pstring length
    movq    $format_d, %rdi     #moving first argument to scanf
    leaq    -536(%rbp), %rsi    #moving second argument to scanf
    xorq    %rax, %rax          #convention setting %rax = 0
    call    scanf
    #getting first pstring
    leaq    -528(%rbp), %rcx    #inserting first pstring in memory   
    addq    $1, %rcx            #adding 1 byte so we get input 1 byte after for length in first byte
    movq    $format_s, %rdi     #moving first argument to scanf
    movq    %rcx, %rsi          #moving second argument to scanf
    xorq    %rax, %rax          #convention setting %rax = 0
    call    scanf
    #setting first byte of first pstring
    movl    -536(%rbp), %eax    #eax get the length of first pstring
    movb    %al, -528(%rbp)     #we put in first byte of first psring his length
    #getting second pstring length 
    movq    $format_d, %rdi     #moving first argument to scanf
    leaq    -272(%rbp), %rsi    #moving second argument to scanf
    xorq    %rax, %rax          #convention setting %rax = 0
    call    scanf
    #getting second pstring
    leaq    -264(%rbp), %r8     #inserting second pstring in memory
    addq    $1, %r8             #adding 1 byte so we get input 1 byte after for length in first byte
    movq    $format_s, %rdi     #moving first argument to scanf
    movq    %r8, %rsi           #moving second argument to scanf
    xorq    %rax, %rax          #convention setting %rax = 0
    call    scanf
    #setting first byte of second pstring
    movl    -272(%rbp), %eax    #eax get the length of second pstring
    movb    %al, -264(%rbp)     #we put in first byte of second psring his length
    #getting the option for the menu
    movq    $format_d, %rdi     #moving first argument to scanf
    leaq    -8(%rbp), %rsi      #moving second argument to scanf
    xorq    %rax, %rax          #convention setting %rax = 0
    call    scanf
    #setting parameters for run_func
    movq    -8(%rbp), %rdi      #moving first argument to scanf: opt
    leaq    -528(%rbp), %rsi    #moving second argument to scanf: &pstring1
    leaq    -264(%rbp), %rdx    #moving third argument to scanf: &pstring2
    call    run_func
    xorq    %rax, %rax          #the program return exit code 0
    movq    %rbp, %rsp          #exiting program
    pop     %rbp
    ret    
    
    
