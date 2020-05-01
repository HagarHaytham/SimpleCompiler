To run :
1. lex lexer.l
2. yacc parser.y
3. g++ symbol_tablecpp.cpp y.tab.c lexx.yy.c

To run the tests:
./a.out filename

attached 3 test files 
two of them compile successfully,
and the third has two errors, it continues compilation even if an error is discovered to show where the errors are.


NOTE: delete the quad.txt file before compiling each new test case.
