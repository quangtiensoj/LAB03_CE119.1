.data
n_val:	.word 20
str1:	.asciiz "F("
str2:	.asciiz ") ="

.text
main:
	lw    $s0, n_val
	
	move  $a0, $s0
	jal   fib_opt
	move  $s1, $v0		# $s1 = F(n)
	
	# In chuoi "F("
        li    $v0, 4
        la    $a0, str1
        syscall
	
	# In gia tri n
        li    $v0, 1
        move  $a0, $s0
        syscall

        # In chuoi ") = "
        li    $v0, 4
        la    $a0, str2
        syscall

        # In ket qua F(n)
        li    $v0, 1
        move  $a0, $s1
        syscall

        # Ket thuc chuong trinh
        li    $v0, 10
        syscall
        
# fib_opt: tinh F(n) bang de quy, kiem tra truong hop co so truoc khi cap khung
# Tham so  : $a0 = n 
# Tra ve   : $v0 = F(n)
# Thanh ghi: $s0 (luu n), $s1 (luu F(n-1)), $ra (chi cat khung 12 byte khi n >= 2)
fib_opt:
	slti   $t0, $a0, 2		#kiem tra n < 2 
	beq    $t0, $zero, fo_rec
	move   $v0, $a0			#truong hop co so F(0) = 0; F(1) = 1
	jr     $ra
fo_rec:
	addi  $sp, $sp, -12     # mo dau: cap khung ngan xep 3 word
        sw    $ra, 8($sp)       # cat dia chi tro ve
        sw    $s0, 4($sp)       # cat $s0 cua nguoi goi
        sw    $s1, 0($sp)       # cat $s1 cua nguoi goi
        
        move  $s0, $a0          #
        addi  $a0, $s0, -1      # n - 1
        jal   fib_opt
        move  $s1, $v0          # $s1 = F(n-1)
        
        addi  $a0, $s0, -2      # n - 2
        jal   fib_opt
        addu  $v0, $s1, $v0     # $v0 = F(n - 1) + F(n - 2)
        
        lw    $s1, 0($sp)      
        lw    $s0, 4($sp)
        lw    $ra, 8($sp)
        addi  $sp, $sp, 12      # thu hoi khung ngan xep
        jr    $ra













