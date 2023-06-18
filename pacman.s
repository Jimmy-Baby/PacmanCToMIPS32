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

print_welcome__prologue:

print_welcome__body:
	li		$v0, 4					# $v0 = 4 (print string)
	la		$a0, welcome_msg		# $a0 = addr(welcome_msg)
	syscall 						# pass control to handler

	li		$v0, 11					# $v0 = 11 (print character)
	la		$a0, WALL_CHAR			# $a0 = addr(welcome_msg)
	syscall 						# pass control to handler

	li		$v0, 4
	la		$a0, welcome_msg_wall
	syscall

	li		$v0, 11
	la		$a0, PLAYER_CHAR
	syscall

	li		$v0, 4
	la		$a0, welcome_msg_you
	syscall
	
	li		$v0, 11
	la		$a0, DOT_CHAR
	syscall

	li		$v0, 4
	la		$a0, welcome_msg_dot
	syscall
	
	li		$v0, 11
	la		$a0, GHOST_CHAR
	syscall

	li		$v0, 4
	la		$a0, welcome_msg_ghost
	syscall

	li		$v0, 4
	la		$a0, welcome_msg_objective
	syscall

	li		$v0, 4
	la		$a0, welcome_msg_wasd
	syscall

	li		$v0, 4
	la		$a0, welcome_msg_ghost_move
	syscall

print_welcome__epilogue:

	jr		$ra


################################################################################
# .TEXT <main>
	.text
main:

main__prologue:
	push	$ra							# save return address

main__body:
	# get_seed();
    # print_welcome();
	jal		get_seed					# jump to get_seed and save position to $ra
	jal		print_welcome				# jump to print_welcome and save position to $ra

	# do {
main__loop:
	# print_map();
	jal		print_map					# jump to print_map and save position to $ra

	# printf("You've collected ");
	li		$v0, 4
	la		$a0, dots_collected_msg_1
	syscall

	# printf("%d", dots_collected);
	li		$v0, 1						# print integer syscall code
	la		$t0, dots_collected			# load address of dots_collected 
	lw		$a0, 0($t0)					# load word from the address
    syscall

	# printf(" out of ");
	li		$v0, 4
	la		$a0, dots_collected_msg_2
	syscall

	# printf("%d", MAP_DOTS);
	li		$v0, 1						# print integer syscall code
	li		$a0, MAP_DOTS				# $a0 = MAP_DOTS
    syscall

	# printf(" dots.\n");
	li		$v0, 4
	la		$a0, dots_collected_msg_3
	syscall

	# } while(play_tick(&dots_collected))
	la		$a0, dots_collected
	jal		play_tick					# jump to play_tick and save position to $ra
	bnez	$v0, main__loop				# if $v0 != 0 then goto main__loop
	
	# return 0;
	li		$v0, 0						# $v0 = 0

main__epilogue:
	pop		$ra							# restore return address

	jr		$ra


################################################################################
# .TEXT <get_direction>
	.text
get_direction:

get_direction__prologue:

get_direction__body:
	# printf("Choose next move (wasd): ");
	li		$v0, 4
	la		$a0, choose_move_msg
	syscall

check_key:
	li		$v0, 12						# read character syscall code
	syscall

# if (input == 'a') {
	bne		$v0, 'a', check_up_key		# if $v0 != 'a' then goto check_up_key
# return LEFT;
	li		$v0, LEFT					# $v0 = LEFT
	b		get_direction__epilogue		# branch to get_direction__epilogue

check_up_key:
# if (input == 'w') {
	bne		$v0, 'w', check_right_key	# if $v0 != 'w' then goto check_right_key
# return UP;
	li		$v0, UP						# $v0 = UP
	b		get_direction__epilogue		# branch to get_direction__epilogue

check_right_key:
# if (input == 'd') {
	bne		$v0, 'd', check_down_key	# if $v0 != 'd' then goto check_down_key
# return RIGHT;
	li		$v0, RIGHT					# $v0 = RIGHT
	b		get_direction__epilogue		# branch to get_direction__epilogue

check_down_key:
# if (input == 's') {
	bne		$v0, 's', check_newline		# if $v0 != 's' then goto check_newline
# return DOWN;
	li		$v0, DOWN					# $v0 = DOWN
	b		get_direction__epilogue		# branch to get_direction__epilogue

check_newline:
# continue;
	beq		$v0, '\n', check_key		# if $v0 == '\n' then goto check_key

invalid_input:
	# printf("Invalid input! Use the wasd keys to move.\n");
	li		$v0, 4
	la		$a0, invalid_input_msg
	syscall

	# end of while
	b		check_key					# branch to check_key

get_direction__epilogue:
	jr	$ra


################################################################################
# .TEXT <play_tick>
	.text
play_tick:

play_tick__prologue:

play_tick__body:
	# try_move(&player_x, &player_y, get_direction());
	push	$a0
	jal 	get_direction
	la		$a0, player_x
	la		$a1, player_y
	move	$a2, $v0					# $v0 holds get_direction result
	jal 	try_move
	pop		$a0
	
	# if (check_ghost_collision()) {
	jal 	check_ghost_collision
	beqz	$v0, do_ghost_logic_call
	li		$v0, FALSE
	jr		$ra

do_ghost_logic_call:
	push 	$ra
	jal 	do_ghost_logic
	pop 	$ra

	# if (check_ghost_collision()) {
	jal 	check_ghost_collision
	beqz	$v0, play_tick__epilogue
	li		$v0, FALSE
	jr		$ra

play_tick__epilogue:
	# return !collect_dot_and_check_win(dots);
	# $a0 already holds our argument so we just make the call
	jal		collect_dot_and_check_win	# jump to collect_dot_and_check_win and save position to $ra
	xori	$v0, $v0, 1					# $v0 = v0 ^ 1
	
	jr		$ra


################################################################################
# .TEXT <copy_map>
	.text
copy_map:

copy_map__prologue:

copy_map__body:
	# first calculate size of map in memory; 
	# memory is contiguous so we can just copy all of the data in a single loop
	li		$t0, MAP_HEIGHT
	li		$t1, MAP_WIDTH
	mult	$t0, $t1					# $t0 * $t1 = Hi and Lo registers
	mflo	$t0							# copy Lo to $t0, now $t0 holds array size

	# store base address of arrays
	move	$t2, $a0
	move	$t3, $a1

copy_loop:
	lb		$t4, 0($t3)					# load byte to temp store
	sb		$t4, 0($t2)					# store byte from temp store
	
	addi	$t2, $t2, 1					# increment position in array
	addi	$t3, $t3, 1					# increment position in array
	bne		$t0, $t1, copy_loop			# if $t0 != $t1 then goto target

copy_map__epilogue:
	jr	$ra


################################################################################
# .TEXT <get_valid_directions>
	.text
get_valid_directions:

get_valid_directions__prologue:

get_valid_directions__body:

get_valid_directions__epilogue:
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

print_map__body:

print_map__epilogue:
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
	#   - ...
	#
	# Structure:
	#   try_move
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

try_move__prologue:

try_move__body:

try_move__epilogue:
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
