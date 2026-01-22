# Advent of Code 2020
Advent of Code 2020 in FORTRAN 77 (mostly)## Notes

Fortran 77 on RaspberryPiOS (Debian trixie)

Use (with gfortran installed) f77 filename.f -o filename to compile and link.

## Notes

**Day 1** A gentle start with nested do loops with a STOP as we need only need the first matching sum that adds up to 2020 for both parts. Pi4B times 0.006s for part 1, 0.011s for part 2.

**Day 2** Part 2 is simpler than part 1 as we don't need a loop for it! Pi4B times 0.023s for part 1, 0.021s for part 2.

**Day 3** Minor refactoring for part 2 to use a function to calculate the number of trees encountered for multiple toboggan runs. Pi4B times for part 1 and part 2 identical at 0.007s.

**Day 4** Part 1 was fairly simple. Part 2 needed a function to apply the rules for each passport field. Slightly tricky as working out where the terminating space is for INDEX needs to take account of the position in the string of the field ... if it's the second or greater field on a line then simply doing an INDEX for the space returns the wrong (first) one! Pi4 time for part 1 0.016s, part 2 0.025s.

**Day 5** A straightforward binary search problem. Pi4B times for parts 1 and 2 identical at 0.008s. There's a bit of space and time inefficiency in both solutions (e.g. we know the highest seat id that is occupied from part 1 and we can stop as soon as we have the correct seat in part 2) but for the number of seats (1,024) it's hardly worthwhile on this hardware. If I converted the code to Fortran 66 and ran it on Z80 hardware such optimisations might help a little.

**Day 6** Similar to day 4 in many ways. Part 2 could probably be coded more elegantly, but it's only 0.001s slower than part 1 on a Pi4B (0.011s for part 1, 0.012s for part 2).

**Day 7** Fairly nasty input to parse to produce a weighted graph / tree. Part 1 repurposes the array created to turn node descriptions (bag colours) into node numbers to mark off the seen bags uniquely. Part 2 is straightforward after solving part 1 as it makes use of the node weights (number of bags) and a slightly different function to calculate the number of bags that need to be contained by one shiny gold bag. Both parts use recursion after I decided that a stack based approach was too painful to implement on a rainy day in January, so the solution falls into f90 territory rather than pure f77. Part 1 is slightly slower at 0.048s vs Part 2 at 0.045s on a Pi4B. With the diagnostics removed these times reduce to 0.042s and 0.036s respectively.

**Day 8** An implementation of a very, very simple instruction set with an accumulator. Part 1 determines when the program as written goes wrong, part 2 fixes the program to terminate normally. Part 2 could be written more efficiently at the expense of some greater complexity as per the comment in the code, but it's fast enough anyway. (Part 1 0.011s, part 2 0.028s including diagnostic output).

**Day 9** Straightforward puzzle with part 1 needing to find the first number in the list that isn't a sum of any two of the previous 25. Part 2 takes the number found in part 1 and finds the first contiguous range of numbers in the original list that add up to this number. The answer to part 2 is the sum of the lowest and highest numbers in that range - not the first and the last as I'd originally coded for. It's not the most efficient or prettiest code that's possible, but it works well enough. My part 2 solution produces both answers in a combined 0.015s on the Pi4B.

**Day 10** A straightforward sort is all that's required for part 1 (making use of the heapsort algorithm I wrote after I'd finished AoC 2025). Part 2 is simplest using recursion (so f90 territory again), and the puzzle data requires a memo otherwise the runtime would approach the time remaining until the "heat death of the universe". As written, both parts run in 0.006s on the Pi4B.

**Day 11** A grid puzzle with rules similar to Conway's 'Life' for seating the passengers on a ferry. A border around the edge of the grid makes the code simpler to write at the expense of a little extra storage. Part 1 on the Pi4B completes in around 0.08s, part 2 0.38s - the most expensive solution so far. There are optimisations that could be made to the rules algorithms in both cases, but it probably wouldn't improve the overall execution time by very much.

**Day 12** A movement and Manhattan distance finding puzzle. Using complex numbers for the ship and waypoint co-ordinates and complex arithmetic for movement makes it straightforward in Fortran 77. Part 1 and part 2 both execute in 0.013s on the Pi4B.

**Day 13** Bus timetimetables. Lovely. Part 1 is relatively straightforward but given the nature of the input (just two lines) I'd guessed that part 2 would probably require some 'interesting' maths to solve it - and it does. I'd already noticed that all of the bus numbers were primes, so searching combining terms like primes, modulus, remainder uncovered the Chinese Remainder Theorum. This is simple to implememt in Fortran. Both parts are fast and take 0.006s each. 
