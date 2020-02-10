Usage: check_statistical.sage <bin/prime> <n/p> <t> <start> <end> (<lin>)

For the first argument, provide "prime" for prime fields and "bin" for binary fields
For the second argument, provide the power of 2 in the field in the case of binary field, or the prime (in base 10)
For the third argument, provide t written in base 10
For the foruth and fifth arguments, provide the start and end point of the a's you want the program to check.
By default, the program checks resistance against differential cryptanalysis. By supplying (anything) in the <lin> (sixth) argument, 
the program will check resistiance in regard to linear cryptanalysis instead.

The program will notify you about the progress as follows: 

When starting a new "a", the program with print "start <a>" and when ending enumerating patterns matching to that "a", the program
will print "end <a>"

Whenever the program will find a pattern for which a matching differential (resp. linear) characterstic exists, the pattern will be printed.


NOTE: when enumerating pattern for a certain "a", the algorithm assumes that enumeration for previous "a"'s has already been done and
that no characteristic were found.
