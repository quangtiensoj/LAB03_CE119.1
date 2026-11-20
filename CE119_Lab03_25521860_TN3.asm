.data
n_val:	.word 20
str1:	.asciiz "F("
str2:	.asciiz ") ="

.text
main:
	lw    $s0, n_val
	
	move  $a0, $s0
	jal   fib_rec
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
        
  
# fib_rec: tinh F(n) bang de quy (thu tuc khong la)
# Tham so  : $a0 = n (n >= 0)
# Tra ve   : $v0 = F(n)
# Thanh ghi: $s0 (luu n), $s1 (luu F(n-1)), $ra (cat khung 12 byte)
fib_rec:
	addi  $sp, $sp, -12     # mo dau: cap khung ngan xep 3 word
        sw    $ra, 8($sp)       # cat dia chi tro ve
        sw    $s0, 4($sp)       # cat $s0 cua nguoi goi
        sw    $s1, 0($sp)       # cat $s1 cua nguoi goi
        
        move  $s0, $a0          # giu gia tri n qua cac loi goi de quy
        slti  $t0, $s0, 2       # kiem tra n < 2
        beq   $t0, $zero, fr_rec
        move  $v0, $s0          # F(0) = 0, F(1) = 1
        j     fr_done

fr_rec:
	# F(n-1)
	addi  $a0, $s0, -1
	jal   fib_rec
	move  $s1, $v0
	
	# F(n-2)
	addi $a0, $s0, -2
	jal  fib_rec
	add  $v0, $s1, $v0	# F(n) = F(n - 1) + F(n - 2)

fr_done:
	lw    $s1, 0($sp)      
        lw    $s0, 4($sp)
        lw    $ra, 8($sp)
        addi  $sp, $sp, 12      # thu hoi khung ngan xep
        jr    $ra
        
# fib_iter: tinh F(n) bang vong lap
# Tham so : $a0 = n    Tra ve : $v0 = F(n)
# Thanh ghi: $t0-$t3 (thu tuc la)
fib_iter:
        move  $v0, $zero        # a = F(0)
        li    $t0, 1            # b = F(1)
        move  $t1, $zero        # i = 0
fi_loop:
        slt   $t2, $t1, $a0
        beq   $t2, $zero, fi_done
        addu  $t3, $v0, $t0     # a + b
        move  $v0, $t0
        move  $t0, $t3
        addiu $t1, $t1, 1
        j     fi_loop
fi_done:
        jr    $ra
        
        
        
        
        