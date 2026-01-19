# Advent of Code 2020
Advent of Code 2020 in FORTRAN 77

Fortran 77 on RaspberryPiOS (Debian trixie)

Use (with gfortran installed) f77 filename.f -o filename to compile and link.

Day 1 - a gentle start with nested do loops with a STOP as we need only need the first matching sum that adds up to 2020 for both parts. Pi4B times 0.006s for part 1, 0.011s for part 2.

Day 2 - part 2 is simpler than part 1 as we don't need a loop for it! Pi4B times 0.023s for part 1, 0.021s for part 2.

Day 3 - a small bit of refactoring for part 2 to use a function to calculate the number of trees encountered for multiple toboggan runs. Pi4B times for part 1 and part 2 identical at 0.007s.

Day 4 - part 1 was fairly simple. Part 2 needed a function to apply the rules for each passport field. Slightly tricky as working out where the terminating space is for INDEX needs to take account of the position in the string of the field ... if it's the second or greater field on a line then simply doing an INDEX for the space returns the wrong (first) one! Pi4 time for part 1 0.016s, part 2 0.025s.
