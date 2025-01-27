        .section .data
input_string:   .asciz "Hellow world!"

        # tohost/fromhost are data locations used by Spike
        .align 8
tohost: .byte 0
        .align 8
fromhost: .byte 0

        
        .section .text
        .globl _start
_start:
        # Load the address of the input string into a0
        la a0, input_string

        # Your code here!
loop:
        lbu a1,0(a0)    # load the charactor into a1
        beqz a1,end_program     # if a1 is null, jump to end_program
        li a2,'a'       # load immediate 'a' to a2
        li a3,'z'       # load immediate 'z' to a3
        blt a1,a2,skip  # if a1(current charactor) is smaller than a2('a'), jump to skip
        bgt a1,a3,skip  # if a1(current charactor) is bigger than a3('z'),jump to skip
        li a4,0x20      # load immediate 0x20(32) to a4, the gap between the uppercase and lowercase letter is 32
        sub a1,a1,a4    # minus a1(current charactor) by 32 to change it to uppercase letter
        sb a1,0(a0)     # store a1 back to memory

skip:
        addi a0,a0,1    # increment a0 by 1 to point at next charactor
        j loop          # back to the beginnning of loop


        
end_program:
        # jump here when you're done
        j end_program

