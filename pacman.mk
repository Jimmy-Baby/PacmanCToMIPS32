EXERCISES += pacman
CLEAN_FILES += pacman

pacman: pacman_EOF.c
	$(CC) -o $@ $<

.PHONY: submit give

submit give: pacman.s
	give cs1521 ass1_pacman pacman.s

.PHONY: test autotest

test autotest: pacman.s
	1521 autotest pacman
