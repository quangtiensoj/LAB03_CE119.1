.data
bar:	.asciiz "|" 
nl:	.asciiz "\n"

str1:   .asciiz "kien truc may tinh"
str2:   .asciiz "mips"
str3:   .asciiz ""
str4:   .asciiz "a bc def"
str5:   .asciiz "luu dia chi tro ve truoc khi goi"

.text
main:
# Kiem thu chuoi 1
        la    $a0, str1
        jal   test_print

        # Kiem thu chuoi 2
        la    $a0, str2
        jal   test_print

        # Kiem thu chuoi 3 
        la    $a0, str3
        jal   test_print

        # Kiem thu chuoi 4
        la    $a0, str4
        jal   test_print

        # Kiem thu chuoi 5
        la    $a0, str5
        jal   test_print

        # Ket thuc chuong trinh
        li    $v0, 10
        syscall
     
# test_print : goi reverse_word va in ket qua
#tham so     :     $a0 = dia chi chuoi can kiem thu
#tra ve      :      khong co
#thanh ghi   :   $s0, $ra       
test_print:
	addi  $sp, $sp, -8
        sw    $ra, 4($sp)
        sw    $s0, 0($sp)
        
        move $s0, $a0		#luu dia chi qua loi goi ham
        jal reverse_words
        
	li    $v0, 4            # in ky tu '|' mo dau
        la    $a0, bar
        syscall

        move  $a0, $s0          # in chuoi sau khi dao
        li    $v0, 4
        syscall

        li    $v0, 4            # in ky tu '|' ket thuc
        la    $a0, bar
        syscall

        li    $v0, 4            # xuong dong
        la    $a0, nl
        syscall
        
	lw    $s0, 0($sp)
        lw    $ra, 4($sp)
        addi  $sp, $sp, 8
        jr    $ra

# strlen   : tinh do dai chuoi .asciiz (thu tuc la)
# Tham so  : $a0 = dia chi chuoi
# Tra ve   : $v0 = so ky tu truoc byte 0
# Thanh ghi: $t0, $t1 (khong dung ngan xep)
strlen:
	move  $t0, $a0		# $t0 la con tro duyet mang
sl_loop:
	lbu   $t1, 0($t0)
	beq   $t1, $zero, sl_done
	addiu $t0, $t0, 1
	j sl_loop
	
sl_done:
	subu  $v0, $t0, $a0
	jr    $ra

# rev_range: dao tai cho doan ky tu [$a0, $a1] (thu tuc la)
# Tham so  : $a0 = dia chi ky tu dau, $a1 = dia chi ky tu cuoi
# Tra ve   : khong co
# Thanh ghi: $t0, $t1, $t2 (khong dung ngan xep)
rev_range:
rr_loop:
	sltu  $t0, $a0, $a1
	beq   $t0, $zero, rr_done
	
	lbu   $t1, 0($a0)
	lbu   $t2, 0($a1)
	sb    $t2, 0($a0)
	sb    $t1, 0($a1)
	
	addiu $a0, $a0, 1
	addiu $a1, $a1, -1
	j rr_loop

rr_done:
	jr    $ra
	
# reverse_words: dao thu tu cac tu trong chuoi tai cho (thu tuc khong la)
# Tham so  : $a0 = dia chi chuoi
# Tra ve   : khong co
# Thanh ghi: $s0 (dau tu), $s1 (con tro duyet), $ra (cat khung 12 byte)
reverse_words:
	addi $sp, $sp, -12
	sw   $ra, 8($sp)
	sw   $s0, 4($sp)
	sw   $s1, 0($sp)
	
	move $s0, $a0
	jal strlen
	
	li   $t0, 2
	blt  $v0, $t0, rw_done		# neu do dai chuoi < 2 thi xong
	
	#dao toan bo chuoi
	move $a0, $s0
	addu $a1, $s0, $v0
	addiu $a1, $a1, -1
	jal rev_range
	
	#dao tung tu
	move $s1, $s0			# $s1 la con tro duyet bat dau tu dau chuoi	
	
rw_loop:
	lbu $t0, 0($s1)
	beq $t0, $zero, rw_last_word
	
	li  $t1, 32			# ma ascii cua dau cach ' '
	bne $t0, $t1, rw_next_char	# duyet cho toi khi gap dau cach
	
	move $a0, $s0
	addiu $a1, $s1, -1
	jal  rev_range
	
	addiu $s0, $s1, 1
	move  $s1, $s0
	j     rw_loop

rw_next_char:
	addiu $s1, $s1, 1
	j      rw_loop

rw_last_word:
	move  $a0, $s0
	addiu $a1, $s1, -1
	jal    rev_range

rw_done:
	lw    $s1, 0($sp)
	lw    $s0, 4($sp)
	lw    $ra, 8($sp)
	addiu $sp, $sp, 12
	jr    $ra
	
        
        
        
        
        
