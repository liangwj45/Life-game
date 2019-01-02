.data
  N: 
    .word 15
  Nsquare: 
    .word 224
  newBoard: 
    .space 225
  iterations: 
    .word 0
  hash: 
    .asciiz "#"
  dot: 
    .asciiz "."
  inputMessage: 
    .asciiz "# Iterations: "
  afterIteration: 
    .asciiz "\nAfter iteration "
  endl:
    .asciiz "\n"
  board:
   .byte 1,0,0,0,0,0,0,0,0,0,1,0,0,0,0
   .byte 1,1,0,0,0,0,0,0,0,0,1,1,0,0,0
   .byte 0,0,0,1,0,0,0,0,0,0,1,0,1,0,0
   .byte 0,0,1,0,1,0,0,0,0,0,1,0,0,1,0
   .byte 0,0,0,0,1,0,0,0,0,0,1,0,0,0,1
   .byte 0,0,0,0,1,1,1,0,0,0,1,0,0,1,0
   .byte 0,0,0,1,0,0,1,0,0,0,1,0,1,0,0
   .byte 0,0,1,0,0,0,1,0,0,0,1,1,0,0,0
   .byte 0,0,1,0,0,0,1,0,0,0,1,0,1,0,0
   .byte 0,0,1,0,0,0,1,0,0,0,1,0,0,1,0
   .byte 0,0,1,0,0,0,0,0,0,0,1,0,0,0,1
   .byte 0,0,1,0,0,0,0,0,0,0,1,0,0,1,0
   .byte 0,0,1,0,0,0,0,0,0,0,1,0,1,0,0
   .byte 0,0,1,0,0,0,0,0,0,0,1,1,0,0,0
   .byte 0,0,1,0,0,0,0,0,0,0,1,0,0,0,0


.text
.globl main
main:
  la $a0,inputMessage                  # Print message
  li $v0,4
  syscall
  li $v0,5                             # Read user input
  syscall
  la $v1,iterations
  sw $v0,0($v1)                        # Save iterations
initial:
  li $s0,1                             # Set iterations counter to 1
  iterations_loop:                     # Cycling loop begins
    lw  $t0,iterations                 # Load temporarily the number of iterations into $t0
    bgt $s0,$t0,end_iterations_loop    # Jump to the loop end if num_iters > specified_iters
    li  $s1,0                          # Initial counter $s1
    logic_loop:                        # loop from 0 to N^2-1 
      lw   $t0,Nsquare                 # Get exit status
      bgt  $s1,$t0 logic_end           # Exit if counter > N^2-1
      move $a0,$s1                     # $a0 = current index
      jal  neighbours                  # Get neighbours
      move $s3,$v0                     # Copy the amount of neighbours to $s3
      li   $t0,2
      blt  $s3,$t0,dead
      beq  $s3,$t0,keep
      li   $t0,3
      beq  $s3,$t0,alive
      dead:
        sb $zero,newBoard($s1)         # Write 0 to newBoard
        j  end_incr_j                  # end loop iteration
      alive:
        li $t0,1
        sb $t0,newBoard($s1)           # Write 1 to newBoard
        j  end_incr_j                  # end loop iteration
      keep:
        lb $t0,board($s1)              # Load the status of current cell
        sb $t0,newBoard($s1)
    end_incr_j:
      addi $s1,1                       # End inner loop, increment and jump
      j logic_loop
  logic_end:
    la $a0,afterIteration              # Print "After iteration "
    li $v0,4
    syscall     
    move $a0,$s0                       # Print the iteration number
    li $v0,1
    syscall
    la $a0,endl
    li $v0,4
    syscall 
    jal copyBackAndShow                # Print the board and copy into new board
    addi $s0,1                         # Increment and save back
    j iterations_loop                  # Next iteration
  end_iterations_loop:
exit:
  li $v0, 10
  syscall                              # exit


# Some funtions
neighbours: 
  li  $v0,0                            # Initial counter of neighbours $v0
  lw  $t9,N                            # Load constant N
  # Cartesian coordinates: $t0 = $t5*N + $t6
  div $t5,$a0,$t9                      # $t5 = integerDivision $t0/N
  rem $t6,$a0,$t9                      # $t6 = mod  $t0 % N
  li  $t1,-1                           # Init counter $t1
  li  $t2,-1                           # Init counter $t2
  li  $t8,1                            # Load branching constant into $t8
  outerNeighbours:
    bgt $t1,$t8,outerNeighboursEnd     # Jump to the end if counter greater than 1
    li  $t2,-1                         # Reset counter
    innerNeighbours:
      bgt  $t2,$t8,innerNeighboursEnd  # Jump to the end if counter greater than 1
      add  $t7,$t1,$t5                 # Border check
      bltz $t7,caseFail                # above board if less than 0
      bge  $t7,$t9,caseFail            # below board if greater than N-1
      add  $t3,$t2,$t6                 # Border check
      bltz $t3,caseFail                # above board if less than 0
      bge  $t3,$t9,caseFail            # below board if greater than N-1
      mul  $t7,$t7,$t9                 # +(-N||0||N)
      add  $t7,$t7,$t3
      beq  $t7,$a0,caseFail            # Pass index itself
      lb   $t4,board($t7)              # Add the board index $t3 into $t4
      add  $v0,$v0,$t4
    caseFail:
      addi $t2,$t2,1                   # Incement and jump 
      j innerNeighbours
    innerNeighboursEnd: 
      addi $t1,$t1,1                   # Increment outer counter and jump to start of loop
      j outerNeighbours
  outerNeighboursEnd:    
    jr $ra

copyBackAndShow: 
  lw $t0,N                             # $t0 = N
  li $t1,0                             # Init counter $t1
  li $t2,0                             # Init counter $t2
  outerCopy:
    beq $t1,$t0,endOuterCopy           # Exit if outer counter equals N
    li $t2,0                           # Reset inner counter
    innerCopy:
      beq $t2,$t0,endInnerCopy         # Jump if done
      mul $t3,$t1,$t0                  # Get offset into $t3,: offset = $t1*N + $t2
      addu $t3,$t3,$t2
      lb $t5,newBoard($t3)             # Copy newBoard to board
      sb $t5,board($t3)
      lb $t4,board($t3)
      beqz $t4,caseDot                 # Determine print hash or dot
        la $a0,hash                    # Print hash
        li $v0,4
        syscall
        addi $t2,$t2,1                 # Increment and jump to the start of the loop
        j innerCopy
      caseDot:
        la $a0,dot                     # Print dot
        li $v0,4 
        syscall
        addu $t2,$t2,1                 # Increment and jump to the start of the loop
        j innerCopy
    endInnerCopy:
      la $a0,endl                      # Print endl
      li $v0,4
      syscall
      addu $t1,$t1,1                   # Increment row counter and continue
      j outerCopy
  endOuterCopy:  
    jr $ra
