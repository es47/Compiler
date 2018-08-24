al : compile

compile :
	java -cp antlr-3.5.2-complete.jar org.antlr.Tool mylexer.g
	javac -cp ./antlr-3.5.2-complete.jar testLexer.java mylexer.java

execute : compile 
	java -cp ./antlr-3.5.2-complete.jar:. testLexer input_comment.c

clean :
	rm *.class mylexer.java mylexer.tokens
