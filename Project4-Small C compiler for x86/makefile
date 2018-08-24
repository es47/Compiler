all:
	java -cp ./antlr-3.5.2-complete.jar org.antlr.Tool myCompiler.g
	javac -cp ./antlr-3.5.2-complete.jar myCompilerLexer.java register.java myCompilerParser.java myCompiler_test.java
	java -cp ./antlr-3.5.2-complete.jar:. myCompiler_test test1.c > test1.s
	java -cp ./antlr-3.5.2-complete.jar:. myCompiler_test test2.c > test2.s
	java -cp ./antlr-3.5.2-complete.jar:. myCompiler_test test3.c > test3.s
	java -cp ./antlr-3.5.2-complete.jar:. myCompiler_test test4.c > test4.s
	java -cp ./antlr-3.5.2-complete.jar:. myCompiler_test test5.c > test5.s

execute1:
	gcc test1.s -o test1.o
	./test1.o

execute2:
	gcc test2.s -o test2.o
	./test2.o

execute3:
	gcc test3.s -o test3.o
	./test3.o

execute4:
	gcc test4.s -o test4.o
	./test4.o

execute5:
	gcc test5.s -o test5.o
	./test5.o

clean:
	rm *.class myCompilerParser.java myCompilerLexer.java myCompiler.tokens *.s *.o
