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
#  - [ ] print_welcome
#  SUBSET 1
#  - [ ] main
#  - [ ] get_direction
#  - [ ] play_tick
#  SUBSET 2
#  - [ ] copy_map
#  - [ ] get_valid_directions
#  - [ ] print_map
#  - [ ] try_move
#  SUBSET 3
#  - [ ] check_ghost_collision
#  - [ ] collect_dot_and_check_win
#  - [ ] do_ghost_logic
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
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   print_welcome
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

print_welcome__prologue:


print_welcome__body:
	# TODO: put your implementation of print_welcome here
	li	$v0, 4				# syscall 4: print_string
	la 	$a0, welcome_msg		#
	syscall					# printf("Welcome to 1521 Pacman!\n");

	li	$v0, 11				# syscall 11: putchar
	la	$a0, WALL_CHAR			#
	syscall					# printf("%c", WALL_CHAR);

	li	$v0, 4				# syscall 4: print_string
	la	$a0, welcome_msg_wall		#
	syscall					# printf(" = wall\n");

	li	$v0, 11				# syscall 11: putchar
	la	$a0, PLAYER_CHAR		#
	syscall					# printf("%c", PLAYER_CHAR);

	li	$v0, 4				# syscall 4: print_string
	la	$a0, welcome_msg_you		#
	syscall					# printf(" = you\n");

	li	$v0, 11				# syscall 11: putchar
	la	$a0, DOT_CHAR			#
	syscall					# printf("%c", DOT_CHAR);

	li	$v0, 4				# syscall 4: print_string
	la	$a0, welcome_msg_dot		#
	syscall					# printf(" = dot\n");

	li	$v0, 11				# syscall 11: putchar
	la	$a0, GHOST_CHAR			#
	syscall					# printf("%c", GHOST_CHAR);

	li	$v0, 4				# syscall 4: print_string
	la	$a0, welcome_msg_ghost		#
	syscall					# printf(" = ghost\n");

	li	$v0, 4				# syscall 4: print_string
	la	$a0, welcome_msg_objective	#
	syscall					# printf("\nThe objective is to collect all the dots.\n");

	li	$v0, 4				# syscall 4: print_string
	la	$a0, welcome_msg_wasd		#
	syscall					# printf("Use WASD to move\n");

	li	$v0, 4				# syscall 4: print_string
	la	$a0, welcome_msg_ghost_move	#
	syscall					# printf("Ghosts will move every time you move.\nTouching them will end the game.\n");

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
	# TODO: put your prologue for main here
	begin
	push	$s0
	push	$ra

main__body:
	# TODO: put your body for main here

	jal	get_seed

	jal	print_welcome

main__loop:
	jal	print_map

	li	$v0, 4
	la	$a0, dots_collected_msg_1
	syscall					# printf("You've collected");

	li	$v0, 1
	la	$t0, dots_collected
	lw	$s0, 0($t0)

	move	$a0, $s0

	syscall					# printf("%d", dots_collected);

	li	$v0, 4
	la	$a0, dots_collected_msg_2
	syscall					# printf("out of");

	li	$v0, 1
	li	$a0, MAP_DOTS
	syscall					# printf("%d", MAP_DOTS);

	li	$v0, 4
	la	$a0, dots_collected_msg_3
	syscall					# printf("dots.\n");

	la	$a0, dots_collected
	jal	play_tick			
	beqz	$v0, main__epilogue
	

	b	main__loop

main__epilogue:
	# TODO: put your epilogue for main here
	
	pop	$ra
	pop	$s0
	end
	jr	$ra


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
	li	$v0, 4					# syscall 4: print_string
	la	$a0, choose_move_msg			#
	syscall						# printf("Choose next move (wasd): ");

get_direction_loop_cond:
	li	$t0, FALSE				# move FALSE into register
	li	$t2, TRUE				# move TRUE into register
	li	$t1, 0					# int input = 0;		

	beq	$t2, $t0, get_direction__epilogue	# if (FALSE) goto get_direction__epilogue;

	li	$v0, 12					# syscall 12: read_char
	syscall
	move	$t1, $v0				# int input = getchar();

first_get_direction_cond:
	bne	$t1, 'a', second_get_direction_cond	# if (input != 'a') goto second_get_direction_cond;
	li	$v0, LEFT				#
	b	get_direction__epilogue			# return LEFT;

second_get_direction_cond:
	bne	$t1, 'w', third_get_direction_cond	# if (input != 'w') goto third_get_direction_cond;
	li	$v0, UP					#
	b	get_direction__epilogue			# return UP;

third_get_direction_cond:
	bne	$t1, 'd', fourth_get_direction_cond	# if (input != 'd') goto fourth_get_direction_cond;
	li	$v0, RIGHT				#
	b	get_direction__epilogue			# return RIGHT;

fourth_get_direction_cond:
	bne	$t1, 's', print_newline			# if (input != 's') goto print_newline;
	li	$v0, DOWN				#
	b 	get_direction__epilogue			# return DOWN;

print_newline:
	beq	$t1, 10, get_direction_loop_cond	# if (input == '\n') goto get_direction_loop_cond;

invalid_input:
	li	$v0, 4					# syscall 4: print_string
	la	$a0, invalid_input_msg			# 
	syscall						# printf("Invalid input! Use the wasd keys to move.\n");

	b	get_direction_loop_cond			# goto get_direction_loop_cond;

get_direction__epilogue:
	
	jr	$ra


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
	move	$s0, $a0				# store *dots into the stack

	jal	get_direction				# get_direction();
	move	$a0, $s0
	move	$a2, $v0				# store result from get_direction
	
	la	$a0, player_x				#
	la	$a1, player_y				#
	jal	try_move				# try_move(&player_x, &player_y, get_direction());

play_tick_check_ghost_collision:
	jal	check_ghost_collision			# check_ghost_collision();
	beqz	$v0, play_tick_do_ghost_logic		# if (!check_ghost_collision()) goto play_tick_do_ghost_logic;

play_tick_return_false:
	li	$v0, FALSE					# return FALSE
	b	play_tick__epilogue			# goto play_tick__epilogue;

play_tick_do_ghost_logic:
	jal	do_ghost_logic				# do_ghost_logic();

play_tick_check_ghost_collision_2:
	jal	check_ghost_collision			# check_ghost_collision();
	beqz	$v0, play_tick_collect_dot_check_win	# if (!check_ghost_collision()) goto play_tick_collect_dot_check_win;

	b	play_tick_return_false			# goto play_tick_return_false

play_tick_collect_dot_check_win:
	move	$a0, $s0				# load *dots
	jal	collect_dot_and_check_win		# collect_dot_and_check_win();
	bnez	$v0, play_tick_collect_dot_false	# if (collect_dot_and_check_win(dots) != 0) goto play_tick_false;

	li	$v0, 1					# return TRUE;	
	b	play_tick__epilogue

play_tick_collect_dot_false:
	li	$v0, 0

play_tick__epilogue:
	pop	$s0
	pop	$ra
	jr	$ra


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
	# Structure:
	#   copy_map
	#   -> [prologue]
	#       -> body
	#		-> height_loop__init
	#		-> height_loop__cond
	#		-> height_loop__body
	#		-> width_loop__init
	#		-> width_loop__cond
	#		-> width_loop__cond
	#		-> width_loop__body
	#		-> height_loop__Step
	#		-> height_loop__end
	#   -> [epilogue]

copy_map__prologue:
	begin
	push	$ra
copy_map__body:

height_loop__init:
	li	$t0, 0						# i = 0

height_loop__cond:
	bge	$t0, MAP_HEIGHT, height_loop__end 		# if (i >= MAP_HEIGHT) goto height_loop__end;

height_loop__body:

width_loop__init:
	li	$t1, 0						# j = 0;

width_loop__cond:
	bge	$t1, MAP_WIDTH, height_loop__step		# if (j >= MAP_WIDTH) goto height_loop__step;

width_loop__body:
	mul	$t4, $t0, MAP_WIDTH				# (i * MAP_WIDTH			
    	addu    $t4, $t4, $t1      				#  + j)	
    	addu    $t4, $a0, $t4         				# + dest[i][j] 

	mul	$t5, $t0, MAP_WIDTH				# (i * MAP_WIDTH
    	addu    $t5, $t5, $t1         				# + j)
	addu    $t5, $a1, $t5					# + source[i][j] 

	lb      $t6, 0($t5)           				# Load a byte from source[i][j]
    	sb      $t6, 0($t4)           				# Store the byte in dest[i][j]

	addi	$t1, $t1, 1					# j++;
	b	width_loop__cond				# goto width_loop__cond;

height_loop__step:
	addi	$t0, $t0, 1					# i++;
	b	height_loop__cond				# goto height_loop__cond;		

height_loop__end:

copy_map__epilogue:
	pop 	$ra
	end
	jr	$ra						# return;


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
	begin
	push	$s4
	push	$s3
	push	$s2
	push	$s1
	push	$s0
	push	$ra
	
get_valid_directions__body:
	move	$s0, $a2					# store dir_array in $s0
	li	$s1, 0						# int valid_dirs = 0

loop__init:
	li	$s2, 0						# int dir = 0;		

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

	jal	try_move					# 

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
	pop	$ra
	pop	$s0
	pop	$s1
	pop	$s2
	pop	$s3
	pop	$s4
	end
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
	bge		$t0, MAP_HEIGHT, loop_end

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
	move		$a0, $t2							#
	syscall										# putchar(map_copy[i][j]);

	add 		$t1, $t1, 1
	b		loop_print_width_cond

loop_print_height_step:
	li	$v0, 11
	li		$a0, '\n'
	syscall

	add		$t0, $t0, 1
	b		loop_print_height_cond

loop_end:

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
	begin
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
	end
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

check_ghost_collision__epilogue:
	jr	$ra


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
	#   - ...
	#
	# Structure:
	#   collect_dot_and_check_win
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

collect_dot_and_check_win__prologue:

collect_dot_and_check_win__body:

collect_dot_and_check_win__epilogue:
	jr	$ra


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

do_ghost_logic__body:

do_ghost_logic__epilogue:
	jr	$ra


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
