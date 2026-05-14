The Fibonacci numbers are the numbers in the following integer sequence. 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, …….. In mathematical terms, the sequence Fn of Fibonacci numbers is defined by the recurrence relation Fn = Fn-1 + Fn-2 with seed values F0 = 0 and F1 = 1. Write a function fib that returns Fn. For example:
if n = 0, then fib should return 0
if n = 1, then it should return 1
if n > 1, it should return Fn-1 + Fn-2
Write bash script accepting operation parameter (“-”, “+”, “*”, “%”), sequence of numbers and debug flag. For example:
 ./your_script.sh -o % -n 5 3 -d > Result: 2
./your_script.sh -o + -n 3 5 7 -d > Result: 15
If -d flag is passed, script must print additional information:

User: <username of the user running the script>
Script: <script name>        
Operation: <operation>
Numbers: <all space-separated numbers>
You need to write a script that prints the numbers from 1 to 100 such that:
If the number is a multiple of 3, you need to print "Fizz" instead of that number.
If the number is a multiple of 5, you need to print "Buzz" instead of that number.
If the number is a multiple of both 3 and 5, you need to print "FizzBuzz" instead of that number.
Write caesar cipher script accepting three parameters -s <shift> -i <input file> -o <output file>
Write script with following functionality:
If -v tag is passed, replaces lowercase characters with uppercase and vise versa
If -s is passed, script substitutes <A_WORD> with <B_WORD> in text (case sensitive)
If -r is passed, script reverses text lines
If -l is passed, script converts all the text to lower case
If -u is passed, script converts all the text to upper case
Script should work with -i <input file> -o <output file> tags
Create script, that generates report file with following information:
 - current date and time;
name of current user;
internal IP address and hostname;
external IP address;
name and version of Linux distribution;
system uptime;
information about used and free space in / in GB;
information about total and free RAM;
number and frequency of CPU cores
