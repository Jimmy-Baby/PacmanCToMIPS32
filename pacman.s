########################################################################
# COMP1521 23T2 -- Assignment 1 -- Pacman!
#
#
# !!! IMPORTANT !!!
# Before starting work on the assignment, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
# Instructions to configure your text editor can be found here:
#   https://cgi.cse.unsw.edu.au/~cs1521/23T2/resources/mips-editors.html
# !!! IMPORTANT !!!
#
#
# This program was written by YOUR-NAME-HERE (z5555555)
# on INSERT-DATE-HERE. INSERT-SIMPLE-PROGRAM-DESCRIPTION-HERE
#
# Version 1.0 (12-06-2023): Team COMP1521 <cs1521@cse.unsw.edu.au>
#
########################################################################

#![tabsize(8)]

# Constant definitions.
# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THESE DEFINITIONS !!!

# Bools
FALSE = 0
TRUE  = 1

# Directions
LEFT  = 0
UP    = 1
RIGHT = 2
DOWN  = 3
TOTAL_DIRECTIONS = 4

# Map
MAP_WIDTH  = 13
MAP_HEIGHT = 10
MAP_DOTS   = 53
NUM_GHOSTS = 3

WALL_CHAR   = '#'
DOT_CHAR    = '.'
PLAYER_CHAR = '@'
GHOST_CHAR  = 'M'
EMPTY_CHAR  = ' '

# Other helpful constants
GHOST_T_X_OFFSET          = 0
GHOST_T_Y_OFFSET          = 4
GHOST_T_DIRECTION_OFFFSET = 8
SIZEOF_GHOST_T            = 12
SIZEOF_INT                = 4

########################################################################
# DATA SEGMENT
# !!! DO NOT ADD, REMOVE, MODIFY OR REORDER ANY OF THESE DEFINITIONS !!!

	.data
map:
	.byte '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#'
	.byte '#', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '#'
	.byte '#', '.', '#', '#', '#', '#', '#', '#', '#', '#', '#', '.', '#'
	.byte '#', '.', '#', ' ', '#', '.', '.', '.', '.', '.', '.', '.', '#'
	.byte '#', '.', '#', '#', '#', '#', '#', '.', '#', '#', '#', '.', '#'
	.byte '#', '.', '.', '.', '.', '.', '#', '.', '#', '.', '.', '.', '#'
	.byte '#', '.', '#', '#', '#', '#', '#', '.', '#', '#', '#', '.', '#'
	.byte '#', '.', '#', '.', '#', '.', '.', '.', '#', '.', '.', '.', '#'
	.byte '#', '.', '.', '.', '.', '.', '#', '.', '.', '.', '#', '.', '#'
	.byte '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#'

	.align 2
ghosts:
	.word 3, 3, UP		# ghosts[0]
	.word 4, 5, RIGHT	# ghosts[1]
	.word 9, 7, LEFT	# ghosts[2]

player_x:
	.word 7
player_y:
	.word 5

map_copy:
	.space	MAP_HEIGHT * MAP_WIDTH

	.align 2
valid_directions:
	.space	4 * TOTAL_DIRECTIONS
dots_collected:
	.word	0
x_copy:
	.word	0
y_copy:
	.word	0

lfsr_state:
	.space	4

# print_welcome strings
welcome_msg:
	.asciiz "Welcome to 1521 Pacman!\n"
welcome_msg_wall:
	.asciiz " = wall\n"
welcome_msg_you:
	.asciiz " = you\n"
welcome_msg_dot:
	.asciiz " = dot\n"
welcome_msg_ghost:
	.asciiz " = ghost\n"
welcome_msg_objective:
	.asciiz "\nThe objective is to collect all the dots.\n"
welcome_msg_wasd:
	.asciiz "Use WASD to move.\n"
welcome_msg_ghost_move:
	.asciiz "Ghosts will move every time you move.\nTouching them will end the game.\n"

# get_direction strings
choose_move_msg:
	.asciiz "Choose next move (wasd): "
invalid_input_msg:
	.asciiz "Invalid input! Use the wasd keys to move.\n"

# main strings
dots_collected_msg_1:
	.asciiz "You've collected "
dots_collected_msg_2:
	.asciiz " out of "
dots_collected_msg_3:
	.asciiz " dots.\n"

# check_ghost_collision strings
game_over_msg:
	.asciiz "You ran into a ghost, game over! :(\n"

# collect_dot_and_check_win strings
game_won_msg:
	.asciiz "All dots collected, you won! :D\n"


# ------------------------------------------------------------------------------
#                                 Text Segment
# ------------------------------------------------------------------------------

	.text

############################################################
####                                                    ####
####   Your journey begins here, intrepid adventurer!   ####
####                                                    ####
############################################################

################################################################################
#
# Implement the following functions,
# and check these boxes as you finish implementing each function.
#
#  SUBSET 0
#  - [x] print_welcome
#  SUBSET 1
#  - [x] main
#  - [x] get_direction
#  - [x] play_tick
#  SUBSET 2
#  - [x] copy_map
#  - [x] get_valid_directions
#  - [x] print_map
#  - [x] try_move
#  SUBSET 3
#  - [x] check_ghost_collision
#  - [x] collect_dot_and_check_win
#  - [x] do_ghost_logic
#     (and also the ghosts part of print_map)
#  PROVIDED
#  - [X] get_seed
#  - [X] random_number


################################################################################
# .TEXT <print_welcome>
	.text
print_welcome:
	# Subset:   0
	#
	# Args:     void
	#
	# Returns:  void
	#
	# Frame:    [...]
	# Uses:     [$v0, $a0]
	# Clobbers: [$v0, $a0]
	#
	# Locals:
	#
	# Structure:
	#   print_welcome
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

print_welcome__prologue:

print_welcome__body:
	# printf("Welcome to 1521 Pacman!\n");
	li	$v0, 4								# syscall 4: print_string
	la 	$a0, welcome_msg
	syscall

	# printf("%c", WALL_CHAR);
	li	$v0, 11								# syscall 11: putchar
	la	$a0, WALL_CHAR
	syscall

	# printf(" = wall\n");
	li	$v0, 4
	la	$a0, welcome_msg_wall
	syscall

	# printf("%c", PLAYER_CHAR);
	li	$v0, 11
	la	$a0, PLAYER_CHAR
	syscall

	# printf(" = you\n");
	li	$v0, 4
	la	$a0, welcome_msg_you
	syscall
	
	# printf("%c", DOT_CHAR);
	li	$v0, 11
	la	$a0, DOT_CHAR
	syscall

	# printf(" = dot\n");
	li	$v0, 4
	la	$a0, welcome_msg_dot
	syscall

	# printf("%c", GHOST_CHAR);
	li	$v0, 11
	la	$a0, GHOST_CHAR
	syscall	

	# printf(" = ghost\n");
	li	$v0, 4
	la	$a0, welcome_msg_ghost
	syscall

	# printf("\nThe objective is to collect all the dots.\n");
	li	$v0, 4
	la	$a0, welcome_msg_objective
	syscall

	# printf("Use WASD to move\n");
	li	$v0, 4
	la	$a0, welcome_msg_wasd
	syscall

	# printf("Ghosts will move every time you move.\nTouching them will end the game.\n");
	li	$v0, 4
	la	$a0, welcome_msg_ghost_move
	syscall

print_welcome__epilogue:
	jr	$ra


################################################################################
# .TEXT <main>
	.text
main:
	# Subset:   1
	#
	# Args:     void
	#
	# Returns:
	#    - $v0: int
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

main__prologue:
	push	$ra

main__body:
	# get_seed();
    # print_welcome();
	jal	get_seed
	jal	print_welcome

play_tick_loop:
	# do { 
	# 	print_map();
	jal	print_map

	# printf("You've collected ");
	li		$v0, 4
	la		$a0, dots_collected_msg_1
	syscall

	# printf("%d out of %d dots.\n", dots_collected
	li		$v0, 1							# print integer
	la		$t0, dots_collected
	lw		$a0, ($t0)
	syscall									# printf("%d", dots_collected);

	# printf(" out of ");
	li		$v0, 4
	la		$a0, dots_collected_msg_2
	syscall									

	# printf("%d", MAP_DOTS);
	li		$v0, 1
	li		$a0, MAP_DOTS
	syscall									

	# printf(" dots.\n");
	li		$v0, 4
	la		$a0, dots_collected_msg_3
	syscall									

	# } while (play_tick(&dots_collected));
	la		$a0, dots_collected
	jal		play_tick
	beqz	$v0, main__epilogue
	
	# branch to 'do'
	b		play_tick_loop

main_return:
	# return 0;
	li		$v0, 0

main__epilogue:
	pop		$ra

	jr		$ra


################################################################################
# .TEXT <get_direction>
	.text
get_direction:
	# Subset:   1
	#
	# Args:     void
	#
	# Returns:
	#    - $v0: int
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - $t0: FALSE
	#   - $t1: int input
	# Structure:
	#   get_direction
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

get_direction__prologue:

get_direction__body:
	# printf("Choose next move (wasd): ");
	li		$v0, 4
	la		$a0, choose_move_msg
	syscall

check_key:
	li		$v0, 12							# read character syscall code
	syscall

# if (input == 'a') {
	bne		$v0, 'a', check_up_key			# if $v0 != 'a' then goto check_up_key
# return LEFT;
	li		$v0, LEFT						# $v0 = LEFT
	b		get_direction__epilogue			# branch to get_direction__epilogue

check_up_key:
# if (input == 'w') {
	bne		$v0, 'w', check_right_key		# if $v0 != 'w' then goto check_right_key
# return UP;
	li		$v0, UP							# $v0 = UP
	b		get_direction__epilogue			# branch to get_direction__epilogue

check_right_key:
# if (input == 'd') {
	bne		$v0, 'd', check_down_key		# if $v0 != 'd' then goto check_down_key
# return RIGHT;
	li		$v0, RIGHT						# $v0 = RIGHT
	b		get_direction__epilogue			# branch to get_direction__epilogue

check_down_key:
# if (input == 's') {
	bne		$v0, 's', check_newline			# if $v0 != 's' then goto check_newline
# return DOWN;
	li		$v0, DOWN						# $v0 = DOWN
	b		get_direction__epilogue			# branch to get_direction__epilogue

check_newline:
# continue;
	beq		$v0, '\n', check_key			# if $v0 == '\n' then goto check_key

invalid_input:
	# printf("Invalid input! Use the wasd keys to move.\n");
	li		$v0, 4
	la		$a0, invalid_input_msg
	syscall

	# end of while
	b		check_key						# branch to check_key

get_direction__epilogue:
	jr		$ra


################################################################################
# .TEXT <play_tick>
	.text
play_tick:
	# Subset:   1
	#
	# Args:
	#    - $a0: int *dots_collected
	#	
	#
	# Returns:
	#    - $v0: int
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#    - $a1: *player_x
	#    - $a2: *player_y
	#    - $a3: results from get_direction
	#
	# Structure:
	#   play_tick
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

play_tick__prologue:
	push	$ra
	push	$s0

play_tick__body:
	# preserve dots in saved register $s0
	move	$s0, $a0
	
	# try_move(&player_x, &player_y, get_direction());
	la		$a0, player_x
	la		$a1, player_y
	jal		get_direction
	move	$a2, $v0						# store result from get_direction
	jal		try_move	

    # if (check_ghost_collision()) goto play_tick_return_false
	jal		check_ghost_collision
	bnez	$v0, play_tick_return_false

	# do_ghost_logic();
	jal		do_ghost_logic

    # if (check_ghost_collision()) goto play_tick_return_false
	jal		check_ghost_collision
	bnez	$v0, play_tick_return_false

	# return !collect_dot_and_check_win(dots);
	move	$a0, $s0						# load dots
	jal		collect_dot_and_check_win
	bnez	$v0, play_tick_invert_true

play_tick_invert_false:
	li		$v0, 1
	b		play_tick__epilogue

play_tick_invert_true:
	li		$v0, 0								
	b		play_tick__epilogue

play_tick_return_false:
	li		$v0, FALSE

play_tick__epilogue:
	pop		$s0
	pop		$ra

	jr		$ra


################################################################################
# .TEXT <copy_map>
	.text
copy_map:
	# Subset:   2
	#
	# Args:
	#    - $a0: char dst[MAP_HEIGHT][MAP_WIDTH]
	#    - $a1: char src[MAP_HEIGHT][MAP_WIDTH]
	#
	# Returns:  void
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - $t0: int i
	#   - $t1: int j
	#   - $t2: MAP_HEIGHT
	#   - $t3: MAP_WIDTH
	#   - $t4: temporary result dest[i][j]( i * MAP_WIDTH + j )
	#   - $t5: temporary result source[i][j]( i * MAP_WIDTH + j )
	#   - $t6: temporary storage for source[i][j]	
	#
	# Structure:
	#   copy_map
	#   -> [prologue]
	#       -> body
	#		-> height_loop_init
	#		-> height_loop_cond
	#		-> height_loop_body
	#		-> width_loop_init
	#		-> width_loop_cond
	#		-> width_loop_cond
	#		-> width_loop_body
	#		-> height_loop_Step
	#		-> height_loop_end
	#   -> [epilogue]

copy_map__prologue:
	push	$ra

copy_map__body:

height_loop_init:
	# i = 0
	li		$t0, 0

height_loop_cond:
	# if (i >= MAP_HEIGHT) goto height_loop_end;
	bge		$t0, MAP_HEIGHT, height_loop_end

height_loop_body:

width_loop_init:
	# j = 0;
	li		$t1, 0

width_loop_cond:
	# if (j >= MAP_WIDTH) goto height_loop_step;
	bge		$t1, MAP_WIDTH, height_loop_step

width_loop_body:
	# dest[i][j] = source[i][j];
	mul		$t4, $t0, MAP_WIDTH				# (i * MAP_WIDTH			
    addu    $t4, $t4, $t1      				#  + j)	
    addu    $t4, $a0, $t4         			# + dest[i][j] 

	mul		$t5, $t0, MAP_WIDTH				# (i * MAP_WIDTH
    addu    $t5, $t5, $t1         			# + j)
	addu    $t5, $a1, $t5					# + source[i][j] 

	lb      $t6, ($t5)           			# Load a byte from source[i][j]
    sb      $t6, ($t4)           			# Store the byte in dest[i][j]

	# j++;
	addi	$t1, $t1, 1
	b		width_loop_cond

height_loop_step:
	# i++;
	addi	$t0, $t0, 1
	b		height_loop_cond		

height_loop_end:

copy_map__epilogue:
	pop 	$ra

	jr		$ra


################################################################################
# .TEXT <get_valid_directions>
	.text
get_valid_directions:
	# Subset:   2
	#
	# Args:
	#    - $a0: int x
	#    - $a1: int y
	#    - $a2: int dir_array[TOTAL_DIRECTIONS]
	#
	# Returns:
	#    - $v0: int
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - $t0: valid_dirs * 4
	#   - $t1: address of dir_array[valid_dirs]
	#   
	#   
	# Structure:
	#   get_valid_directions
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

get_valid_directions__prologue:
	push	$ra
	push	$s0
	push	$s1

get_valid_directions__body:
	move	$s0, $a2					# store dir_array in $s0
	li	$s1, 0							# int valid_dirs = 0

loop__init:
	li	$s2, 0							# int dir = 0;		

	move	$s3, $a0					# store x in $s3	
	move	$s4, $a1					# store y in $s4

loop__cond:
	bge	$s2, TOTAL_DIRECTIONS, loop__end		# if (dir >= TOTAL_DIRECTIONS) goto loop__end;

loop__body:
	la	$a0, x_copy					# load address of x_copy into $a0
	sw	$s3, ($a0)					# store value of x in address of x_copy
	la	$a1, y_copy					# load address of y_copy into $a1
	sw	$s4, ($a1)					# store value of y in address of y_copy

loop__check_try_move_cond:
	move	$a2, $s2					# move dir_array into $a2

	jal		try_move					# 

	beqz	$v0, loop__step					# if (!try_move(&x_copy, &y_copy, dir)) goto loop__step;

loop__check_try_move_body:
	mul	$t0, $s1, 4					# valid_dirs * 4
	add	$t1, $s0, $t0					# address of dir_array[valid_dirs]
	sw	$s2, 0($t1)					# store dir into dir_array[valid_dirs]

	add	$s1, $s1, 1					# valid_dirs++;

loop__step:
	add	$s2, $s2, 1					#  dir++;
	b	loop__cond					# goto loop__cond;

loop__end:
	move 	$v0, $s1					# return valid_dirs;

get_valid_directions__epilogue:
	pop	$s1
	pop	$s0
	pop	$ra

	jr	$ra


################################################################################
# .TEXT <print_map>
	.text
print_map:
	# Subset:   2
	#
	# Args:     void
	#
	# Returns:  void
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   print_map
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

print_map__prologue:
	push 	$ra

print_map__body:
	# copy_map(map_copy, map);
	la		$a0, map_copy						# load address of map_copy
	la		$a1, map							# load address of map
	jal		copy_map							# copy_map(map_copy, map);

	# load player_y and _x into $t1 and $t2, respectively
	la 		$t1, player_y
	lw		$t1, ($t1)
	la 		$t2, player_x
	lw		$t2, ($t2)

	# calculate offset into map_copy for our player character
	mul		$t3, $t1, MAP_WIDTH					# (player_y * MAP_WIDTH)
	add		$t3, $t3, $t2						# (player_y * MAP_WIDTH) + player_x
	la		$t4, map_copy						# load address of map_copy into $t4
	add		$t4, $t4, $t3						# $t4 = map_copy[player_y][player_x]

	li		$t5, PLAYER_CHAR
	sb		$t5, ($t4)							# map_copy[player_y][player_x] = PLAYER_CHAR;

loop_ghost_init:
	# i = 0
	li		$t0, 0

loop_ghost_cond:
	# if (i >= NUM_GHOSTS) goto loop_print_height__init
	bge		$t0, NUM_GHOSTS, loop_print_height_init	

loop_ghost_body:
	# get our ghost structure in memory
	mul		$t1, $t0, SIZEOF_GHOST_T			# i * 12
	la		$t2, ghosts
	add		$t2, $t2, $t1						# ghosts[i] = ghosts + (i * 12);

	# get our x/y values from struct in memory
	lw		$t3, GHOST_T_Y_OFFSET($t2)			# $t3 = ghostd[i].y
	lw		$t4, GHOST_T_X_OFFSET($t2)			# $t4 = ghosts[i].x

	# calculate address of memory to write our player character '@'
	mul		$t3, $t3, MAP_WIDTH					# ghosts[i].y * MAP_WIDTH
	add		$t3, $t4, $t3						# (ghosts[i].y * MAP_WIDTH) + ghosts[i].x
	la		$t4, map_copy						# load address of map_copy into $t4
	add		$t3, $t3, $t4						# $s1 = map_copy[ghosts[i].y][ghosts[i].x]

	# load ghost char into reg, and then store it at our address
	li		$t4, GHOST_CHAR
	sb		$t4, ($t3)

loop_ghost_step:
	# i++;
	add		$t0, $t0, 1		

	b		loop_ghost_cond

loop_print_height_init:
	# i = 0;
	li		$t0, 0

loop_print_height_cond:
	bge		$t0, MAP_HEIGHT, print_map__epilogue

loop_print_height_body:

loop_print_width_init:
	li		$t1, 0								# j = 0;

loop_print_width_cond:
	bge		$t1, MAP_WIDTH, loop_print_height_step

	mul		$t2, $t0, MAP_WIDTH					# i = i * MAP_WIDTH
	add		$t2, $t1, $t2						# (i * MAP_WIDTH) + j
	la		$t3, map_copy						# load address of map_copy into $t4
	add		$t2, $t3, $t2						# map_copy[i][j]
	lb		$t2, ($t2)							# load byte from address

	li		$v0, 11								# syscall 11: putchar
	move	$a0, $t2							#
	syscall										# putchar(map_copy[i][j]);

	add 	$t1, $t1, 1
	b		loop_print_width_cond

loop_print_height_step:
	li		$v0, 11
	li		$a0, '\n'
	syscall

	add		$t0, $t0, 1
	b		loop_print_height_cond

print_map__epilogue:
	pop	$ra

	jr	$ra


################################################################################
# .TEXT <try_move>
	.text
try_move:
	# Subset:   2
	#
	# Args:
	#    - $a0: int *x
	#    - $a1: int *y
	#    - $a2: int directions
	#
	# Returns:
	#    - $v0: int
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - $t0: int new_x
	#   - $t1: int new_y
	#   - $t2: temporary storage for int directions
	#   - $t3: temporary result: new_y * MAP_WIDTH
	#   - $t4: map[new_y][new_x]
	# Structure:
	#   try_move
	#   -> [prologue]
	#       -> body
	#		-> try_move_first_cond
	#		-> try_move_second_cond
	#		-> try_move_third_cond
	#		-> try_move_fourth_cond
	#		-> try_move_check_wall_char
	# 		-> try_move_set_pointers
	#   -> [epilogue]

try_move__prologue:
	push	$ra

try_move__body:
	lw	$t0, ($a0)						# new_x = *x
	lw	$t1, ($a1)						# new_y = *y

	move	$t2, $a2						# move value of direction into $t2

try_move_first_cond:
	bne	$t2, LEFT, try_move_second_cond				# if (direction != LEFT) goto try_move_second_cond;

	subu	$t0, $t0, 1						# new_x--;
	b	try_move_check_wall_char				# goto try_move_check_wall_char;

try_move_second_cond:
	bne	$t2, UP, try_move_third_cond				# if (direction != UP) goto try_move_third_cond;

	subu	$t1, $t1, 1						# new_y--;
	b	try_move_check_wall_char				# goto try_move_check_wall_char;

try_move_third_cond:
	bne	$t2, RIGHT, try_move_fourth_cond			# if (direction != RIGHT) goto try_move_fourth_cond;

	add	$t0, $t0, 1						# new_x++;
	b	try_move_check_wall_char				# goto try_move_check_wall_char;


try_move_fourth_cond:
	bne	$t2, DOWN, try_move_check_wall_char			# if (direction != DOWN) goto try_move_check_wall_char;

	add	$t1, $t1, 1						# new_y++;

try_move_check_wall_char:
	mul	$t3, $t1, MAP_WIDTH					# (new_y * MAP_WIDTH		
	add	$t3, $t3, $t0						# + new_x)
	lb	$t4, map($t3)						# + map = map[new_y][new_x]

	bne	$t4, WALL_CHAR, try_move_set_pointers			# if (map[new_y][new_x] != WALL_CHAR) goto try_move_set_pointers;
	li	$v0, FALSE						# return FALSE;
	b	try_move__epilogue

try_move_set_pointers:
	sw	$t0, ($a0)						# *x = new_x;
	sw	$t1, ($a1)						# *y = new_y;
	li	$v0, TRUE 						# return TRUE;

try_move__epilogue:
	pop	$ra
	jr	$ra


################################################################################
# .TEXT <check_ghost_collision>
	.text
check_ghost_collision:
	# Subset:   3
	#
	# Args:     void
	# Returns:
	#    - $v0: int
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   check_ghost_collision
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

check_ghost_collision__prologue:

check_ghost_collision__body:

collision_loop_init:
	# i = 0
	li		$t0, 0

collision_loop_cond:
	# i < NUM_GHOSTS
	bge		$t0, NUM_GHOSTS, check_ghost_collision_false

collision_loop_body:
	# if (player_x == ghosts[i].x && player_y == ghosts[i].y) {
	# create copies of player_x and player_y into $t1 and $t2
	la		$t1, player_x
	lw		$t1, 0($t1)
	la		$t2, player_y
	lw		$t2, 0($t2)

	# get address of our current ghost struct
	mul		$t3, $t0, SIZEOF_GHOST_T
	la		$t4, ghosts
	add		$t5, $t4, $t3

	# get our x and y values from our ghost struct
	lw		$t6, GHOST_T_X_OFFSET($t5)
	lw		$t7, GHOST_T_Y_OFFSET($t5)

	# do our comparisons
	bne		$t1, $t6, collision_loop_step
	bne		$t2, $t7, collision_loop_step

	# printf("You ran into a ghost, game over! :(\n");
	li		$v0, 4
	la		$a0, game_over_msg
	syscall

	# return TRUE;
	li		$v0, TRUE
	j		check_ghost_collision__epilogue

collision_loop_step:
	# i++
	add		$t0, $t0, 1
	b		loop_print_height_cond

check_ghost_collision_false:
	# return FALSE;
	li		$v0, FALSE

check_ghost_collision__epilogue:
	jr		$ra


################################################################################
# .TEXT <collect_dot_and_check_win>
	.text
collect_dot_and_check_win:
	# Subset:   3
	#
	# Args:
	#    - $a0: int *dots_collected
	#
	# Returns:
	#    - $v0: int
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - $t0: map_char
	#
	# Structure:
	#   collect_dot_and_check_win
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

collect_dot_and_check_win__prologue:

collect_dot_and_check_win__body:
	# char *map_char = &map[player_y][player_x];
	# create copies of player_x and player_y into $t1 and $t0
	la		$t0, player_y
	lw		$t0, ($t0)
	la		$t1, player_x
	lw		$t1, ($t1)

	# calculate offset into map
	mul		$t0, $t0, MAP_WIDTH
	add		$t0, $t0, $t1
	la		$t1, map
	add		$t0, $t0, $t1						# $t0 = map_char = &map[player_y][player_x]

	# if (*map_char == DOT_CHAR) {
	lb		$t1, ($t0)
	bne		$t1, DOT_CHAR, collect_dot_and_check_win_false

	# *map_char = EMPTY_CHAR;
	li		$t2, EMPTY_CHAR
	sb		$t2, ($t0)

	# (*dots)++;
	lb		$t3, ($a0)
	add		$t3, $t3, 1
	sb		$t3, ($a0)

	# if (*dots == MAP_DOTS) {
	bne		$t3, MAP_DOTS, collect_dot_and_check_win_false

	# printf("All dots collected, you won! :D\n");
	li		$v0, 4
	la		$a0, game_won_msg

	# return TRUE;
	li		$v0, TRUE
	j		collect_dot_and_check_win__epilogue

collect_dot_and_check_win_false:
	# return FALSE;
	li		$v0, FALSE

collect_dot_and_check_win__epilogue:
	jr		$ra


################################################################################
# .TEXT <do_ghost_logic>
	.text
do_ghost_logic:
	# Subset:   3
	#
	# Args:     void
	#
	# Returns:  void
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   do_ghost_logic
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

do_ghost_logic__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2

do_ghost_logic__body:

ghost_id_loop_init:
	# ghost_id = 0
	li		$s0, 0

ghost_id_loop_cond:
	# ghost_id < NUM_GHOSTS
	bge		$s0, NUM_GHOSTS, do_ghost_logic__epilogue

ghost_id_loop_body:
	# int n_valid_dirs = get_valid_directions(
    #        ghosts[ghost_id].x,
    #        ghosts[ghost_id].y,
    #        valid_directions
    #    );
	# get address of our current ghost struct
	mul		$t0, $s0, SIZEOF_GHOST_T
	la		$t1, ghosts
	add		$s1, $t1, $t0						# $s1 = &ghosts[ghost_id]

	# setup arguments and call get_valid_directions
	lw		$a0, GHOST_T_X_OFFSET($s1)
	lw		$a1, GHOST_T_Y_OFFSET($s1)
	la		$a2, valid_directions
	jal		get_valid_directions
	move	$s2, $v0							# n_valid_dirs = $v0

	# if (n_valid_dirs == 0) continue;
	beqz	$s2, ghost_id_loop_step

	# if (n_valid_dirs > 2)
	bgt		$s2, 2, ghost_try_move
	
	# if (!try_move(
    #     		&ghosts[ghost_id].x,
    #     		&ghosts[ghost_id].y,
    #     		ghosts[ghost_id].direction
    #     ))

	li		$v0, 34
	add		$a0, $s1, GHOST_T_X_OFFSET
	syscall

	add		$a0, $s1, GHOST_T_X_OFFSET
	add		$a1, $s1, GHOST_T_Y_OFFSET
	lw		$a2, GHOST_T_DIRECTION_OFFFSET($s1)
	jal		try_move
	bnez	$v0, ghost_try_move

	# if neither condition fulfilled; jump to increment
	b 		ghost_id_loop_step

ghost_try_move:
	# uint32_t dir_index = random_number() % n_valid_dirs;
	jal		random_number
	div		$v0, $s2			# $v0 / $s2
	mfhi	$t2					# $t2 = dir_index = $v0 % $s2

	# ghosts[ghost_id].direction = valid_directions[dir_index];
	mul		$t3, $t2, 4	
	la		$t4, valid_directions
	add		$t5, $t3, $t4
	lw		$t6, ($t5)
	sw		$t6, GHOST_T_DIRECTION_OFFFSET($s1)

	# try_move(
    # 		&ghosts[ghost_id].x,
    # 		&ghosts[ghost_id].y,
    #       ghosts[ghost_id].direction
    # );

	add		$a0, $s1, GHOST_T_X_OFFSET
	add		$a1, $s1, GHOST_T_Y_OFFSET
	lw		$a2, GHOST_T_DIRECTION_OFFFSET($s1)
	jal		try_move

ghost_id_loop_step:
	# ghost_id++
	add		$s0, $s0, 1
	b		ghost_id_loop_cond

do_ghost_logic__epilogue:
	pop		$s2
	pop		$s1
	pop		$s0
	pop		$ra

	jr		$ra


################################################################################
################################################################################
###                   PROVIDED FUNCTIONS — DO NOT CHANGE                     ###
################################################################################
################################################################################

	.data
get_seed_prompt_msg:
	.asciiz "Enter a non-zero number for the seed: "
invalid_seed_msg:
	.asciiz "Seed can't be zero.\n"

################################################################################
# .TEXT <get_seed>
	.text
get_seed:
	# Args:     void
	#
	# Returns:  void
	#
	# Frame:    [$ra]
	# Uses:     [$v0, $a0]
	# Clobbers: [$v0, $a0]
	#
	# Locals:
	#   - $v0: copy of lfsr_state
	#
	# Structure:
	#   get_seed
	#   -> [prologue]
	#       -> body
	#       -> loop_start
	#       -> loop_end
	#   -> [epilogue]
	#
	# PROVIDED FUNCTION — DO NOT CHANGE

get_seed__prologue:
	begin
	push	$ra

get_seed__body:
get_seed__loop:					# while (TRUE) {
	li	$v0, 4				#   syscall 4: print_string
	la	$a0, get_seed_prompt_msg
	syscall					#   printf("Enter a non-zero number for the seed: ");

	li	$v0, 5				#   syscall 5: read_int
	syscall
	sw	$v0, lfsr_state			#   scanf("%u", &lfsr_state);

	bnez	$v0, get_seed__loop_end		#   if (lfsr_state != 0) break;

	li	$v0, 4				#   syscall 4: print_string
	la	$a0, invalid_seed_msg
	syscall					#   printf("Seed can't be zero.\n");

	b	get_seed__loop			# }

get_seed__loop_end:
get_seed__epilogue:
	pop	$ra
	end

	jr	$ra


################################################################################
# .TEXT <random_number>
	.text
random_number:
	# Args:     void
	#
	# Returns:
	#    - $v0: uint32_t
	#
	# Frame:    [$ra]
	# Uses:     [$t0, $t1, $t2, $v0]
	# Clobbers: [$t0, $t1, $t2, $v0]
	#
	# Locals:
	#   - $t0: uint32_t bit
	#   - $t1: copy of lfsr_state
	#   - $t2: temporary shift result
	#
	# Structure:
	#   random_number
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]
	#
	# PROVIDED FUNCTION — DO NOT CHANGE

random_number__prologue:
	begin
	push	$ra

random_number__body:
	lw	$t1, lfsr_state		# load lfsr_state
	move	$t0, $t1		# uint32_t bit = lfsr_state;

	srl	$t2, $t1, 10		# lfsr_state >> 10
	xor	$t0, $t0, $t2		# bit ^= lfsr_state >> 10;

	srl	$t2, $t1, 30		# lfsr_state >> 30
	xor	$t0, $t0, $t2		# bit ^= lfsr_state >> 30;

	srl	$t2, $t1, 31		# lfsr_state >> 31
	xor	$t0, $t0, $t2		# bit ^= lfsr_state >> 31;

	andi	$t0, $t0, 1		# bit &= 0x1u;

	sll	$t1, $t1, 1		# lfsr_state <<= 1;
	or	$t1, $t1, $t0		# lfsr_state |= bit;

	sw	$t1, lfsr_state		# store lfsr_state
	move	$v0, $t1		# return lfsr_state;

random_number__epilogue:
	pop	$ra
	end

	jr	$ra
